({
	onInit: function(component, event, helper){
		var action = component.get('c.checkIfOauthed');
		action.setCallback(this, function(res){

			if(res.getState() === 'SUCCESS'){
				var responseObject = JSON.parse(res.getReturnValue());
				if (responseObject.error){
					
					component.set('v.userIsOauthed', false);
					component.set('v.isLoading', false);
				} else {
					component.set('v.userIsOauthed', true);

					helper.checkIfConnectedToChannel(component, event, helper);
				}
			}
		})
		$A.enqueueAction(action);
        
        window.addEventListener('message', refreshComponent, false);

        function refreshComponent(event) {
            
            $A.enqueueAction(action);
        }
	},
	initializeOauth: function(component, event, helper) {
        var isSandbox = window.location.hostname.indexOf('.cs') !== -1
		var slackOauth = $A.get('e.force:navigateToURL');
        var oauthUrl = 'https://slack.com/oauth/authorize?client_id=2147483693.81309486848&scope=channels:read%20channels:write%20chat:write:bot%20team:read&redirect_uri=';

        oauthUrl += isSandbox ? 'https://test.salesforce.com' : 'https://login.salesforce.com';
        oauthUrl += '/apex/slack__Setup';
        oauthUrl += '&state=' + window.location.origin;
     	
        if(slackOauth){
			slackOauth.setParams({
				url: oauthUrl
			});
			slackOauth.fire();
		} else {	
			window.open(oauthUrl);
		}  

	},
	handleInput: function(component, event, helper) {
		var postButton = component.find('post-button').getElement();
        var message = component.find('message').getElement();

        if (message.value.length) {
            postButton.removeAttribute('disabled');
        } else {
            postButton.setAttribute('disabled', 'disabled');
        }
	},
	clickOpenChannelsModal: function(component,event,helper) {
		var modal = component.find('channelModal').getElement();
		var backdrop = component.find('channelBackdrop').getElement();
        var channelInput = component.find('channelInput').getElement();
		var allChannels = component.get('v.channelsList');
        var createButton = component.find('createButton').getElement();
		var saveButton = component.find('saveButton').getElement();
        
        $A.util.addClass(createButton, 'slds-hide');
        $A.util.removeClass(saveButton, 'slds-hide');
        saveButton.setAttribute('disabled', 'true');
        
        component.set('v.isInCreateMode', false);
		component.set('v.channelSelection', allChannels[0].id);
        component.find('inputSelectCreateMode').set('v.value', 'none');
        
        $A.util.addClass(channelInput, 'slds-hide');
        
        helper.openModal(modal, backdrop);
	},
	clickSave: function(component,event,helper){
		var modal = component.find('channelModal').getElement();
		var backdrop = component.find('channelBackdrop').getElement();
		var recordId = component.get('v.recordId');

		var channelSelection = component.get('v.channelSelection');

		var action = component.get('c.linkChannel');

		action.setParams({
			slackChannelId: channelSelection,
			recordId: recordId
		});

		action.setCallback(this, function(res){
			if(res.getState() === "SUCCESS"){
				
				var returnValue = JSON.parse(res.getReturnValue());
				if(returnValue.error){

					
				} else {

					helper.checkIfConnectedToChannel(component,event,helper);
				}
			}
		});
		$A.enqueueAction(action);
        
        helper.closeModal(modal, backdrop);
	},

	clickCreate: function(component,event,helper){
		var recordId = component.get('v.recordId');
		var modal = component.find('channelModal').getElement();
		var backdrop = component.find('channelBackdrop').getElement();
		var createModalPlaceholder = component.get('v.createModalPlaceholder');
		var userInput = component.find('createModalInput').getElement().value;
		var channelName;
        
        channelName = userInput;

		var action = component.get('c.createNewChannel');

		action.setParams({
			recordId: recordId,
			channelName: channelName
		});

		action.setCallback(this, function(res){

			if (res.getState() === 'SUCCESS'){
				
				var returnValue = JSON.parse(res.getReturnValue());

				if(returnValue.error === 'name_taken') {
					component.set('v.channelNameTaken', true);
				} else {
					component.set('v.channelNameTaken', false);
				}
				helper.checkIfConnectedToChannel(component,event,helper);
			}

			var channelTaken = component.get('v.channelNameTaken');
			if(channelTaken === false){
                helper.closeModal(modal, backdrop);
			}
		});
		$A.enqueueAction(action);

	},
	selectInput: function(component,event,helper){
		var channelSelection = component.find('inputSelectCreateMode').get('v.value');
        var channelInput = component.find('channelInput').getElement();
        var createInput = component.find('createModalInput').getElement();
		var saveButton = component.find('saveButton').getElement();
        var createButton = component.find('createButton').getElement();
        
        saveButton.removeAttribute('disabled');

        if(channelSelection === 'createNew'){
            component.set('v.channelNameTaken', false);
        	component.set('v.isInCreateMode', true);
            $A.util.removeClass(channelInput, 'slds-hide');
            createButton.removeAttribute('disabled');
            
            var interval = window.setInterval($A.getCallback(function() {
                var input = component.find('createModalInput');

                if (!$A.util.hasClass(input, 'slds-hide')) {
                    input.getElement().focus();
                    $A.util.removeClass(createButton, 'slds-hide');
            		$A.util.addClass(saveButton, 'slds-hide');
                    window.clearInterval(interval);
                }

            }), 100);

			createInput.value = component.get('v.createModalPlaceholder');
		} else {
			component.set('v.isInCreateMode', false);
            $A.util.addClass(channelInput, 'slds-hide');
            $A.util.addClass(createButton, 'slds-hide');
            $A.util.removeClass(saveButton, 'slds-hide');
			component.set('v.channelSelection', channelSelection);
		}
	},
	clickPost: function(component,event,helper){
		component.set('v.isLoading', true);
		var postButton = component.find('post-button').getElement();
		var textArea = component.find('message').getElement();
		var slackChannelInfo = component.get('v.slackChannelInfo');
		var textValue = textArea.value;
		var channelId = slackChannelInfo.id;
		var includeLink = component.find('includeLink').getElement();
		var linkValue = null;
		if(includeLink.checked){
			linkValue = window.location.href;
		}
		var action = component.get('c.postToSlack');
		action.setParams({
			text: textValue,
			channelId: channelId,
			link: linkValue
		});

		action.setCallback(this, function(res){
			if (res.getState() === "SUCCESS"){
				textArea.value = '';
				postButton.setAttribute('disabled', 'disabled');
				includeLink.checked = false;
				var showToast = $A.get('e.force:showToast');
				showToast.setParams({
					title: 'Message Posted!',
					message: 'Successfully posted to Slack',
					type: 'success'
				});
				showToast.fire();
				
			}
			component.set('v.isLoading', false);
		});

		$A.enqueueAction(action);
	},
	clickGoToSlack: function(component,event,helper){
		var slackTeamInfo = component.get('v.slackTeamInfo');
		var slackChannelInfo = component.get('v.slackChannelInfo');

		var urlNavigate = $A.get('e.force:navigateToURL');
		if (urlNavigate){
			urlNavigate.setParams({
				"url": "https://" + slackTeamInfo.domain + ".slack.com/messages/" + slackChannelInfo.name + "/"
			});
			urlNavigate.fire();
		} else {
            window.open("https://" + slackTeamInfo.domain + ".slack.com/messages/" + slackChannelInfo.name + "/");
		}

	},
    clickUnlinkChannel: function(component, event, helper) {
        var modal = component.find('unlinkModal').getElement();
        var backdrop = component.find('unlinkBackdrop').getElement();
        
        helper.openModal(modal, backdrop);
    },
    clickCancelOrCloseUnlinkModal: function(component, event, helper) {
        var modal = component.find('unlinkModal').getElement();
        var backdrop = component.find('unlinkBackdrop').getElement();
        
        helper.closeModal(modal, backdrop);
    },
	clickConfirmUnlinkChannel: function(component,event,helper){
        var modal = component.find('unlinkModal').getElement();
        var backdrop = component.find('unlinkBackdrop').getElement();
        
        helper.closeModal(modal, backdrop);
        
		component.set('v.isLoading', true);
		var recordId = component.get('v.recordId');
		var slackChannelInfo = component.get('v.slackChannelInfo');
		var slackChannelId = slackChannelInfo.id;

		var action = component.get('c.unlinkChannel');
		action.setParams({
			recordId: recordId,
			slackChannelId: slackChannelId
		});

		action.setCallback(this,function(res){
			if (res.getState() === "SUCCESS"){
				helper.checkIfConnectedToChannel(component,event,helper);
			}
		});

		$A.enqueueAction(action);

	},
	closeCreateModal: function(component, event, helper){
		var modal = component.find('channelModal').getElement();
		var backdrop = component.find('channelBackdrop').getElement();

		helper.closeModal(modal, backdrop);
	},
	clickLearnMore: function(component, event, helper){
		var urlNavigate = $A.get('e.force:navigateToURL');
		if(urlNavigate){
			urlNavigate.setParams({
				"url": "https://get.slack.help/hc/en-us/articles/227838227"
			});
			urlNavigate.fire();
		} else {
			window.open("https://get.slack.help/hc/en-us/articles/227838227");
		}
	},
    checkIfEmpty: function(component, event, helper) {
		var userInput = component.find('createModalInput').getElement().value;
        var createButton = component.find('createButton').getElement();
        
        if (userInput == '') {
            createButton.setAttribute('disabled', 'true');
        } else {
            createButton.removeAttribute('disabled');
        }
    }
})