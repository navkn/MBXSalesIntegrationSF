public class CustomPaginationSearch {
    public Opportunity opp{get;set;}
	public List<Opportunity> oppList {get;set;}
    private integer totalRecs  ;
    private integer OffsetSize ;
	private integer LimitSize;
    public String sName{get;set;}
    public String sAccountName{get;set;}
    public String sStageName{get;set;}
    public String sType{get;set;}
    public String sAmount{get;set;}

    //private ApexPages.StandardController ctrl;
    
    //public CustomPaginationSearch(ApexPages.StandardController controller){
    //ctrl=controller;
    //}
    
	public CustomPaginationSearch(){
 	opp = new Opportunity();
 	sName='';
    sAccountName='';
    sStageName='';
    sType='';
    sAmount='>0';
    totalRecs = 0;
    OffsetSize = 0;
    LimitSize=10;
}

	public void searchOpp(){
    totalRecs = 0;
    OffsetSize = 0;
    if(oppList !=null && oppList.size()>0){
       oppList=null;
     }
    searchOpps ();
    //conditionsClear();
}


	public void searchOpps(){
   if(oppList != null && !oppList.isEmpty()){
      oppList.clear();
   }
    sName=String.isBlank(sName) ? '' :sName;
    sAccountName=String.isBlank(sAccountName) ?'':sAccountName;
    sStageName=String.isBlank(opp.StageName) ? '': opp.StageName;
    sType=String.isBlank(opp.Type) ? '':opp.Type;
    sAmount=String.isBlank(sAmount)? '>0' : sAmount;
    
    String strQuery ='SELECT Account.Name,Amount,Name,StageName,Type,Integration_Status__c FROM Opportunity where name  like  \'' + sName + '%\' ' + ' and  Account.Name  like  \'' + sAccountName + '%\' ' + ' and  Type  like  \'' + sType + '%\' '+ ' and  StageName  like  \'' + sStageName + '%\' '+ ' and  Amount  '+ sAmount ; 
 
    //checked only at beginning
     if(totalRecs !=null && totalRecs ==0){
         List<Opportunity> oppTemp = Database.query(strQuery);
         totalRecs = (oppTemp !=null && oppTemp.size()>0) ? oppTemp.size():0;
     }
     // add sort and limits at the end  
      strQuery += ' ORDER BY Name  limit :LimitSize  offset  :OffsetSize';
      oppList  = Database.query(strQuery);
}
    
	public void  conditionsClear(){
        opp = new Opportunity();
     sName='';
    sAccountName='';
    sStageName='';
    sType='';
    sAmount='>0';
    totalRecs = 0;
    OffsetSize = 0;
        searchOpps();
    }
    
	public void FirstPage(){
OffsetSize = 0;
searchOpps();
}
    
	public void previous(){
OffsetSize = (OffsetSize-LimitSize);
searchOpps();
}
    
	public void next(){
OffsetSize = OffsetSize + LimitSize;
searchOpps();

}
    
	public void LastPage(){
    integer temp= Math.mod(totalRecs,LimitSize);
OffsetSize = totalRecs - temp;
searchOpps();
}
    
	public boolean getprev(){
if(OffsetSize == 0){
return true;
}
else {
return false;
}
}
    
	public boolean getnxt(){
    Integer t=OffsetSize + LimitSize;
if((t) > totalRecs){
return true;
}
else {
return false;
}
}

    public PageReference shareRecord(){
        String recId=ApexPages.currentPage().getParameters().get('shareId');
        List<Opportunity> lsopp=[SELECT Account.Name,Amount,Name,StageName,Type,Integration_Status__c FROM Opportunity where id= :recId ];
        //lsopp.add(lsopp);
        String result=ShareOpportunitiesToExternalSite.sendOpportunity(lsopp);
        //System.debug(result);
        PageReference pgref=Page.resultPage;
        pgref.getParameters().put('msg',result);
        pgref.getParameters().put('type','other');
        return pgref;
        
    }
    
     public PageReference editRecord(){
        String recId=ApexPages.currentPage().getParameters().get('editId');
        //List<Opportunity> lsopp=[SELECT Account.Name,Amount,Name,StageName,Type,Integration_Status__c FROM Opportunity where id= :recId ];
        //lsopp.add(lsopp);
        // System.debug(ShareOpportunitiesToExternalSite.sendOpportunity(lsopp));
        //PageReference editPage=new PageReference('/'+ recId);
        PageReference editPage=Page.CustomOpporRecordPage;
        editPage.setRedirect(true);
         editPage.getParameters().put('id',recId);
         editPage.getParameters().put('mode','EDIT');
        //howto pass id value from on epage to another vf page
         return editPage;
    }
    //public String oppRecId{set;get;}
    public PageReference navigateToRecord(){
        String recId=ApexPages.currentPage().getParameters().get('viewId');
         PageReference viewPage=Page.CustomOpporRecordPage;
        viewPage.setRedirect(true);
         viewPage.getParameters().put('id',recId);
         viewPage.getParameters().put('mode','VIEW');
        return viewPage;
    }
    

}