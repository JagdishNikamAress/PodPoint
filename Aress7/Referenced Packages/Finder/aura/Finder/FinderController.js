({
	init: function(component, event, helper) {
		helper.init(component);
	},
    query: function(cmp, event, helper) {
        helper.query(cmp);
    },
	eventCalled: function(component, event, helper) {
        // Respond to the event to navigate to the record in SF1
        var sObjectEvent = $A.get("e.force:navigateToSObject");
        if(sObjectEvent) {
            sObjectEvent.setParams({
                "recordId": event.getParam("id"),
                "slideDevName": "detail"
            });
            sObjectEvent.fire();
        }
    }
})