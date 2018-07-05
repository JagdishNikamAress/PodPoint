({
  doInit: function(component, event, helper) {
    var action = component.get('c.getKanbanBoardInfo');
    action.setParams({
      recordId: helper.getRecordId(component)
    });
    if (helper.getRecordId(component) == undefined) {
      component.set('v.recordError', 'true');
      component.set('v.records', []);
    } else {
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          // success with records
          if (response.getReturnValue().projects.length > 0) {
            var data = response.getReturnValue();
            component.set('v.visibleProjectIndex', 0);
            var unsortedData = helper.drawKanban(
              data,
              helper.getRecordId(component)
            );
            var sortedData = helper.applySortOrder(unsortedData);
            var currentProjectObject = JSON.parse(
              JSON.stringify(sortedData[0])
            );

            component.set('v.currentProjectObject', currentProjectObject);

            component.set('v.records', sortedData);
          }
          // success with no records
          if (response.getReturnValue().projects.length === 0) {
            $A.util.addClass(
              document.getElementById('trQuickKanbanBoard'),
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
    var action = component.get('c.getKanbanBoardInfo');
    action.setParams({
      recordId: recordId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var data = response.getReturnValue();
        component.set('v.visibleProjectIndex', 0);
        var unsortedData = helper.drawKanban(
          data,
          helper.getRecordId(component)
        );
        var sortedData = helper.applySortOrder(unsortedData);
        component.set('v.records', sortedData);
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  //fired from SuccessfulChange event AFTER the data comes from the server
  successOnChange: function(component, event, helper) {
    var parsedResult = helper.drawKanban(
      event.getParam('data'),
      helper.getRecordId(component)
    );
    var sortedResults = helper.applySortOrder(parsedResult);
    var visibleProjectIndex = component.get('v.visibleProjectIndex');
    component.set('v.currentProjectObject', sortedResults[visibleProjectIndex]);
    component.set('v.records', sortedResults);
  },
  goToProject: function(component, event) {
    var navEvt = $A.get('e.force:navigateToSObject');
    navEvt.setParams({
      recordId: event.target.id
    });
    navEvt.fire();
  },
  goLeft: function(component, event, helper) {
    if (component.get('v.visibleProjectIndex') > 0) {
      component.set(
        'v.visibleProjectIndex',
        component.get('v.visibleProjectIndex') - 1
      );
      var sortedData = helper.applySortOrder(component.get('v.records'));
      component.set('v.records', sortedData);
      component.set(
        'v.currentProjectObject',
        sortedData[component.get('v.visibleProjectIndex')]
      );
    }
  },
  goRight: function(component, event, helper) {
    if (
      component.get('v.visibleProjectIndex') <
      component.get('v.records').length - 1
    ) {
      component.set(
        'v.visibleProjectIndex',
        component.get('v.visibleProjectIndex') + 1
      );
      var sortedData = helper.applySortOrder(component.get('v.records'));
      component.set('v.records', sortedData);
      component.set(
        'v.currentProjectObject',
        sortedData[component.get('v.visibleProjectIndex')]
      );
    }
  },
  makeProject: function(component) {
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