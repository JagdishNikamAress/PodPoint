({
  getOverdueDatesForUser: function(component, event, helper) {
    var action = component.get('c.overdueDatesForUser');
    action.setParams({
      limitInt: component.get('v.numDatesToShow')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var dateArray = [];
        if (component.get('v.datesWithTodoItems')) {
          dateArray = component.get('v.datesWithTodoItems');
        }
        var countOfOldDates = dateArray.length;
        var lastOldDate = dateArray.length
          ? dateArray[dateArray.length - 1]
          : null;
        var countOfNewDates = response.getReturnValue().length;

        var lastNewDate = response.getReturnValue().length
          ? response.getReturnValue()[response.getReturnValue().length - 1]
          : null;
        component.set(
          'v.hasOverdue',
          response.getReturnValue().length ? true : false
        );
        component.set('v.datesWithTodoItems', response.getReturnValue());
        if (
          countOfNewDates === countOfOldDates && lastOldDate === lastNewDate
        ) {
          component.set('v.hideShowMore', true);
        }

        if (response.getReturnValue().length === 0 && countOfOldDates > 0) {
          component.set('v.showOverdueTasks', false);
        }
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  popErrorMessage: function(component, action) {
    var errors = action.getError();
    var msg = errors &&
      errors[0] &&
      errors[0].pageErrors &&
      errors[0].pageErrors[0] &&
      errors[0].pageErrors[0] &&
      errors[0].pageErrors[0].message
      ? errors[0].pageErrors[0].statusCode +
          ' ' +
          errors[0].pageErrors[0].message
      : '';
    if (msg == '') {
      if (typeof errors[0].message != 'undefined' && errors[0].message) {
        msg = errors[0].message;
      }
    }
    var showToast = $A.get('e.force:showToast');
    console.log(errors);
    showToast.setParams({
      title: 'Error: ',
      message: 'Taskray encountered an error: ' + msg,
      type: 'error'
    });
    showToast.fire();
  }
});