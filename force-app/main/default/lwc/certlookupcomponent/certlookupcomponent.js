import { LightningElement, track, api } from 'lwc';
import searchRecords from '@salesforce/apex/SearchPageApexController.searchRecords';

export default class Certlookupcomponent extends LightningElement {
    @api objectName = 'Account';
    @api fieldName = 'Name';
    @api iconname = 'standard:record';
    @api label = 'Account';
    @api parentidfield = 'AccountId';
    listLL=[1,2,3];
    /* private property */
    @track records;
    @api selectedRecord;
    @api predefinedRecord;

    connectedCallback() {
        console.log('inside lookup');
        console.log(this.selectedRecord);
        console.log(this.predefinedRecord);
    }

    hanldeSearch(event) {

        var searchVal = event.detail.value;

        searchRecords({
            objName: this.objectName,
            fieldName: this.fieldName,
            searchKey: searchVal
        })
            .then(data => {
                if (data) {
                     
                    let searchRecordList = JSON.parse(data);
                    //console.log(searchRecordList);
                    // for (let i = 0; i < searchRecordList.length; i++) {
                    //     let record = searchRecordList[i];
                    //     record.Name = record[this.fieldName];
                    // }
                    //window.console.log(' data ', searchRecordList);
                    this.records = searchRecordList;
                    console.log(this.records);
                }
            })
            .catch(error => {
                window.console.log(' error ', error);
            });
    }

    handleSelect(event) {
        var selectedVal = event.detail.selRec;
        this.selectedRecord = selectedVal;
        //alert(this.selectedRecord.Name);
        //alert(this.selectedRecord.Id);
        let finalRecEvent = new CustomEvent('select', {
            detail: { selectedRecordId: this.selectedRecord.Id, parentfield: this.parentidfield, selectedRecordName: this.selectedRecord.Name }
        });
        this.dispatchEvent(finalRecEvent);
    }

    // handleRemove() {
    //     this.selectedRecord = undefined;
    //     this.records = undefined;
    //     this.predefinedRecord = undefined;
    //     let finalRecEvent = new CustomEvent('select', {
    //         detail: { selectedRecordId: undefined, parentfield: this.parentidfield, selectedRecordName: undefined }
    //     });
    //     this.dispatchEvent(finalRecEvent);
    // }
     handleRemove() {
         console.log('clicked');
        // this.selectedRecord = undefined;
        // this.records = undefined;
        // this.predefinedRecord = undefined;
        // let finalRecEvent = new CustomEvent('select', {
        //     detail: { selectedRecordId: undefined, parentfield: this.parentidfield, selectedRecordName: undefined }
        // });
        // this.dispatchEvent(finalRecEvent);
    }

}