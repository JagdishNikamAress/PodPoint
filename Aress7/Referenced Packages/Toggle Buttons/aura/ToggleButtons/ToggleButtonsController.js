({
	handleToggle : function(component, event, helper) { 
		var currentValue = component.get("v.checkboxField");
        var toggleEvent = component.getEvent("toggle");
        component.set("v.checkboxField", !currentValue);
        toggleEvent.setParams({
            "toggleField" : !currentValue
        });
        toggleEvent.fire();
	},    
})