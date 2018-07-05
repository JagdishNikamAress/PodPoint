({
	handleChange : function(component, event, helper) {
        console.log(event);
        console.log(event.target.checked);
        component.set("v.toggleField", event.target.checked);
	}
})