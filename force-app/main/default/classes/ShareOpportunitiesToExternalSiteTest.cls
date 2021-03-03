@isTest(SeeAllData=true)
public class ShareOpportunitiesToExternalSiteTest {
   
    @isTest
    public static void oppsShareSuccessUpdateSuccess(){
        List<Opportunity> oldTestRec=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity Limit 3];
         //setting the mock response
        Test.setMock(HttpCalloutMock.class, new ShareOpprtunitiesMockCallout('ShareSuccessUpdateSuccess'));
        //Test
        String actualOutp=ShareOpportunitiesToExternalSite.sendOpportunity(oldTestRec);
        //Load new values
        List<Opportunity> newTestRec=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity Limit 3];
        //Check values
        System.assertEquals('Shared And Updated Successfully', actualOutp, 'result is incorrect');
        for(Opportunity opp:newTestRec){
            System.assertEquals( 'SUCCESS' , opp.Integration_Status__c , 'Intg status is incorrect');
            System.assertEquals( 'OKAY' , opp.Integration_Comments__c , 'Intg comments is incorrect');
        }
        
    }
    
     @isTest
    public static void oppsShareFailUpdateSuccess(){
        List<Opportunity> oldTestRec=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity Limit 3];
         //setting the mock response
        Test.setMock(HttpCalloutMock.class, new ShareOpprtunitiesMockCallout('ShareFailUpdateSuccess'));
        //Test
        String actualOutp=ShareOpportunitiesToExternalSite.sendOpportunity(oldTestRec);
        //Load new values
        List<Opportunity> newTestRec=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity Limit 3];
        //Check values
        System.assertEquals('Unable To Connect To The Server But Status Updated Successfully', actualOutp, 'result is incorrect');
        for(Opportunity opp:newTestRec){
            System.assertEquals( '500' , opp.Integration_Status__c , 'Intg status is incorrect');
            System.assertEquals( 'Internal server serror' , opp.Integration_Comments__c , 'Intg comments is incorrect');
        }
        
    }
    
    @isTest
    public static void oppsShareSuccessUpdateFail(){
        List<Opportunity> oldTestRec=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity Limit 3];
         //setting the mock response
        Test.setMock(HttpCalloutMock.class, new ShareOpprtunitiesMockCallout('ShareSuccessUpdateFail'));
        //Test
        String actualOutp=ShareOpportunitiesToExternalSite.sendOpportunity(oldTestRec);
        //Load new values
        List<Opportunity> newTestRec=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity Limit 3];
        //Check values
         System.assertEquals('Shared But Failed To Update', actualOutp, 'result is incorrect');
        for(Opportunity newOpp:newTestRec){
            for(Opportunity oldOpp:oldTestRec){
                if(oldOpp.Id == newOpp.Id){
                     System.assertEquals( oldOpp.Integration_Status__c , newOpp.Integration_Status__c , 'Intg status is incorrect');
                     System.assertEquals( oldOpp.Integration_Comments__c , newOpp.Integration_Comments__c , 'Intg comments is incorrect');
                }
            }
           
        }
        
    }
    
     @isTest
    public static void oppsShareFailUpdateFail(){
        List<Opportunity> oldTestRec=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity Limit 3];
         //setting the mock response
        Test.setMock(HttpCalloutMock.class, new ShareOpprtunitiesMockCallout('ShareFailUpdateFail'));
        //Test
        String actualOutp=ShareOpportunitiesToExternalSite.sendOpportunity(oldTestRec);
        //Load new values
        List<Opportunity> newTestRec=[select Id,Name,Amount,StageName,Type,AccountId,CloseDate,Integration_Status__c,Integration_Comments__c from opportunity Limit 3];
        //Check values
        System.assertEquals('Unable To Connect To The Server And Failed To Update', actualOutp, 'result is incorrect');
        for(Opportunity newOpp:newTestRec){
            for(Opportunity oldOpp:oldTestRec){
                if(oldOpp.Id == newOpp.Id){
                     System.assertEquals( oldOpp.Integration_Status__c , newOpp.Integration_Status__c , 'Intg status is incorrect');
                     System.assertEquals( oldOpp.Integration_Comments__c , newOpp.Integration_Comments__c , 'Intg comments is incorrect');
                }
            }
           
        }
        
    }
    
    //It will be executed first automatically
   // @testSetup static void testSetUpOpportunities(){
        // Create common test opportunities
    //    List<Opportunity> testOpps = new List<Opportunity>();
    //    for(Integer i=0;i<5;i++) {
    //        testOpps.add(new Opportunity(Name = 'TestOpp'+i , StageName='Prospecting' , CloseDate=System.today()));
    //    }
    //    try{
    //    insert testOpps;
    //    }
    //    catch(DmlException ex){
    //        return;
    //    }
   // }
}