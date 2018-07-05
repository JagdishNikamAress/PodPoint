@isTest
private class RunFieldAwareBatch_Test 
{

    static testmethod void test() 
    {
        
       Test.startTest();
       RunFieldAwareBatch c = new RunFieldAwareBatch();
       c.RunBatch();
       Test.stopTest();
      
    }
}