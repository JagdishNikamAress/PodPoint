({
  setup: function(component) {
    if (!component.get('v.type')) {
      $A.error(
        'inputLookup component requires a valid SObject type as input: [' +
          component.getGlobalid() +
          ']'
      );
      return;
    }
  },
  initTypeahead: function(component, event, helper) {
    //creates the typeahead component
    helper.loadFirstValue(component);
  }
});