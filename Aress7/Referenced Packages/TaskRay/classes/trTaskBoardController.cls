/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class trTaskBoardController {
    global static Boolean atMaxViewState {
        get;
        set;
    }
    global String chatterGroupInfoJSON {
        get;
        set;
    }
    global String columnSortingFields {
        get;
        set;
    }
    global static Id currentChatterGroupId {
        get;
        set;
    }
    global static List<Id> currentlyVisibleProjects {
        get;
        set;
    }
    global static String currentUserInfo {
        get;
        set;
    }
    global static String currentView {
        get;
        set;
    }
    global String customLabelJSON {
        get;
        set;
    }
    global static String customPermissionsForUserJSON {
        get;
        set;
    }
    global String customStyleSheet {
        get;
        set;
    }
    global static String defaultListName {
        get;
        set;
    }
    global static Boolean displayUnassignedTasks {
        get;
        set;
    }
    global static Map<Id,TASKRAY__Project__c> favoriteProjectStaticCache {
        get;
        set;
    }
    global static String firstDayOfTheWeek {
        get;
    }
    global static Boolean getChatterBasedOnProjectOrTaskGroupIds {
        get;
        set;
    }
    global String getDefaultList {
        get;
        set;
    }
    global String getPowerFiltersForUserJSON {
        get;
        set;
    }
    global String getViewFiltersForUserJSON {
        get;
        set;
    }
    global static Boolean hasFLSForTaskBoardUpdate {
        get;
        set;
    }
    global static Boolean isUserSysAdmin {
        get;
    }
    global static Id lastEditedTaskId {
        get;
        set;
    }
    global static String lastListName {
        get;
        set;
    }
    global String listNamesJson {
        get;
        set;
    }
    global String listNamesMapJson {
        get;
        set;
    }
    global static Id masterRecordTypeId {
        get;
        set;
    }
    global static String masterRecordTypeName {
        get;
        set;
    }
    global static List<Map<String,String>> newlyAddedContribInfoStaticCache {
        get;
        set;
    }
    global static Map<String,TASKRAY__trMetadataCache__c> objectsInMetadataCache {
        get;
        set;
    }
    global String priorityFieldInfo {
        get;
        set;
    }
    global static String projectIdPrefix {
        get;
        set;
    }
    global static List<Id> projectsToShowTasksFor {
        get;
        set;
    }
    global static Boolean queryFilesBasedOnProjectOrTaskGroupIds {
        get;
        set;
    }
    global static Map<Id,SObject> recordTypeInfoStaticCache {
        get;
        set;
    }
    global static Set<Id> recordTypesAvailableToUser {
        get;
        set;
    }
    global static Boolean recordTypesEnabled {
        get;
        set;
    }
    global static List<Id> shownProjectOwnerIds {
        get;
        set;
    }
    global static List<Id> shownTaskIds {
        get;
        set;
    }
    global static List<Id> shownTaskOwnerIds {
        get;
        set;
    }
    global String sidebarProjectInfoJSON {
        get;
        set;
    }
    global static TASKRAY__Project__c singleProjectInfoCache {
        get;
        set;
    }
    global static Boolean siteGuestUserProjectAccessDisabled {
        get;
    }
    global static String taskIdPrefix {
        get;
        set;
    }
    global String taskInfoJSON {
        get;
        set;
    }
    global static Boolean trackContributorsAddedDuringTransaction {
        get;
        set;
    }
    global static String userSettings_currentPowerFilter {
        get;
        set;
    }
    global static String userSettings_currentViewFilter {
        get;
        set;
    }
    global static String userSettings_currentViewFilterInfo {
        get;
        set;
    }
    global static String userSettings_selectedLists {
        get;
        set;
    }
    global String userSettingsJSON {
        get;
        set;
    }
    global static Id viewAsUserId {
        get;
        set;
    }
    global static String viewAsUserInfo {
        get;
        set;
    }
    global static Map<Id,Boolean> viewProjectAutoFollowTasksStaticCache {
        get;
        set;
    }
    global static Map<Id,Integer> viewProjectFavoriteProjectPersonalSortOrderStaticCache {
        get;
        set;
    }
    global static Set<Id> viewProjectFavoriteProjectsStaticCache {
        get;
        set;
    }
    global static Boolean viewProjectStaticCacheSet {
        get;
        set;
    }
    global static Map<Id,Boolean> viewProjectTasksOnOffStaticCache {
        get;
        set;
    }
    global trTaskBoardController() {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper addChecklistItem(Id taskId, String text, Id checklistGroupId, Double sortOrder) {
        return null;
    }
    @RemoteAction
    global static void addCommentToFeedItem(Id feedItemId, List<String> messageArr) {

    }
    @RemoteAction
    global static void addContributorRecordToProjects(Map<Id,List<Id>> projectToContribMapping) {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper addContributorToProjectsReturnBoardInfo_bulk(Map<Id,List<Id>> userIdToProjectIds) {
        return null;
    }
    @RemoteAction
    global static void addContributorToProjects_bulk(Map<Id,List<Id>> userIdToProjectIds) {

    }
    @RemoteAction
    global static void addContributorsToProject(List<Map<String,Id>> contributors) {

    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.DetailedTaskInfoWrapper> addDetailedTaskTimeItemsFromModal(List<Map<String,Object>> newEntries) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.RightSidebarTimeWrapper addDetailedTimeEntriesToTaskFromTimesheet(List<Map<String,Object>> newEntries, Integer startDateYear, Integer startDateMonth, Integer startDateDay) {
        return null;
    }
    @RemoteAction
    global static Map<Id,TASKRAY.trTaskBoardController.DetailedProjectWrapper> addProjectContributorsAndReturnInfo(List<String> contributorIds, String projectId) {
        return null;
    }
    @RemoteAction
    global static void addProjectContributors(List<String> contributorIds, String projectId) {

    }
    @RemoteAction
    global static List<SObject> addRecordSObjectTags(List<String> tags, String taskId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__trRecordTypeMapping__c> addRecordTypeMapping(TASKRAY__trRecordTypeMapping__c newMapping) {
        return null;
    }
    global static void addSharesToProjects(Map<Id,List<Id>> projectToShareMapping) {

    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.viewFilterItemWrapper> addViewFilterForUser(Id userId, String filterName, List<Map<String,String>> filterDetails) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.viewFilterItemWrapper> addViewFilterForUser_v2(Id userId, String filterType, String filterName, List<Map<String,String>> filterDetails) {
        return null;
    }
    @RemoteAction
    global static void archivePersonalTasksInLastColumn() {

    }
    @RemoteAction
    global static void archiveProject(String projectId) {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper archiveProjectsReturnBoardInfo(List<Id> projectIds, Boolean archiveSubProjects) {
        return null;
    }
    @RemoteAction
    global static void archiveProjects_v2(List<Id> projectIds, Boolean archiveSubProjects) {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper archiveTaskGroupsReturnBoardInfo(List<Id> taskGroupIds) {
        return null;
    }
    @RemoteAction
    global static void associateContentVersionWithRecord(Id versionId, Id relatedToObject) {

    }
    @RemoteAction
    global static Map<Id,TASKRAY.trTaskBoardController.DetailedProjectWrapper> changeContributorAccessLevelReturnInfo(String projectId, List<Map<String,Object>> contribShareInfo) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper changeItemField(List<Map<String,String>> itemsToUpdate) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper changeOwnerAndRemoveContributorBulk(List<Map<String,Id>> contribOwnerChangesMap) {
        return null;
    }
    @RemoteAction
    global static void changeOwnerAndRemoveContributor(Id newUserOrGroupId, Id oldUserOrGroupId, Id oldContributorId, Id projectId, List<Map<String,Id>> contributorsToAdd) {

    }
    @RemoteAction
    global static void changeProjectOwnerFromTeamTab(Id projectId, Id newOwnerId) {

    }
    @RemoteAction
    global static Map<Id,Boolean> checkForShareContribSyncOnProjectIds(List<Id> projectIdList) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper cloneChecklistGroupsToExistingTasks(Map<Id,List<TASKRAY.trCloneUtils.ChecklistGroupCloneConfigWrapper>> cloneConfigs) {
        return null;
    }
    @RemoteAction
    global static String cloneProjectReturnId_v2(Map<String,String> projectInfo) {
        return null;
    }
    @RemoteAction
    global static String cloneProjectReturnId_v3(Id baseProjectId, Map<String,Map<String,String>> projectInfo, Map<String,String> options) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper cloneProjectsIntoExistingProjects(Map<Id,List<TASKRAY.trCloneUtils.ProjectStitchConfigWrapper>> cloneConfigs) {
        return null;
    }
    global static Map<String,Id> cloneProjectsReturnIds(Map<String,Map<String,Object>> projectInfo, Map<String,Object> cloneOptions) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper cloneTaskGroupsToExistingProjects(Map<Id,List<TASKRAY.trCloneUtils.TaskGroupCloneConfigWrapper>> cloneConfigs) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__Project_Task__c> cloneTasksReturnTasks(List<Map<String,Object>> taskInfo, Map<String,Object> options) {
        return null;
    }
    @RemoteAction
    global static void createBaselineForProjectIds(Map<Id,String> projectIdToNotesMap) {

    }
    @RemoteAction
    global static void deleteBaselines(List<Id> baselineIds) {

    }
    @RemoteAction
    global static Map<String,List<Object>> deleteBoardFilters(List<Id> boardFilterIds) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper deleteChecklistGroup(Id checklistGroupId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper deleteChecklistItem(Id checklistId) {
        return null;
    }
    @RemoteAction
    global static void deleteContributorsFromProject(List<Id> contributorIdsToDelete) {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper deleteDependencyReturnBoardInfo(List<TASKRAY__trDependency__c> sObjs) {
        return null;
    }
    global static void deleteFile(List<Id> fileDeleteInfo) {

    }
    global static void deleteFile(List<Id> fileDeleteInfo, List<Id> objIds) {

    }
    @RemoteAction
    global static void deleteFile_v2(List<Map<String,Id>> fileDeleteInfo) {

    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.viewFilterItemWrapper> deleteFilterView(Id viewId) {
        return null;
    }
    @RemoteAction
    global static void deleteLink(List<Id> linkIds) {

    }
    @RemoteAction
    global static Map<String,List<Object>> deletePowerFilters(List<Id> powerFilterIds) {
        return null;
    }
    @RemoteAction
    global static void deleteRecordSobjectTag(String projectTaskTagId) {

    }
    @RemoteAction
    global static List<TASKRAY__trRecordTypeMapping__c> deleteRecordTypeMapping(TASKRAY__trRecordTypeMapping__c existingMapping) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper deleteTaskGroupsReturnBoardInfo(List<Id> taskGroupIds) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper deleteTaskTimeEntryFromModal(Id taskTimeId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.RightSidebarTimeWrapper deleteTaskTimeEntryFromTimesheet(Id timeId, Id userId, Integer startDateYear, Integer startDateMonth, Integer startDateDay) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper deleteTasks(List<Id> tasksToDel) {
        return null;
    }
    @RemoteAction
    global static Map<String,Id> enqueueBatchJobs(List<String> batchJobNames, Map<String,Map<String,Object>> batchJobOptions) {
        return null;
    }
    @RemoteAction
    global static Map<Id,List<TASKRAY__trBaseline_Project__c>> fetchBaselinesForProjectIds(List<Id> projectIds) {
        return null;
    }
    @RemoteAction
    global static List<AsyncApexJob> fetchJobStatus(List<Id> batchJobIds) {
        return null;
    }
    @RemoteAction
    global static List<SObject> fetchNotifications(String type, List<String> initMap, String startTime, String endTime) {
        return null;
    }
    @RemoteAction
    global static Map<String,TASKRAY__trMetadataCache__c> fetchObjectsFromMetadataCache(Set<String> objectNames) {
        return null;
    }
    global static List<Schema.DescribeFieldResult> fieldPathToDFR(Schema.DescribeSObjectResult baseObject, String fieldPath) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.fieldSetInfo> fieldSetsForObject(String objName) {
        return null;
    }
    @RemoteAction
    global static String findProjectForTaskId(Id taskId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper getBoardInfo() {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper getBoardInfoUserSettingOverride(Map<String,Object> options) {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static String getChatterForRecordIds_projectView(List<Id> recordIds, Integer returnLimit) {
        return null;
    }
    @RemoteAction
    global static String getChatterForRecordIds(List<Id> recordIds, Integer returnLimit) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.chatterGroupWrapper> getChatterGroups(Boolean showAll) {
        return null;
    }
    @RemoteAction
    global static Map<Id,Id> getContentDocumentIdsForVersionIds(List<Id> contentVersionIds) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.contributorSearchResult> getCurrentContributorsList(String projectId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__trRecordTypeMapping__c> getCurrentRecordTypeMapping(String objectType) {
        return null;
    }
    global static Map<Id,String> getDefaultListForRecordTypeIds(List<Id> recordTypeIds) {
        return null;
    }
    @RemoteAction
    global static Map<Id,TASKRAY.trTaskBoardController.DetailedProjectWrapper> getDetailedInformationForProjects(List<Id> projectIds) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.DetailedTaskInfoWrapper> getDetailedInformationForTasks(List<Id> taskIds) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.projectWrapper> getFavoriteProjects() {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.GroupingFieldWrapper> getFieldsToDisplayInRowView(String objectType) {
        return null;
    }
    @RemoteAction
    global static Map<Id,List<TASKRAY.trTaskBoardController.modalFileResult>> getFilesForId(List<Id> ids) {
        return null;
    }
    global static List<TASKRAY.trTaskBoardController.FilterableFieldWrapper> getFilterableFieldsForObject(Schema.SObjectType objType) {
        return null;
    }
    @RemoteAction
    global static Map<String,List<TASKRAY.trTaskBoardController.FilterableFieldWrapper>> getFilterableFields() {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static TASKRAY.trTaskBoardController.InfoTabWrapper getInfoTabInfoUserSettingOverride(List<Id> selectedParentRecordIds, Boolean inProjectView, Map<String,String> chartTabConfig, Map<String,Object> options) {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static TASKRAY.trTaskBoardController.InfoTabWrapper getInfoTabInfo(List<Id> selectedParentRecordIds, Boolean inProjectView, Map<String,String> chartTabConfig) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.initialInfoWrapper getInitialInfo() {
        return null;
    }
    global static Map<Id,String> getLastListForRecordTypeIds(List<Id> recordTypeIds) {
        return null;
    }
    global static Map<Id,String> getLastListForTaskRecords(List<Id> taskIds) {
        return null;
    }
    global static Map<String,String> getListColors() {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__trMetadataCache__c> getMetadataCache(List<String> objectNames) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__Project_Task__c> getMilestonesForProject(Id projectId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__Project_Task__c> getMilestonesForTaskGroup(Id taskGroupId) {
        return null;
    }
    @RemoteAction
    global static List<SObject> getMostRecentObjectsForSearch(String scope) {
        return null;
    }
    @RemoteAction
    global static Map<String,List<Object>> getMyPowerFilters() {
        return null;
    }
    @RemoteAction
    global static Map<Integer,List<Integer>> getNonWorkingDaysForYears_multipleBusinessHours(List<Id> businessHoursIds, List<Integer> years) {
        return null;
    }
    @RemoteAction
    global static Map<Integer,List<Integer>> getNonWorkingDaysForYears(Id businessHoursId, List<Integer> years) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.projectWrapper> getProjectInfoForFilterId() {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.ProjectViewProjectWrapper> getProjectViewInfo(String projectFilterId) {
        return null;
    }
    @RemoteAction
    global static Map<Id,TASKRAY.trTaskBoardController.BulkContributorActionProjectWrapper> getProjectsForSelectedContributor(Id userOrGroupId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Boolean> getProjectsOwnershipInfoBulkRemove(Id selectedUserOrGroup, List<Id> projectIdsToCheckForOwnership) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.projectWrapper> getProjectsUserIsContributorTo(Id userOrGroupId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__Project__c> getRecentTemplateProjects() {
        return null;
    }
    @RemoteAction
    global static Id getRecordTypeIdForProjectId(Id projectId) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.recordTypeInfo> getRecordTypesUserHasAccessTo(String objectType, Boolean showAllRegardlessOfAccess, Boolean excludeMaster) {
        return null;
    }
    @RemoteAction
    global static List<User> getSidebarContributors() {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.AllContributorsWrapper> getSidebarContributors_v2() {
        return null;
    }
    @ReadOnly
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.sidebarFileResult> getSidebarFiles_projectView(List<Id> visibleProjectIds) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.sidebarFileResult> getSidebarFiles() {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.projectWrapper> getSidebarProjectInfo() {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.GroupingFieldWrapper> getSortableFields(String objectType) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.taskWithPhotoWrapper> getTasksForTaskBoard() {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.RightSidebarTimeWrapper getTimeDataForUserAndDates(Id userId, Integer startDateYear, Integer startDateMonth, Integer startDateDay) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.sharingAccessSearchResult> getUserNamesAndAccessForProject(String projectId) {
        return null;
    }
    global static Map<String,Object> getUserSettings() {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.recordTypeInfo getUsersCurrentRecordType(String objectType) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper insertTaskGroupReturnBoardInfo(Id projectId, String taskGroupName) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper insertTaskGroupReturnBoardInfo_v2(Id projectId, String taskGroupName, String destination) {
        return null;
    }
    global static Map<String,Boolean> isIdViewAsFilterId(List<String> filterIds) {
        return null;
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
    global static Map<Id,String> isSelectedContributorOwnerOfProject(Id selectedContributor, Id projectId) {
        return null;
    }
    @RemoteAction
    global static void logTaskcardView(String Id) {

    }
    @RemoteAction
    global static void markProjectDeleted(String projectId) {

    }
    @RemoteAction
    global static void markProjectDeleted_v2(String projectId, Boolean deleteSubs) {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper markProjectDeleted_v3(String projectId, Boolean deleteSubs) {
        return null;
    }
    @RemoteAction
    global static void moveTaskToTopOfList(String taskId) {

    }
    @RemoteAction
    global static List<Map<String,String>> projectContributorSearch(String searchString, List<String> existingContributorIds) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,String>> projectContributorSearch_v2(String searchString, List<String> existingContributorIds) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trController.sharingAccessSearchResult> projectSharingUGSearchResults(String searchString, String projectId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY__trChecklistGroup__c quickAddChecklistGroup(Id taskId, String checklistGroupName) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper quickAddTask(String taskName, Id projectId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.taskWithPhotoWrapper quickAddTaskReturnTask(String taskName, Id projectId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.taskWithPhotoWrapper quickAddTaskReturnTask_v2(String taskName, Id projectId, Id recordTypeId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper quickAddTask_v2(String taskName, Id projectId, Id recordTypeId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper quickAddTask_v3(String taskName, Id projectId, Id recordTypeId, String listName) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper quickAddTask_v4(String taskName, Id projectId, Id recordTypeId, String listName, List<Map<String,Object>> presetFieldValues) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper quickAddTimeEntryToTask(Id taskId, Decimal timeNumberText, String notesBoxText, Id ownerId, Date dateForTime, Boolean billable) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.recordTypeInfo> recordTypesForObject(String objName) {
        return null;
    }
    @RemoteAction
    global static List<SObject> recordsObjectTags(String projectTaskId) {
        return null;
    }
    @RemoteAction
    global static void removeContributorFromProject(String contributorId) {

    }
    @RemoteAction
    global static Map<Id,TASKRAY.trTaskBoardController.DetailedProjectWrapper> removeContributorFromProjectAndReturnInfo(String projectId, String contributorId) {
        return null;
    }
    @RemoteAction
    global static void removeContributorFromProjects_bulk(Map<Id,List<Id>> userIdToProjectIds) {

    }
    @RemoteAction
    global static void removeContributorRecordFromProjects(Map<Id,Set<Id>> projectToContribMapping) {

    }
    global static void removeSharesFromProjects(Map<Id,Set<Id>> projectToShareMapping) {

    }
    @RemoteAction
    global static Map<Id,TASKRAY.trTaskBoardController.DetailedProjectWrapper> resyncContributorsOnProjectsAndReturnInfo(List<Id> projectIdsList) {
        return null;
    }
    @RemoteAction
    global static Map<Id,TASKRAY.trTaskBoardController.DetailedProjectWrapper> saveProjectChangeWithSharingOnAndReturnInfo(String projectId, Map<Id,String> userAccessMap) {
        return null;
    }
    @RemoteAction
    global static Map<Id,TASKRAY.trTaskBoardController.DetailedProjectWrapper> saveProjectChatterGroups(List<Id> groupIds, Id projectId) {
        return null;
    }
    @RemoteAction
    global static void saveProjectSharing_bulk(String projectId, Map<Id,String> userAccessMap) {

    }
    @RemoteAction
    global static List<CollaborationGroup> searchChatterGroups(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__trChecklistGroup__c> searchChecklistGroupsForTypeahead(String currentSearchInputValue) {
        return null;
    }
    @RemoteAction
    global static List<Group> searchGroupsAndRoles(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<Group> searchGroups(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<SObject> searchObjectsFromTypeahead(String currentSearchInputValue, String scope, String template, String archived, Boolean onlyCurrentProjectRT, Map<String,Map<String,String>> searchParameters) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__Project__c> searchProjectsForTypeahead(String currentSearchInputValue) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.projectWrapper> searchProjects(String searchTerm, String archived) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__Project__c> searchProjects_v2(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__trTaskGroup__c> searchTaskGroupsForTypeahead(String currentSearchInputValue) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__Project_Task__c> searchTasksForTypeahead(String currentSearchInputValue) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__Project_Task__c> searchTasks(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__Project__c> searchTemplateProjects(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<Topic> searchTopics(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.UserAndQueueSearchResult> searchUsersAndQueuesWithInactive(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.UserAndQueueSearchResult> searchUsersAndQueues(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.UserAndQueueSearchResult> searchUsersQueuesAndGroupsWithInactiveUsers(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY.trTaskBoardController.UserAndQueueSearchResult> searchUsersQueuesAndGroups(String searchString) {
        return null;
    }
    @RemoteAction
    global static List<User> searchUsers(String searchString) {
        return null;
    }
    @Future(callout=false)
    global static void sendFutureOwnerEmail(List<Id> taskIds, Id newUserId) {

    }
    @RemoteAction
    global static void setBusinessDayMode(String option) {

    }
    global void setColumnSortingFields() {

    }
    global void setCustomLabelJSON() {

    }
    global void setGlobalSettings() {

    }
    global void setListInfo() {

    }
    global void setMetaDataCacheInfo() {

    }
    global void setObjectDescribes() {

    }
    global void setPriorityInfo() {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper setRowViewGroupInfo(String rowGroupName) {
        return null;
    }
    global static void setStaticVarsForRemoteActions() {

    }
    global void setUserBoardViewSettings() {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.recordTypeInfo setUsersCurrentRecordType(String objectType, Id recordTypeId) {
        return null;
    }
    @RemoteAction
    global static void shareBoardFilterWithPublicGroup(List<TASKRAY__trBoardFilterShareJunction__c> boardFilterSharesToAdd) {

    }
    @RemoteAction
    global static Map<String,List<Object>> sortPowerFilters(List<String> filterIdArr) {
        return null;
    }
    @RemoteAction
    global static void spoolUpRemoteActions() {

    }
    @RemoteAction
    global static void syncFromSharesToContributors(List<Id> projectIdList) {

    }
    @RemoteAction
    global static void syncRuleSharesAndContributors(List<Id> projectIdList) {

    }
    @RemoteAction
    global static void taskOwnershipChanged_bulk(List<Id> taskIds, Id newUserId) {

    }
    @RemoteAction
    global static String toggleAllInternalUserSharing(String projectId, String operation) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper toggleFollowTask(String taskId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper toggleFollowTask_v2(String taskId, Boolean newfollowValue) {
        return null;
    }
    @RemoteAction
    global static void toggleProjectAutoFollow(Id projectId) {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper toggleProjectAutoFollowReturnBoardInfo(Id projectId) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper toggleProjectViewStatus(List<Id> projectIds, Boolean forceValues) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper unDeleteTasks(List<Id> tasksToUnDel) {
        return null;
    }
    @RemoteAction
    global static void unfollowArchivedTasks() {

    }
    @RemoteAction
    global static void updateCurrentView(String newCurrentView) {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper updatePlanViewColumns(String nameToToggle) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper updatePlanningViewItemDates(String itemType, String itemId, String startTime, String endTime) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper updateProjectFavorites(Map<Id,Boolean> newMapping) {
        return null;
    }
    @RemoteAction
    global static void updateProjectGroupSharing(List<String> groupIds, String projectId) {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper updateProjectPersonalSortOrder(Map<Id,Integer> newMapping) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper updateProjectViewColumns(String newProjectViewColumns) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper updateProjectViewStatus(Map<Id,Boolean> newMapping) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__trRecordTypeMapping__c> updateRecordTypeMapping(TASKRAY__trRecordTypeMapping__c existingMapping) {
        return null;
    }
    @RemoteAction
    global static void updateRecordTypesOfRecords(String objectName, Map<Id,Id> recordInfo) {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.RightSidebarTimeWrapper updateTaskTimeEntryFromTimesheet(Id timeId, Id taskId, Id userId, String notesInput, Boolean billableInput, Integer dateYear, Integer dateMonth, Integer dateDay, String hoursInput, Integer startDateYear, Integer startDateMonth, Integer startDateDay) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper updateUserSettingsViaMapReturnBoardData(Map<String,Object> fieldMap) {
        return null;
    }
    @RemoteAction
    global static String updateUserSettingsViaMap(Map<String,Object> fieldMap) {
        return null;
    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper updateUsersCurrentlySelectedChatterGroup(String newGroupId) {
        return null;
    }
    @RemoteAction
    global static void uploadLink(String linkUrl, String title, String taskOrProject, Id targetId) {

    }
    @RemoteAction
    global static TASKRAY.trTaskBoardController.boardInfoWrapper upsertDependencyReturnBoardInfo(List<TASKRAY__trDependency__c> depObjs) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__trMetadataCache__c> upsertMetadataCache(Map<String,String> updateInfo) {
        return null;
    }
    @RemoteAction
    global static Map<String,List<Object>> upsertPowerFilterWithShares(Map<String,String> powerFilterSettings, List<TASKRAY.trTaskBoardController.viewFilterItemWrapper> filtersToAdd, List<TASKRAY.trTaskBoardController.viewFilterItemWrapper> filtersToUpdate, List<Group> groupsToShareTo) {
        return null;
    }
    @RemoteAction
    global static Map<String,List<Object>> upsertPowerFilter(Map<String,String> powerFilterSettings, List<TASKRAY.trTaskBoardController.viewFilterItemWrapper> filtersToAdd, List<TASKRAY.trTaskBoardController.viewFilterItemWrapper> filtersToUpdate) {
        return null;
    }
    @RemoteAction
    global static List<TASKRAY__trRecordTypeMapping__c> upsertRecordTypeMapping(TASKRAY__trRecordTypeMapping__c existingMapping) {
        return null;
    }
global class AllContributorsWrapper implements System.Comparable {
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class BulkContributorActionProjectWrapper {
}
global class DetailedProjectWrapper {
}
global class DetailedTaskInfoWrapper {
}
global class FilterableFieldWrapper implements System.Comparable {
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class GroupingFieldWrapper {
}
global class InfoTabWrapper {
}
global class ProjectViewProjectWrapper {
}
global class RightSidebarTimeWrapper {
    global Map<Id,List<TASKRAY__trTaskTime__c>> timeDataByTask {
        get;
        set;
    }
}
global class UserAndQueueSearchResult implements System.Comparable {
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class boardInfoWrapper {
}
global class chatterGroupWrapper {
}
global class contributorInfoWrapper {
}
global class contributorSearchResult {
}
global class fieldSetInfo implements System.Comparable {
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class initialInfoWrapper {
}
global class modalFileResult implements System.Comparable {
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class projectWrapper {
}
global class recentProjectWrapper implements System.Comparable {
    global Integer compareTo(Object recentProjWrapper) {
        return null;
    }
}
global class recordTypeInfo implements System.Comparable {
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class sidebarFileResult implements System.Comparable {
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class taskReassignGroupsWrapper implements System.Comparable {
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
global class taskReassignProjectToGroupsWrapper {
}
global class taskWithPhotoWrapper {
}
global class viewFilterItemWrapper {
}
}
