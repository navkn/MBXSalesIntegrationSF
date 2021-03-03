import { LightningElement, track, wire, api } from 'lwc';
import getOpp from '@salesforce/apex/SearchPageApexController.getAllOpportunities';
import sendOpp from '@salesforce/apex/ShareOpportunitiesToExternalSite.sendOpportunity';
import updateOpp from '@salesforce/apex/SearchPageApexController.updateOpportunity';
import { CurrentPageReference } from "lightning/navigation";

const actionsList = [
    { label: "Integrate", name: "integrate" },
    { label: "Edit", name: "edit" },
];
const columnsGlobal = [
    {
        label: 'Opportunity Name',
        fieldName: 'linkOppName',
        type: 'url',
        typeAttributes:
        {
            label:
                { fieldName: 'Name' },
            tooltip: "Name",
            target: '_blank'
        }
    },
    {
        label: 'Account Name',
        fieldName: 'linkAccountName',
        type: 'url',
        typeAttributes:
        {
            label: {
                fieldName: 'AccountName',
            },
            tootltip: 'AccountName',
            target: '_blank'
        }
    },
    { label: 'Stage', fieldName: 'StageName' },
    { label: 'Type', fieldName: 'Type' },
    { label: 'Amount', fieldName: 'Amount' },
    {
        label: 'actions', type: "action",
        typeAttributes: { rowActions: actionsList, menulAlignment: "left" },
    },
];

