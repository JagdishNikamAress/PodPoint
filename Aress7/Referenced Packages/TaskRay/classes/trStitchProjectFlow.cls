/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trStitchProjectFlow {
    global trStitchProjectFlow() {

    }
    @InvocableMethod(label='Stitch a TaskRay Project (Flow Only)' description='Stitch together a TaskRay Project from Task Groups')
    global static List<Id> stitchProject(List<TASKRAY.trStitchProjectFlow.Request> requests) {
        return null;
    }
global class Request {
    @InvocableVariable(label='New Project?' required=true)
    global Boolean createNewProject;
    @InvocableVariable(label='Existing Project Id (only if New Project? is false)' required=false)
    global Id existingProjectId;
    @InvocableVariable(label='New Project Date Target (only if New Project? is true)' required=false)
    global Date projectDateTarget;
    @InvocableVariable(label='New Project Name (only if New Project? is true)' required=false)
    global String projectName;
    @InvocableVariable(label='New Project Schedule Mode (only if New Project? is true "Start", "End", or a Milestone Id)' required=false)
    global String projectScheduleMode;
    @InvocableVariable(label='New Project Template Id (only if New Project? is true)' required=false)
    global Id projectTemplateId;
    @InvocableVariable(label='Source Object Id (populates lookup fields on project)' required=false)
    global Id sourceRecordId;
    @InvocableVariable(label='Task Group Id List' required=true)
    global List<Id> taskGroupIds;
    @InvocableVariable(label='Task Group Schedule Mode List ("Start", "End", or a Milestone Id)' required=false)
    global List<String> taskGroupScheduleModes;
    @InvocableVariable(label='Task Group Target Date List' required=false)
    global List<Date> taskGroupTargetDates;
    global Request() {

    }
}
}
