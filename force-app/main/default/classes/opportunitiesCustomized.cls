public with sharing class opportunitiesCustomized{
    private  ApexPages.StandardSetController ssc;
    public opportunitiesCustomized(){
        this.NameFromVF='hii';
       this.ssc=new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name,Account.Name,Amount,Type, StageName FROM Opportunity ]));
    }
    public List<Opportunity> getOpportunities() {
        return (List<Opportunity>) this.ssc.getRecords();
    }
   
    public ApexPages.StandardSetController getSsc(){
        return this.ssc;
    }
    
    public  List<Opportunity> getSearchOpportunities(String sName,String sAccountName,String sType,String sStageName,String sAmount){
       
  String query='SELECT Account.Name,Amount,Name,StageName,Type FROM Opportunity where name  like  \'' + sName + '%\' ' + ' and  Account.Name  like  \'' + sAccountName + '%\' ' + ' and  Type  like  \'' + sType + '%\' '+ ' and  StageName  like  \'' + sStageName + '%\' '+ ' and  Amount  '+ sAmount;
       List<Opportunity> lsopp=Database.query(query);
        this.ssc.setSelected(lsopp);
       return lsopp;
    }
   // public void setNameFromVF() {
   //     //return 'okay';
   // }
    public String NameFromVF{set;get;}
    public PageReference inc(){
        String sName='u';
        this.NameFromVF='hello';
         String query='SELECT Account.Name,Amount,Name,StageName,Type FROM Opportunity where name  like  \'' + sName + '%\' ' ;
       List<Opportunity> lsopp=Database.query(query);
        this.ssc.setSelected(lsopp);
        return null;
    }
}