const TypeOptionsGlobal = [{ label: 'None', value: '' }, { label: 'Existing Customer - Upgrade', value: 'Existing Customer - Upgrade' },
{ label: 'Existing Customer - Replacement', value: 'Existing Customer - Replacement' },
{ label: 'Existing Customer - Downgrade', value: 'Existing Customer - Downgrade' },
{ label: 'New Customer', value: 'New Customer' }
];
const StageNameOptionsGlobal = [{ label: 'None', value: '' }, { label: 'Prospecting', value: 'Prospecting' },
{ label: 'Qualification', value: 'Qualification' },
{ label: 'Needs Analysis', value: 'Needs Analysis' },
{ label: 'Value Proposition', value: 'Value Proposition' },
{ label: 'Id. Decision Makers', value: 'Id. Decision Makers' },
{ label: 'Perception Analysis', value: 'Perception Analysis' },
{ label: 'Proposal/Price Quote', value: 'Proposal/Price Quote' },
{ label: 'Negotiation/Review', value: 'Negotiation/Review' },
{ label: 'Closed Won', value: 'Closed Won' },
{ label: 'Closed Lost', value: 'Closed Lost' }
];
export default class RecordsTableSearch extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    @track pageSize = 20;
    @track totalRecords;//31
    rawData;
    @track noOfPages;//2

    @track lowLimit;
    @track uppLimit;
    @track isLastPage = false;//used in html displaying totalrecords count rather than calculated one
    @track isFirstPage = true;
    @track currentPage;
    @track oppList;
    columns = columnsGlobal;
    TypeOptions = TypeOptionsGlobal;
    StageNameOptions = StageNameOptionsGlobal;
    stored_data = [];
    //considering situation records less than 50k
    jName = '';
    jAccName = '';
    jStage = '';
    jType = '';
    jAmount = '';
    @wire(getOpp, { sName: '$jName', sAccountName: '$jAccName', sType: '$jType', sStageName: '$jStage', sAmount: '$jAmount' })
    GotOppor(jsonObj) {
        const { data, error } = jsonObj;
        console.log(data,error);
        if (data) {
            // Tranform the fieldname of parent object field
            this.stored_data = data;
            this.rawData = data.map(row => {
                return {
                    ...row,
                    AccountName: row.Account == null ? '' : row.Account.Name,
                    linkAccountName: row.Account == null ? '' : '/' + row.Account.Id,
                    linkOppName: '/' + row.Id
                };
            });
            this.totalRecords = this.rawData.length;
            this.noOfPages = Math.ceil(this.totalRecords / this.pageSize);
            this.currentPage = 0;
            this.lowLimit = parseInt(this.currentPage) * parseInt(this.pageSize) + 1;//0+1 =1st record
            this.currentPage = this.currentPage + 1;//1
            this.isFirstPage = true;
            this.uppLimit = parseInt(this.currentPage) * parseInt(this.pageSize);// 20th record
            this.offset = this.lowLimit;
            this.oppList = this.rawData.slice(this.lowLimit - 1, this.uppLimit);// slicce(0,20)=>[0-19]
        }
        if (error) {
            console.log(error);
        }
    };

    @track prevButtonDisabled = true;
    @track nextButtonDisabled = false;
    prevPage(event) {
        this.nextButtonDisabled = false;
        this.currentPage = this.currentPage - 1;//2-1=1
        this.uppLimit = (parseInt(this.currentPage)) * parseInt(this.pageSize);//20
        this.lowLimit = (parseInt(this.currentPage) - 1) * parseInt(this.pageSize) + 1;//0+1=1st record
        this.oppList = this.rawData.slice(this.lowLimit - 1, this.uppLimit);//slice(0,20)=>[0-19]=>20 records
        if (this.currentPage == 1) {
            //this is the first page so disable the prev  button for next time to be unclickable
            this.prevButtonDisabled = true;
            this.isFirstPage = true;
        }
        else {
            this.prevButtonDisabled = false;
            this.isFirstPage = false;
        }

    }

    //**** Handle all when there are no records */
    nextPage(event) {
        this.prevButtonDisabled = false;

        this.currentPage = this.currentPage + 1;//1+1=2
        this.lowLimit = (parseInt(this.currentPage) - 1) * parseInt(this.pageSize) + 1;//20+1= 21st record
        this.uppLimit = parseInt(this.currentPage) * parseInt(this.pageSize);//40 th record
        if (this.currentPage == this.noOfPages) {
            //this is last  page so disable the nextPage button 
            this.uppLimit = this.totalRecords;
            this.nextButtonDisabled = true;
            this.isLastPage = true;
        }
        else {

            this.nextButtonDisabled = false;
            this.isLastPage = false;
        }
        this.oppList = this.rawData.slice(this.lowLimit - 1, this.uppLimit);//slice(20,31)=>[20-30]=>11 records
    }


    handleRowActions(event) {
        //Looking for if only one record is selected
        const action = event.detail.action;
        const row = event.detail.row;
        var lds = [];
        for (var i = 0; i < this.stored_data.length; i++) {
            if (this.stored_data[i].Id == row.Id) {
                lds.push(this.stored_data[i]);
                break;
            }
        }
        switch (action.name) {
            case 'integrate':
                {
                    sendOpp({ records: lds }).then(res => { alert(JSON.stringify(res)); console.log(res); }).catch(err => { alert(err); console.log(err); console.log(err.toString()); });
                    break;
                }
            case 'edit':
                {
                    this.oppName = lds[0].Name;
                    this.oppAmount = lds[0].Amount;
                    this.oppAccName = lds[0].Account.Name;
                    this.oppStageName = lds[0].StageName;
                    this.oppType = lds[0].Type;
                    this.oppId = lds[0].Id;
                    this.oppAccId = lds[0].AccountId;
                    this.opp=lds[0];
                    this.editRecord = true;

                }
                break;
        }

    }

    handleOppNameSearch(event) {
        this.jName = event.detail.value;
    }
    handleAccNameSearch(event) {
        this.jAccName = event.detail.value;
    }
    handleStageSearch(event) {
        this.jStage = event.detail.value;
    }
    handleTypeSearch(event) {
        this.jType = event.detail.value;
    }
    handleAmountSearch(event) {
        this.jAmount = event.detail.value;
    }


    @track editRecord = false;
    closepopup(event) {
        this.editRecord = false;
    }

    @track oppName;
    @track oppType;
    @track oppStageName;
    @track oppAmount;
    @track oppAccName;
    oppId;
    oppAccId;
    opp;
    updateOpp() {
        console.log('update clicked');
        updateOpp({ recId: this.oppId, sName: this.oppName, sAccountId: this.oppAccId, sType: this.oppType, sStageName: this.oppStageName, sAmount: this.oppAmount })
            .then(res => { console.log(res); alert(res); })
            .catch(err => { console.log(err); alert(err); });
    }

    oppNameChange(event) {
        this.oppName=event.detail.value;
    }
    oppAmountChange(event) {
        this.oppAmount=event.detail.value;
    }
    oppTypeChange(event) {
        this.oppType=event.detail.value;
    }
    oppStageNameChnage(event) {
        this.oppStageName=event.detail.value;
    }
    handleAccountChange(event){
        this.oppAccId=event.detail.selectedRecordId;
        this.oppAccName=event.detail.selectedRecordName;
    }

}