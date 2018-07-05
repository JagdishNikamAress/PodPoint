({
  isTimeEnabled: function(component) {
    var action = component.get('c.getIsTimeEnabled');
    action.setCallback(this, function(response) {
      if (
        component.isValid() &&
        response !== null &&
        response.getState() == 'SUCCESS'
      ) {
        component.set('v.timeEnabled', response.getReturnValue());
      }
    });
    $A.enqueueAction(action);
  },
  getContextAccountId: function(people, component) {
    if (people != null) {
      var emailToSearch = people.from.email;
      var action = component.get('c.findAccountMapForUserEmail');
      action.setParams({
        emailToSearch: emailToSearch
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (
          state === 'SUCCESS' &&
          response.getReturnValue() !== null &&
          response.getReturnValue() !== 'undefined'
        ) {
          var accountMapIdToName = response.getReturnValue();
          var accountIdForContact;
          var accountName;
          for (var i in accountMapIdToName) {
            accountIdForContact = i;
          }
          accountName = accountMapIdToName[accountIdForContact];
          component.set('v.accountId', accountIdForContact);
          component.set('v.hasContext', true);
          component.set('v.accountName', accountName);
        } else {
          component.set('v.accountId', null);
          component.set('v.hasContext', false);
          component.set('v.accountName', null);
        }
      });
    } else {
      return null;
    }
    $A.enqueueAction(action);
  }
});