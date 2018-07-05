/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trLightningComponentDataProvider {
    global trLightningComponentDataProvider() {

    }
    @RemoteAction
    global static List<TASKRAY__Project_Task__c> getMilestonesForProject(Id projectId) {
        return null;
    }
    global static List<TASKRAY_LTNG.trLightningComponentDataProvider.projectWrapper> getProjectsWithALookupToRecord(Id recordId) {
        return null;
    }
    global static List<TASKRAY__Project__c> getTemplateProjects() {
        return null;
    }
    @Deprecated
    global static List<SObject> querySObject(String sObjectName, List<String> fieldsToQuery, Map<String,Object> whereClauses) {
        return null;
    }
global class projectWrapper {
    global TASKRAY__Project__c project {
        get;
        set;
    }
    global List<TASKRAY__Project_Task__c> tasks {
        get;
        set;
    }
    global projectWrapper(TASKRAY__Project__c project, List<TASKRAY__Project_Task__c> tasks) {

    }
}
}
