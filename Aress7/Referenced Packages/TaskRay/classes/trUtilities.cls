/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trUtilities {
    global static Id aiuGroupIdCache {
        get;
        set;
    }
    global static Map<String,Schema.SObjectType> cachedGlobalDescribe {
        get;
        set;
    }
    global static Map<String,TASKRAY.trUtilities.DefaultSharingGroupInfo> defaultSharingGroupInfoCache {
        get;
        set;
    }
    global static Boolean defaultSharingGroupInfoCacheSet {
        get;
        set;
    }
    global trUtilities() {

    }
    global static Boolean checkProjectTaskTaggingEnabled() {
        return null;
    }
    global static Boolean checkSharingEnabled(String objectType) {
        return null;
    }
    global static String colorLuminance(String hex, Decimal lum) {
        return null;
    }
    global static void createAndAssociateUnassignedQueue() {

    }
    @Future(callout=false)
    global static void createAndAssociateUnassignedQueue_future() {

    }
    global static String currentUserProjectRecordType() {
        return null;
    }
    global static Map<Id,TASKRAY__Project__c> findAllProjectsInHierarchy(List<Id> parentProjectIds) {
        return null;
    }
    global static String findNextList(String currentList) {
        return null;
    }
    global static Set<Id> findProjectsUpHierarchy(List<TASKRAY__Project__c> projects, Id contextProjectId) {
        return null;
    }
    global static Set<Id> findProjectsUpHierarchy(Set<Id> projectIds) {
        return null;
    }
    global static Map<Id,Id> findUltimateParentProjectId(Set<Id> projectIds) {
        return null;
    }
    global static List<String> getAccessibleFields(String objectName) {
        return null;
    }
    global static Boolean getAddContributorsAsyncFromTriggers() {
        return null;
    }
    global static String getBusinessDayMode() {
        return null;
    }
    global static List<String> getCreatableFields(String objectName) {
        return null;
    }
    global static Map<String,TASKRAY.trUtilities.DefaultSharingGroupInfo> getDefaultSharingGroupInfo() {
        return null;
    }
    global static String getDependenciesMode() {
        return null;
    }
    global static Map<String,Set<String>> getFieldsToSync() {
        return null;
    }
    global static Map<String,Schema.SObjectType> getGlobalDescribeFromCache() {
        return null;
    }
    global static String getNameFieldForField(String field, String lookupObj) {
        return null;
    }
    global static String getNameFieldForObject(String objectName) {
        return null;
    }
    global static Map<Id,TASKRAY__Project__c> getProjectsForLookupToRecordId(Id recordId) {
        return null;
    }
    global static String getReadableDeadline(Date d) {
        return null;
    }
    global static Map<Id,String> getTaskBoardURLForUserIds(Set<Id> userIds) {
        return null;
    }
    global static String getUserName() {
        return null;
    }
    global static Map<String,UserRecordAccess> getUserRecordAccessMap(List<Id> recordIds) {
        return null;
    }
    global static Boolean isCommunitiesEnabled() {
        return null;
    }
    global static Boolean isDependenciesEnabled() {
        return null;
    }
    global static Boolean isProjectRTEnabled() {
        return null;
    }
    global static Boolean isTaskRTEnabled() {
        return null;
    }
    global static Boolean isTimeTrackingEnabled() {
        return null;
    }
    global static Boolean isValidId(String s) {
        return null;
    }
    global static Boolean isValidJSON(String s) {
        return null;
    }
    global static Boolean networkMemberObjectExists() {
        return null;
    }
    global static Boolean projectRecordTypeIdFieldPresent() {
        return null;
    }
    global static void setBusinessDayMode(String option) {

    }
    global static Map<String,Schema.SObjectField> stripDuplicateManagedFieldsFromDescribeMap(Map<String,Schema.SObjectField> fMap) {
        return null;
    }
    global static Boolean taskRecordTypeIdFieldPresent() {
        return null;
    }
    global static void testDescribesWithNamespace() {

    }
    global static void updateProjectCompletionPercentage(Set<Id> projectIds) {

    }
    global static Boolean useSharingReason() {
        return null;
    }
    global static Boolean userHasPortalField() {
        return null;
    }
global class DefaultSharingGroupInfo {
}
}
