@isTest
private class BatchFollowupOpportunity_Test 
{

    static testmethod void test() 
    {
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
       Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().adddays(-3).Date(),StageName='Qualification');
      
  	   insert opp; 
        
    
       Test.startTest();
       BatchFollowupOpportunity c = new BatchFollowupOpportunity();
       Database.executeBatch(c);
       Test.stopTest();
      
    }
}