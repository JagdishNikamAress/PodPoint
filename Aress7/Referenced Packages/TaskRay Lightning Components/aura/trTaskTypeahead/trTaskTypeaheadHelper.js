({
  uniqueSearchId: null,
  waitingId: null,
  searchObject: function(component, event, helper) {
    var action = component.get('c.searchSObjects');
    var searchId = new Date().getTime();
    this.uniqueSearchId = searchId;
    var currentSearchInputValue = event.target.value;
    action.setParams({
      currentSearchInputValue: currentSearchInputValue,
      scope: 'tasks',
      template: 'false',
      archived: 'false'
    });

    action.setCallback(this, function(response) {
      if (this.uniqueSearchId == searchId && component.isValid()) {
        component.set('v.suggestions', response.getReturnValue());
      } else {
        // Action aborted because another has been fired
        // Or the component is not valid anymore
      }
    });

    window.clearTimeout(this.waitingId);

    this.waitingId = window.setTimeout(
      $A.getCallback(function() {
        if (component.isValid()) {
          $A.enqueueAction(action);
        }
      }),
      250
    );
  }
});