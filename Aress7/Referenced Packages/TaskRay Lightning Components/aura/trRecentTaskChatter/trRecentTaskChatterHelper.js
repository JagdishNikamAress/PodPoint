({
  fetchRecentTasks: function(component) {
    var action = component.get('c.tasksWithRecentChatter');
    action.setParams({
      numTasksToShow: component.get('v.numTasksToShow')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        // success with records
        var insertedTaskIds = component.get('v.insertedTaskIds');
        var insertedATask = false;
        if (!response.getReturnValue()) {
          return;
        }
        response.getReturnValue().forEach(function(taskObj) {
          if (insertedTaskIds.indexOf(taskObj.Id) === -1) {
            insertedATask = true;
            var params = { taskObj: taskObj };
            insertedTaskIds.push(taskObj.Id);
            $A.createComponent(
              'TASKRAY_LTNG:trForceChatterFullFeedWrapper',
              params,
              function(chatterFeed) {
                var content = component.find('content');
                var contentBody = content.get('v.body');
                contentBody.push(chatterFeed);
                content.set('v.body', contentBody);
                component.set('v.insertedTaskIds', insertedTaskIds);
              }
            );
          }
        });
        if (insertedATask === false) {
          $A.util.toggleClass(component.find('showMore'), 'slds-hide');
        }
      } else {
        this.popErrorMessage(component, action);
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
    showToast.setParams({
      title: 'Error: ',
      message: 'Taskray encountered an error: ' + msg,
      type: 'error'
    });
    showToast.fire();
  }
});