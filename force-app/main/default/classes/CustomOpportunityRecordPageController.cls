public class CustomOpportunityRecordPageController {
    //ApexPages.StandardController ctrl;
    public String ProfileName{set;get;}
    public String mode{set;get;}
    public Opportunity Opp{set;get;}
    public CustomOpportunityRecordPageController(){
       // ctrl = controller;
        //get the record id from url
        String ProfileId=userinfo.getProfileId();
        ProfileName=[select name from Profile where id= :ProfileId][0].name;
        String recordId=System.currentPageReference().getParameters().get('id');
        mode=System.currentPageReference().getParameters().get('mode');
        opp=[select Account.Name,Amount,CloseDate,CreatedDate,ExpectedRevenue,Integration_Comments__c,Integration_Status__c,Name,OwnerId,Probability,StageName,Type from Opportunity where id= :recordId][0];
    }
    
    public PageReference saveRecord(){
        PageReference pgref=Page.resultPage;
        try{
            update Opp;
            pgref.getParameters().put('msg','Done Successfully');
            pgref.getParameters().put('type','SUCCESS');
        }
        catch(Exception e){
            pgref.getParameters().put('msg',e.getMessage());
            pgref.getParameters().put('type','ERROR');
        }
        pgref.setRedirect(false);
        return pgref;
    }
    
    public PageReference cancelRecord(){
        PageReference pgref=Page.SalesOpportunitiesList;
        pgref.setRedirect(true);
        return pgref;
    }
    
    public PageReference editRecord(){
        PageReference editPage=Page.CustomOpporRecordPage;
        editPage.setRedirect(true);
         editPage.getParameters().put('id',Opp.Id);
         editPage.getParameters().put('mode','EDIT');
        //howto pass id value from on epage to another vf page
         return editPage;
    }
    
     public PageReference shareRecord(){
        //String recId=ApexPages.currentPage().getParameters().get('shareId');
        List<Opportunity> lsopp=[SELECT Account.Name,Amount,Name,StageName,Type,Integration_Status__c FROM Opportunity where id= :Opp.Id ];
        //lsopp.add(lsopp);
        String result=ShareOpportunitiesToExternalSite.sendOpportunity(lsopp);
        System.debug(result);
        PageReference pgref=Page.resultPage;
        pgref.getParameters().put('msg',result);
        pgref.getParameters().put('type','other');
        return pgref;
        
    }
}