@isTest
public class TaskRayProjectTriggerTest {
    static testMethod void TestMethodTaskRayProjectTrigger() {
        TASKRAY__Project__c NewTask = new TASKRAY__Project__c();
        NewTask.Name = 'Test';
        NewTask.TASKRAY__trTemplate__c = true;
        insert Newtask;
        
        
        TASKRAY__Project_Task__c TRTask1= new TASKRAY__Project_Task__c();
        TRTask1.TASKRAY__Project__c =Newtask.Id ;
        TRTask1.Name = 'TRTaskname';
        //   TRTask1.TASKRAY__Priority__c = TRTask.TASKRAY__Priority__c;
        //   TRTask1.TASKRAY__List__c = TRTask.TASKRAY__List__c;
        //  TaskrayprojectTasks.add(TRTask1);
        INSERT TRTask1;
        TASKRAY__Project__c NewTask2 = new TASKRAY__Project__c();
        NewTask2.Name = 'Test';
        NewTask2.TASKRAY__trTemplate__c = false;
        NewTask2.TASKRAY__trTemplateSource__c = Newtask.id;
        insert Newtask2;
    }
}