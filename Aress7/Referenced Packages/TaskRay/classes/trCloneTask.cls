/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trCloneTask {
    global trCloneTask() {

    }
    @InvocableMethod(label='Clone a TaskRay Task' description='Will Clone a TaskRay task and overwrite task fields')
    global static List<TASKRAY__Project_Task__c> cloneTaskRayTask(List<TASKRAY.trCloneTask.Request> requests) {
        return null;
    }
global class Request {
    @InvocableVariable(label='Owner for task' required=false)
    global Id ownerId;
    @InvocableVariable(label='Project for task' required=false)
    global Id projectId;
    @InvocableVariable(label='Source Object Id (populates lookup fields on task)' required=false)
    global Id sourceRecordId;
    @InvocableVariable(label='Ending Date of Task' required=false)
    global Date taskEndDate;
    @InvocableVariable(label='Task Name' required=false)
    global String taskName;
    @InvocableVariable(label='Starting Date of Task' required=false)
    global Date taskStartDate;
    @InvocableVariable(label='Template Task Id' required=true)
    global Id templateTaskId;
    global Request() {

    }
}
}
