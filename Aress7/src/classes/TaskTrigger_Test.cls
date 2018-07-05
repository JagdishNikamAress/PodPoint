@isTest
Public class TaskTrigger_Test {
	
    static testMethod void testTaskCompletionEvent(){
        // Create a lead record
        Lead ld = new Lead(LastName='TestLead',Company='TestCompany',Status='Open - Not Contacted');
        insert ld;
        
        // Create a task record
        System.Test.startTest();
        Task tsk = new Task(OwnerId=UserInfo.getUserId(),Subject='Call',Priority='High',TaskSubtype='Email',Status='Completed',WhoId=ld.Id);
        insert tsk;
        Task tsk2 = new Task(OwnerId=UserInfo.getUserId(),Subject='Call',Priority='High',TaskSubtype='Call',Status='Completed',WhoId=ld.Id);
        insert tsk2;
        System.Test.stopTest();
    }
}