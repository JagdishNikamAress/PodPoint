({
  doInit: function(component, event, helper) {
    var action = component.get('c.getBaseURL');
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var baseURL = response.getReturnValue();
        component.set('v.baseURL', baseURL);
        var customURL = component.get('v.customURL');

        var iframeURL = baseURL + '/apex/TASKRAY__trTaskBoard?isdtp=p1';
        if (customURL) {
          iframeURL = customURL;
        }

        var queryDict = {};
        window.location.search.substr(1).split('&').forEach(function(item) {
          queryDict[item.split('=')[0]] = item.split('=')[1];
        });

        if (queryDict['projectid']) {
          iframeURL +=
            '&projectid=' + queryDict['projectid'] + '&showmodal=false';
        }

        if (queryDict['taskid']) {
          iframeURL += '&taskid=' + queryDict['taskid'] + '&showmodal=false';
        }

        if (queryDict['showTimesheet']) {
          iframeURL += '&showTimesheet=true';
        }

        component.set('v.iframeURL', iframeURL);
      } else {
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
        var showToast = $A.get('e.force:showToast');
        showToast.setParams({
          title: 'Error: ',
          message: 'Taskray encountered an error: ' + msg,
          type: 'error'
        });
        showToast.fire();
      }
    });
    $A.enqueueAction(action);
  }
});