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
  drawKanban: function(data, recordId) {
    //allRecords gets 1 tempRecord p/ project
    var allRecords = [];
    //for each project...
    for (var projectId in data.projects) {
      var project = data.projects[projectId];
      //set up a temp record
      var tempRecord = {
        projectName: project.project.Name,
        projectId: project.project.Id,
        tasks: [],
        noTasks: false
      };
      tempRecord.projectName = project.project.Name;
      tempRecord.tasks = [];
      data.listOptions.forEach(function(listOption) {
        if (!listOption) {
          return;
        }
        var title = listOption.toLowerCase();
        var cappedFirst = title.charAt(0).toUpperCase() + title.slice(1);
        tempRecord.tasks.push({
          statusName: title,
          colColor: data.listColors[cappedFirst],
          colDisplayName: cappedFirst,
          tasks: []
        });
      });
      if (project.tasks) {
        //go through the projects tasks
        project.tasks.forEach(function(taskForProject) {
          var id = taskForProject.Id;
          if (!taskForProject.TASKRAY__List__c) {
            return;
          }
          var blocked = 'not-blocked';
          if (taskForProject.TASKRAY__Blocked__c) {
            blocked = 'blocked';
          }
          if (!taskForProject.TASKRAY__List__c) {
            return;
          }
          var status = taskForProject.TASKRAY__List__c.toLowerCase();
          //iterate tempRecord's tasks to see if we've defined this status
          tempRecord.tasks.forEach(function(tempRecordTask) {
            //add a recordID property to each task
            taskForProject.recordId = recordId;
            taskForProject.blocked = blocked;
            taskForProject.sortOrder = taskForProject.TASKRAY__SortOrder__c;
            if (tempRecordTask.statusName === status) {
              tempRecordTask.tasks.push(taskForProject);
            }
          });
        });
      } else {
        tempRecord.noTasks = true;
      }
      allRecords.push(tempRecord);
    }
    return allRecords;
  },
  applySortOrder: function(projectsDataByList) {
    projectsDataByList.forEach(function(projectDataByList) {
      projectDataByList.tasks.forEach(function(listName) {
        var sortedArray = listName.tasks.sort(function(a, b) {
          return a.sortOrder - b.sortOrder;
        });
        listName.tasks = sortedArray;
      });
    });
    return projectsDataByList;
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
    this.drawKanban();
    showToast.fire();
  }
});