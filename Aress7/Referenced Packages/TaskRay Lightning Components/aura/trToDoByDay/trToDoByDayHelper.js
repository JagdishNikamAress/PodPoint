({
  groupByTaskId: function(arrayToGroup) {
    var returnObj = {};
    if (arrayToGroup) {
      arrayToGroup.forEach(function(todoItemObj) {
        var isInterview = todoItemObj.TASKRAY__trFlowUniqueName__c
          ? true
          : false;
        var isChecklistItem = todoItemObj.TASKRAY__Project_Task__c
          ? true
          : false;
        var taskId = isChecklistItem
          ? todoItemObj.TASKRAY__Project_Task__c
          : isInterview ? 'interview-' + todoItemObj.Id : todoItemObj.Id;
        if (!returnObj[taskId]) {
          returnObj[taskId] = [];
        }
        returnObj[taskId].push(todoItemObj);
      });
    }
    return returnObj;
  },
  fetchTodoItems: function(component, event, helper) {
    helper.getLocaleDateString(component, event, helper);
    var action = component.get('c.todoItemsForDate');
    if (component.get('v.dateToDisplay')) {
      action.setParams({
        dateStr: component.get('v.dateToDisplay')
      });
    }
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        helper.organizeToDoResponse(
          response.getReturnValue(),
          component,
          helper
        );
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  getLocaleDateString: function(component, event, helper) {
    var action = component.get('c.getLocalizedDateString');
    if (component.get('v.dateToDisplay')) {
      action.setParams({
        dateStr: component.get('v.dateToDisplay')
      });
    }
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        component.set('v.localizedDateStr', response.getReturnValue());
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  completeTodoItem: function(todoItemId, component, helper, failCallback) {
    var action = component.get('c.completeTodoItem');
    action.setParams({
      todoItemId: todoItemId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        helper.organizeToDoResponse(
          response.getReturnValue(),
          component,
          helper
        );
        var appEvent = $A.get('e.TASKRAY_LTNG:trExternalChange');
        appEvent.fire();
      } else {
        if (failCallback) {
          $A.enqueueAction(failCallback);
        }
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  },
  organizeToDoResponse: function(returnValue, component, helper) {
    function sortSObjectItems(a, b) {
      var aIsChecklistItem = typeof a.TASKRAY__Project_Task__c !== 'undefined'
        ? true
        : false;
      var bIsChecklistItem = typeof b.TASKRAY__Project_Task__c !== 'undefined'
        ? true
        : false;

      var aIsTaskFlow = typeof a.TASKRAY__trTask__r !== 'undefined'
        ? true
        : false;
      var bIsTaskFlow = typeof b.TASKRAY__trTask__r !== 'undefined'
        ? true
        : false;

      var aIsProjectFlow = typeof a.TASKRAY__trProject__r !== 'undefined'
        ? true
        : false;
      var bIsProjectFlow = typeof b.TASKRAY__trProject__r !== 'undefined'
        ? true
        : false;

      var aSortName = aIsChecklistItem
        ? a.TASKRAY__Project_Task__r.Name
        : aIsTaskFlow
            ? a.TASKRAY__trTask__r.Name
            : aIsProjectFlow ? a.TASKRAY__trProject__r.Name : a.Name;
      var bSortName = bIsChecklistItem
        ? b.TASKRAY__Project_Task__r.Name
        : bIsTaskFlow
            ? b.TASKRAY__trTask__r.Name
            : bIsProjectFlow ? b.TASKRAY__trProject__r.Name : b.Name;
      return aSortName.localeCompare(bSortName);
    }
    function normalizeViewInfo(todoItemObj) {
      var isChecklistItem = todoItemObj.TASKRAY__Project_Task__c ? true : false;
      var projectName = '';
      var projectId;
      var taskGroupName;
      if (
        isChecklistItem &&
        todoItemObj.TASKRAY__Project_Task__r.TASKRAY__Project__r
      ) {
        projectName =
          todoItemObj.TASKRAY__Project_Task__r.TASKRAY__Project__r.Name;
        projectId = todoItemObj.TASKRAY__Project_Task__r.TASKRAY__Project__r.Id;
      } else {
        if (todoItemObj.TASKRAY__Project__r) {
          projectName = todoItemObj.TASKRAY__Project__r.Name;
          projectId = todoItemObj.TASKRAY__Project__r.Id;
        }
      }
      if (
        isChecklistItem &&
        todoItemObj.TASKRAY__Project_Task__r.TASKRAY__trTaskGroup__r
      ) {
        taskGroupName =
          todoItemObj.TASKRAY__Project_Task__r.TASKRAY__trTaskGroup__r.Name;
      } else {
        taskGroupName = todoItemObj.TASKRAY__trTaskGroup__r
          ? todoItemObj.TASKRAY__trTaskGroup__r.Name
          : null;
      }
      var taskName = isChecklistItem && todoItemObj.TASKRAY__Project_Task__r
        ? todoItemObj.TASKRAY__Project_Task__r.Name
        : todoItemObj.Name;
      var taskId = isChecklistItem && todoItemObj.TASKRAY__Project_Task__r
        ? todoItemObj.TASKRAY__Project_Task__r.Id
        : todoItemObj.Id;
      var viewObj = {
        taskName: taskName,
        taskId: taskId,
        taskGroupName: taskGroupName,
        projectName: projectName,
        projectId: projectId,
        isChecklistItem: isChecklistItem
      };
      if (todoItemObj.TASKRAY__trFlowUniqueName__c) {
        viewObj = todoItemObj;
      }
      todoItemObj.viewObj = viewObj;
    }
    function organizeChecklists(todoItemsByTaskId) {
      var taskObjArray = [];
      for (var taskId in todoItemsByTaskId) {
        if (taskId.indexOf('interview-') === 0) {
          taskObjArray.push(todoItemsByTaskId[taskId][0]);
        } else {
          var itemArray = todoItemsByTaskId[taskId];
          var taskInfo = {
            taskId: '',
            taskName: '',
            projectName: '',
            projectId: '',
            hasChecklistItems: false,
            taskObj: {},
            checklists: [],
            taskGroupName: null,
            showTaskCheckbox: false
          };
          itemArray.forEach(function(todoItem, index) {
            taskInfo.taskName = todoItem.viewObj.taskName;
            taskInfo.taskId = todoItem.viewObj.taskId;
            taskInfo.projectName = todoItem.viewObj.projectName;
            taskInfo.projectId = todoItem.viewObj.projectId;
            taskInfo.taskGroupName = todoItem.viewObj.taskGroupName;
            if (todoItem.viewObj.isChecklistItem === true) {
              var checklistId = todoItem.TASKRAY__trChecklistGroup__r
                ? todoItem.TASKRAY__trChecklistGroup__r.Id
                : 'Unassigned';
              var checklistName = todoItem.TASKRAY__trChecklistGroup__r
                ? todoItem.TASKRAY__trChecklistGroup__r.Name
                : 'Unassigned';
              var indexOfChecklist = null;
              taskInfo.checklists.forEach(function(checklistObj, index) {
                if (checklistObj.checklistId === checklistId) {
                  indexOfChecklist = index;
                }
              });

              if (indexOfChecklist === null) {
                var checklistObj = {
                  checklistId: checklistId,
                  checklistName: checklistName,
                  checklistItems: [todoItem]
                };
                taskInfo.checklists.push(checklistObj);
              } else {
                taskInfo.checklists[indexOfChecklist].checklistItems.push(
                  todoItem
                );
              }
              taskInfo.hasChecklistItems = true;
            } else {
              taskInfo.taskObj = todoItem;
              taskInfo.showTaskCheckbox = true;
            }
          });
          taskObjArray.push(taskInfo);
        }
      }

      return taskObjArray;
    }
    var sorted = returnValue.sort(sortSObjectItems);
    var itemCount = sorted.length;
    sorted.forEach(function(todoItemObj) {
      normalizeViewInfo(todoItemObj);
    });

    var groupedByTask = this.groupByTaskId(sorted);
    var organized = organizeChecklists(groupedByTask);
    //If this is today's overdue run confetti when complete
    if (
      component.get('v.todoItemCount') > 0 &&
      itemCount === 0 &&
      component.get('v.overdue') === false
    ) {
      helper.runConfetti(component, helper);
    }

    if (itemCount === 0 && component.get('v.overdue') === false) {
      component.set(
        'v.noItemsMessage',
        $A.get('$Label.taskray_ltng.trToDoByDay_NothingDueToday')
      );
    }

    //If this is an overdue todo, remove it
    if (
      component.get('v.todoItemCount') > 0 &&
      itemCount === 0 &&
      component.get('v.overdue') === true
    ) {
      var action = component.get('v.refetchOverdueDates');
      if (action) {
        $A.enqueueAction(action);
      }
      return;
    }
    component.set('v.todoItems', organized);
    component.set('v.todoItemCount', itemCount);
  },
  runConfetti: function(component) {
    var action = component.get('v.runConfetti');
    if (action) {
      $A.enqueueAction(action);
    }
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