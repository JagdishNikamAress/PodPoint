({
  doInit: function(component, event, helper) {
    var action = component.get('c.getAccessLevel');
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var accessLevel = response.getReturnValue();
        component.set('v.accessLevel', accessLevel);
      } else {
        var errors = action.getError();
        var msg = errors &&
          errors[0] &&
          errors[0].pageErrors &&
          errors[0].pageErrors[0] &&
          errors[0].pageErrors[0] &&
          errors[0].pageErrors[0].message
          ? errors[0].pageErrors[0].statusCode +
              ' ' +
              errors[0].pageErrors[0].message
          : '';
        var showToast = $A.get('e.force:showToast');
        showToast.setParams({
          title: 'Error: ',
          message: 'Taskray encountered an error: ' + msg,
          type: 'error'
        });
        showToast.fire();
      }
    });
    $A.enqueueAction(action);

    var baseURLAction = component.get('c.getBaseURL');
    baseURLAction.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        component.set('v.baseURL', response.getReturnValue());
      } else {
        var errors = baseURLAction.getError();
        var msg = errors &&
          errors[0] &&
          errors[0].pageErrors &&
          errors[0].pageErrors[0] &&
          errors[0].pageErrors[0] &&
          errors[0].pageErrors[0].message
          ? errors[0].pageErrors[0].statusCode +
              ' ' +
              errors[0].pageErrors[0].message
          : '';
        var showToast = $A.get('e.force:showToast');
        showToast.setParams({
          title: 'Error: ',
          message: 'Taskray encountered an error: ' + msg,
          type: 'error'
        });
        showToast.fire();
      }
    });
    $A.enqueueAction(baseURLAction);

    var getSettingAction = component.get('c.getGlobalSetting_orgDefaults');
    getSettingAction.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var customSetting = response.getReturnValue();
        if (customSetting.TASKRAY_LTNG__trLTNG_navigateToStandardUI__c) {
          component.set('v.navigateToStandardUI', true);
        }
      } else {
        var errors = baseURLAction.getError();
        var msg = errors &&
          errors[0] &&
          errors[0].pageErrors &&
          errors[0].pageErrors[0] &&
          errors[0].pageErrors[0] &&
          errors[0].pageErrors[0].message
          ? errors[0].pageErrors[0].statusCode +
              ' ' +
              errors[0].pageErrors[0].message
          : '';
        var showToast = $A.get('e.force:showToast');
        showToast.setParams({
          title: 'Error: ',
          message: 'Taskray encountered an error: ' + msg,
          type: 'error'
        });
        showToast.fire();
      }
    });
    $A.enqueueAction(getSettingAction);
  },
  handleNavigationEvent: function(component, event, helper) {
    var projectId = event.getParam('projectId');
    var taskId = event.getParam('taskId');
    var showTimesheet = event.getParam('showTimesheet');
    var openModal = event.getParam('openModal');
    var navigateToSObject = $A.get('e.force:navigateToSObject');
    //if navigateToSObject is available (LEx)
    //If the custom setting to navigate to std ui is checked
    //and we're not opening the timesheet
    if (
      navigateToSObject &&
      component.get('v.navigateToStandardUI') &&
      !showTimesheet
    ) {
      //Navigate to the record in the standard UI
      if (projectId && !taskId) {
        navigateToSObject.setParams({
          recordId: projectId
        });
        navigateToSObject.fire();
      } else if (taskId) {
        var navigateToSObject = $A.get('e.force:navigateToSObject');
        navigateToSObject.setParams({
          recordId: taskId
        });
        navigateToSObject.fire();
      }
      return;
    }

    var baseURL = component.get('v.baseURL');
    var navURL = '';
    if (baseURL) {
      navURL = baseURL + '/s/taskray?';
    } else {
      navURL = '/apex/TASKRAY__trtaskboard?';
    }
    if (projectId) {
      navURL += 'projectid=' + projectId;
    }
    if (taskId) {
      if (projectId) {
        navURL += '&taskid=' + taskId;
      } else {
        navURL += 'taskid=' + taskId;
      }
    }
    if (showTimesheet) {
      if (projectId || taskId) {
        navURL += '&showTimesheet=true';
      } else {
        navURL += 'showTimesheet=true';
      }
    }

    var showModalStr = openModal ? '&showmodal=true' : '&showmodal=false';

    if (baseURL) {
      // window.open(navURL);
      var urlEvent = $A.get('e.force:navigateToURL');
      urlEvent.setParams({
        url: navURL + showModalStr
      });
      urlEvent.fire();
    } else {
      var urlEvent = $A.get('e.force:navigateToURL');
      if (typeof urlEvent == 'undefined') {
        newwindow = window.open(navURL);
        if (window.focus) {
          setTimeout(newwindow.focus(), 1);
        }
      } else {
        urlEvent.setParams({
          url: navURL + showModalStr
        });
        urlEvent.fire();
      }
    }
  }
});