/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trChecklistActionController {
    global String currentUserInfo {
        get;
        set;
    }
    global String customLabelJSON {
        get;
        set;
    }
    global trChecklistActionController(ApexPages.StandardController stdController) {

    }
    @RemoteAction
    global static Object addChecklistItem(Id taskId, String text, Id checklistGroupId, Double sortOrder) {
        return null;
    }
    @RemoteAction
    global static Object changeItemField(List<Map<String,String>> itemsToUpdate) {
        return null;
    }
    @RemoteAction
    global static Object deleteChecklistGroup(Id checklistGroupId) {
        return null;
    }
    @RemoteAction
    global static Object deleteChecklistItem(Id checklistId) {
        return null;
    }
    @RemoteAction
    global static List<Object> getDetailedInformationForTasks(List<Id> taskIds) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.initialInfoWrapper getInitialInfo() {
        return null;
    }
    @RemoteAction
    global static Object quickAddChecklistGroup(Id taskId, String checklistGroupName) {
        return null;
    }
    @RemoteAction
    global static List<User> searchUsers(String searchString) {
        return null;
    }
}
