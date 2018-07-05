({
  doInit: function(component, event, helper) {
    $A.createComponent('ui:outputText', { value: '' }, function(
      emptyComponent
    ) {
      //Add the new button to the body array
      if (component.isValid()) {
        var body = component.get('v.body');
        body.push(emptyComponent);
        component.set('v.body', body);
      }
    });

    var action = component.get('c.getTemplateProjects');
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        // success with records
        if (response.getReturnValue().length > 0) {
          var projects = response
            .getReturnValue()
            .sort(function(projectA, projectB) {
              if (projectA.Name < projectB.Name) {
                return -1;
              }
              if (projectA.Name > projectB.Name) {
                return 1;
              }
              if (projectA.Name > projectB.Name) {
                return 0;
              }
            });
          component.set('v.projects', response.getReturnValue());
          var opts = [{ class: '', label: 'Select template', value: null }];
          for (var x = 0; x < response.getReturnValue().length; x++) {
            opts.push({
              class: '',
              label: response.getReturnValue()[x].Name,
              value: response.getReturnValue()[x].Id
            });
          }
          component.find('InputSelectDynamic').set('v.options', opts);
        }
        if (response.getReturnValue().length === 0) {
          component.set('v.projects', []);
        }
      } else {
        helper.popErrorMessage(component, action);
      }
    });
    $A.enqueueAction(action);
    helper.setDefaultDate(component);
  },
  setProjectToClone: function(component, event, helper) {
    //when I select a new project, if I have milestoneinfo saved, I need to refresh that
    if (component.get('v.firstLastOrMilestoneOption') == 'milestoneDate') {
      helper.resetMilestoneInfo(component);
    }
    var dropdownMenuOption = component.find('InputSelectDynamic');
    if (dropdownMenuOption.get('v.value')) {
      component.set('v.selectedProjectId', dropdownMenuOption.get('v.value'));
      if (component.get('v.firstLastOrMilestoneOption') == 'milestoneDate') {
        helper.setMilestoneDropdown(component, event, helper);
      }
      helper.setCreateDisabled(component, event, helper);
    } else {
      component.set('v.selectedProjectId', null);
      //no project selected means clonebutton is disabled
      helper.setCreateDisabled(component, event, helper);
      if (component.get('v.firstLastOrMilestoneOption') == 'milestoneDate') {
        component.set('v.projectHasNoMilestonesError', true);
      }
    }
  },
  setMilestoneForCloneDate: function(component, event, helper) {
    var dropdownMenuOption = component.find('InputSelectMilestones');
    if (dropdownMenuOption.get('v.value') !== null) {
      //is there a start date on this milestone?
      //find the index of this milestone in list of milestones
      var milestoneIndex = component
        .get('v.currentProjectMilestones')
        .findIndex(milestone => {
          return milestone.Id == dropdownMenuOption.get('v.value');
        });

      //if there is no milestone at this index (ie, the title pill for dropdown)
      if (milestoneIndex < 0) {
        component.set('v.clonedWithNoMilestoneError', true);
      } else {
        //we do have a milestone selected
        //take away the error if we need to
        if (component.get('v.clonedWithNoMilestoneError') === true) {
          component.set('v.clonedWithNoMilestoneError', false);
        }
        //check if this milestone has a startdate
        if (
          component.get('v.currentProjectMilestones')[milestoneIndex]
            .TASKRAY__trStartDate__c
        ) {
          component.set(
            'v.selectedMilestoneId',
            dropdownMenuOption.get('v.value')
          );
          //if this milestone has startdate, erase any previous error
          if (component.get('v.selectedMilestoneHasNoDates') === true) {
            component.set('v.selectedMilestoneHasNoDates', false);
          }
        } else {
          //if it does not have a start date, then we have an error situation
          component.set('v.selectedMilestoneHasNoDates', true);
        }
      }
    } else {
      component.set('v.clonedWithNoMilestoneError', true);
    }
    helper.setCreateDisabled(component, event, helper);
  },
  navigateToProject: function(component, event, helper) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      projectId: component.get('v.projectObj').project.Id
    });
    navigateToTaskRay.fire();
  },
  setFirstTaskDate: function(component, event, helper) {
    //we aren't basing off of a milestone, so lets reset that info if necessary
    if (component.get('v.firstLastOrMilestoneOption') == 'milestoneDate') {
      helper.resetMilestoneInfo(component);
    }
    component.set(
      'v.firstLastOrMilestoneOption',
      event.currentTarget.dataset.option
    );
  },
  setLastTaskDate: function(component, event, helper) {
    //we aren't basing off of a milestone, so lets reset that info if necessary
    if (component.get('v.firstLastOrMilestoneOption') == 'milestoneDate') {
      helper.resetMilestoneInfo(component);
    }
    component.set(
      'v.firstLastOrMilestoneOption',
      event.currentTarget.dataset.option
    );
  },
  setMilestoneTaskOption: function(component, event, helper) {
    component.set(
      'v.firstLastOrMilestoneOption',
      event.currentTarget.dataset.option
    );
    if (component.get('v.selectedProjectId')) {
      helper.setMilestoneDropdown(component, event, helper);
    } else {
      component.set('v.projectHasNoMilestonesError', true);
    }
    helper.setCreateDisabled(component, event, helper);
  },
  toggleProjectMenu: function(component) {
    var projectDropdownButton = component.find('projectDropdownButton');
    if (component.get('v.projectDropdownOpen') === true) {
      $A.util.addClass(projectDropdownButton, 'slds-is-open');
    } else {
      $A.util.removeClass(projectDropdownButton, 'slds-is-open');
    }
    component.set(
      'v.projectDropdownOpen',
      !component.get('v.projectDropdownOpen')
    );
  },
  onNameInputChange: function(component, event, helper) {
    helper.setCreateDisabled(component, event, helper);
  },
  cloneProject: function(component, event, helper) {
    var selectedProjectId = component.get('v.selectedProjectId');
    var cloneDatePicker = component.find('CloneDatePicker');
    var newProjectName = component.find('InputText');
    var projects = component.get('v.projects');
    var dateForClone;
    /*  
      2 errors to handle and return from
        1 - there is no date, but endDate/startdate/milestonedat are chose
        2 - its milestonedate but no milestone is chosen
    */
    var returnFromError = false;
    if (
      !cloneDatePicker.get('v.value') &&
      component.get('v.firstLastOrMilestoneOption') != null
    ) {
      component.set('v.showNoDateInputError', true);
      returnFromError = true;
    } else {
      component.set('v.showNoDateInputError', false);
    }

    if (
      component.get('v.firstLastOrMilestoneOption') == 'milestoneDate' &&
      !component.get('v.selectedMilestoneId')
    ) {
      component.set('v.clonedWithNoMilestoneError', true);
      returnFromError = true;
    } else {
      component.set('v.clonedWithNoMilestoneError', false);
    }
    //need this incase both error conditions exist
    if (returnFromError === true) {
      return;
    }

    if (
      typeof newProjectName.get('v.value') !== 'undefined' &&
      selectedProjectId !== null
    ) {
      component.set('v.showSpinner', true);
      //where should this be?
      var params = {
        newName: newProjectName.get('v.value'),
        baseProjectId: selectedProjectId
      };
      for (var x = 0; x < projects.length; x++) {
        if (projects[x].Id === selectedProjectId) {
          if (component.get('v.firstLastOrMilestoneOption') === 'startDate') {
            dateForClone = cloneDatePicker.get('v.value');
            params['useStartEndOrMilestoneDate'] = component.get(
              'v.firstLastOrMilestoneOption'
            );
            params['dateForClone'] = cloneDatePicker.get('v.value');
          } else if (
            component.get('v.firstLastOrMilestoneOption') === 'endDate'
          ) {
            params['useStartEndOrMilestoneDate'] = component.get(
              'v.firstLastOrMilestoneOption'
            );
            params['dateForClone'] = cloneDatePicker.get('v.value');
          } else if (
            component.get('v.firstLastOrMilestoneOption') === 'milestoneDate'
          ) {
            params['milestoneId'] = component.get('v.selectedMilestoneId');
            params['dateForClone'] = cloneDatePicker.get('v.value');
            params['useStartEndOrMilestoneDate'] = component.get(
              'v.firstLastOrMilestoneOption'
            );
          } else {
            params['useStartEndOrMilestoneDate'] = '';
            params['dateForClone'] = 'null';
          }
        }
      }
      if (component.get('v.createLookupToCurrentRecordId') === true) {
        params['createLookupToRecordId'] = true;
        params['recordIdForLookup'] = component.get('v.recordId')
          ? component.get('v.recordId')
          : null;
      }
      var action = component.get('c.cloneProjectFromLightning');
      action.setParams(params);
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === 'SUCCESS') {
          component.set('v.createdProjectUrl', '/' + response.getReturnValue());
          component.set('v.createdProjectId', response.getReturnValue());
          component.set('v.showNewProjectLink', true);
          component.set('v.showSpinner', false);
          window.setTimeout(
            $A.getCallback(function() {
              component.set('v.showNewProjectLink', false);
            }),
            20000
          );

          /*
            need to do a bit of reseting after a successfull clone
          */
          document.getElementById('startDateRadioButton').checked = false;
          document.getElementById('endDateRadioButton').checked = false;
          document.getElementById('milestoneDateRadioButton').checked = false;
          cloneDatePicker.set('v.value', '');
          newProjectName.set('v.value', '');
          var dropdownMenuOption = component.find('InputSelectDynamic');
          dropdownMenuOption.set('v.value', 'Select a Template:');
          component.set('v.selectedProjectId', null);
          component.set('v.firstLastOrMilestoneOption', null);
          component.set('v.disableCloneButton', true);
          //could also keep this at the date that we just chose
          helper.setDefaultDate(component);
          helper.resetMilestoneInfo(component);
        } else {
          component.set('v.showSpinner', false);
          helper.popErrorMessage(component, action);
        }
      });
      $A.enqueueAction(action);
    } else {
      $A.createComponent(
        'TASKRAY_LTNG:trErrorComponent',
        {
          errorTitle: 'All cloned projects need a name and a starting project.'
        },
        function(errorMessageComponent) {
          //Add the new button to the body array
          if (component.isValid()) {
            var errorDiv = component.find('errorContainer');
            errorDiv.set('v.body', errorMessageComponent);
          }
        }
      );
    }
  },
  navigateToProject: function(component) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      projectId: component.get('v.createdProjectId')
    });
    navigateToTaskRay.fire();
  },
  showSpinner: function(component) {
    var spinner = component.find('spinner');
    var evt = spinner.get('e.toggle');
    evt.setParams({ isVisible: true });
    evt.fire();
  },
  hideSpinner: function(component) {
    var spinner = component.find('spinner');
    var evt = spinner.get('e.toggle');
    evt.setParams({ isVisible: false });
    evt.fire();
  }
});