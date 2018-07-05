@isTest
private class batchJobs_Test 
{

    static testmethod void test() 
    {
        
       account acc = new account(Name='Test'); 
       insert acc;
       Case cs = new Case(accountid = acc.id,subject='Test Case',status='New');
       insert cs;
        
       Test.startTest();
       batchJobs c = new batchJobs();
       Database.executeBatch(c);
       Test.stopTest();
      
    }
}