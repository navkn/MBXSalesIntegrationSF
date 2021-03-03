public class ShareOpprtunitiesMockCallout implements HttpCalloutMock{
    String context;
    public ShareOpprtunitiesMockCallout(String ctx){
        context=ctx;
    }
//create a fake response
    public HttpResponse respond(HttpRequest req){
         List<Opportunity> selectedRecs=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity Limit 3];
        //String body='[{"attributes": {"type": "Opportunity","url": "/services/data/v49.0/sobjects/Opportunity/0062w000007FSuQAAW"},"Id": "0062w000007FSuQAAW","Name": "United Oil SLA","Amount": "120000","StageName": "Closed Won","Type": "Existing Customer - Upgrade","AccountId": "0012w00000KtEl1AAF","CloseDate": "2020-08-25","Integration_Status__c": "SUCCESS"}';
        System.debug(selectedRecs);
       HttpResponse resp=new HttpResponse();
        resp.setHeader('Content-Type', 'application/json;charset=UTF-8');
        if(context=='ShareSuccessUpdateSuccess'){
             resp.setStatus('OKAY');
             resp.setStatusCode(200);
        }
          if(context=='ShareFailUpdateSuccess'){
             resp.setStatus('Internal server serror');
             resp.setStatusCode(500);
        }
          if(context=='ShareSuccessUpdateFail'){
             resp.setStatus('OKAY');
             resp.setStatusCode(200);
              selectedRecs[0].name='';
        }
          if(context=='ShareFailUpdateFail'){
             resp.setStatus('Internal server serror');
             resp.setStatusCode(500);
               selectedRecs[0].name='';
        }
        resp.setBody(JSON.serialize(selectedRecs));
        return resp;
    } 
}