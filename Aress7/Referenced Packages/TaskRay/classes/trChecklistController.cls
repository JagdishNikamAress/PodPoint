/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trChecklistController {
    global trChecklistController(ApexPages.StandardController stdController) {

    }
    @RemoteAction
    global static List<TASKRAY.trChecklistController.checklistItemWrapper> addChecklistItemForTask(Map<String,Object> itemInsertInfo) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trChecklistController.checklistItemWrapper> convertChecklistItem(Id checklistItemId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trChecklistController.checklistItemWrapper> deleteChecklistItem(Id checklistItemId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trChecklistController.checklistItemWrapper> editChecklistItem(Id checklistItemId, Map<String,Object> itemUpdateInfo) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trChecklistController.checklistItemWrapper> getChecklistItemsForTask(Id taskId) {
        return null;
    }
global class checklistItemWrapper {
    global TASKRAY__trChecklistItem__c checklistItem {
        get;
        set;
    }
    global Boolean completed {
        get;
        set;
    }
    global checklistItemWrapper(TASKRAY__trChecklistItem__c checklistItem) {

    }
}
}
