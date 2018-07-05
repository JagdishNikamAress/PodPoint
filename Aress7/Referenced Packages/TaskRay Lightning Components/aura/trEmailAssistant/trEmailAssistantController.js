({
  handlePeopleChange: function(component, event, helper) {
    var people = component.get('v.people');
    helper.getContextAccountId(people, component);
    helper.isTimeEnabled(component);
  },
  removeContext: function(component, event, helper) {
    component.set('v.hasContext', false);
  }
});