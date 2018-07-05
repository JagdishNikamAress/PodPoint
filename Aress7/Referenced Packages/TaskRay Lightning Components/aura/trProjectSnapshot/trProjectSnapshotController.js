({
  doInit: function(component, event, helper) {
    if (helper.getRecordId(component) == undefined) {
      component.set('v.recordError', 'true');
      component.set('v.records', []);
    } else {
      component.set('v.visibleProjectIndex', 0);
      helper.getStats(component, helper, true, null);
    }
  },
  goLeft: function(component) {
    if (component.get('v.visibleProjectIndex') > 0) {
      component.set(
        'v.visibleProjectIndex',
        component.get('v.visibleProjectIndex') - 1
      );
      var records = component.get('v.records');
      var index = component.get('v.visibleProjectIndex');
      component.set('v.currentProjectObject', records[index]);
    }
  },
  goRight: function(component) {
    if (
      component.get('v.visibleProjectIndex') <
      component.get('v.records').length - 1
    ) {
      component.set(
        'v.visibleProjectIndex',
        component.get('v.visibleProjectIndex') + 1
      );
      var records = component.get('v.records');
      var index = component.get('v.visibleProjectIndex');
      component.set('v.currentProjectObject', records[index]);
    }
  },
  makeTask: function() {
    var urlEvent = $A.get('e.force:createRecord');
    urlEvent.setParams({
      entityApiName: 'TASKRAY__Project_Task__c'
    });
    urlEvent.fire();
  },
  goToProject: function(component, event) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      projectId: event.target.id
    });
    navigateToTaskRay.fire();
  },
  handleExternalChange: function(component, event, helper) {
    var recordId = helper.getRecordId(component);
    if (!recordId) {
      return;
    }
    helper.getStats(component, helper, true, null);
  },
  handleComponentEvent: function(component, event, helper) {
    var payload = event.getParam('payload');
    switch (event.getParam('actionType')) {
      case 'changeTaskGroup':
        var records = component.get('v.records');
        var currentIndex = component.get('v.visibleProjectIndex');
        var currentProjectInfo = records[currentIndex];
        var groupInfoForCurrentProject = currentProjectInfo.taskGroupInfoArray;
        var selectedGroupId = payload.targetId;
        var selectedGroupName;
        groupInfoForCurrentProject.forEach(group => {
          if (group.Id === selectedGroupId) {
            selectedGroupName = group.Name;
          }
        });
        var groupIdToPass = selectedGroupId === 'Ungrouped' ||
          selectedGroupId === 'Show All'
          ? null
          : selectedGroupId;
        component.set('v.selectedGroupId', selectedGroupId);
        component.set('v.selectedGroupName', selectedGroupName);
        var showAllTaskGroups = selectedGroupId === 'Show All' ? true : false;
        helper.getStats(component, helper, showAllTaskGroups, groupIdToPass);
        event.stopPropagation();
        break;
      default:
        break;
    }
  }
});