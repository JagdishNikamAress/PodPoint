({
  toggleShowOverdueTasks: function(component) {
    var action = component.get('v.toggleShowOverdueTasks');
    if (action) {
      $A.enqueueAction(action);
    }
  },
  doInit: function(component, event, helper) {
    helper.getOverdueDatesForUser(component, event, helper);
  },
  showMoreOverDueTasks: function(component, event, helper) {
    component.set('v.numDatesToShow', component.get('v.numDatesToShow') + 3);
    helper.getOverdueDatesForUser(component, event, helper);
  },
  refetchOverdueDates: function(component, event, helper) {
    helper.getOverdueDatesForUser(component, event, helper);
  }
});