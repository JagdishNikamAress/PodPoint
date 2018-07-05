({
  doInit: function(component, event, helper) {
    var action = component.get('c.getTaskCountsByList');
    action.setParams({
      recordId: helper.getRecordId(component)
    });
    if (helper.getRecordId(component) == undefined) {
      component.set('v.recordError', 'true');
      component.set('v.records', []);
    } else {
      component.set('v.visibleProjectIndex', 0);
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          // success with records
          if (response.getReturnValue().length > 0) {
            var projects = response.getReturnValue();
            projects = helper.parseProjects(projects);
            component.set('v.currentProjectObject', projects[0]);
            component.set('v.records', projects);
          }
          // success with no records
          if (response.getReturnValue().length === 0) {
            $A.util.addClass(
              document.getElementById('trProjectStatusBar'),
              'disappear'
            );
            component.set('v.records', []);
          }
        } else {
          helper.popErrorMessage(component, action);
        }
      });
    }
    $A.enqueueAction(action);
  },
  handleExternalChange: function(component, event, helper) {
    var recordId = helper.getRecordId(component);
    if (!recordId) {
      return;
    }
    var action = component.get('c.getTaskCountsByList');
    action.setParams({
      recordId: recordId
    });
    component.set('v.visibleProjectIndex', 0);
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var index = component.get('v.visibleProjectIndex');
        var projectArr = response.getReturnValue();
        projectArr = helper.parseProjects(projectArr);
        component.set('v.currentProjectObject', projectArr[index]);
        component.set('v.records', projectArr);
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  goToProject: function(component, event) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      projectId: event.target.id
    });
    navigateToTaskRay.fire();
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
  makeProject: function() {
    var urlEvent = $A.get('e.force:createRecord');
    urlEvent.setParams({
      entityApiName: 'TASKRAY__Project__c'
    });
    urlEvent.fire();
  },
  makeTask: function() {
    var urlEvent = $A.get('e.force:createRecord');
    urlEvent.setParams({
      entityApiName: 'TASKRAY__Project_Task__c'
    });
    urlEvent.fire();
  }
});