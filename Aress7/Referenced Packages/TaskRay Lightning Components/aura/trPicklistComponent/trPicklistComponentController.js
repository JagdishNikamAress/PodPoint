({
	doInit: function(component, event, helper) {
		var addDropdownHeightLimit = component.get('v.LimitDropdownHeight');
		if (addDropdownHeightLimit === true) {
			var componentForDropdownHeight = component.find(
				'addClassHereForDropdownHeight'
			);
			$A.util.addClass(
				componentForDropdownHeight,
				'slds-limit-dropdown-height'
			);
		}
	},
	toggleMenuOpen: function(component, event, helper) {
		component.set('v.menuOpen', !component.get('v.menuOpen'));
	},
	changeTaskGroup: function(component, event, helper) {
		var targetId = event.target.getAttribute('data-clickedId');
		var toggleAutoFollow = component.getEvent('genericEvent');
		toggleAutoFollow.setParams({
			actionType: 'changeTaskGroup',
			payload: {
				targetId: targetId
			}
		});
		toggleAutoFollow.fire();
	}
});