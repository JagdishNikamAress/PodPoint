/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trCloneProject {
    global trCloneProject() {

    }
    @InvocableMethod(label='Clone a TaskRay Project' description='Will Clone a TaskRay project and overwrite parent project fields')
    global static void cloneTaskRayProject(List<TASKRAY.trCloneProject.Request> requests) {

    }
global class Request {
    @InvocableVariable(label='Project Name' required=false)
    global String optionalParam1;
    @InvocableVariable(label='Starting Date of First Task (pick one)' required=false)
    global Date optionalParam2;
    @InvocableVariable(label='Ending Date of Last Task (pick one)' required=false)
    global Date optionalParam3;
    @InvocableVariable(label='Driving Milestone Date (pick one, requires Driving Milestone Id)' required=false)
    global Date optionalParam3DrivingMilestoneDate;
    @InvocableVariable(label='Driving Milestone Id (optional)' required=false)
    global Id optionalParam3DrivingMilestoneId;
    @InvocableVariable(label='1. Map Source Field (repeat for each pair)' required=false)
    global List<String> optionalParam4;
    @InvocableVariable(label='2. To Project Field (repeat for each pair)' required=false)
    global List<String> optionalParam5;
    @InvocableVariable(label='Source Object Id' required=true)
    global Id sourceRecordId;
    @InvocableVariable(label='3. Users To Add To Project Team' required=false)
    global String teamMembers;
    @InvocableVariable(label='Template Project Id' required=true)
    global Id templateProjectId;
    global Request() {

    }
}
}
