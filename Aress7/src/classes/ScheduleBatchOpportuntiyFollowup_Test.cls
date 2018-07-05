@isTest
private class ScheduleBatchOpportuntiyFollowup_Test {

    static testMethod void myTestMethod() {        
         test.starttest();
         ScheduleBatchOpportuntiyFollowup mySchedule = new ScheduleBatchOpportuntiyFollowup ();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Schedule', chron, mySchedule);
         test.stopTest();
    }
}