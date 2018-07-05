/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trController {
    global List<TASKRAY.trController.groupWrapper> groupFilterList {
        get;
        set;
    }
    global List<TASKRAY.trController.groupWrapper> groupFilterListAll {
        get;
        set;
    }
    @RemoteAction
    global static void addProjectContributors(List<String> contributorIds, String projectId) {

    }
    @RemoteAction
    global static List<SObject> addRecordSObjectTags(List<String> tags, String taskId) {
        return null;
    }
    global static void addRepeatTasks(List<TASKRAY__Project_Task__c> completedTasks) {

    }
    @RemoteAction
    global static TASKRAY.trController.taskWithPhotoWrapper addTask(String Title, String currentProject) {
        return null;
    }
    @RemoteAction
    global static void archivePersonalTasksInLastColumn() {

    }
    @RemoteAction
    global static void archiveProject(String projectId) {

    }
    @RemoteAction
    global static void archiveProjectTasksInLastColumn(Id projectId) {

    }
    global static void archiveProjects(List<TASKRAY__Project__c> projects) {

    }
    @RemoteAction
    global static void assignAssigneeSidebarDrop(String taskId, String userId) {

    }
    @RemoteAction
    global static Boolean assignOwnerSidebarDrop(String taskId, String userId) {
        return null;
    }
    @RemoteAction
    global static Boolean assignOwnerSidebarDrop_bulk(List<Id> taskIds, Id userId) {
        return null;
    }
    @RemoteAction
    global static void assignProjectSidebarDrop(String taskId, String projectId) {

    }
    @RemoteAction
    global static void assignProjectSidebarDrop_bulk(List<Id> taskIds, Id projectId) {

    }
    @RemoteAction
    global static Boolean checkForPublicReadPermission() {
        return null;
    }
    @RemoteAction
    global static void cloneProject(String projectId, String newProjectName) {

    }
    @RemoteAction
    global static String cloneProjectReturnId(String projectId, String newProjectName) {
        return null;
    }
    @RemoteAction
    global static String cloneProjectReturnId_v2(Map<String,String> projectInfo) {
        return null;
    }
    @RemoteAction
    global static void deleteRecordSobjectTag(String projectTaskTagId) {

    }
    @RemoteAction
    global static void deleteTasks(List<Id> tasksToDel) {

    }
    @RemoteAction
    global static List<SObject> fetchNotifications(String type, List<String> initMap, String startTime, String endTime) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.planningViewItemWrapper> fetchPlanningView(String tabId, List<String> projectIds, String userId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.planningViewItemWrapper_v2> fetchPlanningView_v2(String tabId, List<String> projectIds, String userId) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,String>> fetchProject(String projectId) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,String>> fetchProject_v2(String projectId, String userId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.taskWithPhotoWrapper> fetchTask(String tabId, String taskId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.taskWithPhotoWrapper> fetchTask_v2(String tabId, String taskId, String userId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.taskWithPhotoWrapper> fetchTasksFromList(String tabId, List<Id> taskIds, String userId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.taskWithPhotoWrapper> fetchTasks(String tabId, String projStr) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.taskWithPhotoWrapper> fetchTasks_v2(String tabId, String projStr, String userId) {
        return null;
    }
    @Future(callout=false)
    global static void futureAddRepeatTasks(List<Id> taskIds) {

    }
    @RemoteAction
    global static List<TASKRAY.trController.chatterGroupWrapper> getAllChatterGroups() {
        return null;
    }
    @RemoteAction
    global static String getChatterForRecordIds(List<Id> recordIds, Integer returnLimit) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.chatterGroupWrapper> getChatterGroups(Boolean showAll) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.contributorSearchResult> getCurrentContributorsList(String projectId) {
        return null;
    }
    global static String getDefaultListName() {
        return null;
    }
    global static String getFirstListName() {
        return null;
    }
    @RemoteAction
    global static Map<String,Boolean> getGlobalSettings() {
        return null;
    }
    global static Integer getLastListIndex() {
        return null;
    }
    global static String getLastListName() {
        return null;
    }
    global static String getLocaleDeadline(Date d) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__trProjectNotification__c> getMyRecentProjectNotifications(Long startTimeEpoch, Long endTimeEpoch, Integer limitNum) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__trTaskNotification__c> getMyRecentTaskNotifications(Long startTimeEpoch, Long endTimeEpoch, Integer limitNum) {
        return null;
    }
    global static List<System.SelectOption> getPicklistValuesForField(SObject obj, String fld) {
        return null;
    }
    global static String getReadableDeadline(Date d) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.sharingAccessSearchResult> getUserNamesAndAccessForProject(String projectId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.userAccessSearchResult> getUserNamesAndAccess(String searchString, String projectId) {
        return null;
    }
    @RemoteAction
    global static void hideSetupWizard() {

    }
    @RemoteAction
    global static Boolean isProjectSharedToAllInternalUsers(String projectId) {
        return null;
    }
    @RemoteAction
    global static Boolean isProjectSharingEnabled() {
        return null;
    }
    @RemoteAction
    global static void logTaskcardView(String Id) {

    }
    @RemoteAction
    global static void markProjectDeleted(String projectId) {

    }
    @RemoteAction
    global static void moveTaskToTopOfList(String taskId) {

    }
    @RemoteAction
    global static List<User> projectContributorSearch(String searchString, List<String> existingContributorIds) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,String>> projectContributorSearch_v2(String searchString, List<String> existingContributorIds) {
        return null;
    }
    @RemoteAction
    global static List<SObject> projectFiles(String projectId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.projectFileResult> projectFiles_v2(String projectId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.projectFileResult_v2> projectFiles_v3(String projectId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.projectWrapper> projectFilterList(Id projectId, String currentBoardId, Id selectedGroupId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.projectWrapper> projectFilterList_v2(Id projectId, String currentBoardId, Id selectedGroupId, String userId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.projectWrapper_v2> projectFilterList_v3(Id projectId, String currentBoardId, Id selectedGroupId, String userId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.sharingAccessSearchResult> projectSharingUGSearchResults(String searchString, String projectId) {
        return null;
    }
    @RemoteAction
    global static Id recalcAllSharing() {
        return null;
    }
    @RemoteAction
    global static List<SObject> recordsObjectTags(String projectTaskId) {
        return null;
    }
    @RemoteAction
    global static String remoteActionKeepAlive() {
        return null;
    }
    @RemoteAction
    global static void removeContributorFromProject(String contributorId) {

    }
    @RemoteAction
    global static void saveProjectSharing_bulk(String projectId, Map<Id,String> userAccessMap) {

    }
    @RemoteAction
    global static List<TASKRAY.trController.projectSearchResult> searchProjectsArchive(String searchTerm, String archived) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.projectSearchResult> searchProjects(String searchTerm) {
        return null;
    }
    @RemoteAction
    global static List<User> searchUsers(String searchString) {
        return null;
    }
    global static void setHasFLSForTaskBoardUpdate() {

    }
    global static void setLastListName() {

    }
    @RemoteAction
    global static TASKRAY__ViewProjectTasks__c setViewProjectTasks(String projectId, Boolean currentStatus) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__ViewProjectTasks__c> setViewProjectTasks_bulk(List<Id> projectIds, Boolean currentStatus, String userId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY__ViewProjectTasks__c setViewProjectTasks_v2(String projectId, Boolean currentStatus, String userId) {
        return null;
    }
    @RemoteAction
    global static Boolean showHideInviteButton(String projectId) {
        return null;
    }
    @RemoteAction
    global static List<User> sidebarMembersList(String boardId, String inStr) {
        return null;
    }
    @RemoteAction
    global static List<User> sidebarMembersListv2(String boardId, List<String> projectIds, List<String> groupIds) {
        return null;
    }
    @RemoteAction
    global static void taskOwnershipChanged(String taskId, String newUserId) {

    }
    @RemoteAction
    global static void taskOwnershipChanged_bulk(List<Id> taskIds, Id newUserId) {

    }
    @RemoteAction
    global static String toggleAllInternalUserSharing(String projectId, String operation) {
        return null;
    }
    @RemoteAction
    global static void toggleDisplayUnassignedTasks() {

    }
    @RemoteAction
    global static void toggleFollowTask(String taskId) {

    }
    @RemoteAction
    global static void toggleProjectAutoFollow(Id projectId) {

    }
    @RemoteAction
    global static void unDeleteTasks(List<Id> tasksToUnDel) {

    }
    global static void unarchiveProjects(List<TASKRAY__Project__c> projects) {

    }
    @RemoteAction
    global static void unfollowArchivedTasks() {

    }
    @RemoteAction
    global static List<TASKRAY.trController.planningViewItemWrapper> updatePlanningViewItemDates(String itemType, String itemId, String startTime, String endTime) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.planningViewItemWrapper_v2> updatePlanningViewItemDates_v2(String itemType, String itemId, String startTime, String endTime) {
        return null;
    }
    @RemoteAction
    global static void updateProjectGroupSharing(List<String> groupIds, String projectId) {

    }
    @RemoteAction
    global static void updateSortOrder(List<String> taskIds, String currentList, String status) {

    }
    @RemoteAction
    global static void updateTaskListAndSort(List<Map<String,String>> tasksInfo) {

    }
    @RemoteAction
    global static void updateTasksStatus(String taskId, String newStatus) {

    }
    @RemoteAction
    global static void updateTrPrefs(Boolean autoUnfollow, Boolean restartSetupWizard) {

    }
    @RemoteAction
    global static void updateTrPrefsViaMap(Map<String,Boolean> fieldMap) {

    }
    @RemoteAction
    global static void updateTrPrefs_dailyNotifications(Boolean autoUnfollow, Boolean restartSetupWizard, Boolean reverseColumns, Boolean dailyNotifications) {

    }
    @RemoteAction
    global static void updateTrPrefs_reverseColumns(Boolean autoUnfollow, Boolean restartSetupWizard, Boolean reverseColumns) {

    }
global class Export_Utility {
}
global class Import_Utility {
    global Import_Utility() {

    }
}
global class chatterGroupWrapper {
}
global class contributorSearchResult {
}
global class groupWrapper {
}
global class planningViewItemWrapper {
}
global class planningViewItemWrapper_v2 {
}
global class projectFileResult {
}
global class projectFileResult_v2 {
}
global class projectSearchResult {
    global projectSearchResult() {

    }
}
global class projectWrapper {
}
global class projectWrapper_v2 {
}
global class projectWrapper_v3 {
}
global class sharedMethods {
    global sharedMethods() {

    }
    global void autoFollowSubscriptionsForATaskList(Map<Id,List<Id>> projectTasks) {

    }
    global void autoFollowSubscriptionsForNewFollower(Id userId, Id projectId) {

    }
    global Boolean checkProjectTaskTaggingEnabled() {
        return null;
    }
    global Boolean checkShareExists(String objectType, String Id) {
        return null;
    }
    global Boolean checkSharingEnabled(String objectType) {
        return null;
    }
    global String findAllInternalUsersGroupID() {
        return null;
    }
    global String findNextList(String currentList) {
        return null;
    }
    global String generate18CharId(String id) {
        return null;
    }
    global List<TASKRAY__ViewProjectTasks__c> getAutoFollowersByProjectList(Set<Id> projectIds) {
        return null;
    }
    global Map<String,UserRecordAccess> getUserRecordAccessMap(List<Id> recordIds) {
        return null;
    }
    global List<SObject> queryAllSObjectFields(String objectName, Map<String,String> whereClauses, Map<String,String> relationships) {
        return null;
    }
    global void updateTaskSharing(TASKRAY__Project_Task__c pt) {

    }
}
global class sharingAccessSearchResult {
}
global class taskWithPhotoWrapper {
}
global class userAccessSearchResult {
}
}
