({
  doInit: function(component, event, helper) {
    component.set('v.numTasksToShow', 1);
    helper.fetchRecentTasks(component, event, helper);
  },
  showMore: function(component, event, helper) {
    component.set('v.numTasksToShow', component.get('v.numTasksToShow') + 1);
    helper.fetchRecentTasks(component, event, helper);
  }
});