/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trControllerWithoutSharing {
    global static String getOrgType() {
        return null;
    }
    global static void resyncSharesForTasksUnderProjects(Set<Id> projectIds) {

    }
    @RemoteAction
    global static void saveProjectSharing(String projectId, String userOrGroupId, String accessType) {

    }
    @RemoteAction
    global static void saveProjectSharing_bulk_delOptional(String projectId, Map<Id,String> userAccessMap, Boolean deleteOldShares) {

    }
    @RemoteAction
    global static void saveProjectSharing_bulk(String projectId, Map<Id,String> userAccessMap) {

    }
    @RemoteAction
    global static void saveProjectSharing_bulkv2(Map<String,Map<Id,String>> projectInfoMap) {

    }
    @Deprecated
    global static Map<Id,List<TASKRAY.trCloneUtils.TaskGroupCloneConfigWrapper>> stitchProjectsFromTaskGroupIds(List<TASKRAY.trStitchProject.StitchProjectConfigWrapper> stitchConfigs) {
        return null;
    }
    global static Map<Id,List<TASKRAY.trCloneUtils.TaskGroupCloneConfigWrapper>> stitchProjectsFromTaskGroups(List<TASKRAY.trStitchProject.StitchProjectConfigWrapper> stitchConfigs) {
        return null;
    }
    global static Map<Id,List<TASKRAY.trCloneUtils.ChecklistGroupCloneConfigWrapper>> stitchTasksFromChecklistGroups(List<TASKRAY.trStitchTask.StitchTaskConfigWrapper> stitchConfigs) {
        return null;
    }
    @Future(callout=false)
    global static void updateProjectCompletionPercentage_async(Set<Id> projectIds) {

    }
    global static void updateProjectCompletionPercentage(Set<Id> projectIds) {

    }
global class sharedMethods {
    global sharedMethods() {

    }
    global Boolean checkForAllInternalUserShare(String projectId) {
        return null;
    }
    global Map<String,Boolean> checkForAllInternalUserShare_bulk(List<String> projectIds) {
        return null;
    }
    global void insertShares(List<SObject> sharesToInsert) {

    }
    global void migratePublicAttributesToTask() {

    }
    global void migratePublicAttributesToTaskConstricted(List<Id> projectTaskIds) {

    }
    global void updateProjectTaskSharingSortOrder(List<Id> projectTasks, Map<Id,Integer> projectTaskSortOrder) {

    }
    global void updateProjectsSharingOnSpecificTasks(Map<String,Set<Map<String,String>>> projectTaskMap) {

    }
}
global class testOnlyMethod {
    global testOnlyMethod() {

    }
    global void inflateTestCoverage() {

    }
    global void inflateTestCoverage2() {

    }
}
}
