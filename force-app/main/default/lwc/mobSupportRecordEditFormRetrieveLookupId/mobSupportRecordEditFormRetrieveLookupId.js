/*
    Title: Retrieve Lookup RecordId in RecordEditForm under MobileVersion
    Requirement:Create a Lightning Quick Action on Account Detail Page to create a new Opportunity And should work on Mobile Version too. 
    Problem: In Mobile Version, when we click that particular quick action which we create displays in a new screen page where we r unable to have our account recordId available here.
    Reason: When we click That action an aura comp is generated and further calls this LWC by providing the recordId.The auraComp got the recordId by using force:hasRecordId. But in mobileVersion hasRecordId has got no value.
    Fix: 
    1st Way=> 1. Insert an Empty component in RecordPage that stores recordId in browser Window object.(use connectedCallback) 
              2. We can get that recordId by extracting it from url using substring methods. Else use currentPageReference
              3. And This component retrieves the recordId from Window object and use here(use connectedCallback)
    2nd Way=> Use CurrentPageReference in lwc and that has url params stored as attributes. 
    The latter way works very easily because in any mobile or desktop view, the url is not changing . So there is no need no creating an extra comp and attach it in the sourcepage i.e. on recordPage here. 
    */
   import { LightningElement, wire, track, api } from 'lwc';
   import { ShowToastEvent } from 'lightning/platformShowToastEvent';
   import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
   
   export default class MobSupportRecordEditFormRetrieveLookupId extends NavigationMixin(LightningElement) {
       /*
       //1st way
       //Here we used api bcz if we use this inside aura comp then these can be set by auracomp by using force:hasRecordId and force:hasSObjectName 
       //but force:hasrecordId is not working as it returning null. 
       @api recordId;
       @api SObjectType;
       connectedCallback() {
           if (window.myApplication != undefined) {
               this.recordId = window.myApplication.state.accId;
               this.SObjectType = window.myApplication.state.SObjectType;
           }
       }
       */
   
       //2nd way
       @track recordId;
       @track SObjectType;//This is used just to navigate to particular object home page
       newRecId;
       pageRef;
       @wire(CurrentPageReference) storePageRef(resp) {
           this.pageRef = resp;
           this.recordId = this.pageRef.attributes.recordId;
           this.SObjectType = this.pageRef.attributes.objectApiName;
       };
   
       handleOppCreated(event) {
           this.newRecId = event.detail.id;
           this.dispatchEvent(
               new ShowToastEvent({
                   title: 'Record Creation is Successful',
                   message: '',
                   variant: 'success',
               })
           );
           this[NavigationMixin.Navigate]({
               type: 'standard__recordPage',
               attributes: {
                   recordId: this.newRecId,
                   actionName: 'view'
               }
           });
   
   
       }
   
       cancel(event) {
   
           this[NavigationMixin.Navigate]({
               type: 'standard__objectPage',
               attributes: {
                   objectApiName: this.SObjectType,
                   actionName: 'home',
               },
           });
       }
   
   }