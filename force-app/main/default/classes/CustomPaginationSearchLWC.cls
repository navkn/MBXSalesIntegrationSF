public class CustomPaginationSearchLWC {
    public CustomPaginationSearchLWC(){
        
    }
    
     @AuraEnabled(cacheable=true)
    public static List<Opportunity> getAllOpportunities(String sName,String sAccountName,String sType,String sStageName,String sAmount){
        sAmount=(sAmount==null || sAmount=='') ? ' >0 ': sAmount ;
  		String main='SELECT Account.Name,Amount,Name,StageName,Type,CloseDate,Integration_Status__c,Integration_Comments__c FROM Opportunity where name  like  \'' + sName + '%\' ' + ' and  Account.Name  like  \'' + sAccountName + '%\' ' + ' and  Type  like  \'' + sType + '%\' '+ ' and  StageName  like  \'' + sStageName + '%\' '+ ' and  Amount  '+ sAmount  ;
  		List<Opportunity> lsopp=Database.query(main);
  		return lsopp;
    }
}