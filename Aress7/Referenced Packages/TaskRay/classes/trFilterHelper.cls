/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trFilterHelper {
    global Id contextUserId {
        get;
        set;
    }
    global String projectFilterOverrideId {
        get;
        set;
    }
    global String projectScope {
        get;
        set;
    }
    global Boolean singleProjectShowSubs {
        get;
        set;
    }
    global Id singleProjectViewId {
        get;
        set;
    }
    global String taskScope {
        get;
        set;
    }
    global trFilterHelper(String powerFilterId) {

    }
    global String getProjectQuery() {
        return null;
    }
    global String getProjectSelectClause() {
        return null;
    }
    global static Map<Id,Set<Id>> getProjectsUsersAutoFollow(Set<Id> userIds) {
        return null;
    }
    global List<TASKRAY__Project__c> getProjects() {
        return null;
    }
    global String getTaskQuery(List<Id> projectIdsForTasks, Boolean showUnassigned) {
        return null;
    }
    global String getTaskSelectClause() {
        return null;
    }
    global List<TASKRAY__Project_Task__c> getTasks(List<Id> projectIdsForTasks, Boolean showUnassigned) {
        return null;
    }
    global static TASKRAY.trFilterHelper insertNewFilter(String newPowerFilterName, Map<String,Object> projectFilterInfo, Map<String,Object> taskFilterInfo) {
        return null;
    }
    global Boolean isFilterMyInbox() {
        return null;
    }
    global void overrideProjectFilterId(String projectFilterId) {

    }
    global static void removeBoardFilterShares(Set<Id> filterIds) {

    }
    global static void shareBoardFilterWithPublicGroup(List<TASKRAY__trBoardFilterShareJunction__c> boardFilterSharesToAdd) {

    }
    global static void updatePersonalSortOnSharedPowerFilters(Map<Id,Integer> filterIdToSortOrderMap) {

    }
global class BoardFilterWrapper {
    global TASKRAY__trBoardFilter__c boardFilter {
        get;
        set;
    }
    global String filterId {
        get;
        set;
    }
}
}
