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
  organizeResponse: function(component, response) {
    var data = response.getReturnValue();
    //allRecords gets 1 tempRecord per project
    var allRecords = [];
    //for each project...
    data.forEach(function(project) {
      //set up a temporary record
      var keys = [];
      var tempRecord = {
        projectName: project.projectName,
        projectId: project.projectId,
        listTasks: [],
        timeTasks: [],
        taskGroupTasks: [],
        totalTasks: 0,
        completedTasks: 0
      };
      //add the list names to the tempRecord
      for (var listNameKey in project.listOptions) {
        var listName = project.listOptions[listNameKey];
        if (!listName) {
          return;
        }
        tempRecord.listTasks.push({
          statusName: listName.toLowerCase(),
          listColor: project.listColors[listName],
          tasks: []
        });
      }
      var taskGroupIdToTasksMap = {};
      //  go thorugh the project's tasks
      project.projectTasks.forEach(function(tasksForProject) {
        var status = tasksForProject.listName;
        //iterate tempRecord's tasks to see which status it matches in tempRecords
        tempRecord.listTasks.forEach(function(tempRecordListTasks) {
          if (!tempRecordListTasks.statusName || !status) {
            return;
          }
          if (
            tempRecordListTasks.statusName.toLowerCase() ===
            status.toLowerCase()
          ) {
            tempRecordListTasks.tasks.push(tasksForProject);
            tempRecord.totalTasks += 1;
          }
        });
        var time = tasksForProject.timeGroup;
        var timeFound = false;
        //iterate tempRecord's time tasks
        tempRecord.timeTasks.forEach(function(tempRecordTimeTasks) {
          if (tempRecordTimeTasks.timeName === time) {
            tempRecordTimeTasks.tasks.push(tasksForProject);
            timeFound = true; //we found it!
          }
        });
        if (timeFound === false) {
          var timeAndTask = {
            timeName: time,
            tasks: [tasksForProject]
          };
          tempRecord.timeTasks.push(timeAndTask);
        }

        //build map of taskGroupId to an array of all the tasks for taskGroupView
        if (tasksForProject.isComplete === false) {
          var taskGroupId = tasksForProject.taskGroupId !== undefined
            ? tasksForProject.taskGroupId
            : project.projectId + '-Ungrouped';
          if (taskGroupIdToTasksMap[taskGroupId] === undefined) {
            var array = [];
            array.push(tasksForProject);
            taskGroupIdToTasksMap[taskGroupId] = array;
          } else {
            taskGroupIdToTasksMap[taskGroupId].push(tasksForProject);
          }
        }
      });
      //build final task group array based on temporary task group maps for taskGroupView
      for (var key in taskGroupIdToTasksMap) {
        var tasksForGroup = taskGroupIdToTasksMap[key];
        var taskGroupName = tasksForGroup[0].taskGroupName !== undefined
          ? tasksForGroup[0].taskGroupName
          : 'Ungrouped';
        var taskGroupSortOrder = tasksForGroup[0].taskGroupSortOrder !==
          undefined
          ? tasksForGroup[0].taskGroupSortOrder
          : null;
        var taskGroupChunk = {
          taskGroupId: key,
          taskGroupName: taskGroupName,
          taskGroupSortOrder: taskGroupSortOrder,
          tasks: taskGroupIdToTasksMap[key]
        };
        tempRecord.taskGroupTasks.push(taskGroupChunk);
      }
      //sort task groups by taskGroupSortOrder for taskGroupView
      tempRecord.taskGroupTasks = tempRecord.taskGroupTasks.sort(function(
        item1,
        item2
      ) {
        var item1TaskGroupSortOrder = item1.taskGroupSortOrder !== null
          ? item1.taskGroupSortOrder
          : tempRecord.taskGroupTasks.length;
        var item2TaskGroupSortOrder = item2.taskGroupSortOrder !== null
          ? item2.taskGroupSortOrder
          : tempRecord.taskGroupTasks.length;
        if (item1TaskGroupSortOrder < item2TaskGroupSortOrder) {
          return -1;
        } else if (item1TaskGroupSortOrder > item2TaskGroupSortOrder) {
          return 1;
        } else {
          return 0;
        }
      });

      tempRecord.timeTasks.forEach(function(timeGroupObj) {
        timeGroupObj.tasks.sort(function(item1, item2) {
          if (item1.deadline && item2.deadline) {
            var item1Arr = item1.deadline.split('-');
            var item2Arr = item2.deadline.split('-');
            var item1Date = new Date(item1Arr[0], item1Arr[1], item1Arr[2]);
            var item2Date = new Date(item2Arr[0], item2Arr[1], item2Arr[2]);
            return item1Date - item2Date;
          }
          return 0;
        });
      });

      //completed tasks
      tempRecord.completedTasks =
        tempRecord.listTasks[tempRecord.listTasks.length - 1].tasks.length;
      allRecords.push(tempRecord);
    });

    if (component.isValid()) {
      component.set('v.records', allRecords);
      component.set(
        'v.currentProjectObject',
        allRecords[component.get('v.visibleProjectIndex')]
      );
    }
  }
});