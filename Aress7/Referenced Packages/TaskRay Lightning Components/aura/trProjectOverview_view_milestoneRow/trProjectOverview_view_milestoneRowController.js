({
  navigateToTask: function(component, event, helper) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      projectId: component.get('v.projectId'),
      taskId: component.get('v.milestoneId'),
      openModal: true
    });
    navigateToTaskRay.fire();
  }
});