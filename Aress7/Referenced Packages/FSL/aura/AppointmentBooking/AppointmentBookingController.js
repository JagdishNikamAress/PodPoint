({
    doInit : function(component, event, helper) {
        //alert('bbb');
        console.log('init');
        var action = component.get("c.getInitData");
        action.setCallback(this, function(res) {
            var retValue = res.getReturnValue();
            var isCommunitiesVF = component.get("v.isCommunitiesVF");
            var recordId = component.get("v.recordId");

            var pageName = isCommunitiesVF? 'AppointmentBookingCommunitiesVf' : 'AppointmentBookingVf';
            var url = retValue.UrlSuffix.replace('/s', '') + '/apex/' + retValue.PackagePrefix + pageName;
            if (recordId)
                url +=  '?id=' + recordId;
            
            //console.log(url);
            component.set("v.url", url);
        });
        $A.enqueueAction(action);
    }
})