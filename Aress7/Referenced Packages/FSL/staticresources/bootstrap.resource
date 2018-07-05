'use strict';

var bootstrap = {};
bootstrap.loadUserSettings = function () {
    Visualforce.remoting.Manager.invokeAction(RemoteActions.IsUserSettingExist, function (setting, ev) {
        if (ev.status) {
            if (ev.result == false) //Create new settings - try to derive localstorage
                {
                    Visualforce.remoting.Manager.invokeAction(RemoteActions.CreateNewUserSettingsLocStorage, localStorage.getItem(sfdcUser + '_serviceExpertLocations'), localStorage.getItem(sfdcUser + '_serviceExpertOrphan'), localStorage.getItem(sfdcUser + '_serviceExpertSettings'), localStorage.getItem(sfdcUser + '_serviceExpertFilters'), function (setting, ev) {
                        if (ev.status) {
                            bootstrap.loadedUserSettings = JSON.parse(ev.result);
                            angular.bootstrap(document.getElementById("serviceExpertApp"), ['serviceExpert']);
                        }
                    }, { buffer: false, escape: false, timeout: 120000 });
                } else //Existing settings - fetch user setting object
                {
                    Visualforce.remoting.Manager.invokeAction(RemoteActions.GetCreateUserSettings, function (setting, ev) {
                        if (ev.status) {
                            bootstrap.loadedUserSettings = JSON.parse(ev.result);
                            angular.bootstrap(document.getElementById("serviceExpertApp"), ['serviceExpert']);
                        } else {
                            bootstrap.handleError(ev);
                        }
                    }, { buffer: false, escape: false, timeout: 120000 });
                }
        } else {
            bootstrap.handleError(ev);
        }
    }, { buffer: false, escape: false, timeout: 120000 });
};

bootstrap.Start = function () {
    bootstrap.UpdatePermissionSets();
};

bootstrap.UpdatePermissionSets = function () {
    Visualforce.remoting.Manager.invokeAction(RemoteActions.updatePermissionSets, function (res, ev) {
        if (res == null || res == undefined) {
            bootstrap.loadUserSettings();
        } else {
            try {
                handleTabSettingAndRecordTypesPermissions(res).then(function () {
                    bootstrap.loadUserSettings();
                });
            } catch (err) {
                console.log(err);
                bootstrap.loadUserSettings();
            }
        }
    });
};

bootstrap.UpdatePermissionSetsBootstrap = function (DocumentName, AppName) {
    Visualforce.remoting.Manager.invokeAction(sharedRemoteActions.updatePermissionSets, function (res, ev) {
        if (res == null || res == undefined) {
            angular.bootstrap(document.getElementById(DocumentName), [AppName]);
        } else {
            try {
                handleTabSettingAndRecordTypesPermissions(res).then(function () {
                    angular.bootstrap(document.getElementById(DocumentName), [AppName]);
                });
            } catch (err) {
                console.log(err);
                angular.bootstrap(document.getElementById(DocumentName), [AppName]);
            }
        }
    });
};

function handleTabSettingAndRecordTypesPermissions(res) {

    var promise = new Promise(function (resolve, reject) {

        var objAdmin = JSON.parse(res['Admin'].replace(/&quot;/g, '"'));
        var objAgent = JSON.parse(res['Agent'].replace(/&quot;/g, '"'));
        var objCommunity = JSON.parse(res['Community'].replace(/&quot;/g, '"'));
        //var objCommunityDispatcher = JSON.parse(res['CommunityDispatcher'].replace(/&quot;/g,'"'));
        var objDispatcher = JSON.parse(res['Dispatcher'].replace(/&quot;/g, '"'));
        var objResource = JSON.parse(res['Resource'].replace(/&quot;/g, '"'));

        Promise.all([createTabAndRecordTypePermission('FSL_Admin', 'FSL Admin', objAdmin.tabSettings, objAdmin.recordTypeVisibilities), createTabAndRecordTypePermission('FSL_Agent', 'FSL Agent', objAgent.tabSettings, objAgent.recordTypeVisibilities), createTabAndRecordTypePermission('FSL_Dispatcher', 'FSL Dispatcher', objDispatcher.tabSettings, objDispatcher.recordTypeVisibilities), createTabAndRecordTypePermission('FSL_Community_Self_Service', 'FSL Self Service', objCommunity.tabSettings, objCommunity.recordTypeVisibilities),
        //createTabAndRecordTypePermission('FSL_Community_Dispatcher','FSL Community Dispatcher',objCommunityDispatcher.tabSettings,objCommunityDispatcher.recordTypeVisibilities),
        createTabAndRecordTypePermission('FSL_Resource', 'FSL Resource', objResource.tabSettings, objResource.recordTypeVisibilities)]).then(function () {
            resolve();
        }, function () {
            resolve();
        });
    });

    return promise;
}

function createTabAndRecordTypePermission(name, label, tabSettings, recordTypeVisibilities) {
    var promise = new Promise(function (resolve, reject) {
        var baseUrl = window.location.origin;
        var settingsTabName = 'Master_Settings';
        var dataStr = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:met="http://soap.sforce.com/2006/04/metadata">' + '<soapenv:Header>' + '<met:SessionHeader>' + '<met:sessionId>' + sessionId + '</met:sessionId>' + '</met:SessionHeader>' + '</soapenv:Header>' + '<soapenv:Body>' + '<met:updateMetadata>' + '<met:metadata xsi:type="met:PermissionSet">' + '<fullName>' + name + '_Permissions' + '</fullName>' + '<label>' + label + ' Permissions' + '</label>';

        for (var i = 0; i < tabSettings.length; i++) {
            dataStr += '<tabSettings>' + '<tab>' + tabSettings[i].tab + '</tab>' + '<visibility>' + tabSettings[i].visibility + '</visibility>' + '</tabSettings>';
        }

        for (var j = 0; j < recordTypeVisibilities.length; j++) {
            dataStr += '<recordTypeVisibilities>' + '<recordType>' + recordTypeVisibilities[j].recordType + '</recordType>' + '<visible>' + recordTypeVisibilities[j].visible + '</visible>' + '</recordTypeVisibilities>';
        }

        dataStr += '</met:metadata>' + '</met:updateMetadata>' + '</soapenv:Body>' + '</soapenv:Envelope>';

        window.$.ajax({
            url: baseUrl + '/services/Soap/m/38.0',
            type: 'POST',
            dataType: "xml",
            data: dataStr,
            beforeSend: function beforeSend(xhr) {
                xhr.setRequestHeader('Content-Type', 'text/xml');
                xhr.setRequestHeader('SOAPAction', '""');
            }
        }).then(function (res, textStatus, jqXHR) {
            resolve();
        }, function (jqXHR, textStatus, errorThrown) {
            console.log('Failed to update permissions on load of VF');
            resolve();
        });
    });
}

bootstrap.handleError = function (ev) {
    var labelsToShowToUser = {
        no_dispatcher_license_found: true,
        Apex_CPU_time_limit_exceeded: true
    };

    var messageInsideLabelsToShow = false;
    for (var label in labelsToShowToUser) {
        if (customLabels[label] == ev.message) messageInsideLabelsToShow = true;
    }

    if (ev.message.toLowerCase().indexOf('dml') != -1) cantLoadGantt(customLabels.no_dispatcher_permissions_found.replace('{0}', '<a href="vf066_settings#page=0&tab=1" target="_blank">').replace('{1}', '</a>'));else if (messageInsideLabelsToShow) cantLoadGantt(ev.message);else cantLoadGantt(customLabels.dispatcher_console_error_loading + '<div class="otherMessage">' + ev.message + '</div>');
};