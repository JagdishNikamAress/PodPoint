({
  doInit: function(component, event, helper) {
    var taskGroupObj = component.get('v.taskGroupObj');
    var projectStart = component.get('v.projectStartDateUnformatted');
    var projectEnd = component.get('v.projectEndDateUnformatted');
    if (
      taskGroupObj &&
      taskGroupObj.TASKRAY__trStartDate__c &&
      taskGroupObj.TASKRAY__trEndDate__c &&
      projectStart &&
      projectEnd
    ) {
      var projectStartDate = new Date(projectStart).getTime();
      var projectEndDate = new Date(projectEnd);
      projectEndDate.setDate(projectEndDate.getDate() + 1);
      projectEndDate = projectEndDate.getTime();
      var projectDuration = projectEndDate - projectStartDate;
      var percentageRatio = 100.0000 / projectDuration;
      var taskGroupStart = new Date(
        taskGroupObj.TASKRAY__trStartDate__c
      ).getTime();
      //Make sure end dates are inclusive
      var taskGroupEnd = new Date(taskGroupObj.TASKRAY__trEndDate__c);
      taskGroupEnd.setDate(taskGroupEnd.getDate() + 1);
      taskGroupEnd = taskGroupEnd.getTime();
      var taskGroupDuration = taskGroupEnd - taskGroupStart;
      var taskGroupLeftOffset =
        percentageRatio * (taskGroupStart - projectStartDate);
      var taskGroupWidthPct = percentageRatio * taskGroupDuration;
      component.set('v.taskGroupLeftOffset', taskGroupLeftOffset);
      component.set('v.taskGroupWidth', taskGroupWidthPct);
    }
    if (taskGroupObj && taskGroupObj.TASKRAY__trCompletionPercentage__c) {
      component.set(
        'v.parsedTaskGroupCompletionPercentage',
        Number(
          Math.round(taskGroupObj.TASKRAY__trCompletionPercentage__c + 'e2') +
            'e-2'
        )
      );
    }
    if (taskGroupObj && taskGroupObj.TASKRAY__trStartDate__c) {
      component.set(
        'v.parsedTaskGroupStart',
        new Date(taskGroupObj.TASKRAY__trStartDate__c).toLocaleDateString()
      );
    }
    if (taskGroupObj && taskGroupObj.TASKRAY__trEndDate__c) {
      component.set(
        'v.parsedTaskGroupEnd',
        new Date(taskGroupObj.TASKRAY__trEndDate__c).toLocaleDateString()
      );
    }
  }
});