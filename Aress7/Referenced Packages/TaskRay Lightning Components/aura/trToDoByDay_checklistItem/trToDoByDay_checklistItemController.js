({
  completeChecklistItem: function(component) {
    var checklistItemText = component.find('checklistItem-text');
    $A.util.addClass(checklistItemText, 'strike-through');
    var completeChecklistItem = component.getEvent('genericEvent');
    completeChecklistItem.setParams({
      actionType: 'completeChecklistItem',
      payload: {
        Id: component.get('v.checklistItem').Id,
        failCallback: component.get('c.failedCompletion')
      }
    });
    completeChecklistItem.fire();
  },
  failedCompletion: function(component) {
    var checklistItemName = component.find('checklistItem-text');
    $A.util.removeClass(checklistItemName, 'strike-through');
    var checkbox = component.find('completed-checkbox');
    if (checkbox && checkbox.elements && checkbox.elements[0]) {
      checkbox.elements[0].checked = false;
    }
  }
});