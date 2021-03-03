public with sharing class SearchPageApexController {
    public SearchPageApexController() {
    }
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getAllOpportunities(String sName,String sAccountName,String sType,String sStageName,String sAmount){
       
    sAmount=(sAmount==null || sAmount=='') ? ' >0 ': sAmount ;
  String main='SELECT Account.Name,Amount,Name,StageName,Type,CloseDate,Integration_Status__c,Integration_Comments__c FROM Opportunity where name  like  \'' + sName + '%\' ' + ' and  Account.Name  like  \'' + sAccountName + '%\' ' + ' and  Type  like  \'' + sType + '%\' '+ ' and  StageName  like  \'' + sStageName + '%\' '+ ' and  Amount  '+ sAmount + '  order by name'  ;
  List<Opportunity> lsopp=Database.query(main);
  return lsopp;
}
    @AuraEnabled
    public static String updateOpportunity(String recId,String sName,String sAccountId,String sType,String sStageName,Integer sAmount){
        Opportunity opp=new Opportunity(Id=recId,Name=sName,AccountId=sAccountId,Type=sType,StageName=sStageName,Amount=sAmount);
        try{
            update opp;
            return 'Updated Successfully';
        }
        catch(DmlException e){
            return e.getMessage();
        }
    }
    @AuraEnabled
    public static String searchRecords(String objName,String fieldName,String searchKey){
        searchKey='\''+searchKey+'%\'';

        String dynamicQuery='select '+ fieldName+' from '+objName + ' where '+ fieldName + ' like ' + searchKey;
        List<sObject> lsopp=Database.query(dynamicQuery);
        //List<Opportunity> lsopp=[select :fieldName from :objName where :fieldName like :searchKey];
         return JSON.serialize(lsopp);
         //return dynamicQuery;
    }
}
// String main='SELECT Account.Name,Amount,Name,StageName,Type FROM Opportunity  where (name like  \'' + sName + '%\' ';
//  main=sStageName==null   ?  main                              :  main + ' and  (StageName  like  \'' + sStageName + '%\' ';
// main=(sType==null || sType=='') ?  main  + ' or ( Type = null ' :sType==' '?  main  + ' and ( Type = null ' : main + ' and  Type  like  \'' + sType + '%\' ';
//  main=(sAccountName==null || sAccountName=='') ?  main + ' or ( Account.Name = null ' : sAccountName==' '?main +' and ( Account.Name = null ' : main + ' and  ( Account.Name  like  \'' + sAccountName + '%\' ';
//  main=(sAmount==null || sAmount=='')?  main + ' or Amount > 0 ))))'  : sAmount==' '? main  + ' and Amount = null ))))' :  main + ' and Amount  '+ sAmount + '))))';

   
    
    //public with sharing class MyControllerExtension {
//     private ApexPages.StandardSetController setController;
//  private Opportunity[] opportunities;
//     public SearchPageApexController(ApexPages.StandardSetController setController) {
//         this.setController = setController;
        
//        this.opportunities = [SELECT Id, Name,Account.Name,Amount,Type, StageName FROM Opportunity Limit 10];
//         this.setController.setSelected(this.opportunities);
//     }
    
    
//     public List<Opportunity> getOpportunitiesItems(){
//         return this.opportunities;
//     }
    //}