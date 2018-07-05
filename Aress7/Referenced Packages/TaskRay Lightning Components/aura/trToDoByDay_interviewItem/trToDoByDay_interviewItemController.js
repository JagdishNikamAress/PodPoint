({
  doInit: function(cmp, event, helper) {
    var interviewDate = cmp.get('v.interviewObj.TASKRAY__trInterviewDate__c');
    var completed = cmp.get('v.interviewObj.TASKRAY__trCompleted__c');
    var startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);
    if (!completed && startOfDay > completed) {
      cmp.set('v.isOverdue', true);
    }
  },
  toggleExpanded: function(cmp, event, helper) {
    cmp.set('v.expanded', !cmp.get('v.expanded'));
  },
  navigateToTask: function(cmp, event, helper) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      taskId: cmp.get('v.interviewObj.TASKRAY__trTask__c')
    });
    navigateToTaskRay.fire();
  },
  navigateToProject: function(cmp, event, helper) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    var projectId = cmp.get('v.interviewObj.TASKRAY__trProject__c');
    if (!projectId) {
      projectId = cmp.get(
        'v.interviewObj.TASKRAY__trTask__r.TASKRAY__Project__c'
      );
    }
    navigateToTaskRay.setParams({
      projectId: projectId
    });
    navigateToTaskRay.fire();
  },
  navigateToOwner: function(cmp, event, helper) {
    var navEvt = $A.get('e.force:navigateToSObject');
    navEvt.setParams({
      recordId: cmp.get('v.interviewObj.OwnerId')
    });
    navEvt.fire();
  },
  navigateToInterviewRecord: function(cmp, event, helper) {
    var navEvt = $A.get('e.force:navigateToSObject');
    navEvt.setParams({
      recordId: cmp.get('v.interviewObj.Id')
    });
    navEvt.fire();
  }
});