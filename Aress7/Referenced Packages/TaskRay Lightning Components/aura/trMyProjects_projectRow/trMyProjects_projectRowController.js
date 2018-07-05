({
  doInit: function(component, event, helper) {
    var completionPercentage = component.get(
      'v.projectObj.completionPercentage'
    );
    var imgURL =
      $A.get('$Resource.TASKRAY_LTNG__trltngresources') +
      '/progress/trprogressnotext' +
      completionPercentage +
      'pct.png';
    component.set('v.completionImgURL', imgURL);
  },
  toggleExpanded: function(component, event, helper) {
    var currentExpandedStatus = component.get('v.expanded');
    var toggleExpandEvent = component.getEvent('genericEvent');
    toggleExpandEvent.setParams({
      actionType: 'expandProject',
      payload: {
        Id: currentExpandedStatus
          ? null
          : component.get('v.projectObj').project.Id
      }
    });
    toggleExpandEvent.fire();
  },
  toggleAutoFollowForProject: function(component, event, helper) {
    var toggleAutoFollow = component.getEvent('genericEvent');
    toggleAutoFollow.setParams({
      actionType: 'toggleAutoFollowForProject',
      payload: {
        Id: component.get('v.projectObj').project.Id
      }
    });
    toggleAutoFollow.fire();
  },
  navigateToOwner: function(component, event, helper) {
    var ownerId = component.get('v.projectObj').owner.Id;
    if (ownerId.indexOf('00G') === 0) {
      return;
    }
    var navEvt = $A.get('e.force:navigateToSObject');
    navEvt.setParams({
      recordId: ownerId
    });
    navEvt.fire();
  },
  navigateToProject: function(component, event, helper) {
    var navigateToTaskRay = $A.get('e.TASKRAY_LTNG:trNavigateToTaskRayEvent');
    navigateToTaskRay.setParams({
      projectId: component.get('v.projectObj').project.Id
    });
    navigateToTaskRay.fire();
  }
});