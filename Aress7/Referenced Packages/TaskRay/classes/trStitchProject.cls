/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trStitchProject {
    global trStitchProject() {

    }
    @InvocableMethod(label='Stitch a TaskRay Project' description='Stitch together a TaskRay Project from Task Groups')
    global static void stitchProject(List<TASKRAY.trStitchProject.Request> requests) {

    }
global class Request {
    @InvocableVariable(label='New Project?' required=false)
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
    @InvocableVariable(label='Task Group 1 Id' required=false)
    global Id taskGroup1Id;
    @InvocableVariable(label='Task Group 1 Schedule Mode ("Start", "End", or a Milestone Id)' required=false)
    global String taskGroup1ScheduleMode;
    @InvocableVariable(label='Task Group 1 Target Date' required=false)
    global Date taskGroup1TargetDate;
    @InvocableVariable(label='Task Group 2 Id' required=false)
    global Id taskGroup2Id;
    @InvocableVariable(label='Task Group 2 Schedule Mode ("Start", "End", or a Milestone Id)' required=false)
    global String taskGroup2ScheduleMode;
    @InvocableVariable(label='Task Group 2 Target Date' required=false)
    global Date taskGroup2TargetDate;
    @InvocableVariable(label='Task Group 3 Id' required=false)
    global Id taskGroup3Id;
    @InvocableVariable(label='Task Group 3 Schedule Mode ("Start", "End", or a Milestone Id)' required=false)
    global String taskGroup3ScheduleMode;
    @InvocableVariable(label='Task Group 3 Target Date' required=false)
    global Date taskGroup3TargetDate;
    @InvocableVariable(label='Task Group 4 Id' required=false)
    global Id taskGroup4Id;
    @InvocableVariable(label='Task Group 4 Schedule Mode ("Start", "End", or a Milestone Id)' required=false)
    global String taskGroup4ScheduleMode;
    @InvocableVariable(label='Task Group 4 Target Date' required=false)
    global Date taskGroup4TargetDate;
    @InvocableVariable(label='Task Group 5 Id' required=false)
    global Id taskGroup5Id;
    @InvocableVariable(label='Task Group 5 Schedule Mode ("Start", "End", or a Milestone Id)' required=false)
    global String taskGroup5ScheduleMode;
    @InvocableVariable(label='Task Group 5 Target Date' required=false)
    global Date taskGroup5TargetDate;
    global Request() {

    }
}
global class StitchProjectConfigWrapper {
    global List<String> dateModes {
        get;
        set;
    }
    global Id existingProjectId {
        get;
        set;
    }
    global Boolean newProject {
        get;
        set;
    }
    global String newProjectName {
        get;
        set;
    }
    global String projectDateMode {
        get;
        set;
    }
    global Date projectDateTarget {
        get;
        set;
    }
    global List<Date> targetDates {
        get;
        set;
    }
    global List<Id> taskGroupIds {
        get;
        set;
    }
    global Id templateProjectId {
        get;
        set;
    }
    global String uniqueProjectIdentifier {
        get;
        set;
    }
}
}
