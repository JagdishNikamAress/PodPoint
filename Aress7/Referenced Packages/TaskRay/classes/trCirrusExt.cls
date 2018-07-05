/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trCirrusExt {
    global Id accountIdForContact {
        get;
        set;
    }
    global String columnSortingFields {
        get;
        set;
    }
    global String customLabelJSON {
        get;
        set;
    }
    global String priorityFieldInfo {
        get;
        set;
    }
    global trCirrusExt() {

    }
    @RemoteAction
    global static void attachEmailToTask(Id taskId, String toString, String fromString, String ccString, String bccString, String subjectString, String bodyString, Id currentUserId) {

    }
    @RemoteAction
    global static void completeTasks(List<Id> taskIds) {

    }
    @RemoteAction
    global static List<TASKRAY.trCirrusExt.checklistWrapper> getChecklistInformationForTasks(Set<Id> taskIds) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trCirrusExt.cirrusInfoWrapper getInfoBasedOnId(Id userId, Id contextId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trCirrusExt.cirrusInfoWrapper getInfoForLookupToRecord(Id recordId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trCirrusExt.cirrusInfoWrapper getInfoForUser(Id userId) {
        return null;
    }
    global void setCustomLabelJSON() {

    }
    @RemoteAction
    global static void toggleChecklistItems(List<Id> checklistItemIds) {

    }
    @RemoteAction
    global static void toggleProjectFavorites(List<Id> projectIds) {

    }
global class checklistWrapper {
}
global class cirrusInfoWrapper {
}
global class projectWrapper {
}
global class taskWrapper {
}
}
