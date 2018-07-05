/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trCloneUtils {
    global trCloneUtils() {

    }
    global static Map<Id,List<TASKRAY.trCloneUtils.ChecklistGroupCloneConfigWrapper>> addChecklistGroupsToTasks(Map<Id,List<TASKRAY.trCloneUtils.ChecklistGroupCloneConfigWrapper>> taskIdsToChecklistGroupCloneConfigs) {
        return null;
    }
    global static Map<Id,List<TASKRAY.trCloneUtils.TaskGroupCloneConfigWrapper>> addTaskGroupsToProjects(Map<Id,List<TASKRAY.trCloneUtils.TaskGroupCloneConfigWrapper>> projectIdsToTaskGroupCloneConfigs) {
        return null;
    }
    global static Map<Id,TASKRAY.trCloneUtils.ChecklistGroupContentsWrapper> getChecklistGroupContentInfo(Set<Id> checklistGroupIds) {
        return null;
    }
    global static Map<Id,TASKRAY.trCloneUtils.TaskGroupContentsWrapper> getTaskGroupContentInfo(Set<Id> taskGroupIds) {
        return null;
    }
    global static void setCloneOperationStart() {

    }
    global static void setCloneOperationStop() {

    }
global class ChecklistGroupCloneConfigWrapper {
    global Id newChecklistGroupId {
        get;
        set;
    }
    global Integer newSortOrder {
        get;
        set;
    }
    global Id templateChecklistGroupId {
        get;
        set;
    }
    global ChecklistGroupCloneConfigWrapper(Id templateChecklistGroupId) {

    }
    global ChecklistGroupCloneConfigWrapper(Id templateChecklistGroupId, Integer newSortOrder) {

    }
}
global class ChecklistGroupContentsWrapper {
    global TASKRAY__trChecklistGroup__c checklistGroup {
        get;
        set;
    }
    global Id checklistGroupId {
        get;
        set;
    }
    global List<TASKRAY__trChecklistItem__c> checklistItems {
        get;
        set;
    }
    global ChecklistGroupContentsWrapper(Id checklistGroupId) {

    }
}
global class ProjectStitchConfigWrapper {
    global String scheduleMode {
        get;
        set;
    }
    global Date targetDate {
        get;
        set;
    }
    global Id templateProjectId {
        get;
        set;
    }
    global ProjectStitchConfigWrapper(Id templateProjectId, String scheduleMode, Date targetDate) {

    }
}
global class TaskGroupCloneConfigWrapper {
    global Integer cloneOffsetOverride {
        get;
        set;
    }
    global Id newTaskGroupId {
        get;
        set;
    }
    global String newTaskGroupName {
        get;
        set;
    }
    global String scheduleMode {
        get;
        set;
    }
    global Date targetDate {
        get;
        set;
    }
    global Id templateProjectId {
        get;
        set;
    }
    global Id templateTaskGroupId {
        get;
        set;
    }
    global TaskGroupCloneConfigWrapper(Id templateTaskGroupId, String scheduleMode, Date targetDate) {

    }
    global TaskGroupCloneConfigWrapper(Id templateTaskGroupId, String scheduleMode, Date targetDate, String newTaskGroupName) {

    }
}
global class TaskGroupContentsWrapper {
    global List<TASKRAY__trChecklistGroup__c> checklistGroups {
        get;
        set;
    }
    global List<TASKRAY__trChecklistItem__c> checklistItems {
        get;
        set;
    }
    global List<ContentDocumentLink> contentDocumentLinks {
        get;
        set;
    }
    global List<ContentVersion> contentVersions {
        get;
        set;
    }
    global List<TASKRAY__trDependency__c> deps {
        get;
        set;
    }
    global List<FeedItem> linkPosts {
        get;
        set;
    }
    global TASKRAY__trTaskGroup__c taskGroup {
        get;
        set;
    }
    global Id taskGroupId {
        get;
        set;
    }
    global List<TASKRAY__Project_Task__c> tasks {
        get;
        set;
    }
    global List<TopicAssignment> taskTopics {
        get;
        set;
    }
    global TaskGroupContentsWrapper(Id taskGroupId) {

    }
    global Integer getCloneOffset(String scheduleMode, Date targetDate) {
        return null;
    }
}
}
