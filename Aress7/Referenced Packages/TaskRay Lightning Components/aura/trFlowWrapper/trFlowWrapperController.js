({
  init: function(cmp, event, helper) {
    var flowCmp = cmp.find('flowCmp');
    var inputVariables = [
      {
        name: 'recordId',
        type: 'String',
        value: cmp.get('v.recordId')
      }
    ];
    flowCmp.startFlow(cmp.get('v.flowName'), inputVariables);
  },
  handleStatusChange: function(cmp, event, helper) {
    if (
      event.getParam('status') === 'FINISHED' && cmp.get('v.pendingInterviewId')
    ) {
      var completeInterview = cmp.getEvent('genericEvent');
      completeInterview.setParams({
        actionType: 'completeInterview',
        payload: {
          Id: cmp.get('v.pendingInterviewId'),
          failCallback: cmp.get('c.failedCompletion')
        }
      });
      completeInterview.fire();
      var outputVariables = event.getParam('outputVariables');
      var eventName = null;
      var eventParams = {};
      if (outputVariables) {
        outputVariables.forEach(function(outputVariable) {
          if (outputVariable.name === 'flowOutput_eventName') {
            eventName = outputVariable.value;
          }
          if (outputVariable.name.indexOf('flowOutput_eventParam') === 0) {
            var paramName = outputVariable.name.replace(
              'flowOutput_eventParam_',
              ''
            );
            var paramValue = outputVariable.value;
            eventParams[paramName] = paramValue;
          }
        });
      }
      if (eventName !== null) {
        var appEvent = $A.get(eventName);
        if (appEvent) {
          appEvent.setParams(eventParams);
          appEvent.fire();
        }
      }
    }
  },
  failedCompletion: function(cmp) {}
});