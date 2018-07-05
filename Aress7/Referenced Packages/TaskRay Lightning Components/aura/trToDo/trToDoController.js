({
  doInit: function(component, event, helper) {
    var action = component.get('c.getTaskByStatCountAndList');
    action.setParams({
      recordId: helper.getRecordId(component)
    });
    if (helper.getRecordId(component) == undefined) {
      component.set('v.recordError', 'true');
      component.set('v.records', []);
    } else {
      component.set('v.viewToDisplay', 'list');
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          // success with records
          if (response.getReturnValue().length > 0) {
            helper.organizeResponse(component, response);
          }
          // success with no records
          if (response.getReturnValue().length === 0) {
            // $A.util.addClass(document.getElementsByClassName('slds-button')[0], 'doNotShow')
            $A.util.addClass(
              document.getElementsByClassName('trToDo')[0],
              'disappear'
            );
            component.set('v.records', []);
            // component.set("v.showButton", " ");
          }
        } else {
          helper.popErrorMessage(component, action);
        }
      });
      var timeTasks = component.find('projectTime');
      var timeButton = component.find('time');
      var taskGroupTasks = component.find('projectTaskGroup');
      var statusLightButton = component.find('statusLight');
      $A.util.addClass(timeTasks, 'invisible');
      $A.util.addClass(timeButton, 'invisible');
      $A.util.addClass(taskGroupTasks, 'invisible');
      $A.util.addClass(statusLightButton, 'invisible');
    }
    $A.enqueueAction(action);
  },
  handleExternalChange: function(component, event, helper) {
    var recordId = helper.getRecordId(component);
    if (!recordId) {
      return;
    }
    var action = component.get('c.getTaskByStatCountAndList');
    action.setParams({
      recordId: recordId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        helper.organizeResponse(component, response);
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  goLeft: function(component) {
    if (component.get('v.visibleProjectIndex') > 0) {
      var newVisibleProjectIndex = component.get('v.visibleProjectIndex') - 1;
      component.set('v.visibleProjectIndex', newVisibleProjectIndex);
      var allRecords = component.get('v.records');
      component.set(
        'v.currentProjectObject',
        allRecords[newVisibleProjectIndex]
      );
    }
  },
  goRight: function(component) {
    if (
      component.get('v.visibleProjectIndex') <
      component.get('v.records').length - 1
    ) {
      var newVisibleProjectIndex = component.get('v.visibleProjectIndex') + 1;
      component.set('v.visibleProjectIndex', newVisibleProjectIndex);
      var allRecords = component.get('v.records');
      component.set(
        'v.currentProjectObject',
        allRecords[newVisibleProjectIndex]
      );
    }
  },
  listView: function(component, event) {
    event.preventDefault();
    component.set('v.viewToDisplay', 'list');
    var timeTasks = component.find('projectTime');
    var statusTasks = component.find('projectList');
    var taskGroupTasks = component.find('projectTaskGroup');
    $A.util.addClass(timeTasks, 'invisible');
    $A.util.removeClass(statusTasks, 'invisible');
    $A.util.addClass(taskGroupTasks, 'invisible');
  },
  timeView: function(component, event) {
    event.preventDefault();
    component.set('v.viewToDisplay', 'time');
    var timeTasks = component.find('projectTime');
    var statusTasks = component.find('projectList');
    var taskGroupTasks = component.find('projectTaskGroup');
    $A.util.removeClass(timeTasks, 'invisible');
    $A.util.addClass(statusTasks, 'invisible');
    $A.util.addClass(taskGroupTasks, 'invisible');
  },
  taskGroupView: function(component, event) {
    event.preventDefault();
    component.set('v.viewToDisplay', 'taskGroup');
    var timeTasks = component.find('projectTime');
    var statusTasks = component.find('projectList');
    var taskGroupTasks = component.find('projectTaskGroup');
    $A.util.addClass(timeTasks, 'invisible');
    $A.util.addClass(statusTasks, 'invisible');
    $A.util.removeClass(taskGroupTasks, 'invisible');
  },
  toggleMenuOpen: function(component, event, helper) {
    component.set('v.menuOpen', !component.get('v.menuOpen'));
  },
  goToProject: function(component, event) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      projectId: event.target.id
    });
    navigateToTaskRay.fire();
  },
  finished: function(component, event, helper) {
    $A.util.addClass(
      document.getElementById('taskText-' + event.target.id),
      'cross'
    );
    $A.util.addClass(
      document.getElementById('taskText-' + event.target.id),
      'fade'
    );
    $A.util.addClass(
      document.getElementById('taskText2-' + event.target.id),
      'cross'
    );
    $A.util.addClass(
      document.getElementById('taskText2-' + event.target.id),
      'fade'
    );
    var action = component.get('c.markTaskComplete');
    action.setParams({
      taskId: event.target.id,
      recordId: helper.getRecordId(component)
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        helper.organizeResponse(component, response);
        // var allRecords = component.get("v.records");
        // component.set("v.currentProjectObject", (allRecords[component.get("v.visibleProjectIndex")]));
        var appEvent = $A.get('e.TASKRAY_LTNG:trExternalChange');
        appEvent.fire();
      } else {
        $A.util.removeClass(
          document.getElementById('taskText-' + event.target.id),
          'cross'
        );
        $A.util.removeClass(
          document.getElementById('taskText-' + event.target.id),
          'fade'
        );
        $A.util.addClass(
          document.getElementById('taskText2-' + event.target.id),
          'cross'
        );
        $A.util.addClass(
          document.getElementById('taskText2-' + event.target.id),
          'fade'
        );
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
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
  },
  handleColumnScrollStart: function(component, event) {
    event.stopPropagation();
  }
});