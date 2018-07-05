({
  doInit: function(component, event, helper) {
    var todayDate = new Date();
    component.set('v.selectedDay', todayDate.getDay());
    var monday = helper.getStartDateOfWeek(todayDate);
    component.set('v.startDateOfWeek', monday);
    component.set('v.startDateFormatted', helper.formatDate(monday));
    component.set('v.addLabelShowing', true);
    var action = component.get('c.getTimeDataForUserAndDates');
    action.setParams({
      startDateYear: monday.getFullYear(),
      startDateMonth: monday.getMonth() + 1,
      startDateDay: monday.getDate()
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        helper.organizeData(response.getReturnValue(), component);
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  handleAppEvent: function(component, event, helper) {
    var payload = event.getParam('payload');
    switch (event.getParam('actionType')) {
      case 'typeaheadSelected':
        if (payload.target === 'TIME_ENTRY_ADD_TASK') {
          helper.setPendingTaskId(component, payload.selectedItemId);
          event.stopPropagation();
          break;
        }
    }
  },
  clickedADay: function(component, event) {
    var clickedDay = event.target.id;
    component.set('v.selectedDay', parseInt(clickedDay));
  },
  goBackAWeek: function(component, event, helper) {
    var oldStartDate = component.get('v.startDateOfWeek');
    var newStartDate = helper.addDays(oldStartDate, -7);
    component.set('v.startDateOfWeek', newStartDate);
    component.set('v.startDateFormatted', helper.formatDate(newStartDate));
    var action = component.get('c.getTimeDataForUserAndDates');
    action.setParams({
      startDateYear: newStartDate.getFullYear(),
      startDateMonth: newStartDate.getMonth() + 1,
      startDateDay: newStartDate.getDate()
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        helper.organizeData(response.getReturnValue(), component);
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  goForwardAWeek: function(component, event, helper) {
    var oldStartDate = component.get('v.startDateOfWeek');
    var newStartDate = helper.addDays(oldStartDate, 7);
    component.set('v.startDateOfWeek', newStartDate);
    component.set('v.startDateFormatted', helper.formatDate(newStartDate));
    var action = component.get('c.getTimeDataForUserAndDates');
    action.setParams({
      startDateYear: newStartDate.getFullYear(),
      startDateMonth: newStartDate.getMonth() + 1,
      startDateDay: newStartDate.getDate()
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        helper.organizeData(response.getReturnValue(), component);
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  goToTask: function(component, event) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      taskId: event.target.id
    });
    navigateToTaskRay.fire();
  },
  addTimeItem: function(component) {
    component.set('v.addLabelShowing', false);
    $A.createComponent('TASKRAY_LTNG:trTaskTypeahead', {}, function(
      newComponent
    ) {
      if (component.isValid()) {
        component.set('v.typeaheadElement', newComponent);
      }
    });
  },
  cancelClicked: function(component) {
    component.set('v.addLabelShowing', true);
    component.set('v.typeaheadElement', null);
  },
  saveClicked: function(component, event, helper) {
    var startDateOfWeek = component.get('v.startDateOfWeek');
    var startDateYear = component.get('v.startDateOfWeek').getFullYear();
    var startDateMonth = component.get('v.startDateOfWeek').getMonth() + 1;
    var startDateDay = component.get('v.startDateOfWeek').getDate();
    var selectedDate = null;
    var viewSelectedDayInt = component.get('v.selectedDay');
    if (viewSelectedDayInt === 1) {
      selectedDate = new Date(startDateOfWeek);
    } else if (viewSelectedDayInt === 2) {
      selectedDate = helper.addDays(new Date(startDateOfWeek), 1);
    } else if (viewSelectedDayInt === 3) {
      selectedDate = helper.addDays(new Date(startDateOfWeek), 2);
    } else if (viewSelectedDayInt === 4) {
      selectedDate = helper.addDays(new Date(startDateOfWeek), 3);
    } else if (viewSelectedDayInt === 5) {
      selectedDate = helper.addDays(new Date(startDateOfWeek), 4);
    } else if (viewSelectedDayInt === 6) {
      selectedDate = helper.addDays(new Date(startDateOfWeek), 5);
    } else if (viewSelectedDayInt === 0) {
      selectedDate = helper.addDays(new Date(startDateOfWeek), 6);
    }
    var taskId = component.get('v.pendingTaskId');
    var hoursInput = component.find('hoursInput').getElement().value;
    var isBillable = component.find('billableCheckbox').getElement().checked;
    var action = component.get('c.addDetailedTimeEntriesToTaskFromTimesheet');
    action.setParams({
      objectYear: selectedDate.getFullYear(),
      objectMonth: selectedDate.getMonth() + 1,
      objectDate: selectedDate.getDate(),
      objectTaskId: taskId,
      objectBillable: isBillable,
      objectHours: hoursInput,
      startDateYear: startDateYear,
      startDateMonth: startDateMonth,
      startDateDay: startDateDay
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        helper.organizeData(response.getReturnValue(), component);
        component.set('v.addLabelShowing', true);
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  goToTimesheet: function(component) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      showTimesheet: true
    });
    navigateToTaskRay.fire();
  }
});