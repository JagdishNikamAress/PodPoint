({
  completeTask: function(component) {
    var taskName = component.find('task-name');
    $A.util.addClass(taskName, 'strike-through');
    var completeTask = component.getEvent('genericEvent');

    completeTask.setParams({
      actionType: 'completeTask',
      payload: {
        Id: component.get('v.todoItem').taskId,
        failCallback: component.get('c.failedCompletion')
      }
    });
    completeTask.fire();
  },
  failedCompletion: function(component) {
    var taskName = component.find('task-name');
    $A.util.removeClass(taskName, 'strike-through');
    var checkbox = component.find('completed-checkbox');
    if (checkbox && checkbox.elements && checkbox.elements[0]) {
      checkbox.elements[0].checked = false;
    }
  },
  goToProject: function(component, event) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      projectId: event.target.id
    });
    navigateToTaskRay.fire();
  }
});