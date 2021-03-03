public with sharing class ShareOpportunitiesToExternalSite {
    @AuraEnabled
    public static String sendOpportunity(List<Opportunity> records){
        //List<Opportunity> selectedRecs=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity where id in :recIds];
       // sendOpportunites(JSON.serialize(opps));
       System.debug(records);
        HttpResponse resp=makeCallOut(JSON.serialize(records));
            //Converting json into sobject list
          // List<Opportunity> receivedOpps=(List<Opportunity>)JSON.deserialize(resp.getBody(), List<Opportunity>.class);
        if(resp.getStatusCode()==200) {
             for(Opportunity opp:records){
            	opp.Integration_Comments__c = resp.getStatus();
                opp.Integration_Status__c = 'SUCCESS';
             }
        }
        else {
             for(Opportunity opp:records){
            opp.Integration_Comments__c = resp.getStatus();
            opp.Integration_Status__c = resp.getStatusCode().format();
             }
        }
        try{
             update records;
            if(resp.getStatusCode()==200)
             return 'Shared And Updated Successfully';
            else return 'Unable To Connect To The Server But Status Updated Successfully';
        }
        catch(DmlException e){
            System.debug(e.getMessage());
              if(resp.getStatusCode()==200)
             return 'Shared But Failed To Update';
            else return 'Unable To Connect To The Server And Failed To Update';
        }
         
        
    }
    
     public static HttpResponse makeCallOut(String jsonOpps) {
        Http http=new Http();
        HttpRequest req=new HttpRequest();
        req.setEndPoint('https://bootcamp-project-node-server.herokuapp.com/');
        // req.setEndPoint('https://www.google.com/');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(jsonOpps);
        //System.debug(req);
        HttpResponse resp;
         try{
              resp=http.send(req);
         }
         catch(Exception e){
             System.debug(e.getMessage());
         }
     return resp;
    }
    
       //We can use this inside a trigger to call async
  //   @future(callout=true)
  //  public static void sendOpportunites(List<Id> recIds){
  //      List<Opportunity> selectedRecs=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity where id in :recIds];
  //      HttpResponse resp=makeCallOut(JSON.serialize(selectedRecs));
  //          //Converting json into sobject list
  //         List<Opportunity> opps=(List<Opportunity>)JSON.deserialize(resp.getBody(), List<Opportunity>.class);
  //       for(Opportunity opp:opps){
  //          if(resp.getStatusCode()==200) opp.Integration_Status__c = 'SUCCESS';
  //           else opp.Integration_Status__c = resp.getStatusCode().format(); 
  //          opp.Integration_Comments__c = resp.getStatus();
  //       }
  //      try{
  //           update opps;
  //      }
  //    catch(DMLException e){
  //          System.debug(e.getMessage());        
  //      }
  //  }
}