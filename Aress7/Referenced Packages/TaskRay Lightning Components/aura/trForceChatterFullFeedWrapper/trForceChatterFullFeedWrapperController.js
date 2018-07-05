({
  doInit: function(component, event, helper) {
    var action = component.get('c.globalSettingShowFullFeedChatter');
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        component.set('v.showNewFeed', response.getReturnValue());
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  navigateToTask: function(component, event) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      taskId: event.target.id
    });
    navigateToTaskRay.fire();
  }
});