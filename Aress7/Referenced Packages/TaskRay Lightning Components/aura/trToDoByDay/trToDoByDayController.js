({
  doInit: function(component, event, helper) {
    helper.fetchTodoItems(component, event, helper);
  },
  handleComponentEvent: function(component, event, helper) {
    var payload = event.getParam('payload');
    if (
      event.getParam('actionType') === 'completeTask' ||
      event.getParam('actionType') === 'completeChecklistItem' ||
      event.getParam('actionType') === 'completeInterview'
    ) {
      helper.completeTodoItem(
        payload.Id,
        component,
        helper,
        payload.failCallback
      );
      event.stopPropagation();
    }
  },
  showSpinner: function(component) {
    var spinner = component.find('spinner');
    var evt = spinner.get('e.toggle');
    evt.setParams({ isVisible: true });
    evt.fire();
  },
  hideSpinner: function(component) {
    var spinner = component.find('spinner');
    var evt = spinner.get('e.toggle');
    evt.setParams({ isVisible: false });
    evt.fire();
  },
  handleExternalChange: function(component, event, helper) {
    helper.fetchTodoItems(component, event, helper);
  }
});