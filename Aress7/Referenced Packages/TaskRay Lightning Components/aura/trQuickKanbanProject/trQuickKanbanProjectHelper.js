({
  initializeDragula: function(component, helper) {
    var allColumns = component.find('draggable');
    var draggableElements = [];
    allColumns.forEach(function(columnComponent) {
      if (columnComponent.getElement()) {
        draggableElements.push(columnComponent.getElement());
      }
    });

    if (draggableElements.length === 0) {
      return;
    }

    if (component.get('v.drake')) {
      //Get the existing containers and see if they are still initted by dragula
      //We can't just always kill the old instance of dragula because that trips another rerender
      //which cause an infinite loop, because we init dragula based upon a rerender :)
      var containers = component.get('v.drake').containers;
      var stillValidContainers = [];
      containers.forEach(function(container) {
        //if the container dom element is not equal to the current dom element
        //it's not valid and we need todestroy and reinit dragula
        var containerId = container.id;
        var elementInDOM = document.getElementById(containerId);
        var isStillValid = container === elementInDOM;
        if (isStillValid) {
          stillValidContainers.push(container);
        }
      });
      if (stillValidContainers.length !== containers.length) {
        var oldDrake = component.get('v.drake');
        oldDrake.destroy();
      } else {
        return;
      }
    }

    var drake = dragula(draggableElements);
    drake.on(
      'drop',
      $A.getCallback(function(el, target, source, sibling) {
        if (
          el === null ||
          target === null ||
          el.id === null ||
          target.id === null ||
          !el ||
          !target ||
          !el.id ||
          !target.id
        ) {
          drake.end();
        } else {
          //get the moved task new info
          var taskId = el.id;
          var newList = target.id;
          var sortOrder = Array.from(el.parentNode.children).indexOf(el);
          var movedTaskNewInfo = {};
          movedTaskNewInfo['taskId'] = taskId;
          movedTaskNewInfo['newList'] = newList;
          movedTaskNewInfo['sortOrder'] = sortOrder;
          helper.handleListChange(movedTaskNewInfo, component, event, helper);
        }
      })
    );
    component.set('v.drake', drake);
  },
  handleListChange: function(movedTaskNewInfo, component, event, helper) {
    var data = component.get('v.currentProjectObject').tasks;
    var dataForServer = [];
    var movedTaskForServer = {
      taskId: movedTaskNewInfo.taskId,
      colName: movedTaskNewInfo.newList,
      sortOrder: movedTaskNewInfo.sortOrder
    };
    dataForServer.push(movedTaskForServer);
    data.forEach(function(thisProjectsTasks) {
      //go through tasks - if the column's name is the same as the one the task moved to, update index of tasks in that column:
      if (
        thisProjectsTasks.statusName.toLowerCase() ===
        movedTaskNewInfo.newList.toLowerCase()
      ) {
        thisProjectsTasks.tasks.forEach(function(task, index) {
          if (task.sortOrder < movedTaskNewInfo.sortOrder) {
            //skip
          } else if (
            task.sortOrder >= movedTaskNewInfo.sortOrder &&
            task.Id !== movedTaskNewInfo.taskId
          ) {
            var taskForServer = {
              taskId: task.Id,
              colName: thisProjectsTasks.statusName,
              sortOrder: index + 1
            };
            dataForServer.push(taskForServer);
          }
        });
      }
    });
    var recordId = component.get('v.recordId');
    var action = component.get('c.handleTaskMove');
    action.setParams({
      itemsToUpdate: JSON.stringify(dataForServer),
      recordId: recordId
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        var appEvent = $A.get('e.TASKRAY_LTNG:trListChangeSuccess');
        appEvent.setParams({ data: response.getReturnValue() }).fire();
      } else {
        this.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
  }
});