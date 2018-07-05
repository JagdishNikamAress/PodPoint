({
  getStats: function(
    component,
    helper,
    showAllTaskGroups,
    selectedTaskGroupId
  ) {
    var action = component.get('c.getFilteredStatCounts');
    action.setParams({
      recordId: component.get('v.recordId'),
      showAllTaskGroups: showAllTaskGroups,
      taskGroup: selectedTaskGroupId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        if (response.getReturnValue().length > 0) {
          var allProjects = [];
          response.getReturnValue().forEach(project => {
            var clonedProject = JSON.parse(JSON.stringify(project));
            clonedProject.statList.forEach(statGroup => {
              var color = statGroup.statColor;
              statGroup.colorBoxStyle =
                'height:10px; width:10px; background-color:' + color + ';';
              statGroup.color = color;
              statGroup.count = statGroup.taskCount;
              statGroup.label = statGroup.statName;
            });
            if (clonedProject.statList) {
              clonedProject.progressArray = [];
              clonedProject.statList.forEach(
                function(taskStatusObj) {
                  if (
                    taskStatusObj.statName != 'overdue' &&
                    taskStatusObj.statName != 'blocked' &&
                    taskStatusObj.statName != 'completionPercentage'
                  ) {
                    clonedProject.progressArray.push({
                      percentage: taskStatusObj.percentage,
                      color: taskStatusObj.statColor
                    });
                  }
                }.bind(this)
              );
            }
            if (clonedProject.statList) {
              clonedProject.statList.forEach(function(taskStatusObj) {
                if (taskStatusObj.statName === 'blocked') {
                  clonedProject.blockedCount = taskStatusObj.count;
                }
                if (taskStatusObj.statName === 'overdue') {
                  clonedProject.overdueCount = taskStatusObj.count;
                }
                if (taskStatusObj.statName === 'scheduleConflictCount') {
                  clonedProject.scheduleConflictCount = taskStatusObj.count;
                }
                if (taskStatusObj.statName === 'completionPercentage') {
                  clonedProject.completionPercentage = taskStatusObj.count;
                }
              });

              // show 0 for blocked and overdue if they are 0
              if (
                typeof clonedProject.blockedCount == 'undefined' ||
                clonedProject.blockedCount == null
              ) {
                clonedProject.blockedCount = 0;
              }
              if (
                typeof clonedProject.overdueCount == 'undefined' ||
                clonedProject.overdueCount == null
              ) {
                clonedProject.overdueCount = 0;
              }
            }

            clonedProject.statList.sort(function(listA, listB) {
              if (
                clonedProject.listOptions.indexOf(listA.label) >
                clonedProject.listOptions.indexOf(listB.label)
              ) {
                return 1;
              } else if (
                clonedProject.listOptions.indexOf(listA.label) <
                clonedProject.listOptions.indexOf(listB.label)
              ) {
                return -1;
              } else {
                return 0;
              }
            });

            //adding doesProjectHaveTaskGroups to project object to check if we should render the dropdown.
            var onlyTaskGroupIsNotUngrouped;
            if (clonedProject.taskGroupInfoArray.length === 1) {
              onlyTaskGroupIsNotUngrouped = clonedProject.taskGroupInfoArray[0]
                .taskGroup === undefined
                ? false
                : true;
            }
            clonedProject.doesProjectHaveTaskGroups = clonedProject
              .taskGroupInfoArray.length > 1 || onlyTaskGroupIsNotUngrouped
              ? true
              : false;
            //add "Show All" option to dropdown
            clonedProject.taskGroupInfoArray.push({
              Id: $A.get('$Label.taskray_ltng.trSnapshotComponent_ShowAll'),
              Name: $A.get('$Label.taskray_ltng.trSnapshotComponent_ShowAll'),
              taskGroupSortOrder: -1
            });
            clonedProject.taskGroupInfoArray = clonedProject.taskGroupInfoArray.sort(
              function(groupA, groupB) {
                var groupASortOrder = groupA.taskGroupSortOrder !== undefined
                  ? groupA.taskGroupSortOrder
                  : clonedProject.taskGroupInfoArray.length;
                var groupBSortOrder = groupB.taskGroupSortOrder !== undefined
                  ? groupB.taskGroupSortOrder
                  : clonedProject.taskGroupInfoArray.length;
                if (groupASortOrder > groupBSortOrder) {
                  return 1;
                } else if (groupASortOrder < groupBSortOrder) {
                  return -1;
                } else {
                  return 0;
                }
              }
            );
            if (clonedProject.statList.length == 0) {
              clonedProject.hasStatList = false;
            }
            clonedProject.statList = clonedProject.statList.filter(function(
              taskStatusObj
            ) {
              return taskStatusObj.statName !== 'completionPercentage';
            });
            allProjects.push(clonedProject);
          });
          component.set('v.records', allProjects);
          var visibleProjectIndex = component.get('v.visibleProjectIndex');
          component.set(
            'v.currentProjectObject',
            allProjects[visibleProjectIndex]
          );
        }
        // success with no records
        if (response.getReturnValue().length === 0) {
          $A.util.addClass(
            document.getElementsByClassName('trProjectSnapshot')[0],
            'disappear'
          );
          component.set('v.records', []);
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
    showToast.setParams({
      title: 'Error: ',
      message: 'Taskray encountered an error: ' + msg,
      type: 'error'
    });
    showToast.fire();
  },
  getRecordId: function(component) {
    var recordId = component.get('v.recordId');
    return recordId;
  }
});