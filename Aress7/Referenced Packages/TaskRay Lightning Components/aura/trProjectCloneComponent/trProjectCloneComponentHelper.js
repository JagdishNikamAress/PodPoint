({
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
      : null;
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
  resetMilestoneInfo: function(component) {
    component.set('v.currentProjectMilestones', []);
    component.set('v.showMilestoneDropdown', false);
    component.set('v.projectHasNoMilestonesError', false);
    component.set('v.selectedMilestoneHasNoDates', false);
    component.set('v.showNoDateInputError', false);
    component.set('v.clonedWithNoMilestoneError', false);
    component.set('v.selectedMilestoneId', null);
  },
  setDefaultDate: function(component) {
    var today = new Date();
    var day = today.getDate();
    var month = today.getMonth() + 1; //January is 0!
    var year = today.getFullYear();
    component.set('v.cloneDefaultDate', year + '-' + month + '-' + day);
  },
  setMilestoneDropdown: function(component, action, helper) {
    component.set('v.showSpinner', true);
    var action = component.get('c.getMilestonesForProject');
    action.setParams({
      projectId: component.get('v.selectedProjectId')
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === 'SUCCESS') {
        if (response.getReturnValue().length > 0) {
          var milestones = response
            .getReturnValue()
            .sort(function(milestoneA, milestoneB) {
              if (milestoneA.Name < milestoneB.Name) {
                return -1;
              }
              if (milestoneA.Name > milestoneB.Name) {
                return 1;
              }
              if (milestoneA.Name > milestoneB.Name) {
                return 0;
              }
            });
          var opts = [{ class: '', label: 'Select milestone', value: null }];
          /*
            would love to do something here to add a flag to those with no dates
            but cant pass an object as a value? if I could set the whole milestone 
            if I could set the whole milestone as value in opt, 
            I could avoid iterating milestones when I select one to see if it has dates 
          */
          for (var x = 0; x < milestones.length; x++) {
            opts.push({
              class: '',
              label: milestones[x].Name,
              value: milestones[x].Id
            });
          }
          component.find('InputSelectMilestones').set('v.options', opts);

          component.set('v.currentProjectMilestones', milestones);
          component.set('v.projectHasNoMilestonesError', false);
          component.set('v.showMilestoneDropdown', true);
        } else {
          component.set('v.currentProjectMilestones', []);
          component.set('v.showMilestoneDropdown', false);
          component.set('v.clonedWithNoMilestoneError', false);
          component.set('v.projectHasNoMilestonesError', true);
        }
      } else {
        helper.popErrorMessage(component, action);
      }
      component.set('v.showSpinner', false);
    });
    $A.enqueueAction(action);
  },
  setCreateDisabled: function(component, event, helper) {
    var selectedProjectId = component.get('v.selectedProjectId');
    var projectHasNoMilestonesError = component.get(
      'v.projectHasNoMilestonesError'
    );
    var clonedWithNoMilestoneError = component.get(
      'v.clonedWithNoMilestoneError'
    );
    var selectedMilestoneHasNoDates = component.get(
      'v.selectedMilestoneHasNoDates'
    );
    var showNoDateInputError = component.get('v.showNoDateInputError');
    var firstLastOrMilestoneOption = component.get(
      'v.firstLastOrMilestoneOption'
    );
    var newName = component.get('v.newName');
    var createDisabled = false;
    if (
      !selectedProjectId ||
      projectHasNoMilestonesError ||
      clonedWithNoMilestoneError ||
      selectedMilestoneHasNoDates ||
      showNoDateInputError ||
      !newName
    ) {
      createDisabled = true;
    }
    component.set('v.disableCloneButton', createDisabled);
  }
});