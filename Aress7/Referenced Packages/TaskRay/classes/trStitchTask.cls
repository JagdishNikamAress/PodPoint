/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trStitchTask {
    global trStitchTask() {

    }
    @InvocableMethod(label='Stitch a TaskRay Task' description='Stitch together a TaskRay Task from Checklist Groups')
    global static List<TASKRAY.trStitchTask.Request> stitchTask(List<TASKRAY.trStitchTask.Request> requests) {
        return null;
    }
global class Request {
    @InvocableVariable(label='1. Checklist Group Id' required=false)
    global Id checklistGroup1Id;
    @InvocableVariable(label='2. Checklist Group Id' required=false)
    global Id checklistGroup2Id;
    @InvocableVariable(label='3. Checklist Group Id' required=false)
    global Id checklistGroup3Id;
    @InvocableVariable(label='4. Checklist Group Id' required=false)
    global Id checklistGroup4Id;
    @InvocableVariable(label='5. Checklist Group Id' required=false)
    global Id checklistGroup5Id;
    @InvocableVariable(label='New Task?' required=false)
    global Boolean createNewTask;
    @InvocableVariable(label='Existing Task Id (only if New Task? is false)' required=false)
    global Id existingTaskId;
    @InvocableVariable(label='Source Object Id (populates lookup fields on task)' required=false)
    global Id sourceRecordId;
    @InvocableVariable(label='New Task Name (only if New Task? is true)' required=false)
    global String taskName;
    @InvocableVariable(label='New Task End Date (only if New Task? is true)' required=false)
    global Date taskTemplateEndDate;
    @InvocableVariable(label='New Task Template Id (only if New Task? is true)' required=false)
    global Id taskTemplateId;
    @InvocableVariable(label='New Task Owner Id (only if New Task? is true)' required=false)
    global Id taskTemplateOwnerId;
    @InvocableVariable(label='New Task Project Id (only if New Task? is true)' required=false)
    global Id taskTemplateProjectId;
    @InvocableVariable(label='New Task Start Date (only if New Task? is true)' required=false)
    global Date taskTemplateStartDate;
    global Request() {

    }
}
global class StitchTaskConfigWrapper {
    global List<Id> checklistGroupIds {
        get;
        set;
    }
    global Id existingTaskId {
        get;
        set;
    }
    global Id newlyCreatedTaskId {
        get;
        set;
    }
    global Boolean newTask {
        get;
        set;
    }
    global Date newTaskEndDate {
        get;
        set;
    }
    global String newTaskName {
        get;
        set;
    }
    global Id newTaskOwnerId {
        get;
        set;
    }
    global Id newTaskProjectId {
        get;
        set;
    }
    global Date newTaskStartDate {
        get;
        set;
    }
    global Id templateTaskId {
        get;
        set;
    }
    global String uniqueTaskIdentifier {
        get;
        set;
    }
}
}
