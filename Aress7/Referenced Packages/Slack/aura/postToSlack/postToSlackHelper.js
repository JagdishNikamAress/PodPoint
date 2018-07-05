({
	checkIfConnectedToChannel: function(component, event, helper) {
		var action = component.get("c.checkIfConnectedToChannel");
		var recordId = component.get('v.recordId');

		action.setParams({
			recordId: recordId

		});
		
		action.setCallback(this, function(res){
			if(res.getState() === 'SUCCESS'){
				var returnValue = JSON.parse(res.getReturnValue());

				if(returnValue.slackChannelInfo === 'No Channel Selected'){

					component.set('v.slackChannelInfo', null);
					component.set('v.recordName', returnValue.recordInfo.Name);
					var createModalPlaceholder = returnValue.recordInfo.Name.replace(/[^0-9a-zA-Z]+/g,'-').toLowerCase().substring(0,21);
					component.set('v.createModalPlaceholder', createModalPlaceholder);
					this.slackChannelCall(component);
				} else {
					var slackChannelInfo = JSON.parse(returnValue.slackChannelInfo);
					var slackTeamInfo = JSON.parse(returnValue.slackTeamInfo);
					if (slackChannelInfo.error === 'channel_not_found' || slackChannelInfo.channel.is_archived === true){
						
						component.set('v.errorMessage', slackChannelInfo.error);
						var  action2 = component.get("c.unlinkChannel");
						action2.setParams({
							recordId: recordId,
							slackChannelId: 'none'
						});
						
						action2.setCallback(this, function(res2){
							if(res2.getState() === 'SUCCESS'){
								
								this.checkIfConnectedToChannel(component,event,helper);
							}
						});
						$A.enqueueAction(action2);

					} else {
						component.set('v.slackChannelInfo', slackChannelInfo.channel);
						
						component.set('v.slackTeamInfo', slackTeamInfo.team);
						
						component.set('v.isLoading', false);
					}
				}
			}

		});
		$A.enqueueAction(action);
	},
	slackChannelCall: function(component){

		var channelAction = component.get("c.getSlackChannels");
		channelAction.setCallback(this, function(res){
			if(res.getState() === 'SUCCESS'){
				var returnChannelsList = JSON.parse(res.getReturnValue());
				if (returnChannelsList.error){
					component.set('v.errorMessage', returnChannelsList.error);
				} else {
					component.set('v.channelsList', returnChannelsList.channels.filter(function(c) { return c.is_archived === false; }));
					
					component.set('v.channelSelection', returnChannelsList.channels[0].id);

				}
			}
			component.set('v.isLoading', false);
		});

		$A.enqueueAction(channelAction);
	},
    openModal: function(modal, backdrop) {
		$A.util.removeClass(backdrop, 'slds-hide');
		$A.util.removeClass(modal, 'slds-hide');
        
        setTimeout(function() { // Ensure elements are displayed and rendered before adding classes
            $A.util.addClass(backdrop, 'slds-backdrop--open');
            $A.util.addClass(modal, 'slds-fade-in-open');
        }, 25);
    },
    closeModal: function(modal, backdrop) {
        var hideModalElements = function() {
            $A.util.addClass(backdrop, 'slds-hide');
            $A.util.addClass(modal, 'slds-hide');
        	backdrop.removeEventListener('transitionend', hideModalElements);
        };
        
        backdrop.addEventListener('transitionend', hideModalElements);
        
        $A.util.removeClass(backdrop, 'slds-backdrop--open');
        $A.util.removeClass(modal, 'slds-fade-in-open');
    }
})