({
  getRecordId: function(component) {
    var recordId = component.get('v.recordId');
    return recordId;
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
  },
  parseProjects: function(projects) {
    projects.forEach(function(project) {
      if (project.project.TASKRAY__TaskRay_Task_Groups__r) {
        project.project.TASKRAY__TaskRay_Task_Groups__r.forEach(
          taskGroupObj => {
            project.taskGroupsArray.push({
              taskGroupInfo: taskGroupObj,
              milestoneTasks: project.milestoneTasksByTaskGroup
                ? project.milestoneTasksByTaskGroup[taskGroupObj.Id]
                : []
            });
          }
        );
        if (project.milestoneTasksByTaskGroup['null']) {
          project.taskGroupsArray.push({
            taskGroupInfo: null,
            milestoneTasks: project.milestoneTasksByTaskGroup['null']
          });
        }
      } else {
        project.taskGroupsArray.push({
          taskGroupInfo: null,
          milestoneTasks: project.milestoneTasksByTaskGroup['null']
        });
      }
    });
    return projects;
  }
});