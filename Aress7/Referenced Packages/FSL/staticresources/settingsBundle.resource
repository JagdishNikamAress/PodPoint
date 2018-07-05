'use strict';

(function () {
    angular.module('SettingsApp', ['Highlight', 'UIDirectives', 'ngNomnoml', 'ui.bootstrap']);
})();
'use strict';

(function () {

    angular.module('SettingsApp').filter('menuFilter', menuFilter);

    function menuFilter() {

        function filter(menuItems, pattern, level) {

            var filteredItems = [];

            if (!pattern || pattern.length < 2) {
                return menuItems;
            }

            menuItems.forEach(function (item) {
                if (item.title.toLowerCase().indexOf(pattern.toLowerCase()) > -1 || level !== 3 && isFound(item.items, pattern)) {
                    item.show = true;
                    filteredItems.push(item);
                }
            });

            return filteredItems;
        }

        function isFound(items, pattern) {

            var found = false;

            items.forEach(function (item) {
                if (item.title.toLowerCase().indexOf(pattern.toLowerCase()) > -1 || item.items && isFound(item.items, pattern)) {
                    found = true;
                    item.show = true;
                }
            });

            return found;
        }

        return filter;
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').controller('settingsCtrl', settingCtrl);

    settingCtrl.$inject = ['dataService', '$timeout', '$scope'];

    function settingCtrl(dataService, $timeout, $scope) {
        var _this = this;

        // menu items, global object with labels
        this.menu = settings.menu;

        // init
        this.searchPattern = null;
        this.selectedItem = settings.menu[0];
        this.selectedItemTab = { name: settings.menu[0].items[0].tabName };

        setDefaultTab.call(this);

        $scope.$on('PermissionsMissing', function (eve, data) {
            if (profile == 'FSL Optimization') {
                data.resolve();
            } else {
                _this.switchPageAndTab(eve, settings.menu[0], settings.menu[0].items[1]);
                data.reject();
            }
        });

        // switch main tab
        this.switchPage = function ($event, item, pageIndex) {
            if ($event.stopPropagation) {
                $event.stopPropagation();
            }

            if (dataService.isDirty()) {
                if (!confirm('You have unsaved changes that will be lost. Are you sure you want to navigate away?')) {
                    return;
                } else {
                    dataService.setOriginal();
                }
            }

            _this.selectedItem = item;
            _this.selectedItemTab.name = item.items[0].tabName;

            var sulamitIndex = location.href.indexOf('#');

            if (sulamitIndex === -1) {
                location.href = location.href + '#page=' + pageIndex + '&tab=0';
            } else {
                location.href = location.href.substr(0, sulamitIndex) + '#page=' + pageIndex + '&tab=0';
            }
        };

        // navigate to sub menu
        this.switchPageAndTab = function ($event, item, subItem, pageIndex, tabIndex, domId) {
            if ($event.stopPropagation) {
                $event.stopPropagation();
            }

            if (dataService.isDirty()) {
                if (!confirm('You have unsaved changes that will be lost. Are you sure you want to navigate away?')) {
                    return;
                } else {
                    dataService.setOriginal();
                }
            }

            _this.selectedItem = item;
            _this.selectedItemTab.name = subItem.tabName;

            var sulamitIndex = location.href.indexOf('#');

            if (sulamitIndex === -1) {
                location.href = location.href + '#page=' + pageIndex + '&tab=' + tabIndex;
            } else {
                location.href = location.href.substr(0, sulamitIndex) + '#page=' + pageIndex + '&tab=' + tabIndex;
            }

            // if (domId) {
            //     $timeout(function() {
            //         $('#SettingsForm').animate({
            //             scrollTop: $("#" + domId).offset().top - 35
            //         }, 300);
            //     }, 150);
            // }
        };

        function setDefaultTab() {
            var _this2 = this;

            var sulamitIndex = location.href.indexOf('#');

            if (sulamitIndex === -1) {
                var page = 0,
                    tab = 0;

                if (profile == 'FSL Optimization') {
                    page = 5;
                }

                location.href = location.href + '#page=' + page + '&tab=' + tab;
                sulamitIndex = location.href.indexOf('#');
            }

            var getParmeters = location.href.substr(sulamitIndex + 1).split('&');

            getParmeters.forEach(function (param) {
                var values = param.split('=');

                if (values[0] === 'page' && values[1] >= 0 && values[1] < settings.menu.length) {
                    _this2.selectedItem = settings.menu[values[1]];
                }

                if (values[0] === 'tab' && values[1] >= 0 && values[1] < _this2.selectedItem.items.length) {
                    _this2.selectedItemTab = { name: _this2.selectedItem.items[values[1]].tabName };
                }
            });
        }
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('objectSharingStatusDirective', objectSharingStatusDirective);

    objectSharingStatusDirective.$inject = [];

    function objectSharingStatusDirective() {

        controllerFunction.$inject = ['$scope', '$q', 'settingsUtils'];

        function controllerFunction($scope, $q, settingsUtils) {

            $scope.sessionId = sessionId;
            $scope.isLoading = true;

            settingsUtils.callRemoteAction(remoteActions.checkObjectSharingStatus, [$scope.objectSharingProps.SharingObjectAPI]).then(function (result) {
                $scope.isLoading = false;
                $scope.Status = result;
                $scope.objectSharingProps.Status = result;
            }).catch(function (result) {
                $scope.isLoading = false;
                $scope.Status = 'ERROR';
                $scope.objectSharingProps.Status = 'ERROR';
            });

            $scope.getIcon = function (name) {
                return settings.icons[name];
            };
        }

        var template = '\n            <div class="sharingStatus">\n            \n                <div class="objectName">{{objectSharingProps.SharingObjectName}}</div>\n\n                <div ng-show="isLoading" class="sharingLoadingContainer">\n                    <img class="loadingImg" src={{getIcon(\'loading\')}} />\n                </div>\n\n                <div ng-show="Status == \'Public\' && isLoading == false">\n                    <i class="fa fa-exclamation-circle warningIcon" aria-hidden="true"></i>\n                </div>\n\n                <div ng-show="Status == \'Private\' && isLoading == false" class="checkmark">\n                    <div class="checkmark_circle_green"></div>\n                    <div class="checkmark_stem"></div>\n                    <div class="checkmark_kick"></div>\n                </div>\n\n                <div ng-show="Status == \'Public\' && isLoading == false" class="sharingPublic">\n                    Object Sharing is Public\n                </div>\n\n                <div ng-show="Status == \'Private\' && isLoading == false" class="sharingPrivate">\n                    Object Sharing is Private\n                </div>\n            </div>';

        return {
            restrict: 'E',
            scope: {
                objectSharingProps: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('pushTopicsCreatorDirective', pushTopicsCreatorDirective);

    pushTopicsCreatorDirective.$inject = [];

    function pushTopicsCreatorDirective() {

        controllerFunction.$inject = ['$scope', '$q', 'settingsUtils'];

        function controllerFunction($scope, $q, settingsUtils) {

            $scope.pushTopicsStatus = 'Validating';
            $scope.disableUpdateButton = true;

            function validatePushTopics() {
                settingsUtils.callRemoteAction(remoteActions.validatePushTopics, [$scope.pushTopicsProps]).then(function (PushTopicsValidations) {

                    if (PushTopicsValidations == null) {
                        $scope.pushTopicsStatus = 'ERROR';
                    } else {

                        $scope.pushTopicsStatus = 'Validating';

                        for (var i in PushTopicsValidations) {
                            if (PushTopicsValidations[i].status == 'NotUpdated' || PushTopicsValidations[i].status == 'NotExist') {
                                $scope.pushTopicsStatus = 'NotUpdated';
                                $scope.disableUpdateButton = false;
                                break;
                            }
                        }

                        if ($scope.pushTopicsStatus == 'Validating') {
                            $scope.pushTopicsStatus = 'Updated';
                        }
                    }
                }).catch(function (error) {
                    $scope.pushTopicsStatus = 'ERROR';
                    console.log('Validating Push Topics Failed: ' + error);
                });
            }

            $scope.updatePushTopics = function () {
                if ($scope.disableUpdateButton == false) {
                    $scope.disableUpdateButton = true;
                    settingsUtils.callRemoteAction(remoteActions.updatePushTopics, [$scope.pushTopicsProps]).then(function (res) {
                        validatePushTopics();
                    }).catch(function (err) {
                        validatePushTopics();
                    });
                }
            };

            validatePushTopics();
        }

        var template = '\n            \n            <div class="setting-row-container">\n                <label class="select-label">\n                    <div ng-show="pushTopicsStatus == \'Validating\'" class="pushTopicsLabelValidating">{{buttonStateLabels.validate}}</div>\n                    <div ng-class="{pushTopicsUpdatedButtonDisable: disableUpdateButton, pushTopicsUpdatedButton: !disableUpdateButton}" ng-click="updatePushTopics()" ng-show="pushTopicsStatus == \'NotUpdated\'">{{buttonStateLabels.update}}</div>\n                    <div ng-show="pushTopicsStatus == \'Updated\'" class="pushTopicsLabelUpdated">{{buttonStateLabels.updated}}</div>\n                    <div ng-show="pushTopicsStatus == \'ERROR\'" class="pushTopicsLabelError">{{buttonStateLabels.failed}}</div>\n                    <tooltip>{{pushTopicsToolTip}}</tooltip>\n                </label>\n                <div class="select-container">\n                </div>\n            <div>\n\n\n            ';

        return {
            restrict: 'E',
            scope: {
                pushTopicsProps: '=',
                buttonStateLabels: '=',
                pushTopicsToolTip: '@'
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('automators', automators);

    automators.$inject = [];

    function automators() {

        controllerFunction.$inject = ['$scope', 'dataService', 'primitiveType', '$filter', 'settingsUtils', '$q', '$timeout', '$rootScope'];

        function controllerFunction($scope, dataService, primitiveType, $filter, settingsUtils, $q, $timeout, $rootScope) {
            $scope.settings = dataService.getDraftSettings();
            $scope.primitiveType = primitiveType;

            $scope.jobsTemplates = {
                'Sched008_TimePhaseSharing': {
                    Name: 'Sharing Automation',
                    Label__c: 'Sharing Automation',
                    Allow_Time_Span_Back__c: true,
                    Allow_Time_Horizon__c: true,
                    Allow_Filter_Field__c: false,
                    Enabled__c: true,
                    Time_Span_Backward__c: 7,
                    Time_Span_Forward__c: 7,
                    //Filter_Field__c: null,
                    Allow_No_Location__c: false,
                    Allow_Locations__c: true,
                    Allow_Scheduling_Policy__c: false,
                    Cron_Expression__c: '0 0 0 ? JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC SUN,MON,TUE,WED,THU,FRI,SAT *'
                },
                'Sched009_STMIntegrityChecker': {
                    Name: 'Integrity Checker',
                    Label__c: 'Integrity Checker',
                    Allow_Time_Span_Back__c: false,
                    Allow_Time_Horizon__c: true,
                    Allow_Filter_Field__c: false,
                    Enabled__c: true,
                    //Time_Span_Backward__c: null,
                    Time_Span_Forward__c: 7,
                    //Filter_Field__c: null,
                    Allow_No_Location__c: false,
                    Allow_Locations__c: true,
                    Allow_Scheduling_Policy__c: true,
                    Cron_Expression__c: '0 0 0 ? JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC SUN,MON,TUE,WED,THU,FRI,SAT *'
                },
                'Sched006_SLRPurge': {
                    Name: 'SLR Purge',
                    Label__c: 'SLR Purge',
                    Allow_Time_Span_Back__c: false,
                    Allow_Time_Horizon__c: false,
                    Allow_Filter_Field__c: false,
                    Enabled__c: true,
                    //Time_Span_Backward__c: null,
                    //Time_Span_Forward__c: null,
                    //Filter_Field__c: null,
                    Allow_No_Location__c: false,
                    Allow_Locations__c: false,
                    Allow_Scheduling_Policy__c: false,
                    Max_Objects_Count__c: 50000,
                    Cron_Expression__c: '0 0 0 ? JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC SUN,MON,TUE,WED,THU,FRI,SAT *'
                },
                'Sched007_ServicesAppoDispatched': {
                    Name: 'Auto Dispatch',
                    Label__c: 'Auto Dispatch',
                    Allow_Time_Span_Back__c: false,
                    Allow_Time_Horizon__c: true,
                    Allow_Filter_Field__c: true,
                    Enabled__c: true,
                    //Time_Span_Backward__c: null,
                    Time_Span_Forward__c: 1,
                    //Filter_Field__c: null,
                    Allow_No_Location__c: true,
                    Allow_Locations__c: true,
                    Allow_Scheduling_Policy__c: false,
                    Cron_Expression__c: '0 0 0 ? JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC SUN,MON,TUE,WED,THU,FRI,SAT *'
                },
                'Sched004_OAAS': {
                    Name: 'Optimization',
                    Label__c: 'Optimization',
                    Allow_Time_Span_Back__c: false,
                    Allow_Time_Horizon__c: true,
                    Allow_Filter_Field__c: true,
                    Enabled__c: true,
                    //Time_Span_Backward__c: null,
                    Time_Span_Forward__c: 7,
                    //Filter_Field__c: null,
                    Allow_No_Location__c: true,
                    Allow_Locations__c: true,
                    Allow_Scheduling_Policy__c: true,
                    One_Location_Mandatory__c: true,
                    Cron_Expression__c: '0 0 0 ? JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC SUN,MON,TUE,WED,THU,FRI,SAT *'
                }
            };

            (function addNSToAutomatorTemplates() {
                for (var automatorTemplateName in $scope.jobsTemplates) {
                    var automator = $scope.jobsTemplates[automatorTemplateName];

                    for (var fieldName in automator) {
                        if (fieldName == 'Name') continue;
                        var fieldValue = automator[fieldName];
                        delete automator[fieldName];

                        automator[orgNameSpace + fieldName] = fieldValue;
                    }
                }
            })();

            createFormulaAndPoliciesOptionsArray();

            $rootScope.$on('savingForm', function () {
                $scope.editMode = false;
            });

            $scope.getIcon = function (name) {
                return settings.icons[name];
            };

            $scope.initTerritoryChecked = function (territory, automator) {
                var jobsStr = territory[fieldNames.ServiceTerritory.System_Jobs__c] || '';
                var jobs = jobsStr.split(';');
                var automatorName = automator.Name.toLowerCase();
                this.checked = jobs.indexOf(automatorName) != -1;
                this.$parent.numberOfTerritories++;
            };

            $scope.locationSelected = function (territory, automator, checked) {
                var jobsStr = territory[fieldNames.ServiceTerritory.System_Jobs__c] || '';
                var jobs = jobsStr.split(';');
                var automatorName = automator.Name.toLowerCase();

                if (checked) {
                    if (jobs.indexOf(automatorName) == -1) {
                        jobs.push(automatorName);
                        this.$parent.numberOfTerritories++;
                    }
                } else {
                    var index = jobs.indexOf(automatorName);
                    if (index != -1) {
                        jobs.splice(index, 1);
                        this.$parent.numberOfTerritories--;
                    }
                }

                territory[fieldNames.ServiceTerritory.System_Jobs__c] = jobs.join(';');
            };

            $scope.runNow = function (automator) {
                if (this.currentAutomatorRunNowDone || this.currentAutomatorLoading) return;
                this.currentAutomatorLoading = true;
                var me = this;
                settingsUtils.callRemoteAction(remoteActions.runJobNow, [automator]).then(function () {
                    me.currentAutomatorLoading = false;
                    me.currentAutomatorRunNowDone = true;
                    $timeout(function () {
                        me.currentAutomatorRunNowDone = false;
                    }, 4000);
                }, function (res) {
                    me.currentAutomatorLoading = false;
                });
            };

            $scope.removeAutomator = function (automator) {
                for (var terr in $scope.settings.Territories) {
                    $scope.locationSelected($scope.settings.Territories[terr], automator, false);
                }

                $scope.objects.splice($scope.objects.indexOf(automator), 1);
                delete dataService.getDraftSettings().AutomatorConfig[automator.Name];

                if (automator.Id) dataService.getDraftSettings().DeletedAutomators.push(automator);

                dataService.setDirty();
            };

            $scope.newJobClicked = function () {

                $scope.currentNewAutomator = {
                    Name: 'Job name'
                };

                $scope.currentNewAutomator[fieldNames.Automator_Config__c.Class_Name__c] = $scope.classNames[0];

                $scope.automatorTypes = [];

                for (var i = 0; i < $scope.classNames.length; i++) {
                    $scope.automatorTypes.push({
                        label: $scope.jobsTemplates[$scope.classNames[i]][fieldNames.Automator_Config__c.Label__c],
                        value: $scope.classNames[i]
                    });

                    if ($scope.classNames[i] == $scope.currentNewAutomator[fieldNames.Automator_Config__c.Class_Name__c]) $scope.currentNewAutomator.Name = $scope.jobsTemplates[$scope.classNames[i]][fieldNames.Automator_Config__c.Label__c];
                }

                $scope.popUpOpen = true;
            };

            $scope.newAutomatorSaveButtonClicked = function () {
                if ($scope.checkIfAutomatorExists()) return;
                $scope.popUpOpen = false;
                var templateCopy = angular.copy($scope.jobsTemplates[$scope.currentNewAutomator[fieldNames.Automator_Config__c.Class_Name__c]]);
                angular.merge(templateCopy, $scope.currentNewAutomator);
                templateCopy[fieldNames.Automator_Config__c.Label__c] = $scope.currentNewAutomator.Name;
                $scope.objects.push(templateCopy);
                dataService.getDraftSettings().AutomatorConfig[templateCopy.Name] = templateCopy;
                dataService.setDirty();
            };

            $scope.newAutomatorCancelButtonClicked = function () {
                $scope.popUpOpen = false;
            };

            $scope.checkIfAutomatorExists = function () {
                for (var automatorName in $scope.settings.AutomatorConfig) {
                    if (automatorName.toLowerCase() == $scope.currentNewAutomator.Name.toLowerCase()) return true;
                }

                return false;
            };

            $scope.getAutomatorFieldName = function (field) {
                return fieldNames.Automator_Config__c[field];
            };

            function createFormulaAndPoliciesOptionsArray() {
                dataService.getSettingsPromise().then(function () {
                    $scope.formulaOptions = dataService.serviceBooleanFields;
                    $scope.policies = dataService.policies;;
                });
            }

            $scope.usersCache = {};

            $scope.searchUsers = function (inputValue) {
                var deferred = $q.defer();

                settingsUtils.callRemoteAction(remoteActions.searchUsers, [inputValue]).then(function (users) {
                    var userNames = [];

                    for (var i = 0; i < users.length; i++) {
                        userNames.push(users[i].Name);

                        // FSL-946
                        //$scope.usersCache[users[i].Name] = users[i].Username;
                        $scope.usersCache[users[i].Name] = users[i].Email;
                    }

                    deferred.resolve(userNames);
                });

                return deferred.promise;
            };

            $scope.filterInput = function (inputValue, automator) {
                var fromCache = $scope.usersCache[inputValue];

                if (fromCache == undefined) fromCache = inputValue;

                var currVal = automator[fieldNames.Automator_Config__c.Notification_Username__c];

                if (currVal != undefined || fromCache != null) {
                    automator[fieldNames.Automator_Config__c.Notification_Username__c] = fromCache;
                }

                return fromCache;
            };
        }

        var template = '\n        <div class="automatorsWrapper" ng-if="!hideSection">\n                       \n            <div class="automatorButtonsWrapper" ng-hide="noChange">\n                <div class="newAutomator automatorButton settingsButton blueButton" ng-click="newJobClicked()">New job</div>\n                <div ng-show="objects.length > 0" class="editAutomators automatorButton settingsButton whiteButton" ng-click="editMode = !editMode">\n                    <span ng-if="!editMode">Edit</span>\n                    <span ng-if="editMode">Done</span>\n                </div>\n            </div>\n            <div class="noAutomators" ng-show="objects.length == 0">\n                No scheduled jobs\n            </div>\n            <div class="singleAutomator" ng-repeat="automator in objects | orderBy: getAutomatorFieldName(\'Name\') track by automator.Name" ng-class="{active: automator[getAutomatorFieldName(\'Enabled__c\')]}" ng-init="open=false; numberOfTerritories = 0;">\n                <div class="automatorRowAndContent" ng-class="{last: $last, selected: open}">\n                    <div class="automatorRowContainer">\n                        <div class="automatorRow" ng-class="{automatorEditMode: editMode}">\n                            <div class="editErrorIcon" ng-click="removeAutomator(automator)">\n                                <svg aria-hidden="true" class="slds-icon">\n                                    \u2028<use xlink:href="{{getIcon(\'remove\')}}"></use>\n                                \u2028</svg>\n                            </div>\n                            <span class="automatorTextAndCollapse">\n                                <span ng-click="open = !open">\n                                    <span class="collapseBox blueHover" ng-show="!open">+</span>\n                                    <span class="collapseBox blueHover openedCollapse" ng-show="open">-</span>\n                                </span>\n                                <span ng-if="!editMode" class="automatorNameCont">\n                                    {{automator[getAutomatorFieldName(\'Label__c\')]}}\n                                </span>\n                                <span ng-if="editMode" class="automatorEditNameCont">\n                                    <custom-settings-wrapper primitive-type="primitiveType.text" label="" value-field-name="\'Label__c\'" setting="automator" class="automatorName"></custom-settings-wrapper>\n                                </span>\n                            </span>\n                        </div>\n                        <div class="runNowContainer">\n                            <span class="runNow" ng-class="{disabled: currentAutomatorRunNowDone || currentAutomatorLoading}" ng-show="automator.Id" ng-click="runNow(automator)">\n                            Run now\n                            </span>\n                            <svg class="automatorRunNowDone" ng-show="currentAutomatorRunNowDone" aria-hidden="true" class="slds-icon">\n                                \u2028<use xlink:href="{{getIcon(\'check\')}}"></use>\n                            \u2028</svg>\n                            <img class="automatorSmallLoading" ng-show="currentAutomatorLoading" src={{getIcon(\'loading\')}} />\n                        </div>\n                    </div>\n                    <div class="automatorContent" ng-show="open">\n                        <div class="automatorLeftContent">\n                            <div class="automatorContentSon">\n                                <checkbox label="\'Active\'" object="automator" value-field="\'Enabled__c\'"></checkbox>\n                                <div class="automatorHeader" ng-show="automator[getAutomatorFieldName(\'Allow_Locations__c\')] || automator[getAutomatorFieldName(\'Allow_No_Location__c\')]">Effective Territories</div>\n                                <div class="automatorLocationsList">\n                                    <div ng-show="automator[getAutomatorFieldName(\'Allow_No_Location__c\')]">\n                                        <input ng-disabled="automator[getAutomatorFieldName(\'One_Location_Mandatory__c\')] && numberOfTerritories == 0" id="{{automator.Name + \'noLocation\'}}" type="checkbox" ng-model="automator[getAutomatorFieldName(\'No_Location__c\')]"></input> <label for="{{automator.Name + \'noLocation\'}}">No territory</label>\n                                    </div>\n                                    <div ng-show="automator[getAutomatorFieldName(\'Allow_Locations__c\')]" ng-repeat="territory in settings.Territories track by territory.Id" ng-init="initTerritoryChecked(territory, automator)">\n                                        <input id="{{\'loc\' + automator.Name + $index}}" type="checkbox" ng-model="checked" ng-change="locationSelected(territory, automator, checked)"></input> <label for="{{\'loc\' + automator.Name + $index}}"> {{territory.Name}} </label>\n                                    </div>\n                                </div>\n                                \n                                <custom-settings-wrapper ng-if="automator[getAutomatorFieldName(\'Allow_Time_Span_Back__c\')]" min="1" max="30" primitive-type="primitiveType.number" label="\'Time Horizon in days (backwards)\'" value-field-name="\'Time_Span_Backward__c\'" setting="automator"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="automator[getAutomatorFieldName(\'Allow_Time_Horizon__c\')]" min="1" max="30" primitive-type="primitiveType.number" label="\'Time Horizon in days\'" value-field-name="\'Time_Span_Forward__c\'" setting="automator"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="automator[getAutomatorFieldName(\'Allow_Filter_Field__c\')]" options="formulaOptions" primitive-type="primitiveType.picklist" label="\'Filter by critieria\'" value-field-name="\'Filter_Field__c\'" setting="automator"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="automator[getAutomatorFieldName(\'Allow_Scheduling_Policy__c\')]" options="policies" primitive-type="primitiveType.picklist" label="\'Scheduling Policy\'" value-field-name="\'Scheduling_Policy_Id__c\'" setting="automator"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="automator[getAutomatorFieldName(\'Class_Name__c\')] == \'Sched006_SLRPurge\'" primitive-type="primitiveType.number" min="0" max="1000000000" label="\'Max routes in cache\'" value-field-name="\'Max_Objects_Count__c\'" setting="automator"></custom-settings-wrapper>\n                                <custom-settings-wrapper filter-input="filterInput(inputValue, automator)" get-suggestions="searchUsers(inputValue)" primitive-type="primitiveType.autoComplete" label="\'Email recipient user name\'" value-field-name="\'Notification_Username__c\'" setting="automator" ng-hide="noChange"></custom-settings-wrapper>\n                            </div>\n                        </div>\n                        <div class="automatorRightContent">\n                            <div>\n                                <cron-exp automator="automator" expression="automator[getAutomatorFieldName(\'Cron_Expression__c\')]" valid="valid"></cron-exp>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n            <pop-up ng-if="popUpOpen" on-cancel="newAutomatorCancelButtonClicked()" on-save="newAutomatorSaveButtonClicked()">\n                <main-content>\n                    <div class="automatorPopUpContent">\n                        <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Name\'" value-field-name="\'Name\'" setting="currentNewAutomator"></custom-settings-wrapper>\n                        <custom-settings-wrapper options="automatorTypes" primitive-type="primitiveType.picklist" label="\'Automator type\'" value-field-name="\'Class_Name__c\'" setting="currentNewAutomator"></custom-settings-wrapper>\n                        <div class="newAutomatorError" ng-if="checkIfAutomatorExists()">\n                            <ui-error>\n                                <main-content>\n                                    <div>There is already a scheduled job with this name</div>\n                                </main-content>\n                            </ui-error>\n                        </div>\n                    </div>\n                </main-content>\n            </pop-up>\n        </div>\n        ';

        return {
            restrict: 'E',
            scope: {
                objects: '=',
                classNames: '=',
                noChange: '=',
                hideSection: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('betaFeature', betaFeature);

    betaFeature.$inject = [];

    function betaFeature() {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {}

        var template = '\n        <span class="betaFeature">\n            Beta\n        </span>';

        return {
            restrict: 'E',
            scope: {},
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

(function () {

    angular.module('SettingsApp').directive('bulkActionsOrder', bulkActionsOrder);

    function bulkActionsOrder() {

        controller.$inject = ['$scope', 'dataService'];

        function controller($scope, dataService) {

            $scope.$watch("object['Bulk Action Buttons Order']", function (newValue, oldValue) {
                if (newValue != oldValue) {
                    $scope.actionOrder = JSON.parse($scope.object['Bulk Action Buttons Order'][fieldNames.General_Config__c.Value__c]);
                    //console.log($scope.actionOrder);

                    $scope.unused = $scope.actionOrder.unused;
                    $scope.used = $scope.actionOrder.dropdown;
                    $scope.shown = [].concat(_toConsumableArray($scope.actionOrder.first), _toConsumableArray($scope.actionOrder.second));
                }
            });

            $scope.uiTimes = 0;
            $scope.unusedCurrentlySelected = null;
            $scope.usedCurrentlySelected = null;

            function setNewObject() {

                dataService.setDirty();

                var first = [],
                    second = [];

                if ($scope.shown.length == 2) {
                    second = [$scope.shown[1]];
                    first = [$scope.shown[0]];
                }

                if ($scope.shown.length == 1) {
                    first = [$scope.shown[0]];
                }

                $scope.object['Bulk Action Buttons Order'][fieldNames.General_Config__c.Value__c] = JSON.stringify({
                    dropdown: $scope.used,
                    first: first,
                    second: second,
                    unused: $scope.unused
                });
            }

            $scope.moveHorizontally = function (fromArr, toArr, action, shownLength) {

                $scope.uiTimes++;
                if ($scope.uiTimes > 10) {
                    console.log('%c   UI LEVEL OVER 9000   ', 'background:red;color:#fff;font-size:48px;;text-align:center');
                }

                if (!action || shownLength && shownLength == 2) {
                    return;
                }

                var actionIndex = fromArr.indexOf(action);
                fromArr.splice(actionIndex, 1);
                toArr.push(action);

                $scope.unusedCurrentlySelected = null;
                $scope.usedCurrentlySelected = null;
                $scope.shownCurrentlySelected = null;

                setNewObject();
            };

            $scope.moveVertically = function (arr, action, up) {

                if (!action) {
                    return;
                }

                var actionIndex = arr.indexOf(action);

                if (up && actionIndex > 0) {
                    swap(arr, actionIndex, actionIndex - 1);
                }

                if (up === undefined && actionIndex != arr.length - 1) {
                    swap(arr, actionIndex, actionIndex + 1);
                }

                setNewObject();
            };

            function swap(arr, a, b) {
                var tmp = arr[a];
                arr[a] = arr[b];
                arr[b] = tmp;
            }
        }

        return {
            restrict: 'E',
            scope: {
                object: '='
            },
            controller: controller,
            template: '\n                        <div>Select the actions shown on the appointment list</div>\n                        <div class="setting-action-container"> \n                            \n                            \n                            <div class="bulkActionOrder">\n                                <div>Unused Actions</div>\n                                <div ng-repeat="action in unused track by $index" ng-click="$parent.unusedCurrentlySelected = action" ng-class="{\'optionselected\' : action === $parent.unusedCurrentlySelected}">{{action.title}}</div>\n                            </div> \n                            \n                            <div class="upDownContainer">\n                                <div class="arrowButtonContainer" ng-click="moveHorizontally(unused, used, unusedCurrentlySelected)">\n                                    <svg aria-hidden="true" class="slds-icon">\n                                        \u2028<use xlink:href="' + settings.icons.right + '"></use>\n                                    \u2028</svg>\n                                </div> \n                                \n                                <div class="arrowButtonContainer" ng-click="moveHorizontally(used, unused, usedCurrentlySelected)">\n                                    <svg aria-hidden="true" class="slds-icon">\n                                        \u2028<use xlink:href="' + settings.icons.left + '"></use>\n                                    \u2028</svg>\n                                </div>\n                            </div>\n                             \n                            \n                            <div class="bulkActionOrder usedActions">\n                                <div>Dropdown Actions</div>\n                                <div ng-repeat="action in used track by $index" ng-click="$parent.usedCurrentlySelected = action" ng-class="{\'optionselected\' : action === $parent.usedCurrentlySelected}">{{action.title}}</div>\n                            </div> \n                            \n                            <div class="upDownContainer">\n                                <div class="arrowButtonContainer" ng-click="moveVertically(used, usedCurrentlySelected, true)">\n                                    <svg aria-hidden="true" class="slds-icon">\n                                        \u2028<use xlink:href="' + settings.icons.up + '"></use>\n                                    \u2028</svg>\n                                </div> \n                                \n                                <div class="arrowButtonContainer" ng-click="moveVertically(used, usedCurrentlySelected)">\n                                    <svg aria-hidden="true" class="slds-icon">\n                                        \u2028<use xlink:href="' + settings.icons.down + '"></use>\n                                    \u2028</svg>\n                                </div>\n                                \n                                <div class="middle-arrows">\n                                    <div class="arrowButtonContainer" ng-click="moveHorizontally(used, shown, usedCurrentlySelected, shown.length)">\n                                        <svg aria-hidden="true" class="slds-icon">\n                                            \u2028<use xlink:href="' + settings.icons.right + '"></use>\n                                        \u2028</svg>\n                                    </div> \n                                    \n                                    <div class="arrowButtonContainer" ng-click="moveHorizontally(shown, used, shownCurrentlySelected)">\n                                        <svg aria-hidden="true" class="slds-icon">\n                                            \u2028<use xlink:href="' + settings.icons.left + '"></use>\n                                        \u2028</svg>\n                                    </div>\n                                </div>\n                            </div>\n                            \n                            \n                            \n                            \n                            <div class="bulkActionOrder usedActions">\n                                <div>Shown Actions</div>\n                                <div ng-repeat="action in shown track by $index" ng-click="$parent.shownCurrentlySelected = action" ng-class="{\'optionselected\' : action === $parent.shownCurrentlySelected}">{{action.title}}</div>\n                            </div> \n                            \n                            <div class="upDownContainer">\n                                <div class="arrowButtonContainer" ng-click="moveVertically(shown, shownCurrentlySelected, true)">\n                                    <svg aria-hidden="true" class="slds-icon">\n                                        \u2028<use xlink:href="' + settings.icons.up + '"></use> \n                                    \u2028</svg>\n                                </div> \n                                \n                                <div class="arrowButtonContainer" ng-click="moveVertically(shown, shownCurrentlySelected)">\n                                    <svg aria-hidden="true" class="slds-icon">\n                                        \u2028<use xlink:href="' + settings.icons.down + '"></use>\n                                    \u2028</svg>\n                                </div>\n                            </div>\n                        </div>'
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('checkbox', checkbox);

    checkbox.$inject = [];

    function checkbox() {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {
            $scope.valueWithNS = orgNameSpace + $scope.valueField;
        }

        var template = '\n        <div>\n            <span class="checkBoxWrapper" ng-click="object[valueWithNS] = !object[valueWithNS]" ng-class="{checked: object[valueWithNS], unchecked: !object[valueWithNS]}">\n                <span class="innerCheckboxValue" ng-class="{checked: object[valueWithNS], unchecked: !object[valueWithNS]}"></span>\n            </span>\n            <span class="checkboxLabel">{{label}}</span>\n        </div>';

        return {
            restrict: 'E',
            scope: {
                label: '=',
                valueField: '=',
                object: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('collapseBox', collapseBox);

    function collapseBox() {

        controller.$inject = ['$scope'];

        function controller($scope) {

            $scope.toggleCollapse = function ($event, item) {
                $event.stopPropagation();
                item.show = !item.show;
            };
        }

        return {
            restrict: 'E',
            scope: {
                item: '='
            },
            controller: controller,
            template: '<span>\n                            <span class="collapseBox blueHover" ng-click="toggleCollapse($event, item)" ng-show="!item.show && item.items.length !== 0">+</span>\n                            <span class="collapseBox blueHover openedCollapse" ng-click="toggleCollapse($event, item)" ng-show="item.show && item.items.length !== 0">-</span>\n                            <span class="collapseBox blueHover hiddenCollapse" ng-show="item.items.length === 0"></span>\n                        </span>'
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('contentCollapseWrapper', contentCollapseWrapper);

    contentCollapseWrapper.$inject = [];

    function contentCollapseWrapper() {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {}

        var template = '\n            <div class="collapseWrapper">\n                <div class="collapseHeader" ng-click="open = !open">\n                    <i class="fa fa-plus-square-o" ng-show="!open"></i>\n                    <i class="fa fa-minus-square-o" ng-show="open"></i>\n                    {{header}}\n                </div>\n                <div ng-transclude="content" class="collapseContent" ng-show="open">\n                </div>\n            </div>\n        ';

        return {
            restrict: 'E',
            transclude: {
                content: 'content'
            },
            scope: {
                open: '=?',
                header: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('cronExp', cronExp);

    cronExp.$inject = ['dataService'];

    function cronExp(dataService) {

        function link(scope, element, attrs) {

            dataService.getSettingsPromise().then(function () {

                scope.userTimeZone = dataService.getDraftSettings().UserTimeZone;

                var getRangeArray = function getRangeArray(start, end) {
                    var arr = [];
                    for (var i = start; i <= end; i++) {
                        arr.push(i);
                    }return arr;
                };

                scope.daysOfWeek = [{ label: 'Sun', value: 'SUN' }, { label: 'Mon', value: 'MON' }, { label: 'Tue', value: 'TUE' }, { label: 'Wed', value: 'WED' }, { label: 'Thu', value: 'THU' }, { label: 'Fri', value: 'FRI' }, { label: 'Sat', value: 'SAT' }];

                scope.months = [{ label: 'Jan', value: 'JAN' }, { label: 'Feb', value: 'FEB' }, { label: 'Mar', value: 'MAR' }, { label: 'Apr', value: 'APR' }, { label: 'May', value: 'MAY' }, { label: 'Jun', value: 'JUN' }, { label: 'Jul', value: 'JUL' }, { label: 'Aug', value: 'AUG' }, { label: 'Sep', value: 'SEP' }, { label: 'Oct', value: 'OCT' }, { label: 'Nov', value: 'NOV' }, { label: 'Dec', value: 'DEC' }];
                scope.daysOfMonth = getRangeArray(1, 31);
                scope.daysOfMonthWithLabel = [];

                for (var i = 0; i < scope.daysOfMonth.length; i++) {
                    scope.daysOfMonthWithLabel.push({
                        label: scope.daysOfMonth[i].toString(),
                        value: scope.daysOfMonth[i].toString()
                    });
                }

                scope.allHours = getRangeArray(0, 23);
                scope.allMinutes = getRangeArray(0, 59);
                scope.allYears = getRangeArray(new Date().getFullYear(), new Date().getFullYear() + 10);
                scope.id = Math.floor(Math.random() * 1000000 + 1);
                scope.selected = { months: [],
                    daysMonth: [],
                    daysWeek: []
                };
                scope.valid = true;
                ///////////////////////////////////////////////////

                scope.parseNumber = function (str) {
                    if (str) return parseInt(str);
                    return 0;
                };

                var setDefaultValues = function setDefaultValues(scope) {
                    scope.specificDate = moment().tz(scope.userTimeZone);
                    scope.recurringType = null;
                    scope.month = scope.months[0].value;
                    scope.year = scope.allYears[0];
                    scope.dayMonth = scope.daysOfMonth[0];
                    scope.hours = scope.allHours[14];
                    scope.minutes = scope.allMinutes[30];
                    scope.selected.months = [];
                    scope.recurringDay = 'dayWeek';
                    scope.selected.daysMonth = [];
                    scope.selected.daysWeek = [];
                    scope.recurringTime = 'specific';
                    scope.recurringHours = scope.allHours[1];
                };

                var getParam = function getParam(param) {
                    return function (obj) {
                        return obj[param];
                    };
                };

                var setValues = function setValues(scope, cronExpr) {
                    var regExps = {
                        'regExpOneTime': /^0\s([0-9]|([1-5][0-9]))\s([0-9]|(1[0-9])|(2[0-3]))\s([1-9]|([1-2][0-9])|3([0-1]))\s(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\s\?\s([2-9][0-9][0-9][0-9])$/,
                        'recurringDayWeek': /^0\s([0-9]|([1-5][0-9]))\s((0\/([1-9]|(1[0-9])|(2[0-3])))|([0-9]|(1[0-9])|(2[0-3])))\s\?\s(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(,FEB)?(,MAR)?(,APR)?(,MAY)?(,JUN)?(,JUL)?(,AUG)?(,SEP)?(,OCT)?(,NOV)?(,DEC)?\s(SUN|MON|TUE|WED|THU|FRI|SAT)(,SUN|,MON|,TUE|,WED|,THU|,FRI|,SAT)*\s\*$/,
                        'recurringDayMonth': /^0\s([0-9]|([1-5][0-9]))\s((0\/([1-9]|(1[0-9])|(2[0-3])))|([0-9]|(1[0-9])|(2[0-3])))\s(1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31)(,1|,2|,3|,4|,5|,6|,7|,8|,9|,10|,11|,12|,13|,14|,15|,16|,17|,18|,19|,20|,21|,22|,23|,24|,25|,26|,27|,28|,29|,30|,31)*\s(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)(,JAN|,FEB|,MAR|,APR|,MAY|,JUN|,JUL|,AUG|,SEP|,OCT|,NOV|,DEC)*\s\?\s\*$/
                    };
                    var argsCron = cronExpr.split(' ');
                    if (regExps.regExpOneTime.test(cronExpr)) {
                        scope.recurringType = 'oneTime';
                        scope.minutes = scope.parseNumber(argsCron[1]);
                        scope.hours = scope.parseNumber(argsCron[2]);
                        scope.dayMonth = argsCron[3];
                        scope.month = argsCron[4];
                        scope.year = argsCron[6];
                    } else if (regExps.recurringDayWeek.test(cronExpr)) {
                        scope.recurringType = 'recurring';
                        scope.recurringDay = 'dayWeek';
                        scope.minutes = scope.parseNumber(argsCron[1]);
                        var hours = argsCron[2];
                        if (hours.indexOf('0/') === 0) {
                            scope.recurringHours = scope.parseNumber(hours.substring(2));
                            scope.recurringTime = 'recurring';
                        } else {
                            scope.recurringTime = 'specific';
                            scope.hours = scope.parseNumber(hours);
                        }
                        scope.selected.months = argsCron[4].split(',');
                        scope.selected.daysWeek = argsCron[5].split(',');
                    } else if (regExps.recurringDayMonth.test(cronExpr)) {
                        scope.recurringType = 'recurring';
                        scope.recurringDay = 'dayMonth';
                        scope.minutes = scope.parseNumber(argsCron[1]);
                        hours = argsCron[2]; // var
                        if (hours.indexOf('0/') === 0) {
                            scope.recurringHours = scope.parseNumber(hours.substring(2));
                            scope.recurringTime = 'recurring';
                        } else {
                            scope.recurringTime = 'specific';
                            scope.hours = scope.parseNumber(hours);
                        }
                        scope.selected.daysMonth = argsCron[3].split(',');
                        scope.selected.months = argsCron[4].split(',');
                    } else {
                        return false;
                    }
                    scope.specificDate.tz(scope.userTimeZone).set('years', scope.year);
                    scope.specificDate.tz(scope.userTimeZone).set('month', scope.months.map(getParam('value')).indexOf(scope.month));
                    scope.specificDate.tz(scope.userTimeZone).set('date', scope.dayMonth);
                    return true;
                };

                var joinElements = function joinElements(selectedElements) {
                    if (selectedElements === undefined || selectedElements.length === 0) {
                        scope.valid = false;
                        return '*';
                    } else {
                        return selectedElements.join(",");
                    }
                };

                setDefaultValues(scope);
                if (scope.expression) {
                    setValues(scope, scope.expression);
                }

                scope.getCronExpr = function () {
                    try {
                        scope.valid = true;
                        var expr = { "sec": "0", "min": "0", "hour": "*", "dayMonth": "*", "month": "*", "dayWeek": "?", "year": "*" };
                        if (scope.recurringType === 'recurring') {
                            expr.month = joinElements(scope.selected.months, scope.months);
                            if (scope.recurringDay === 'dayWeek') {
                                expr.dayMonth = '?';
                                expr.dayWeek = joinElements(scope.selected.daysWeek);
                            } else {
                                expr.dayMonth = joinElements(scope.selected.daysMonth);
                            }
                            if (scope.recurringTime === 'specific') {
                                expr.hour = scope.hours;
                                expr.min = scope.minutes;
                            } else {
                                expr.hour = '0/' + scope.recurringHours;
                            }
                        } else if (scope.recurringType === 'oneTime') {
                            expr.hour = scope.hours;
                            expr.min = scope.minutes;
                            expr.month = scope.months[scope.specificDate.tz(scope.userTimeZone).get('month')].value;
                            expr.year = scope.specificDate.tz(scope.userTimeZone).get('year');
                            expr.dayMonth = scope.specificDate.tz(scope.userTimeZone).get('date');
                        } else {
                            scope.valid = false;
                        }
                        var newExp = expr.sec + " " + expr.min + " " + expr.hour + " " + expr.dayMonth + " " + expr.month + " " + expr.dayWeek + " " + expr.year;
                        if (scope.expression != newExp) {
                            scope.expression = newExp;
                            dataService.setDirty();
                        }

                        return scope.expression;
                    } catch (ex) {
                        scope.valid = false;
                    }
                };

                // watch and always update cron string
                scope.$watch('recurringType', scope.getCronExpr);
                scope.$watch('recurringDay', scope.getCronExpr);
                scope.$watch('selected', scope.getCronExpr, true);
                scope.$watch('recurringTime', scope.getCronExpr);
                scope.$watch('recurringHours', scope.getCronExpr);
                scope.$watch('hours', scope.getCronExpr);
                scope.$watch('minutes', scope.getCronExpr);
                scope.$watch('specificDate', scope.getCronExpr);
            });
        }

        return {
            restrict: 'E',
            scope: {
                expression: '=',
                valid: '=',
                automator: '='
            },
            link: link,
            template: '\n                <div class="automatorFreq">\n                    <div class="cronHeader">Frequency</div>\n                    <div>\n                        <input id="{{automator.Name + \'oneTime\'}}" type="radio" ng-model="recurringType" value="oneTime">\n                        <label for="{{automator.Name + \'oneTime\'}}">\n                        One Time\n                      </label>\n                      <input id="{{automator.Name + \'recurring\'}}" type="radio" ng-model="recurringType" value="recurring">\n                      <label for="{{automator.Name + \'recurring\'}}">\n                        Recurring\n                      </label>\n                    </div>\n                </div>\n                <div class="automatorMonthAndDays" ng-show="recurringType == \'recurring\'">\n                    <div class="automatorMonth">\n                        <div class="cronHeader">Month</div>\n                        <cron-exp-rows-of-dates rows="months" selected-rows="selected.months" label-id-prefix="automator.Name + \'month\'"></cron-exp-rows-of-dates>\n                    </div>\n                    <div class="automatorDays">\n                        <div class="automatorWeekOrMonth">\n                            <label>\n                            <input type="radio" ng-model="recurringDay" value="dayWeek">\n                            Day of week\n                          </label>\n                          <label>\n                            <input type="radio" ng-model="recurringDay" value="dayMonth">\n                            Day of month\n                          </label>\n                        </div>\n                        <cron-exp-rows-of-dates ng-show="recurringDay == \'dayWeek\'" rows="daysOfWeek" selected-rows="selected.daysWeek" label-id-prefix="automator.Name + \'daysOfWeek\'"></cron-exp-rows-of-dates>\n                        <cron-exp-rows-of-dates ng-show="recurringDay == \'dayMonth\'" rows="daysOfMonthWithLabel" selected-rows="selected.daysMonth" label-id-prefix="automator.Name + \'daysOfMonth\'"></cron-exp-rows-of-dates>\n                    </div>\n                </div>\n                <div class="automatorHour">\n                    <div ng-show="recurringType == \'recurring\'" class="recurTime">\n                        <input id="{{automator.Name + \'specificHour\'}}" type="radio" ng-model="recurringTime" value="specific">\n                        <label for="{{automator.Name + \'specificHour\'}}">\n                            Specific Hour\n                        </label>\n                      <input id="{{automator.Name + \'recurHour\'}}" type="radio" ng-model="recurringTime" value="recurring">\n                      <label for="{{automator.Name + \'recurHour\'}}">\n                        Recurring Hour\n                      </label>\n                    </div>\n                    <div class="automatorSpecificHour" ng-show="recurringTime == \'specific\' || recurringType == \'oneTime\'">\n                        <span class="automatorTimeSpan" ng-show="recurringType == \'oneTime\'">\n                            <span class="timeSpanHeader">\n                                Date\n                            </span>\n                            \n                            <span class="timeSpanInput">\n                                <input class="input-settings" fsl-date-picker my-model="specificDate" time-zone="userTimeZone" type="text"> </input>\n                            </span>\n                        </span>\n                        <span class="automatorTimeSpan">\n                            <span class="timeSpanHeader">\n                                Hour\n                            </span>\n                            \n                            <span class="timeSpanInput">\n                                <input ng-model="hours" min="0" max="23" type="number" class="input-settings">\n                            </span>\n                        </span>\n                        <span class="automatorTimeSpan">\n                            <span class="timeSpanHeader">\n                                Minute\n                            </span>\n\n                            <span class="timeSpanInput">\n                                <input ng-model="minutes" min="0" max="55" step="5" type="number" class="input-settings">\n                            </span>\n                        </span>\n                    </div>\n                    <div ng-show="recurringTime == \'recurring\' && recurringType == \'recurring\'" class="automatorRecur">\n                        Every\n                        <input class="input-settings" min="0" max="23" type="number" ng-model="recurringHours" />\n                        Hours\n                    </div>\n                    <ui-error ng-if="!valid">\n                        <main-content>\n                            Please make sure this job has a valid frequency\n                        </main-content>\n                    </ui-error>\n                </div>\n            '
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('cronExpRowsOfDates', cronExpRowsOfDates);

    cronExpRowsOfDates.$inject = [];

    function cronExpRowsOfDates() {

        controllerFunction.$inject = ['$scope', 'dataService'];

        function controllerFunction($scope, dataService) {
            $scope.initRow = function (row) {
                this.selected = $scope.selectedRows.indexOf(row.value) != -1;
            };

            $scope.addOrRemoveItemFromArray = function (array, itemValue, add) {

                if (add) {
                    if (array.indexOf(itemValue) == -1) {
                        array.push(itemValue);
                    }
                } else {
                    var index = array.indexOf(itemValue);
                    if (index != -1) {
                        array.splice(index, 1);
                    }
                }

                $scope.selectedRows.sort(sortByBaseArray);

                function sortByBaseArray(obj1, obj2) {
                    var obj1Index = findObjByValue(obj1);
                    var obj2Index = findObjByValue(obj2);

                    return obj1Index - obj2Index;
                }

                function findObjByValue(val) {
                    for (var i = 0; i < $scope.rows.length; i++) {
                        if ($scope.rows[i].value == val) return i;
                    }

                    return -1;
                }

                dataService.setDirty();
            };
        }

        var template = '<div>\n                            <span class="automatorRowsOfDates" ng-repeat="row in rows">\n                                <input ng-change="addOrRemoveItemFromArray(selectedRows, row.value, selected)" id="{{labelIdPrefix + $index}}" type="checkbox" ng-model="selected" ng-init="initRow(row)"> <label for="{{labelIdPrefix + $index}}">{{row.label}}</label>\n                            </span>\n                        </div>';

        return {
            restrict: 'E',
            scope: {
                rows: '=',
                selectedRows: '=',
                labelIdPrefix: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('customSettingsWrapper', customSettingsWrapper);

    customSettingsWrapper.$inject = ['primitiveType'];

    function customSettingsWrapper(primitiveType) {

        controllerFunction.$inject = ['$scope', 'primitiveType', '$rootScope'];

        function controllerFunction($scope, primitiveType, $rootScope) {

            $scope.primitiveConst = primitiveType;

            $rootScope.$on('settingsUpdated', function () {
                init();
            });

            $scope.$watch('setting', function () {
                init();
            });

            $scope.$watch('options', function (newValue, oldValue) {
                if (JSON.stringify(newValue) != JSON.stringify(oldValue)) {
                    init();
                }
            });

            function init() {
                if (!$scope.setting) return;
                if ($scope.primitiveType == primitiveType.picklist && !$scope.options) return;

                var isCustomField = $scope.valueFieldName.indexOf('__c') != -1;
                var tempOrgNS = isCustomField ? orgNameSpace : '';

                var valueFieldName = tempOrgNS + $scope.valueFieldName;
                var label = null;
                var val = $scope.setting[valueFieldName];

                if ($scope.labelFieldName) {
                    label = $scope.setting[tempOrgNS + $scope.labelFieldName];
                } else label = $scope.label;

                switch ($scope.primitiveType) {
                    case primitiveType.boolean:
                        $scope.rawObject = new booleanDescriptor({
                            label: label,
                            value: val
                        });
                        break;
                    case primitiveType.text:
                        $scope.rawObject = new textDescriptor({
                            label: label,
                            value: val
                        });
                        break;
                    case primitiveType.autoComplete:
                        $scope.rawObject = new textDescriptor({
                            label: label,
                            value: val
                        });
                        break;
                    case primitiveType.number:
                        $scope.rawObject = new numberDescriptor({
                            label: label,
                            value: parseInt(val),
                            min: $scope.min,
                            max: $scope.max
                        });
                        break;
                    case primitiveType.picklist:
                        $scope.rawObject = new picklistDescriptor({
                            label: label,
                            value: val,
                            options: $scope.options
                        });
                        break;
                    case primitiveType.multi:

                        $scope.rawObject = new multiPicklistDescriptor({
                            label: label,
                            value: val,
                            options: $scope.options
                        });
                        break;
                    case primitiveType.booleanText:
                        $scope.rawObject = new booleanTextDescriptor({
                            label: label,
                            value: val
                        }, val == "1");
                        break;
                    default:
                        throw 'customSettingsWrapper - unknown primitive data type';
                }

                $scope.$watch('rawObject.value', function () {
                    var currVal = $scope.setting[valueFieldName];
                    var newVal = $scope.rawObject.value;;

                    // don't put null instead of undefined, isdirty bugs
                    if (currVal == undefined && $scope.rawObject.value == null) {
                        return;
                    }

                    if ($scope.isText) {
                        newVal = newVal ? newVal.toString() : currVal;
                    }

                    $scope.setting[valueFieldName] = newVal;
                });

                $scope.mySuggestions = function (inputValue) {
                    return $scope.getSuggestions({ inputValue: inputValue });
                };

                $scope.myFilterInput = function (inputValue) {
                    return $scope.filterInput({ inputValue: inputValue });
                };
            }
        }

        var template = '\n        <boolean-setting is-disabled="isDisabled" ng-if="primitiveType == primitiveConst.boolean" tooltip-text="{{ tooltipText }}" object="rawObject" is-beta="isBeta"></boolean-setting>\n        <text-setting ng-if="primitiveType == primitiveConst.text" tooltip-text="{{ tooltipText }}" object="rawObject"></text-setting>\n        <auto-complete filter-input="myFilterInput(inputValue)" get-suggestions="mySuggestions(inputValue)" get-suggestions="mySuggestions(inputValue)" ng-if="primitiveType == primitiveConst.autoComplete" tooltip-text="{{ tooltipText }}" object="rawObject"></auto-complete>\n        <number-setting ng-if="primitiveType == primitiveConst.number"tooltip-text="{{ tooltipText }}"  object="rawObject"></number-setting>\n        <picklist-setting is-disabled="isDisabled" ng-if="primitiveType == primitiveConst.picklist" tooltip-text="{{ tooltipText }}" object="rawObject" change="change()"></picklist-setting>\n        <multi-picklist-setting ng-if="primitiveType == primitiveConst.multi" object="rawObject" placeholder="placeholder"></multi-picklist-setting>\n        <boolean-text-setting is-disabled="isDisabled" ng-if="primitiveType == primitiveConst.booleanText" tooltip-text="{{ tooltipText }}" object="rawObject"></boolean-text-setting>\n        ';

        return {
            restrict: 'E',
            scope: {
                valueFieldName: '=',
                labelFieldName: '=',
                isBeta: '=',
                label: '=',
                primitiveType: '=',
                setting: '=',
                min: '=',
                max: '=',
                options: '=',
                placeholder: '=',
                isDisabled: '=',
                isText: '=',
                tooltipText: '@',
                getSuggestions: '&',
                filterInput: '&',
                change: '&'
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('formWithTabs', formWithTabs);

    formWithTabs.$inject = ['$compile', '$injector', '$rootScope'];

    function formWithTabs($compile, $injector, $rootScope) {

        function linkFunction($scope, element) {

            var tabsHtml = '';

            $scope.menuItem.items.forEach(function (item) {
                tabsHtml += '<div class="setting-form-container" ng-show="selectedTab.name == \'' + item.tabName + '\'">\n                        <' + item.directive + ' verify-functions="verifyFunctions"></' + item.directive + '>                       \n                    </div>';
            });

            var templateNew = template.replace('TABS_TEMPLATE_HERE', tabsHtml);
            element.html(templateNew);
            $compile(element.contents())($scope);
        }

        controllerFunction.$inject = ['$scope', '$injector', 'dataService', 'SAVING_STATES'];

        function controllerFunction($scope, $injector, dataService, SAVING_STATES) {

            $scope.verifyFunctions = [];
            $scope.foundErrors = false;
            $scope.switchTab = function (name, tabIndex) {
                $scope.selectedTab.name = name;
                location.href = location.href.substr(0, location.href.lastIndexOf('tab')) + 'tab=' + tabIndex;
            };

            $scope.isSaving = dataService.isSaving;
            $scope.SAVING_STATES = SAVING_STATES;

            var formService = $injector.get($scope.menuItem.service);
            formService.loadData();

            $scope.save = function () {

                $scope.foundErrors = false;

                // run verify functions, if one returns true then we have error(s)
                $scope.verifyFunctions.forEach(function (f) {
                    return $scope.foundErrors = f() || $scope.foundErrors;
                });

                // have errors? don't run save
                if ($scope.foundErrors) {
                    return;
                }

                // run save function if all verifications pass
                var formService = $injector.get($scope.menuItem.service);
                formService.save();

                $rootScope.$broadcast('savingForm', {});
            };

            $scope.restore = function () {

                var shouldRestore = confirm('Are you sure you want to restore to defaults settings?');

                if (!shouldRestore) {
                    return;
                }

                $injector.get($scope.menuItem.service).restore();
            };
        }

        var template = '<div class="settings-form">\n                            <div class="saving-banner" ng-show="isSaving() !== SAVING_STATES.NOT_SAVING" ng-class="{\'settings-saved\' : isSaving() == SAVING_STATES.SAVED}">\n                                <span ng-show="isSaving() == SAVING_STATES.SAVING">Saving Settings</span>\n                                <span ng-show="isSaving() == SAVING_STATES.SAVED">Settings Saved Successfully</span>\n                                <span ng-show="isSaving() == SAVING_STATES.RESTORING">Restoring Default Settings</span>\n                            </div>\n                            \n                            <h1>{{ menuItem.title }}</h1>\n                            \n                            <div class="settings-tabs-container"> \n                                <div ng-repeat="tab in menuItem.items" \n                                     class="settings-tab" \n                                     ng-class="{\'setting-active\': selectedTab.name == tab.tabName }" \n                                     ng-click="switchTab(tab.tabName, $index)"\n                                     ng-bind="tab.title">\n                                </div>     \n                            </div>\n                            \n                            TABS_TEMPLATE_HERE\n                            \n                            \n                            <div class="save-footer">\n                                <div class="save-button settingsButton blueButton" ng-click="save()">Save</div>\n                                <div class="defaults-button settingsButton whiteButton" ng-click="restore()">Restore Defaults</div>\n                            </div>\n                            \n                        </div>';

        return {
            restrict: 'E',
            controller: controllerFunction,
            link: linkFunction,
            scope: {
                selectedTab: '=',
                menuItem: '='
            },
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('Highlight', []).directive('highlight', highlight);

    function highlight() {

        function link(scope) {
            scope.domId = Math.random().toString().replace('.', '');
        }

        function controller($scope) {

            setTimeout(function () {
                return angular.element('#' + $scope.domId).html($scope.content);
            }, 10);

            // check for changes in the search pattern and generate new DOM
            $scope.$watch('search', function (newValue, oldValue) {

                if (newValue == oldValue) {
                    return;
                }

                if (!newValue) {
                    setTimeout(function () {
                        return angular.element('#' + $scope.domId).html($scope.content);
                    }, 10);
                    return;
                }

                var indexOf = $scope.content.toLowerCase().indexOf(newValue.toLowerCase());

                if (indexOf > -1) {

                    var matchedLength = newValue.length;

                    var domString = '' + $scope.content.substring(0, indexOf);
                    domString += '<span style="background: #' + $scope.color + '">' + $scope.content.substr(indexOf, matchedLength) + '</span>';
                    domString += '' + $scope.content.substring(matchedLength + indexOf);

                    setTimeout(function () {
                        return angular.element('#' + $scope.domId).html(domString);
                    }, 10);
                } else {
                    setTimeout(function () {
                        return angular.element('#' + $scope.domId).html($scope.content);
                    }, 10);
                }
            });
        }

        controller.$inject = ['$scope'];

        return {
            restrict: 'E',
            scope: {
                color: '@',
                content: '=',
                search: '='
            },
            link: link,
            controller: controller,
            template: '<span id="{{domId}}" />'
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('popUp', popUp);

    popUp.$inject = ['$document'];

    function popUp($document) {

        function link($scope) {
            function keyupHandler(keyEvent) {
                if (keyEvent.which == 27) $scope.onCancel();else if (keyEvent.which == 13) $scope.onSave();

                $scope.$apply();
            }

            $document.on('keyup', keyupHandler);
            $scope.$on('$destroy', function () {
                $document.off('keyup', keyupHandler);
            });
        }

        var template = '\n        <div class="popUpOverlay">\n            <div class="settingsPopup">\n                <div class="popupHeader">\n                    <h2 class="ng-binding">New scheduled job</h2>\n                </div>\n                <div class="popupContent" ng-transclude="mainContent"></div>\n                <div class="popUpButtons">\n                    <div class="settingsButton popUpButton blueButton" ng-click="onSave()">Save</div>\n                    <div class="settingsButton popUpButton whiteButton" ng-click="onCancel()">Cancel</div>\n                </div>\n            </div>\n        </div>\n        ';

        return {
            restrict: 'E',
            scope: {
                onSave: '&',
                onCancel: '&'
            },
            link: link,
            transclude: {
                mainContent: 'mainContent'
            },
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('tooltip', function () {
        return {
            restrict: 'E',
            transclude: true,
            template: '<div class="helpIconSettingsShai">?</div><div class="tooltipBaloon"><ng-transclude></ng-transclude></div>'
        };
    });
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('uiError', uiError);

    uiError.$inject = [];

    function uiError() {

        var template = '<div class="settingsError">\n                          <span ng-transclude="mainContent"></span>\n                        </div>';

        return {
            restrict: 'E',
            scope: {},
            link: function link(scope) {},
            transclude: {
                mainContent: 'mainContent'
            },
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('dataService', dataService);

    dataService.$inject = ['settingsUtils', '$filter', '$timeout', 'SAVING_STATES', '$rootScope', '$q'];

    function dataService(settingsUtils, $filter, $timeout, SAVING_STATES, $rootScope, $q) {

        var problematicCSTransformedToArray = ['GeocodeSettings', 'AppointmentBookingSettings', 'DripFeedConfig', 'EmergencySettings', 'LogicSettings', 'OptimizationSettingsRSO', 'OptimizationSettingsBGO'];

        var lastFetchedSettings = null,
            draftSettings = {},
            settingsPromise = null,
            isSettingsDirty = false,
            saving = SAVING_STATES.NOT_SAVING;

        // get all settings object
        function getSettings() {
            var deferred = $q.defer();

            settingsUtils.callRemoteAction(remoteActions.getAllSettings).then(function (allSettingsObject) {
                for (var i = 0; i < problematicCSTransformedToArray.length; i++) {
                    transformArrayInObjectToSingle(allSettingsObject, problematicCSTransformedToArray[i]);
                }

                moment.locale(allSettingsObject.UserLocale);
                lastFetchedSettings = allSettingsObject;
                angular.merge(draftSettings, allSettingsObject);
                //console.log(allSettingsObject);
                createFormulaAndPoliciesOptionsArray();
                deferred.resolve();
            }).catch(function (res) {
                $rootScope.$broadcast('PermissionsMissing', deferred);
            });

            return deferred.promise;
        }

        function transformArrayInObjectToSingle(object, propertyName) {
            if (object[propertyName] && object[propertyName].length > 0) object[propertyName] = object[propertyName][0];else object[propertyName] = null;
        }

        function transformPropertyToArrayInObject(object, propertyName) {
            if (object[propertyName]) object[propertyName] = [object[propertyName]];else object[propertyName] = null;
        }

        function getSLRDirty() {
            return lastFetchedSettings && !angular.equals(draftSettings.LogicSettings[fieldNames.Logic_Settings__c.Use_SLR__c], lastFetchedSettings.LogicSettings[fieldNames.Logic_Settings__c.Use_SLR__c]);
        }

        function setOriginal() {
            angular.copy(lastFetchedSettings, draftSettings);
            isSettingsDirty = false;
            $rootScope.$broadcast('settingsUpdated');
        }

        function createFormulaAndPoliciesOptionsArray() {
            service.serviceBooleanFields = [];
            for (var formulaApiName in draftSettings.ServiceCheckboxFields) {
                service.serviceBooleanFields.push({
                    value: formulaApiName,
                    label: draftSettings.ServiceCheckboxFields[formulaApiName]
                });
            }

            service.serviceBooleanFields = $filter('orderBy')(service.serviceBooleanFields, 'label');
            service.serviceBooleanFields.unshift({
                value: null,
                label: 'None'
            });

            service.woBooleanFields = [];
            for (var _formulaApiName in draftSettings.WoCheckboxFields) {
                service.woBooleanFields.push({
                    value: _formulaApiName,
                    label: draftSettings.WoCheckboxFields[_formulaApiName]
                });
            }

            service.woBooleanFields = $filter('orderBy')(service.woBooleanFields, 'label');
            service.woBooleanFields.unshift({
                value: null,
                label: 'None'
            });

            service.woliBooleanFields = [];
            for (var _formulaApiName2 in draftSettings.WoliCheckboxFields) {
                service.woliBooleanFields.push({
                    value: _formulaApiName2,
                    label: draftSettings.WoliCheckboxFields[_formulaApiName2]
                });
            }

            service.woliBooleanFields = $filter('orderBy')(service.woliBooleanFields, 'label');
            service.woliBooleanFields.unshift({
                value: null,
                label: 'None'
            });

            service.policies = [];
            for (var i = 0; i < draftSettings.Policies.length; i++) {
                service.policies.push({
                    value: draftSettings.Policies[i].Id,
                    label: draftSettings.Policies[i].Name
                });
            }

            service.operatingHours = [];
            for (var _i = 0; _i < draftSettings.OperatingHours.length; _i++) {
                service.operatingHours.push({
                    value: draftSettings.OperatingHours[_i].Id,
                    label: draftSettings.OperatingHours[_i].Name
                });
            }

            service.serviceDateFields = [];
            service.serviceDoubleFields = [];
            service.serviceIntegerFields = [];
            service.serviceStringFields = [];

            for (var _formulaApiName3 in draftSettings.ServiceDateFields) {
                service.serviceDateFields.push({
                    value: _formulaApiName3,
                    label: draftSettings.ServiceDateFields[_formulaApiName3]
                });
            }

            for (var _formulaApiName4 in draftSettings.ServiceDoubleFields) {
                service.serviceDoubleFields.push({
                    value: _formulaApiName4,
                    label: draftSettings.ServiceDoubleFields[_formulaApiName4]
                });
            }

            for (var _formulaApiName5 in draftSettings.ServiceIntegerFields) {
                service.serviceIntegerFields.push({
                    value: _formulaApiName5,
                    label: draftSettings.ServiceIntegerFields[_formulaApiName5]
                });
            }

            for (var _formulaApiName6 in draftSettings.ServiceStringFields) {
                service.serviceStringFields.push({
                    value: _formulaApiName6,
                    label: draftSettings.ServiceStringFields[_formulaApiName6]
                });
            }

            service.resourceCheckboxFields = [];
            service.resourceDateFields = [];
            service.resourceDoubleFields = [];
            service.resourceIntegerFields = [];
            service.resourceStringFields = [];

            for (var _formulaApiName7 in draftSettings.ResourceCheckboxFields) {
                service.resourceCheckboxFields.push({
                    value: _formulaApiName7,
                    label: draftSettings.ResourceCheckboxFields[_formulaApiName7]
                });
            }

            for (var _formulaApiName8 in draftSettings.ResourceDateFields) {
                service.resourceDateFields.push({
                    value: _formulaApiName8,
                    label: draftSettings.ResourceDateFields[_formulaApiName8]
                });
            }

            for (var _formulaApiName9 in draftSettings.ResourceDoubleFields) {
                service.resourceDoubleFields.push({
                    value: _formulaApiName9,
                    label: draftSettings.ResourceDoubleFields[_formulaApiName9]
                });
            }

            for (var _formulaApiName10 in draftSettings.ResourceIntegerFields) {
                service.resourceIntegerFields.push({
                    value: _formulaApiName10,
                    label: draftSettings.ResourceIntegerFields[_formulaApiName10]
                });
            }

            for (var _formulaApiName11 in draftSettings.ResourceStringFields) {
                service.resourceStringFields.push({
                    value: _formulaApiName11,
                    label: draftSettings.ResourceStringFields[_formulaApiName11]
                });
            }

            service.woNumberFields = [];
            service.woliNumberFields = [];

            for (var _formulaApiName12 in draftSettings.WoNumberFields) {
                service.woNumberFields.push({
                    value: _formulaApiName12,
                    label: draftSettings.WoNumberFields[_formulaApiName12]
                });
            }

            service.woNumberFields.unshift({
                value: null,
                label: 'None'
            });

            for (var _formulaApiName13 in draftSettings.WoliNumberFields) {
                service.woliNumberFields.push({
                    value: _formulaApiName13,
                    label: draftSettings.WoliNumberFields[_formulaApiName13]
                });
            }

            service.woliNumberFields.unshift({
                value: null,
                label: 'None'
            });
        }

        function saveSettings(settings) {

            // don't allow double saving
            if (saving === SAVING_STATES.SAVING /*|| !isSettingsDirty*/) {
                    return;
                }

            settings = angular.copy(settings);

            // convert numbers to strings
            if (settings.GeneralConfig) {
                for (var key in settings.GeneralConfig) {
                    if (angular.isNumber(settings.GeneralConfig[key][fieldNames.General_Config__c.Value__c])) {
                        settings.GeneralConfig[key].Value__c = settings.GeneralConfig[key][fieldNames.General_Config__c.Value__c].toString();
                    }
                }
            }

            for (var i = 0; i < problematicCSTransformedToArray.length; i++) {
                transformPropertyToArrayInObject(settings, problematicCSTransformedToArray[i]);
            }

            saving = SAVING_STATES.SAVING;
            document.getElementById('SettingsForm').scrollTop = 0;

            return settingsUtils.callRemoteAction(remoteActions.saveSettings, [settings]).then(function (updatedSettings) {
                for (var i = 0; i < problematicCSTransformedToArray.length; i++) {
                    transformArrayInObjectToSingle(updatedSettings, problematicCSTransformedToArray[i]);
                }

                saving = SAVING_STATES.SAVED;
                isSettingsDirty = false;

                // update settings objects
                lastFetchedSettings = updatedSettings;
                angular.copy(updatedSettings, draftSettings);
                draftSettings.DeletedAutomators.length = 0;
                console.log(updatedSettings);

                $rootScope.$broadcast('settingsUpdated');
            }).catch(function () {
                console.error('%cError saving, kolodner was notified ¯\\_(ツ)_/¯', 'background:#353535;color:#7ff734; padding: 5px');
            }).finally(function () {
                $timeout(function () {
                    return saving = SAVING_STATES.NOT_SAVING;
                }, 3500);
            });
        }

        function restoreDefaultSettings(settings) {

            // don't allow double saving
            if (saving === SAVING_STATES.SAVING || saving === SAVING_STATES.RESTORING) {
                return;
            }

            settings = angular.copy(settings);

            for (var i = 0; i < problematicCSTransformedToArray.length; i++) {
                transformPropertyToArrayInObject(settings, problematicCSTransformedToArray[i]);
            }

            saving = SAVING_STATES.RESTORING;
            document.getElementById('SettingsForm').scrollTop = 0;

            return settingsUtils.callRemoteAction(remoteActions.restoreDefaultSettings, [settings]).then(function (updatedSettings) {

                for (var i = 0; i < problematicCSTransformedToArray.length; i++) {
                    transformArrayInObjectToSingle(updatedSettings, problematicCSTransformedToArray[i]);
                }

                saving = SAVING_STATES.SAVED;
                isSettingsDirty = false;

                // update settings objects
                lastFetchedSettings = updatedSettings;
                angular.copy(updatedSettings, draftSettings);

                $rootScope.$broadcast('settingsUpdated');
            }).catch(function () {
                console.error('error restoring to defaults');
            }).finally(function () {
                $timeout(function () {
                    return saving = SAVING_STATES.NOT_SAVING;
                }, 3500);
            });
        }

        function getAutomators(className) {
            var results = [];
            for (var automatorName in draftSettings.AutomatorConfig) {
                var automator = draftSettings.AutomatorConfig[automatorName];

                if (automator[fieldNames.Automator_Config__c.Class_Name__c] == className) results.push(automator);
            }

            return results;
        }

        function getAutomatorsMap(className) {
            var arr = getAutomators(className);
            var res = {};

            for (var i = 0; i < arr.length; i++) {
                res[arr[i].Name] = arr[i];
            }

            return res;
        }

        function deleteAutomators(className) {
            for (var automatorName in draftSettings.AutomatorConfig) {
                var automator = draftSettings.AutomatorConfig[automatorName];

                if (automator[fieldNames.Automator_Config__c.Class_Name__c] == className) delete draftSettings.AutomatorConfig[automatorName];
            }
        }

        settingsPromise = getSettings();

        // set settings as dirty
        function setDirty() {
            isSettingsDirty = true;
        }

        settingDescriptor.prototype.setDirty = function () {
            setDirty();
            this.dirty = true;
        };

        // service object
        var service = {
            getDraftSettings: function getDraftSettings() {
                return draftSettings;
            },
            getSettingsPromise: function getSettingsPromise() {
                return settingsPromise;
            },
            getSLRDirty: getSLRDirty,
            getAutomators: getAutomators,
            getAutomatorsMap: getAutomatorsMap,
            deleteAutomators: deleteAutomators,
            setDirty: setDirty,
            saveSettings: saveSettings,
            restoreDefaultSettings: restoreDefaultSettings,
            isDirty: function isDirty() {
                return lastFetchedSettings && !angular.equals(draftSettings, lastFetchedSettings) /* || isSettingsDirty*/;
            },
            isSaving: function isSaving() {
                return saving;
            },
            setOriginal: setOriginal
        };

        return service;
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('globalActionsService', globalActionsService);

    globalActionsService.$inject = ['dataService'];

    function globalActionsService(dataService) {

        var objectMappings = {};

        return {
            save: function save() {

                var objectMappingsArray = [],
                    deletedObjectsArray = [],
                    deletedObjects = dataService.getDraftSettings().DeletedMappings;

                for (var key in objectMappings) {
                    objectMappingsArray.push(angular.copy(objectMappings[key]));
                    delete objectMappingsArray[objectMappingsArray.length - 1].isOpen;
                }

                deletedObjects.forEach(function (item) {
                    deletedObjectsArray.push(angular.copy(item));
                    delete deletedObjectsArray[deletedObjectsArray.length - 1].isOpen;
                });

                return dataService.saveSettings({
                    EmergencySettings: dataService.getDraftSettings().EmergencySettings,
                    AppointmentBookingSettings: dataService.getDraftSettings().AppointmentBookingSettings,
                    ObjectMapping: objectMappingsArray,
                    deletedMappings: deletedObjectsArray
                }).then(function () {
                    dataService.getDraftSettings().DeletedMappings.length = 0;
                });
            },
            restore: function restore() {
                return dataService.restoreDefaultSettings({
                    EmergencySettings: dataService.getDraftSettings().EmergencySettings,
                    AppointmentBookingSettings: dataService.getDraftSettings().AppointmentBookingSettings,
                    ObjectMapping: []
                });
            },
            loadData: function loadData() {
                return console.info('globalActionsService - Loading settings');
            },
            objectMappings: objectMappings,
            deletedMappings: function deletedMappings() {
                return dataService.getDraftSettings().DeletedMappings;
            }
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').constant('OPTIMIZATION_RUNTIME_VALUES', {
        LOW: 1,
        MEDIUM: 2,
        HIGH: 3
    });
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('optimizationService', optimizationService);

    optimizationService.$inject = ['$q', 'dataService', 'OPTIMIZATION_RUNTIME_VALUES'];

    function optimizationService($q, dataService, OPTIMIZATION_RUNTIME_VALUES) {

        // get all object names
        function getAllObjects() {

            var deferred = $q.defer(),
                result = sforce.connection.describeGlobal().sobjects;

            if (result) {
                deferred.resolve(result);
            } else {
                deferred.reject("fields not found");
            }

            return deferred.promise;
        }

        function save() {
            return dataService.saveSettings({
                OptimizationSettingsBGO: dataService.getDraftSettings().OptimizationSettingsBGO,
                OptimizationSettingsRSO: dataService.getDraftSettings().OptimizationSettingsRSO,
                SoFieldsMapping: dataService.getDraftSettings().SoFieldsMapping,
                // need all 3 for automators to save
                AutomatorConfig: dataService.getAutomatorsMap('Sched004_OAAS'),
                DeletedAutomators: dataService.getDraftSettings().DeletedAutomators,
                Territories: dataService.getDraftSettings().Territories,
                TriggerConfigurations: {
                    'Enable req overlaps prevention': dataService.getDraftSettings().TriggerConfigurations['Enable req overlaps prevention'],
                    'Enable optimization failure': dataService.getDraftSettings().TriggerConfigurations['Enable optimization failure'],
                    'Enable sharing for Optimization': dataService.getDraftSettings().TriggerConfigurations['Enable sharing for Optimization']
                }
            });
        }

        function restore() {
            var RestoreOptimizationSettingsRSO = ['Pinned_Statuses__c'];

            var RestoreOptimizationSettingsBGO = ['Pinned_Statuses__c'];

            // only if value is low, med or high - restore to default.
            if (Object.values(OPTIMIZATION_RUNTIME_VALUES).indexOf(dataService.getDraftSettings().OptimizationSettingsBGO[fieldNames.OptimizationSettings__c.Max_Runtime_Single_Service__c]) > -1) RestoreOptimizationSettingsBGO.push('Max_Runtime_Single_Service__c');

            return dataService.restoreDefaultSettings({
                RestoreOptimizationSettingsRSO: RestoreOptimizationSettingsRSO,
                RestoreOptimizationSettingsBGO: RestoreOptimizationSettingsBGO,
                OptimizationSettingsBGO: dataService.getDraftSettings().OptimizationSettingsBGO,
                OptimizationSettingsRSO: dataService.getDraftSettings().OptimizationSettingsRSO,
                SoFieldsMapping: dataService.getDraftSettings().SoFieldsMapping,
                RestoreAutomatorSettings: ['Sched004_OAAS'],
                TriggerConfigurations: {
                    'Enable req overlaps prevention': {}, 'Enable optimization failure': {}, 'Enable sharing for Optimization': {}
                }
            });
        }

        function serviceReferenceProperties(objectName) {

            var deferred = $q.defer();

            var result = sforce.connection.describeSObject(objectName);
            if (result.fields) {
                deferred.resolve(result);
            } else {
                deferred.reject("fields not found");
            }
            return deferred.promise;
        }

        return {
            save: save,
            restore: restore,
            loadData: function loadData() {
                return console.info('optimizationService - Loading settings');
            },
            getAllObjects: getAllObjects,
            serviceReferenceProperties: serviceReferenceProperties
        };
    }
})();
'use strict';

(function () {

	angular.module('SettingsApp').constant('primitiveType', {
		boolean: '0',
		number: '1',
		text: '2',
		picklist: '3',
		multi: '4',
		booleanText: '5',
		autoComplete: '6'
	});
})();
'use strict';

(function () {

    angular.module('SettingsApp').constant('SAVING_STATES', {
        NOT_SAVING: 0,
        SAVING: 1,
        SAVED: 2,
        RESTORING: 3
    });
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('schedulingService', schedulingService);

    schedulingService.$inject = ['settingsUtils', 'dataService'];

    function schedulingService(settingsUtils, dataService) {

        var loadDataPromise = null;

        function restore() {
            var automatorConfig = ['Sched009_STMIntegrityChecker'];

            if (dataService.getDraftSettings().LogicSettings.Use_SLR__c) {
                automatorConfig.push('Sched006_SLRPurge');
            }

            return dataService.restoreDefaultSettings({
                TriggerConfigurations: {
                    'Travel Time': {},
                    'Wait for clean state': {},
                    'Enable Dynamic Gantt Fix Overlaps': {}
                },
                GeneralConfig: {
                    'Map available on gantt': {},
                    'Show SLR in resource map': {}
                },
                RestoreLogicSettings: ['Fail_On_Schedule__c', 'Travel_Speed__c', 'MDT_Boolean_Field__c', 'WO_Priority_Field__c', 'WOLI_Priority_Field__c', 'Travel_Speed_Unit__c', 'Search_slot_max_days__c', 'Pinned_Statuses_SF__c', 'Enable_Start_Of_Day__c', 'Use_New_MST_Data_Model__c', 'Approved_Absences__c', 'Enable_Crew_Members_Skill_Aggregation__c', 'Include_Secondary_Calendar__c', 'Limit_Apex_Operations__c'],
                RestoreGeocodeSettings: ['Alert_On_Callout_Failure__c'],
                LogicSettings: dataService.getDraftSettings().LogicSettings,
                ApexLimits: dataService.getDraftSettings().ApexLimits,
                GeocodeSettings: dataService.getDraftSettings().GeocodeSettings,
                ServiceOnCreationValidations: dataService.getDraftSettings().ServiceOnCreationValidations,
                DynamicGanttSettings: dataService.getDraftSettings().DynamicGanttSettings,
                RestoreAutomatorSettings: automatorConfig
            });
        }

        var service = {
            save: function save() {
                var automatorConfig = dataService.getAutomatorsMap('Sched009_STMIntegrityChecker');
                if (dataService.getDraftSettings().LogicSettings[fieldNames.Logic_Settings__c.Use_SLR__c]) {
                    automatorConfig = angular.merge(automatorConfig, dataService.getAutomators('Sched006_SLRPurge'));
                }

                return dataService.saveSettings({

                    ApexLimits: dataService.getDraftSettings().ApexLimits,

                    GeneralConfig: {
                        'Map available on gantt': dataService.getDraftSettings().GeneralConfig['Map available on gantt'],
                        'Show SLR in resource map': dataService.getDraftSettings().GeneralConfig['Show SLR in resource map'],
                        'Hide Integrity Checker Automator': dataService.getDraftSettings().GeneralConfig['Hide Integrity Checker Automator']
                    },

                    LogicSettings: dataService.getDraftSettings().LogicSettings,
                    GeocodeSettings: dataService.getDraftSettings().GeocodeSettings,
                    ServiceOnCreationValidations: dataService.getDraftSettings().ServiceOnCreationValidations,
                    DynamicGanttSettings: dataService.getDraftSettings().DynamicGanttSettings,
                    TriggerConfigurations: {
                        'Travel Time': dataService.getDraftSettings().TriggerConfigurations['Travel Time'],
                        'Wait for clean state': dataService.getDraftSettings().TriggerConfigurations['Wait for clean state'],
                        'Enable Dynamic Gantt Fix Overlaps': dataService.getDraftSettings().TriggerConfigurations['Enable Dynamic Gantt Fix Overlaps'],
                        'Enable Service Auto Classification': dataService.getDraftSettings().TriggerConfigurations['Enable Service Auto Classification']
                    },
                    // need all 3 for automators to save
                    AutomatorConfig: automatorConfig,
                    DeletedAutomators: dataService.getDraftSettings().DeletedAutomators,
                    Territories: dataService.getDraftSettings().Territories
                });
            },
            restore: restore,
            loadData: function loadData() {
                if (loadDataPromise) return loadDataPromise;

                loadDataPromise = settingsUtils.callRemoteAction(remoteActions.schedulingLoadData).then(function (res) {
                    service.settings = res;
                });

                return loadDataPromise;
            }
        };

        return service;
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('serviceAppointmentLifeCycleService', serviceAppointmentLifeCycleService);

    serviceAppointmentLifeCycleService.$inject = ['dataService', 'settingsUtils', '$rootScope'];

    function serviceAppointmentLifeCycleService(dataService, settingsUtils, $rootScope) {
        var prom = null;
        var transitionsValid = true;
        var errorMessage = "Error saving status transitions:\n";

        function checkAllFlows() {
            transitionsValid = true;
            errorMessage = "Error saving status transitions:\n";
            var cloned = dataService.getDraftSettings().ServiceLegalStatuses.slice(0).sort(sortByName);

            for (var i = 0; i < cloned.length; i++) {

                // is from == to?
                if (cloned[i][fieldNames.statusTransitions.From_Status__c] === cloned[i][fieldNames.statusTransitions.To_Status__c]) {
                    transitionsValid = false;
                    errorMessage += 'From & To cannot be equal - ' + cloned[i][fieldNames.statusTransitions.From_Status__c] + ' \n';
                }

                // is duplicate?
                if (i == cloned.length - 1) break;

                if (cloned[i][fieldNames.statusTransitions.From_Status__c] === cloned[i + 1][fieldNames.statusTransitions.From_Status__c] && cloned[i][fieldNames.statusTransitions.To_Status__c] === cloned[i + 1][fieldNames.statusTransitions.To_Status__c]) {
                    transitionsValid = false;
                    errorMessage += 'Duplicate transition - ' + cloned[i][fieldNames.statusTransitions.From_Status__c] + ' -> ' + cloned[i][fieldNames.statusTransitions.To_Status__c] + ' \n';
                }
            }

            return transitionsValid;
        }

        function sortByName(a, b) {
            if (a.Name < b.Name) return -1;
            if (a.Name > b.Name) return 1;
            return 0;
        }

        var instance = {
            settings: {},
            save: function save() {

                dataService.getDraftSettings().ServiceLegalStatuses = dataService.getDraftSettings().ServiceLegalStatuses.map(function (statusTransition) {
                    statusTransition.Name = statusTransition[fieldNames.statusTransitions.From_Status__c] + '-' + statusTransition[fieldNames.statusTransitions.To_Status__c];
                    if (statusTransition.Name.length > 37) {
                        statusTransition.Name = statusTransition.Name.substr(0, 22) + Date.now();
                    }

                    delete statusTransition.Id;
                    return statusTransition;
                });

                if (!checkAllFlows()) {
                    $rootScope.$broadcast('transitionsError', { msg: errorMessage });
                    //alert(errorMessage);
                    return;
                } else {
                    $rootScope.$broadcast('transitionsError', { msg: null });
                }

                return dataService.saveSettings({
                    TriggerConfigurations: {
                        'Service Type Derive Due Date': dataService.getDraftSettings().TriggerConfigurations['Service Type Derive Due Date'],
                        'Pinned Service Not Changed': dataService.getDraftSettings().TriggerConfigurations['Pinned Service Not Changed'],
                        'Service Duration Longer Than Minute': dataService.getDraftSettings().TriggerConfigurations['Service Duration Longer Than Minute'],
                        'Enable Service Auto Classification': dataService.getDraftSettings().TriggerConfigurations['Enable Service Auto Classification']
                    },
                    Dictionaries: dataService.getDraftSettings().Dictionaries,
                    LogicSettings: dataService.getDraftSettings().LogicSettings,
                    ServiceLegalStatuses: dataService.getDraftSettings().ServiceLegalStatuses,
                    GeneralConfig: {
                        'Status Transitions Policy': dataService.getDraftSettings().GeneralConfig['Status Transitions Policy']
                    }
                });
            },
            restore: function restore() {
                return dataService.restoreDefaultSettings({
                    TriggerConfigurations: {
                        'Service Type Derive Due Date': {},
                        'Pinned Service Not Changed': {},
                        'Service Duration Longer Than Minute': {},
                        'Enable Service Auto Classification': {}
                    },
                    RestoreLogicSettings: ['Low_Or_High_Territory_Classification__c'],
                    Dictionaries: dataService.getDraftSettings().Dictionaries,
                    GeneralConfig: {
                        'Status Transitions Policy': {}
                    },
                    LogicSettings: dataService.getDraftSettings().LogicSettings,
                    ServiceLegalStatuses: dataService.getDraftSettings().ServiceLegalStatuses
                });
            },
            loadData: function loadData() {
                if (prom) return prom;

                prom = settingsUtils.callRemoteAction(remoteActions.ServiceLifeCycle.LoadData).then(function (res) {
                    instance.settings = res;
                });

                return prom;
            }
        };

        return instance;
    };
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('settingsUtils', settingsUtils);

    settingsUtils.$inject = ['$q'];

    function settingsUtils($q) {

        function callRemoteAction(functionName, paramsArray) {
            paramsArray = paramsArray || [];
            var deferred = $q.defer();
            paramsArray.unshift(functionName);
            paramsArray.push(function (result, event) {
                if (event.status) {
                    deferred.resolve(result);
                } else {
                    deferred.reject(event);
                }
            });
            paramsArray.push({ buffer: false, escape: false, timeout: 120000 });
            Visualforce.remoting.Manager.invokeAction.apply(Visualforce.remoting.Manager, paramsArray);
            return deferred.promise;
        }

        function outOfRange(value, low, max) {
            return value < low || max < value;
        }

        return {
            callRemoteAction: callRemoteAction,
            outOfRange: outOfRange
        };
    }
})();
"use strict";

function ObjectMapping(name, label) {
    var sobject = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};


    for (var field in fieldNames.ObjectMapping__c) {
        this[fieldNames.ObjectMapping__c[field]] = sobject[fieldNames.ObjectMapping__c[field]] || null;
    }

    this.Id = sobject.Id || null;

    this.Name = name;
    this[fieldNames.ObjectMapping__c.label__c] = label;
    this.isOpen = false;
}
"use strict";

function booleanDescriptor(sobject) {
    settingDescriptor.call(this, sobject);
}

booleanDescriptor.prototype = Object.create(settingDescriptor.prototype);
"use strict";

function booleanTextDescriptor(sobject, booleanValue) {
    settingDescriptor.call(this, sobject);

    this.booleanValue = booleanValue;
}

booleanTextDescriptor.prototype = Object.create(settingDescriptor.prototype);

booleanTextDescriptor.prototype.setValue = function () {
    this.value = this.booleanValue ? "1" : "0";
};
"use strict";

function multiPicklistDescriptor(sobject) {
    settingDescriptor.call(this, sobject);
    this.options = sobject.options;
    this.value = this.value;
}

multiPicklistDescriptor.prototype = Object.create(settingDescriptor.prototype);
"use strict";

function numberDescriptor(sobject, min, max) {
    settingDescriptor.call(this, sobject);

    this.min = sobject.min || min || 0;
    this.max = sobject.max || max || 0;
}

numberDescriptor.prototype = Object.create(settingDescriptor.prototype);
"use strict";

function picklistDescriptor(sobject) {
    settingDescriptor.call(this, sobject);
    this.options = sobject.options;
    this.value = this.value || this.options[0] && this.options[0].value || null;
}

picklistDescriptor.prototype = Object.create(settingDescriptor.prototype);
"use strict";

// pass sobject with value/label or directly add label/value

function picklistOption(sobjectOrLabel, value) {

    if (value) {
        this.label = sobjectOrLabel;
        this.value = value;
    } else {
        this.value = sobjectOrLabel.value;
        this.label = sobjectOrLabel.label;
    }
}
'use strict';

function settingDescriptor(sobject) {
    this.id = 'settingDescriptor' + (Math.random() * 10000000000000000).toString();
    this.label = sobject.label;
    this.value = sobject.value;
    this.dirty = false;
    this.customSettingType = sobject.type;
}
"use strict";

function textDescriptor(sobject) {
    settingDescriptor.call(this, sobject);
}

textDescriptor.prototype = Object.create(settingDescriptor.prototype);
'use strict';

(function () {

    angular.module('SettingsApp').directive('autoComplete', autoComplete);

    autoComplete.$inject = ['$q', 'settingsUtils'];

    function autoComplete($q, settingsUtils) {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {
            $scope.setDirty = function () {
                return $scope.object.dirty = true;
            };

            $scope.innerGetSuggestions = function (val) {
                return $scope.getSuggestions({ inputValue: val });
            };

            $scope.innerFilterInput = function (val) {
                return $scope.filterInput({ inputValue: val });
            };
        }

        var template = '<div class="setting-row-container">\n                            <label class="select-label" for="{{object.id}}">\n                                {{ object.label }} <tooltip ng-if="tooltipText">{{tooltipText}}</tooltip>\n                            </label>\n                            <div class="select-container autoCompleteContainer">\n                                <input typeahead-editable="false" \n                                        typeahead-input-formatter="innerFilterInput($model)" \n                                        uib-typeahead="suggestion for suggestion in innerGetSuggestions($viewValue)" \n                                        typeahead-min-length="2" \n                                        typeahead-wait-ms="200" \n                                        id="{{object.id}}" \n                                        type="text" class="input-settings" \n                                        ng-model="object.value" \n                                        ng-change="object.setDirty()" />\n                            </div>\n                        </div>';

        return {
            restrict: 'E',
            scope: {
                object: '=',
                tooltip: '@',
                getSuggestions: '&',
                filterInput: '&'
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('booleanSetting', booleanSetting);

    booleanSetting.$inject = [];

    function booleanSetting() {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {
            $scope.setDirty = function () {
                return $scope.object.dirty = true;
            };
        }

        var template = '<div class="setting-row-container">\n                            <label for="{{object.id}}" class="select-label">\n                                {{ object.label }} <tooltip ng-if="tooltipText">{{tooltipText}}</tooltip> <beta-feature ng-if="isBeta"></beta-feature>\n                            </label>\n                            <div class="select-container">\n                                <input ng-disabled="isDisabled" id="{{object.id}}" type="checkbox" ng-model="object.value" ng-change="object.setDirty()" />\n                            </div>\n                        </div>';

        return {
            restrict: 'E',
            scope: {
                object: '=',
                tooltipText: '@',
                isDisabled: '=',
                isBeta: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('booleanTextSetting', booleanTextSetting);

    booleanTextSetting.$inject = [];

    function booleanTextSetting() {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {
            $scope.setDirty = function () {
                return $scope.object.dirty = true;
            };
        }

        var template = '<div class="setting-row-container">\n                            <label for="{{object.id}}" class="select-label">\n                                {{ object.label }} <tooltip ng-if="tooltipText">{{tooltipText}}</tooltip>\n                            </label>\n                            <div class="select-container">\n                                <input id="{{object.id}}" ng-disabled="isDisabled" type="checkbox" ng-model="object.booleanValue" ng-change="object.setDirty(); object.setValue()" />\n                            </div>\n                        </div>';

        return {
            restrict: 'E',
            scope: {
                object: '=',
                isDisabled: '=',
                tooltipText: '@'
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('multiPicklistSetting', multiPicklistSetting);

    multiPicklistSetting.$inject = [];

    function multiPicklistSetting() {

        controllerFunction.$inject = ['$scope', '$rootScope'];

        function controllerFunction($scope, $rootScope) {
            $scope.setDirty = function () {
                return $scope.object.dirty = true;
            };
            $scope.showDrop = false;

            // valueType - string - can be 'string', 'object', 'array'
            $scope.optionClicked = function (option, valueType) {
                var optionsArray = typeof $scope.object.value == 'string' ? $scope.object.value.split(',') : $scope.object.value;
                var options = {};

                if (!optionsArray) {
                    optionsArray = [];
                }

                for (var i = 0; i < optionsArray.length; i++) {
                    options[optionsArray[i]] = true;
                }

                //remove if exists
                if (options[option]) delete options[option];else options[option] = true;

                delete options[''];

                switch (valueType) {
                    case 'string':
                        $scope.object.value = Object.keys(options).toString();
                        break;
                    case 'array':
                        $scope.object.value = Object.keys(options);
                        break;
                    case 'object':
                        $scope.object.value = options;

                }
            };

            $rootScope.$on('closeAllOthers', function (ev, args) {
                if ($scope.$parent.setting.Name != args.status.Name) $scope.showDrop = false;
            });
        }

        var template = '<div class="setting-row-container">\n                            <label class="select-label" for="{{object.id}}" ng-if="object.label">\n                                {{ object.label }}\n                            </label>\n                            <div class="select-container">\n                                <div class="select-setting" ng-click="showDrop = !showDrop;">\n                                    {{ placeholder }}\n                                </div>\n                                <ul class="multi-dropdown" ng-show="showDrop">\n                                    <li class="single-dropdown-item" ng-repeat="option in object.options track by $index" ng-click="optionClicked(option.Id, \'string\')">\n                                        <svg aria-hidden="true" class="check-icon" ng-show="object.value.indexOf(option.Id) > -1">\n                                            \u2028<use xlink:href="' + settings.icons.check + '"></use>\n                                        \u2028</svg>\n                                        {{option.Name}}\n                                    </li>\n                                </ul>\n                            </div>\n                        </div>';

        return {
            restrict: 'E',
            scope: {
                object: '=',
                placeholder: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('numberSetting', numberSetting);

    numberSetting.$inject = [];

    function numberSetting() {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {
            $scope.setDirty = function () {
                return $scope.object.dirty = true;
            };

            $scope.$watch('object.value', function (newValue, oldValue) {
                if (newValue != oldValue && newValue === undefined) {
                    $scope.object.value = oldValue;
                }
            });
        }

        var template = '<div class="setting-row-container">\n                            <label for="{{object.id}}" class="select-label">\n                                {{ object.label }} <tooltip ng-if="tooltipText">{{tooltipText}}</tooltip>\n                            </label>\n                            <div class="select-container">\n                                <input id="{{object.id}}" type="number" min="{{ object.min }}" max="{{ object.max }}" class="input-settings" ng-model="object.value" ng-change="object.setDirty()" />\n                            </div>\n                        </div>';

        return {
            restrict: 'E',
            scope: {
                object: '=',
                tooltipText: '@'
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('picklistSetting', picklistSetting);

    picklistSetting.$inject = [];

    function picklistSetting() {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {
            $scope.setDirty = function () {
                return $scope.object.dirty = true;
            };

            $scope.validateOnChange = function (status) {
                $scope.object.setDirty();
                $scope.change && $scope.change();
            };
        }

        var template = '<div class="setting-row-container">\n                            <label class="select-label" for="{{object.id}}" ng-if="object.label">\n                                {{ object.label }} <tooltip ng-if="tooltipText">{{tooltipText}}</tooltip>\n                            </label>\n                            <div class="select-container">\n                                <select id="{{object.id}}" class="select-setting" ng-disabled="isDisabled" ng-model="object.value" ng-change="validateOnChange()" ng-options="option.value as option.label for option in object.options">\n                                    <option ng-if="isDisabled" value="" selected="isDisabled">Custom Configuration</option>\n                                </select>\n                            </div>\n                        </div>';

        return {
            restrict: 'E',
            scope: {
                object: '=',
                tooltipText: '@',
                isDisabled: '=',
                change: '&'
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('textSetting', textSetting);

    textSetting.$inject = [];

    function textSetting() {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {
            $scope.setDirty = function () {
                return $scope.object.dirty = true;
            };
        }

        var template = '<div class="setting-row-container">\n                            <label class="select-label" for="{{object.id}}">\n                                {{ object.label }} <tooltip ng-if="tooltipText">{{tooltipText}}</tooltip>\n                            </label>\n                            <div class="select-container">\n                                <input id="{{object.id}}" type="text" class="input-settings" ng-model="object.value" ng-change="object.setDirty()" />\n                            </div>\n                        </div>';

        return {
            restrict: 'E',
            scope: {
                object: '=',
                tooltipText: '@'
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('dispatchAutomation', dispatchAutomation);

    dispatchAutomation.$inject = [];

    function dispatchAutomation() {

        controllerFunction.$inject = ['$scope', 'dataService', 'primitiveType', '$rootScope'];

        function controllerFunction($scope, dataService, primitiveType, $rootScope) {
            $scope.primitiveType = primitiveType;
            $scope.settings = dataService.getDraftSettings();

            dataService.getSettingsPromise().then(function () {
                $scope.automators = dataService.getAutomators('Sched007_ServicesAppoDispatched');
            });

            $rootScope.$on('settingsUpdated', function () {
                $scope.automators = dataService.getAutomators('Sched007_ServicesAppoDispatched');
            });
        }

        var template = '\n            <custom-settings-wrapper id="__disschedjobs" primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Mention user on service dispatch\']"></custom-settings-wrapper>\n            <div class="automatorExp">Set recurring auto dispatch jobs</div>\n            <automators id="__automention" objects="automators" class-names="[\'Sched007_ServicesAppoDispatched\']"></automators>\n        ';

        return {
            restrict: 'E',
            scope: {
                formObject: '=',
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('dispatchDripFeed', dispatchDripFeed);

    dispatchDripFeed.$inject = [];

    function dispatchDripFeed() {

        controllerFunction.$inject = ['$scope', 'dataService', 'primitiveType'];

        function controllerFunction($scope, dataService, primitiveType) {
            $scope.primitiveType = primitiveType;
            $scope.verifyFunctions.push(function () {
                return console.log('verify - dispatchDripFeed');
            });
            $scope.settings = dataService.getDraftSettings();
        }

        var template = '\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Enable drip feed\'" value-field-name="\'Value__c\'" setting="settings.DripFeedConfig" tooltip-text="When this option is enabled, the Service Resource\u2019s subsequent Service Appointment(s) are dispatched as soon as the previous Service Appointment is completed."></custom-settings-wrapper>\n            <custom-settings-wrapper min="1" max="200" primitive-type="primitiveType.number" label="\'Number of Service Appointments to dispatch\'" value-field-name="\'Tasks_To_Dispatch__c\'" setting="settings.DripFeedConfig" tooltip-text="The number of subsequent Service Appointments that will be dispatched" ></custom-settings-wrapper>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('dispatchService', dispatchService);

    dispatchService.$inject = ['dataService'];

    function dispatchService(dataService) {

        return {
            save: function save() {
                return dataService.saveSettings({
                    TriggerConfigurations: {
                        'Mention user on service dispatch': dataService.getDraftSettings().TriggerConfigurations['Mention user on service dispatch']
                    },
                    DripFeedConfig: dataService.getDraftSettings().DripFeedConfig,
                    // need all 3 for automators to save
                    AutomatorConfig: dataService.getAutomatorsMap('Sched007_ServicesAppoDispatched'),
                    DeletedAutomators: dataService.getDraftSettings().DeletedAutomators,
                    Territories: dataService.getDraftSettings().Territories
                });
            },
            restore: function restore() {
                return dataService.restoreDefaultSettings({
                    TriggerConfigurations: {
                        'Mention user on service dispatch': {}
                    },
                    DripFeedConfig: dataService.getDraftSettings().DripFeedConfig,
                    RestoreAutomatorSettings: ['Sched007_ServicesAppoDispatched']
                });
            },
            loadData: function loadData() {
                return console.info('dispatchService - Loading settings');
            }
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('dispatcherConsoleUIService', dispatcherConsoleUIService);

    dispatcherConsoleUIService.$inject = ['settingsUtils', 'dataService'];

    function dispatcherConsoleUIService(settingsUtils, dataService) {

        function restore() {

            return dataService.restoreDefaultSettings({
                GeneralConfig: {
                    'Gantt Default Policy': {},
                    'Timezone display mode': {},
                    'Always show local time in tooltip': {},
                    'Show daily utilization in daily view': {},
                    'Use resource skill filter in gantt': {},
                    'Use new filters': {},
                    'Number Of Days To Load On Gantt Init': {},
                    'Minimun Drag Minutes on Gantt': {},
                    'Maximum Travel Time Displayed': {},
                    'Monthly View High Capacity': {},
                    'Monthly View Critical Capacity': {},
                    'Monthly View High Travel': {},
                    'Low Services Duration': {},
                    'Medium Services Utils': {},
                    'Gantt Custom CSS': {},
                    'Gantt Custom JS': {},
                    'Drag Jumps On Gantt': {},
                    'Online Offset In Minutes': {},
                    'Show secondary STMs on gantt': {},
                    'Delta Will Run Every': {},
                    'Bulk Action Buttons Order': {},
                    'Custom Service Lightbox Page': {},
                    'Custom Chatter Lightbox Page': {},
                    'Custom Related Lightbox Page': {},
                    'Custom Account Lightbox Page': {},
                    'Custom Service Lightbox Page 1': {},
                    'Custom Service Lightbox Page 2': {},
                    'Custom Workorder Lightbox Page': {},
                    'Custom WOLI Lightbox Page': {},
                    'Custom Chatter WO Lightbox Page': {},
                    'Custom Chatter WOLI Lightbox Page': {},
                    'WO related Lightbox Page': {},
                    'WOLI related Lightbox Page': {},
                    'Custom Resource Lightbox Page': {},
                    'Custom Resource Chatter Lightbox Page': {},
                    'Custom Resource Related List Page': {},
                    'Custom Resource Lightbox Page 1': {},
                    'Custom Resource Lightbox Page 2': {},
                    'Absence Lightbox Page': {},
                    'Enable Gantt Updates': {},
                    'Allow Admin Gantt Updates': {},
                    'Absence Chatter Lightbox Page': {}

                },
                RestoreLogicSettings: ['Default_First_Day_Of_Working_Week__c'],
                LogicSettings: dataService.getDraftSettings().LogicSettings
            });
        }

        function save() {

            return dataService.saveSettings({
                GeneralConfig: {
                    'Gantt Default Policy': dataService.getDraftSettings().GeneralConfig['Gantt Default Policy'],
                    'Timezone display mode': dataService.getDraftSettings().GeneralConfig['Timezone display mode'],
                    'Always show local time in tooltip': dataService.getDraftSettings().GeneralConfig['Always show local time in tooltip'],
                    'Show daily utilization in daily view': dataService.getDraftSettings().GeneralConfig['Show daily utilization in daily view'],
                    'Use resource skill filter in gantt': dataService.getDraftSettings().GeneralConfig['Use resource skill filter in gantt'],
                    'Use new filters': dataService.getDraftSettings().GeneralConfig['Use new filters'],
                    'Number Of Days To Load On Gantt Init': dataService.getDraftSettings().GeneralConfig['Number Of Days To Load On Gantt Init'],
                    'Minimun Drag Minutes on Gantt': dataService.getDraftSettings().GeneralConfig['Minimun Drag Minutes on Gantt'],
                    'Maximum Travel Time Displayed': dataService.getDraftSettings().GeneralConfig['Maximum Travel Time Displayed'],
                    'Monthly View High Capacity': dataService.getDraftSettings().GeneralConfig['Monthly View High Capacity'],
                    'Monthly View Critical Capacity': dataService.getDraftSettings().GeneralConfig['Monthly View Critical Capacity'],
                    'Monthly View High Travel': dataService.getDraftSettings().GeneralConfig['Monthly View High Travel'],
                    'Low Services Duration': dataService.getDraftSettings().GeneralConfig['Low Services Duration'],
                    'Medium Services Utils': dataService.getDraftSettings().GeneralConfig['Medium Services Utils'],
                    'Gantt Custom CSS': dataService.getDraftSettings().GeneralConfig['Gantt Custom CSS'],
                    'Gantt Custom JS': dataService.getDraftSettings().GeneralConfig['Gantt Custom JS'],
                    'Drag Jumps On Gantt': dataService.getDraftSettings().GeneralConfig['Drag Jumps On Gantt'],
                    'Online Offset In Minutes': dataService.getDraftSettings().GeneralConfig['Online Offset In Minutes'],
                    'Show secondary STMs on gantt': dataService.getDraftSettings().GeneralConfig['Show secondary STMs on gantt'],
                    'Delta Will Run Every': dataService.getDraftSettings().GeneralConfig['Delta Will Run Every'],
                    'Bulk Action Buttons Order': dataService.getDraftSettings().GeneralConfig['Bulk Action Buttons Order'],
                    'Custom Service Lightbox Page': dataService.getDraftSettings().GeneralConfig['Custom Service Lightbox Page'],
                    'Custom Chatter Lightbox Page': dataService.getDraftSettings().GeneralConfig['Custom Chatter Lightbox Page'],
                    'Custom Related Lightbox Page': dataService.getDraftSettings().GeneralConfig['Custom Related Lightbox Page'],
                    'Custom Account Lightbox Page': dataService.getDraftSettings().GeneralConfig['Custom Account Lightbox Page'],
                    'Custom Service Lightbox Page 1': dataService.getDraftSettings().GeneralConfig['Custom Service Lightbox Page 1'],
                    'Custom Service Lightbox Page 2': dataService.getDraftSettings().GeneralConfig['Custom Service Lightbox Page 2'],
                    'Custom Workorder Lightbox Page': dataService.getDraftSettings().GeneralConfig['Custom Workorder Lightbox Page'],
                    'Custom WOLI Lightbox Page': dataService.getDraftSettings().GeneralConfig['Custom WOLI Lightbox Page'],
                    'Custom Chatter WO Lightbox Page': dataService.getDraftSettings().GeneralConfig['Custom Chatter WO Lightbox Page'],
                    'Custom Chatter WOLI Lightbox Page': dataService.getDraftSettings().GeneralConfig['Custom Chatter WOLI Lightbox Page'],
                    'WO related Lightbox Page': dataService.getDraftSettings().GeneralConfig['WO related Lightbox Page'],
                    'WOLI related Lightbox Page': dataService.getDraftSettings().GeneralConfig['WOLI related Lightbox Page'],
                    'Custom Resource Lightbox Page': dataService.getDraftSettings().GeneralConfig['Custom Resource Lightbox Page'],
                    'Custom Resource Chatter Lightbox Page': dataService.getDraftSettings().GeneralConfig['Custom Resource Chatter Lightbox Page'],
                    'Custom Resource Related List Page': dataService.getDraftSettings().GeneralConfig['Custom Resource Related List Page'],
                    'Custom Resource Lightbox Page 1': dataService.getDraftSettings().GeneralConfig['Custom Resource Lightbox Page 1'],
                    'Custom Resource Lightbox Page 2': dataService.getDraftSettings().GeneralConfig['Custom Resource Lightbox Page 2'],
                    'Absence Lightbox Page': dataService.getDraftSettings().GeneralConfig['Absence Lightbox Page'],
                    'Enable Gantt Updates': dataService.getDraftSettings().GeneralConfig['Enable Gantt Updates'],
                    'Allow Admin Gantt Updates': dataService.getDraftSettings().GeneralConfig['Allow Admin Gantt Updates'],
                    'Absence Chatter Lightbox Page': dataService.getDraftSettings().GeneralConfig['Absence Chatter Lightbox Page']
                },
                LogicSettings: dataService.getDraftSettings().LogicSettings
            });
        }

        return {
            save: save,
            restore: restore,
            loadData: function loadData() {
                return console.info('dispatch console UI sevice');
            }
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('ganttLiveUpdates', ganttLiveUpdates);

    ganttLiveUpdates.$inject = [];

    function ganttLiveUpdates() {

        controllerFunction.$inject = ['$scope', 'primitiveType', 'dataService', 'settingsUtils'];

        function controllerFunction($scope, primitiveType, dataService, settingsUtils) {

            $scope.primitiveType = primitiveType;
            $scope.settings = dataService.getDraftSettings();
            $scope.sharingObjectSettingsStatus = 'Validating';

            $scope.PushTopicProps = ['Optimization_Request__c', 'ServiceResourceCapacity', 'ServiceResource', 'AssignedResource', 'ResourceAbsence', 'ServiceAppointment', 'Time_Dependency__c'];

            $scope.buttonStateLabels = {

                update: 'Update push topics',
                updated: 'Push topics updated',
                validate: 'Validating push topics',
                failed: 'Failed to validate Push Topics for gantt live refresh'
            };

            $scope.sharingObjects = [{
                SharingObjectAPI: "ServiceAppointmentShare",
                SharingObjectName: "Service Appointment",
                Status: 'NotUpdated'
            }, {
                SharingObjectAPI: "ServiceResourceShare",
                SharingObjectName: "Service Resource",
                Status: 'NotUpdated'
            }, {
                SharingObjectAPI: "Optimization_Request__Share",
                SharingObjectName: "Optimization Request",
                Status: 'NotUpdated'
            }];

            $scope.$watch("sharingObjects", function (newValue, oldValue) {
                var privateSettingsCounter = 0;
                for (var i in newValue) {
                    if (newValue[i].Status == 'NotUpdated' || newValue[i].Status == 'ERROR') {
                        return;
                    }

                    if (newValue[i].Status == 'Public') {
                        $scope.sharingObjectSettingsStatus = 'Public';
                        return;
                    }

                    if (newValue[i].Status == 'Private') {
                        privateSettingsCounter++;
                    }
                }

                if (newValue.length == privateSettingsCounter) {
                    $scope.sharingObjectSettingsStatus = 'Private';
                }
            }, true);
        }

        var template = ' \n\n            <div class="section-settings" id="__ganttUpdates">Timed Updates</div>\n            <br>\n            <custom-settings-wrapper is-text="true" primitive-type="primitiveType.number" min="10" max="120" label="\'The Gantt refreshes every x seconds\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Delta Will Run Every\']" tooltip-text="The gantt will refresh its data every X seconds"></custom-settings-wrapper>\n\n            <div class="section-settings" id="__ganttLiveUpdates">Live Updates</div>\n            <br>\n            \n            <div class="alert-warning-banner" ng-show="sharingObjectSettingsStatus == \'Public\'">\n                One of the objects below has public sharing.<br>\n                To enable gantt live updates, set sharing to private for all objects.\n            </div>\n            <br>\n\n            <object-sharing-status-directive ng-repeat="sharingObject in sharingObjects" object-sharing-props="sharingObject"></object-sharing-status-directive>\n            \n            <push-topics-creator-directive push-topics-props="PushTopicProps" button-state-labels="buttonStateLabels" push-topics-tool-tip="Gantt Live Refresh relies on push topic objects that query for changes made for the relevant objects. The push topic updates are created with a script upon installation. In some cases, such as when creating a sandbox from an instance with the package installed, the push topics aren\u2019t created. Click Update push topics to create the push topics."></push-topics-creator-directive>\n\n            <custom-settings-wrapper is-disabled="sharingObjectSettingsStatus != \'Private\'" primitive-type="primitiveType.booleanText" label="\'Gantt Updates are enabled org wide\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Enable Gantt Updates\']" tooltip-text="After you enable the Gantt Updates org wide, you must add the Streaming API custom permission to the users."></custom-settings-wrapper>\n            <custom-settings-wrapper is-disabled="sharingObjectSettingsStatus != \'Private\'" primitive-type="primitiveType.booleanText" label="\'Allow admins to use Gantt Updates\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Allow Admin Gantt Updates\']" tooltip-text="If too many updates are sent to the gantt it may crash. Admins have access to all records, regardless of sharing. Ensure all admins know the risks."></custom-settings-wrapper>\n        ';

        return {
            restrict: 'E',
            scope: {},
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('schedulingDispatcherUi', schedulingDispatcherUi);

    schedulingDispatcherUi.$inject = [];

    function schedulingDispatcherUi() {

        controllerFunction.$inject = ['$scope', 'primitiveType', 'dataService'];

        function controllerFunction($scope, primitiveType, dataService) {

            // nothing to check here, all good
            $scope.verifyFunctions.push(function () {
                return false;
            });

            $scope.primitiveType = primitiveType;
            $scope.settings = dataService.getDraftSettings();

            $scope.startOfWeek = [{ label: 'Sunday', value: 'Sunday' }, { label: 'Monday', value: 'Monday' }];

            $scope.timezoneMode = [{ label: 'User Timezone', value: 'user' }, { label: 'Territory Timezone', value: 'location' }];

            $scope.initialLoad = [{ label: 'Selected View ± 0', value: '0' }, { label: 'Selected View ± 1', value: '1' }, { label: 'Selected View ± 2', value: '2' }, { label: 'Selected View ± 3', value: '3' }];

            dataService.getSettingsPromise().then(function () {
                $scope.schedulingPolicies = dataService.policies;
            });

            // $scope.preventChangingNewFiltersBackToOld = (e) => {
            //
            //     if ($scope.settings.GeneralConfig['Use new filters'].Value__c === '1') {
            //         e.preventDefault();
            //         e.stopPropagation();
            //     }
            //
            //     return;
            //
            // };
        }

        var template = '\n            <custom-settings-wrapper id="__configure" primitive-type="primitiveType.picklist" options="schedulingPolicies" label="\'Default scheduling policy\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Gantt Default Policy\']" tooltip-text=\'The default policy for the dispatcher console and the auto-schedule function\'></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="timezoneMode" label="\'Gantt chart timezone\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Timezone display mode\']" tooltip-text="Select between the logged-in user\'s or each service territories timezone"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.booleanText" label="\'Show secondary Service Territory Members on Gantt chart\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Show secondary STMs on gantt\']" tooltip-text="If checked, secondary STMs are displayed on the gantt chart. Notice - if service territory timezone view is selected, only secondary territories with same timezone as primary territory will be shown"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.booleanText" label="\'Show local time in Gantt chart tooltip\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Always show local time in tooltip\']" tooltip-text="If checked, the appointments local start and finish times are shown in the tooltip"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.booleanText" label="\'Show utilization on the Gantt\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Show daily utilization in daily view\']" tooltip-text="If checked, utilization will be shown on terriroties for the daily gantt views"></custom-settings-wrapper>\n            \n            <custom-settings-wrapper primitive-type="primitiveType.booleanText" label="\'Enable resource filtering by skills in dispatcher console\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Use resource skill filter in gantt\']" tooltip-text="It is recommended to disable the Resource Skills filter on the Gantt if you have more than 200 skills defined in your org to improve the Dispatcher console performance"></custom-settings-wrapper>\n\n            <custom-settings-wrapper primitive-type="primitiveType.booleanText" label="\'Enable Custom Filters\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Use new filters\']" tooltip-text="Use Gantt Filter object with more complex options such as criterias, logics and dynamic time frames in the dispatcher console when filtering service appointments on the appointments list"></custom-settings-wrapper>\n            \n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="startOfWeek" label="\'Gantt chart week start\'" value-field-name="\'Default_First_Day_Of_Working_Week__c\'" setting="settings.LogicSettings" tooltip-text="First day of the week, Sunday versus Monday"></custom-settings-wrapper>\n            \n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="initialLoad" label="\'Initial Gantt loading days boundaries\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Number Of Days To Load On Gantt Init\']" tooltip-text="Control how many extra days will be loaded to the Gantt on top of the selected view upon Gantt loading. Selecting to load additional days will improve the user experience when navigating through next and previous days, but may lead to hit platform limits for large data sets."></custom-settings-wrapper>\n            \n            <custom-settings-wrapper is-text="true" primitive-type="primitiveType.number" min="1" max="60" label="\'Drag jumps on gantt\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Drag Jumps On Gantt\']" tooltip-text="When dragging services on the gantt, this will be the amount of minutes they move"></custom-settings-wrapper>\n\n            <custom-settings-wrapper is-text="true" primitive-type="primitiveType.number" min="1" max="200" label="\'Maximum travel hours displayed on gantt\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Maximum Travel Time Displayed\']" tooltip-text="If travel time is longer than this number, it will be hidden from the Gantt"></custom-settings-wrapper>\n            \n            <custom-settings-wrapper is-text="true" primitive-type="primitiveType.number" min="1" max="9999" label="\'Online Offset In Minutes\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Online Offset In Minutes\']" tooltip-text="For how many minutes from the last seen does the resource considered online"></custom-settings-wrapper>\n            \n            <bulk-actions-order object="settings.GeneralConfig"></bulk-actions-order> \n\n            <div class="section-settings" id="__monthly">Utilization Views</div>\n            <custom-settings-wrapper is-text="true" primitive-type="primitiveType.number" min="1" max="1000" label="\'High utilization(%)\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Monthly View Critical Capacity\']" tooltip-text="High utilization will be colored in shades of Red"></custom-settings-wrapper>\n            <custom-settings-wrapper is-text="true" primitive-type="primitiveType.number" min="1" max="1000" label="\'Medium utilization(%)\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Monthly View High Capacity\']" tooltip-text="Medium utilization will be colored in shades of Yellow"></custom-settings-wrapper>\n            <custom-settings-wrapper is-text="true" primitive-type="primitiveType.number" min="1" max="10000" label="\'Extensive travel alert\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Monthly View High Travel\']" tooltip-text="An extensive travel icon will appear when traveling more than this percentage"></custom-settings-wrapper>\n            \n            \n            <div class="section-settings" id="__calendar">Resource Calendar</div>\n            <custom-settings-wrapper is-text="true" primitive-type="primitiveType.number" min="1" max="10000" label="\'Medium utilization (hours)\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Medium Services Utils\']" tooltip-text="Number of hours which reflect medium utilization"></custom-settings-wrapper>\n            <custom-settings-wrapper is-text="true" primitive-type="primitiveType.number" min="1" max="10000" label="\'Low utilization (hours)\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Low Services Duration\']" tooltip-text="Number of hours which reflect low utilization"></custom-settings-wrapper>\n            \n            \n            <div class="section-settings" id="__customize">Dispatcher View Customizations</div>\n            <custom-settings-wrapper primitive-type="primitiveType.text" label="\'External CSS\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Gantt Custom CSS\']" tooltip-text="External CSS Load an additional CSS file (static resource name)"></custom-settings-wrapper>            \n            <custom-settings-wrapper primitive-type="primitiveType.text" label="\'External JS\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Gantt Custom JS\']" tooltip-text="Load an additional JS file (static resource name)"></custom-settings-wrapper>\n            \n            <content-collapse-wrapper header="\'Service VisualForce pages\'" open="false">\n                <content>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Service - Main Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Service Lightbox Page\']" tooltip-text="The main page displayed when opening the Service"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Service - Chatter Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Chatter Lightbox Page\']" tooltip-text="The chatter tab displayed on the service VisualForce"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Service - Related List Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Related Lightbox Page\']" tooltip-text="The related tabs displayed on the service VisualForce"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Service - Account Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Account Lightbox Page\']" tooltip-text="The account tab displayed on the service VisualForce"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Service - Custom Tab 1\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Service Lightbox Page 1\']" tooltip-text="Define a custom page to be shown on the service lightbox"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Service - Custom Tab 2\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Service Lightbox Page 2\']" tooltip-text="Define a custom page to be shown on the service lightbox"></custom-settings-wrapper>\n                </content>\n            </content-collapse-wrapper>\n            \n            <content-collapse-wrapper header="\'Work Order VisualForce pages\'" open="false">\n                <content>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Work Order - Main Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Workorder Lightbox Page\']" tooltip-text="The work order details tab on the service lightbox"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Work Order Line Item - Main Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom WOLI Lightbox Page\']" tooltip-text="The work order line itemdetails tab on the service lightbox"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Work Order - Chatter Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Chatter WO Lightbox Page\']" tooltip-text="The work order chatter tab on the service lightbox"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Work Order Line Item - Chatter Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Chatter WOLI Lightbox Page\']" tooltip-text="The work order line item chatter tab on the service lightbox"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Work Order - Related List Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'WO related Lightbox Page\']" tooltip-text="The work order related list tab on the service lightbox"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Work Order Line Item - Related List Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'WOLI related Lightbox Page\']" tooltip-text="The work order line item related list tab on the service lightbox"></custom-settings-wrapper>\n                </content>\n            </content-collapse-wrapper>\n            \n            <content-collapse-wrapper header="\'Resource VisualForce pages\'" open="false">\n                <content>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Resource - Main Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Resource Lightbox Page\']" tooltip-text="The main page displayed when opening the resource VisualForce page"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Resource - Chatter Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Resource Chatter Lightbox Page\']" tooltip-text="The chatter tab displayed on the resource VisualForce page"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Resource - Related List Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Resource Related List Page\']" tooltip-text="The related tabs displayed on the resource VisualForce page"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Resource - Custom Tab 1\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Resource Lightbox Page 1\']" tooltip-text="Define a custom page to be shown on the resource lightbox"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Resource - Custom Tab 2\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Custom Resource Lightbox Page 2\']" tooltip-text="Define a custom page to be shown on the resource lightbox"></custom-settings-wrapper>\n                </content>\n            </content-collapse-wrapper>\n            \n            <content-collapse-wrapper header="\'Employee Absences VisualForce pages\'" open="false">\n                <content>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Employee Absences - Main Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Absence Lightbox Page\']" tooltip-text="The main page displayed when opening the employee absence VisualForce page"></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Employee Absences - Chatter Tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Absence Chatter Lightbox Page\']" tooltip-text="The chatter tab displayed on the employee absence VisualForce page"></custom-settings-wrapper>\n                </content>\n            </content-collapse-wrapper>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('gettingStartedGettingStarted', gettingStartedGettingStarted);

    gettingStartedGettingStarted.$inject = [];

    function gettingStartedGettingStarted() {

        controllerFunction.$inject = ['$scope', 'dataService', 'settingsUtils', '$rootScope', 'permissionSetService', '$q', '$window'];

        function controllerFunction($scope, dataService, settingsUtils, $rootScope, permissionSetService, $q, $window) {

            $scope.isLoading = false;
            $scope.buttonText = 'Go to Guided Setup';

            $scope.permissionsMap = { "FSL_Dispatcher": { Name: 'FSL_Dispatcher',
                    Label: 'FSL Dispatcher',
                    License: 'FieldServiceDispatcher',
                    Img: 'dispatcher',
                    Msg: 'Permissions to view and use the dispatcher console, global actions and their related objects, and schedule, optimize, and dispatch service appointments.',
                    Validated: null,
                    ErrorMsg: '' },
                "FSL_Resource": { Name: 'FSL_Resource',
                    Label: 'FSL Resource',
                    License: 'FieldServiceScheduling',
                    Img: 'resource',
                    Msg: 'Permissions to view and manage service appointments and their related parent objects.',
                    Validated: null,
                    ErrorMsg: '' },
                "FSL_Agent": { Name: 'FSL_Agent',
                    Label: 'FSL Agent',
                    License: 'FieldServiceStandard',
                    Img: 'agent',
                    Msg: 'Permissions to view all global actions and their related objects to create, book, and schedule service appointments.',
                    Validated: null,
                    ErrorMsg: '' },
                "FSL_Community_Self_Service": { Name: 'FSL_Community_Self_Service',
                    Label: 'FSL Self Service',
                    License: 'FieldServiceStandard',
                    Img: 'community',
                    Msg: 'Permissions for community users to view all global actions and their related objects to create, book, and schedule their own appointments.',
                    Validated: null,
                    ErrorMsg: '' },
                // "FSL_Community_Dispatcher" :     { Name: 'FSL_Community_Dispatcher',
                //                                    Label: 'FSL Community Dispatcher',
                //                                    License : 'FieldServiceDispatcher',
                //                                    Img: 'dispatchercommunity',
                //                                    Msg: '',
                //                                    Validated : null,
                //                                    ErrorMsg : '' },
                "FSL_Admin": { Name: 'FSL_Admin',
                    Label: 'FSL Admin',
                    License: 'FieldServiceStandard',
                    Img: 'admin',
                    Msg: 'Permissions to access and manage all Field Service Lightning objects including the \'Field Service Admin\' app, Field Service Lightning Visualforce pages, and logic services.',
                    Validated: null,
                    ErrorMsg: '' }
            };

            $scope.getIcon = function (name) {
                return settings.icons[name];
            };

            $scope.createAllPermissionsAndGoToOnboardingWizard = function () {
                $scope.isLoading = true;
                $scope.buttonText = 'Validating permission sets';

                $q.all([settingsUtils.callRemoteAction(remoteActions.validatePS, ['FSL_Dispatcher']), settingsUtils.callRemoteAction(remoteActions.validatePS, ['FSL_Resource']), settingsUtils.callRemoteAction(remoteActions.validatePS, ['FSL_Agent']), settingsUtils.callRemoteAction(remoteActions.validatePS, ['FSL_Community_Self_Service']),
                //settingsUtils.callRemoteAction(remoteActions.validatePS, ['FSL_Community_Dispatcher']),
                settingsUtils.callRemoteAction(remoteActions.validatePS, ['FSL_Admin'])]).then(function (results) {

                    for (var i = 0; i < results.length; i++) {
                        var name = results[i].psName;

                        if (results[i].PSStatus == 'Updated') {
                            permissionSetService.createTabAndRecordTypePermission(name, $scope.permissionsMap[name].Label, results[i].tabSettingsMap, results[i].recordTypeVisibilitiesMap);

                            if (name == 'FSL_Admin') {
                                assignAdmin();
                            }
                            // permissionSetService.validateTabAndRecordTypePermission(name, results[i].tabSettingsMap, results[i].recordTypeVisibilitiesMap).then( res => {
                            //     if (res.Validated == 'NotUpdated') {
                            //         permissionSetService.createTabAndRecordTypePermission(name, $scope.permissionsMap[name].Label, results[i].tabSettingsMap,results[i].recordTypeVisibilitiesMap);
                            //     }
                            // });
                        } else {

                            if (name == 'FSL_Admin') {
                                permissionSetService.createPermission(name, $scope.permissionsMap[name].Label, $scope.permissionsMap[name].License).then(function () {
                                    assignAdmin();
                                });
                            } else {
                                permissionSetService.createPermission(name, $scope.permissionsMap[name].Label, $scope.permissionsMap[name].License);
                            }
                        }
                    }
                });
            };

            function assignAdmin() {
                permissionSetService.assignAdminToUser().then(function (res) {
                    $scope.buttonText = 'Redirecting to Guided Setup';
                    goToOnboarding();
                }).catch(function (res) {
                    $scope.buttonText = 'Something went wrong';
                    $scope.isLoading = false;
                });
            }

            function goToOnboarding() {

                if (sforce && sforce.one) {
                    sforce.one.navigateToURL(settings.onBoardingLink);
                    return;
                }

                location.href = window.location.origin + '/' + settings.onBoardingLink;
            }
        }

        var template = '\n            <h1>FSL Guided Setup</h1>\n\n            Quickly setup Field Service Lightning. Start by creating your service territories and operating hours. Then define your work types and skill sets. Next, setup your service resources, dispatchers and agents. Lastly, specify your appointment booking configuration and tune your scheduling policies.\n            \n            <img class="gantt-pic" src="' + settings.ganttPic + '" /><br/>\n            \n            <div class="ob-link">\n                <div ng-show="isLoading">\n                    <img class="loadingImg"  src={{getIcon(\'loading\')}} />\n                </div>\n                <span ng-click="createAllPermissionsAndGoToOnboardingWizard()" >{{buttonText}}</span>\n            </div>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('gettingStartedService', gettingStartedService);

    gettingStartedService.$inject = ['dataService'];

    function gettingStartedService(dataService) {

        return {
            save: function save() {
                return dataService.saveSettings({
                    TriggerConfigurations: {
                        'Mention user on service dispatch': dataService.getDraftSettings().TriggerConfigurations['Mention user on service dispatch']
                    },
                    DripFeedConfig: dataService.getDraftSettings().DripFeedConfig,
                    // need all 3 for automators to save
                    AutomatorConfig: dataService.getAutomatorsMap('Sched007_ServicesAppoDispatched'),
                    DeletedAutomators: dataService.getDraftSettings().DeletedAutomators,
                    Territories: dataService.getDraftSettings().Territories
                });
            },
            restore: function restore() {
                return dataService.restoreDefaultSettings({
                    TriggerConfigurations: {
                        'Mention user on service dispatch': {}
                    },
                    DripFeedConfig: dataService.getDraftSettings().DripFeedConfig,
                    RestoreAutomatorSettings: ['Sched007_ServicesAppoDispatched']
                });
            },
            loadData: function loadData() {
                return console.info('dispatchService - Loading settings');
            }
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('permissionSet', permissionSet);

    permissionSet.$inject = [];

    function permissionSet() {

        controllerFunction.$inject = ['$scope', '$q', 'settingsUtils', 'permissionSetService'];

        function controllerFunction($scope, $q, settingsUtils, permissionSetService) {

            $scope.isLoading = true;
            $scope.sessionId = sessionId;
            $scope.showBlink = 0;

            var TabOptions = ['Visible', 'Available', 'None'];

            $scope.getImage = function () {
                return settings.images[$scope.settings.Img];
            };

            $scope.createPermission = function () {
                $scope.isLoading = true;

                permissionSetService.createPermission($scope.settings.Name, $scope.settings.Label, $scope.settings.License).then(function (res) {
                    $scope.isLoading = res.isLoading;
                    $scope.settings.Validated = res.Validated;
                    $scope.settings.ErrorMsg = res.errorMsg;
                }).catch(function (res) {
                    $scope.isLoading = res.isLoading;
                    $scope.settings.Validated = res.Validated;
                });
            };

            $scope.getIcon = function (name) {
                return settings.icons[name];
            };

            $scope.showWarning = function () {
                alert($scope.settings.ErrorMsg);
            };

            settingsUtils.callRemoteAction(remoteActions.validatePS, [$scope.settings.Name]).then(function (result) {
                if (result.PSStatus == 'Updated') {
                    permissionSetService.validateTabAndRecordTypePermission($scope.settings.Name, result.tabSettingsMap, result.recordTypeVisibilitiesMap).then(function (res) {
                        $scope.settings.Validated = res.Validated;
                        $scope.isLoading = false;
                    });
                } else {
                    $scope.settings.Validated = result.PSStatus;
                    $scope.isLoading = false;
                }
            }).catch(function (result) {
                $scope.settings.Validated = 'ERROR';
                $scope.isLoading = false;
            });
        }

        var template = '\n            <div class="permissionSet">\n                <div ng-show="showBlink > 10 && settings.Label == \'FSL Dispatcher\'" class="blinking"></div>\n                <img class="permissionImage" ng-src="{{getImage()}}" ng-click="showBlink = showBlink + 1">\n                    <h1>{{settings.Label}}</h1>\n                <div class="desc">\n                    {{settings.Msg}}\n                </div>\n                <div ng-show="isLoading" class="permissionsLoadingContainer">\n                    <img class="loadingImg"  src={{getIcon(\'loading\')}} />\n                </div>\n                <div ng-show="settings.Validated == \'Updated\'" class="permissionSetOK">Permission set is up to date</div>\n                <div ng-click="createPermission()" ng-show="settings.Validated == \'NotUpdated\'" class="settingsButton blueButton">Update Permissions</div>\n                <div ng-click="createPermission()" ng-show="settings.Validated == \'NotExist\'" class="settingsButton blueButton">Create Permissions</div>\n                <div ng-show="settings.Validated == \'ERROR\'" class="permissionSetERROR">An error has occurred</div>\n                <div  ng-show="settings.Validated == \'PartialError\'" class="permissionSetERROR">An error has occurred\n                    <span ng-click="showWarning()" class="error-more-details">More details</span>\n                </div>\n                <div ng-show="settings.Validated == \'LicenseError\'" class="permissionSetERROR">Missing matching license</div>\n            </div>';

        return {
            restrict: 'E',
            scope: {
                settings: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('permissionSetService', permissionSetService);

    permissionSetService.$inject = ['settingsUtils', '$http', '$q'];

    function permissionSetService(settingsUtils, $http, $q) {

        function createPermission(name, label, license) {
            var deferred = $q.defer();

            settingsUtils.callRemoteAction(remoteActions.createAndUpdatePermissionSet, [name, label, license]).then(function (result) {

                if (result.PSStatus == 'PartialError') {
                    deferred.resolve({
                        Validated: result.PSStatus,
                        isLoading: false,
                        errorMsg: result.errorMsg
                    });
                } else {
                    if (result.tabSettings.length != 0 || result.recordTypeVisibilities.length != 0) {
                        createTabAndRecordTypePermission(name, label, result.tabSettings, result.recordTypeVisibilities).then(function (res) {
                            deferred.resolve({
                                Validated: res.Validated,
                                isLoading: res.isLoading
                            });
                        });
                    } else {
                        deferred.resolve({
                            Validated: result.PSStatus,
                            isLoading: false
                        });
                    }
                }
            }, function (res) {
                deferred.reject({
                    Validated: 'ERROR',
                    isLoading: false
                });
            });

            return deferred.promise;
        }

        function validateTabAndRecordTypePermission(permissionName, tabSettingsMap, recordTypeVisibilitiesMap) {
            var deferred = $q.defer();

            var baseUrl = window.location.origin;

            var dataStr = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:met="http://soap.sforce.com/2006/04/metadata">' + '<soapenv:Header>' + '<met:SessionHeader>' + '<met:sessionId>' + sessionId + '</met:sessionId>' + '</met:SessionHeader>' + '</soapenv:Header>' + '<soapenv:Body>' + '<met:readMetadata>' + '<met:type>PermissionSet</met:type>' + '<met:fullNames>' + permissionName + '_Permissions' + '</met:fullNames>' + '</met:readMetadata>' + '</soapenv:Body>' + '</soapenv:Envelope>';

            $http.post(baseUrl + '/services/Soap/m/38.0', dataStr, { headers: { 'SOAPAction': '""',
                    'Content-Type': 'text/xml',
                    contentType: "text/xml" }
            }).then(function (res) {
                var parser = new DOMParser();
                var xmlDoc = parser.parseFromString(res.data, "text/xml");
                if (validateTabVisibilityAndRecordType(xmlDoc, tabSettingsMap, recordTypeVisibilitiesMap)) {
                    deferred.resolve({
                        Validated: 'Updated',
                        isLoading: false
                    });
                } else {
                    deferred.resolve({
                        Validated: 'NotUpdated',
                        isLoading: false
                    });
                }
            }, function (res) {
                deferred.reject({
                    Validated: 'Updated',
                    isLoading: false
                });
                settingsUtils.callRemoteAction(remoteActions.WriteToLog, ['ERROR', 'Failed to validate permission set for record types and tab setting visibility.']);
            });

            return deferred.promise;
        }

        function validateTabVisibilityAndRecordType(doc, tabSettingsMap, recordTypeVisibilitiesMap) {
            try {
                var tabSettings = doc.childNodes[0].children[0].children[0].children[0].children[0].getElementsByTagName('tabSettings');
                var recordTypeVisibilities = doc.childNodes[0].children[0].children[0].children[0].children[0].getElementsByTagName('recordTypeVisibilities');

                if (JSON.stringify(tabSettingsMap) !== JSON.stringify({}) && tabSettings != undefined) {
                    for (var i = 0; i < tabSettings.length; i++) {
                        var currTab = tabSettings[i].children[0].innerHTML;

                        if (tabSettingsMap[currTab] == undefined) {
                            continue;
                        }

                        var visibility = tabSettings[i].children[1].innerHTML;

                        if (tabSettingsMap[currTab] != visibility) {
                            return false;
                        }
                    }
                }

                if (JSON.stringify(recordTypeVisibilitiesMap) !== JSON.stringify({}) && recordTypeVisibilities != undefined) {
                    for (var _i = 0; _i < recordTypeVisibilities.length; _i++) {
                        var currRecordType = recordTypeVisibilities[_i].children[0].innerHTML;

                        if (recordTypeVisibilitiesMap[currRecordType] == undefined) {
                            continue;
                        }

                        var visibility = recordTypeVisibilities[_i].children[1].innerHTML;

                        if (recordTypeVisibilitiesMap[currRecordType] != visibility) {
                            return false;
                        }
                    }
                }

                return true;
            } catch (err) {
                settingsUtils.callRemoteAction(remoteActions.WriteToLog, ['ERROR', err.message]);
                return true;
            }
        }

        function createTabAndRecordTypePermission(name, label, tabSettings, recordTypeVisibilities) {
            var deferred = $q.defer();

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

            // console.log(baseUrl);
            // console.log(dataStr);
            $http.post(baseUrl + '/services/Soap/m/38.0', dataStr, { headers: { 'SOAPAction': '""',
                    'Content-Type': 'text/xml',
                    contentType: "text/xml" }
            }).then(function (res) {
                deferred.resolve({
                    Validated: 'Updated',
                    isLoading: false
                });
            }, function (res) {
                deferred.reject({
                    Validated: 'Updated',
                    isLoading: false
                });
                settingsUtils.callRemoteAction(remoteActions.WriteToLog, ['ERROR', 'Failed to update permission set for record types and tab setting visibility.']);
            });

            return deferred.promise;
        }

        function assignAdminToUser() {
            var deferred = $q.defer();

            settingsUtils.callRemoteAction(remoteActions.AssignAdminToUser).then(function (res) {
                deferred.resolve();
            }).catch(function (res) {
                deferred.reject();
            });

            return deferred.promise;
        }

        return {
            createPermission: createPermission,
            validateTabAndRecordTypePermission: validateTabAndRecordTypePermission,
            validateTabVisibilityAndRecordType: validateTabVisibilityAndRecordType,
            createTabAndRecordTypePermission: createTabAndRecordTypePermission,
            assignAdminToUser: assignAdminToUser
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('gettingStartedPermissionSets', gettingStartedPermissionSets);

    gettingStartedPermissionSets.$inject = [];

    function gettingStartedPermissionSets() {

        controllerFunction.$inject = ['$scope', 'dataService', 'primitiveType', '$rootScope', 'settingsUtils', '$q'];

        function controllerFunction($scope, dataService, primitiveType, $rootScope, settingsUtils, $q) {

            $scope.dataService = dataService;
            dataService.getSettingsPromise().then(function (res) {
                $scope.PermissionsMissing = false;
                $scope.PreventPSAutoUpdate = $scope.dataService.getDraftSettings().PerventPermissionsUpdate;
            }).catch(function (res) {
                $scope.PermissionsMissing = true;
                $scope.PreventPSAutoUpdate = false;
            });

            $scope.permissionsMap = { "FSL_Dispatcher": { Name: 'FSL_Dispatcher',
                    Label: 'FSL Dispatcher',
                    License: 'FieldServiceDispatcher',
                    Img: 'dispatcher',
                    Msg: 'Permissions to view and use the dispatcher console, global actions and their related objects, and schedule, optimize, and dispatch service appointments.',
                    Validated: null,
                    ErrorMsg: '' },
                "FSL_Resource": { Name: 'FSL_Resource',
                    Label: 'FSL Resource',
                    License: 'FieldServiceScheduling',
                    Img: 'resource',
                    Msg: 'Permissions to view and manage service appointments and their related parent objects.',
                    Validated: null,
                    ErrorMsg: '' },
                "FSL_Agent": { Name: 'FSL_Agent',
                    Label: 'FSL Agent',
                    License: 'FieldServiceStandard',
                    Img: 'agent',
                    Msg: 'Permissions to view all global actions and their related objects to create, book, and schedule service appointments.',
                    Validated: null,
                    ErrorMsg: '' },
                "FSL_Community_Self_Service": { Name: 'FSL_Community_Self_Service',
                    Label: 'FSL Self Service',
                    License: 'FieldServiceStandard',
                    Img: 'community',
                    Msg: 'Permissions for community users to view all global actions and their related objects to create, book, and schedule their own appointments.',
                    Validated: null,
                    ErrorMsg: '' },
                // "FSL_Community_Dispatcher" :     { Name: 'FSL_Community_Dispatcher',
                //                                    Label: 'FSL Community Dispatcher',
                //                                    License : 'FieldServiceDispatcher',
                //                                    Img: 'dispatchercommunity',
                //                                    Msg: '',
                //                                    Validated : null,
                //                                    ErrorMsg : '' },
                "FSL_Admin": { Name: 'FSL_Admin',
                    Label: 'FSL Admin',
                    License: 'FieldServiceStandard',
                    Img: 'admin',
                    Msg: 'Permissions to access and manage all Field Service Lightning objects including the \'Field Service Admin\' app, Field Service Lightning Visualforce pages, and logic services.',
                    Validated: null,
                    ErrorMsg: '' }
            };

            $scope.permissions = Object.keys($scope.permissionsMap).map(function (k) {
                return $scope.permissionsMap[k];
            });
        }

        var template = '\n            <div class="permissions-container">\n              <div class="settingsError" ng-show="PermissionsMissing">\n                FSL Admin permissions required. Please assign the "FSL Admin" permission set to your user or contact your system administrator.<br>\n                You can create/update the permission set with the button below.<br>\n              </div>\n              <div ng-show="PreventPSAutoUpdate" class="blue-banner-small">Permission sets auto update feature is turned off. Make sure to update your permission sets after each version upgrade.</div>\n              <permission-set ng-repeat="permission in permissions" settings="permission"></permission-set>\n            </div>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('globalActionsBooking', globalActionsBooking);

    globalActionsBooking.$inject = [];

    function globalActionsBooking() {

        controllerFunction.$inject = ['$scope', 'dataService', 'primitiveType'];

        function controllerFunction($scope, dataService, primitiveType) {

            $scope.verifyFunctions.push(function () {
                return console.log('verify - globalActionsBooking');
            });

            $scope.settings = dataService.getDraftSettings();
            $scope.primitiveType = primitiveType;

            dataService.getSettingsPromise().then(function () {
                $scope.schedulingPolicies = dataService.policies;
                $scope.operatingHours = dataService.operatingHours;
            });
        }

        var template = '\n            <p>These settings affect the Book Appointment and Candidates global actions</p>\n            \n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="schedulingPolicies" label="\'Default scheduling policy\'" tooltip-text="The policy used when no mapping is defined on the Derivations tab." value-field-name="\'SchedulingPolicyId__c\'" setting="settings.AppointmentBookingSettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="operatingHours" label="\'Default operating hours\'" tooltip-text="The appointment slots displayed unless the work order\'s entitlement doesn\'t reference other hours." value-field-name="\'DefaultOperatingHours__c\'" setting="settings.AppointmentBookingSettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="0" max="100" label="\'Ideal grading threshold\'" tooltip-text="A slot grade equal to or higher than the specified value is shown with the Ideal ticker on the Appointment Booking chatter action." value-field-name="\'Ideal_Threshold__c\'" setting="settings.AppointmentBookingSettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="0" max="100" label="\'Recommended grading threshold\'" tooltip-text="A slot grade equal to or higher than the specified value and lower than the ideal threshold is shown with the recommended ticker on the Appointment Booking chatter action." value-field-name="\'Recommended_Threshold__c\'" setting="settings.AppointmentBookingSettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="1" max="500" label="\'Number of hours for initial appointment search\'" tooltip-text="If the difference between the due date and the earliest start permitted is longer than this number, the appointments is displayed first with this setting." value-field-name="\'LazyLoadBookingInHours__c\'" setting="settings.AppointmentBookingSettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Show grades explanation\'" tooltip-text="Shows how each appointment slot ranks against key performance indicators" value-field-name="\'Show_Grade_Explanation__c\'" setting="settings.AppointmentBookingSettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Custom CSS (cascading style sheet)\'" tooltip-text="Customize global actions appearance (static resource name)" value-field-name="\'CustomCSS__c\'" setting="settings.AppointmentBookingSettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Disable service territory picker in appointment booking\'" tooltip-text="If on service territory picker on appointment booking chatter action will not be shown" value-field-name="\'AutoTerritoryPicker__c\'" setting="settings.AppointmentBookingSettings"></custom-settings-wrapper>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('globalActionsDerivations', globalActionsDerivations);

    globalActionsDerivations.$inject = [];

    function globalActionsDerivations() {

        controllerFunction.$inject = ['$scope', 'optimizationService', 'primitiveType', 'dataService', 'globalActionsService', '$rootScope'];

        function controllerFunction($scope, optimizationService, primitiveType, dataService, globalActionsService, $rootScope) {

            $scope.verifyFunctions.push(function () {
                return console.log('verify - globalActionsDerivations');
            });

            $scope.objectMappingFields = fieldNames.ObjectMapping__c;
            $scope.primitiveType = primitiveType;
            $scope.schedulingPolicyName = fieldNames.SchedulingPolicyName;

            // all objects
            $scope.objectMappings = globalActionsService.objectMappings;
            $scope.fieldNamesOfObjects = {};
            $scope.allObjects = [{ label: ' -- Select Object -- ' }];
            $scope.selectedNewObject = $scope.allObjects[0];
            var filteredPicklist = {};

            dataService.getSettingsPromise().then(function () {
                dataService.getDraftSettings().ObjectMapping.forEach(function (mapping) {
                    var newObjectMap = new ObjectMapping(mapping.Name, mapping[fieldNames.ObjectMapping__c.label__c], mapping);
                    newObjectMap.isOpen = false;
                    $scope.objectMappings[mapping.Name] = newObjectMap;

                    if (!$scope.fieldNamesOfObjects[mapping.Name]) {
                        optimizationService.serviceReferenceProperties(mapping.Name).then(function (objectProperties) {
                            $scope.fieldNamesOfObjects[mapping.Name] = transformFieldsToPicklist(objectProperties.fields);
                        });
                    }
                });
            });

            // after restore
            $rootScope.$on('settingsUpdated', function () {

                Object.keys($scope.objectMappings).forEach(function (key) {
                    return delete $scope.objectMappings[key];
                });

                dataService.getDraftSettings().ObjectMapping.forEach(function (mapping) {
                    var newObjectMap = new ObjectMapping(mapping.Name, mapping[fieldNames.ObjectMapping__c.label__c], mapping);
                    newObjectMap.isOpen = false;
                    $scope.objectMappings[mapping.Name] = newObjectMap;

                    if (!$scope.fieldNamesOfObjects[mapping.Name]) {
                        optimizationService.serviceReferenceProperties(mapping.Name).then(function (objectProperties) {
                            $scope.fieldNamesOfObjects[mapping.Name] = transformFieldsToPicklist(objectProperties.fields);
                        });
                    }
                });
            });

            // get all objects
            optimizationService.getAllObjects().then(function (objects) {
                objects.forEach(function (obj) {
                    if (obj.triggerable == "true") {
                        $scope.allObjects.push(obj);
                    }
                });
            });

            // get selectable objects
            $scope.getSelectableObjects = function () {
                return $scope.allObjects.filter(function (obj) {
                    return obj.label === ' -- Select Object -- ' || !$scope.objectMappings[obj.name];
                });
            };

            // get fields of WorkOrder
            optimizationService.serviceReferenceProperties('WorkOrder').then(function (objectProperties) {
                $scope.fieldNamesOfObjects['WorkOrder'] = transformFieldsToPicklist(objectProperties.fields);
            });

            $scope.addObject = function (sobj) {

                if (!sobj.name) {
                    return;
                }

                $scope.selectedNewObject = $scope.allObjects[0];
                var newObjectMap = new ObjectMapping(sobj.name, sobj.label);
                newObjectMap.isOpen = true;
                newObjectMap[fieldNames.ObjectMapping__c.Active__c] = true;
                $scope.objectMappings[sobj.name] = newObjectMap;
                optimizationService.serviceReferenceProperties(sobj.name).then(function (objectProperties) {
                    $scope.fieldNamesOfObjects[sobj.name] = transformFieldsToPicklist(objectProperties.fields);
                });
            };

            function transformFieldsToPicklist(fields) {

                var fieldPicklist = [{ value: null, label: '--- SKIP ---' }];

                fields.forEach(function (field) {
                    fieldPicklist.push({
                        value: field.name,
                        label: field.name,
                        type: field.type,
                        referenceTo: field.referenceTo
                    });
                });

                return fieldPicklist;
            }

            $scope.getFilteredPicklist = function (name, type, refTo) {

                // check if cached
                if (refTo && filteredPicklist[name] && filteredPicklist[name][type] && filteredPicklist[name][type][refTo]) {
                    return filteredPicklist[name][type][refTo];
                }

                if (filteredPicklist[name] && filteredPicklist[name][type] && refTo === undefined) {
                    return filteredPicklist[name][type];
                }

                // calculate
                filteredPicklist[name] = filteredPicklist[name] || {};

                if (refTo) {

                    filteredPicklist[name][type] = filteredPicklist[name][type] || {};
                    filteredPicklist[name][type][refTo] = $scope.fieldNamesOfObjects[name].filter(function (pick) {
                        return pick.type === undefined || pick.type == type && pick.referenceTo == refTo;
                    }).sort(function (a, b) {
                        return a.label > b.label ? 1 : -1;
                    });
                    return filteredPicklist[name][type][refTo];
                }

                filteredPicklist[name][type] = $scope.fieldNamesOfObjects[name].filter(function (pick) {
                    return pick.type == type || type == 'string' && pick.type == 'textarea' || pick.type === undefined;
                }).sort(function (a, b) {
                    return a.label > b.label ? 1 : -1;
                });

                return filteredPicklist[name][type];
            };

            $scope.deleteObjectMapping = function (object) {
                delete $scope.objectMappings[object.Name];

                if (object.Id) {
                    globalActionsService.deletedMappings().push(object);
                }
            };

            $scope.isParent = function (objMapping) {
                return objMapping.Name == 'WorkOrder' || objMapping.Name == 'WorkOrderLineItem';
            };

            $scope.isService = function (objMapping) {
                return objMapping.Name == 'ServiceAppointment';
            };
        }

        var template = '\n                        <p>Set default values from the object to the global action interface. The user can override the values when needed.\n                        </p>\n                        <div class="newObjectSelect-container">\n                            <select class="select-setting" ng-model="selectedNewObject" ng-options="object.label for object in getSelectableObjects() | orderBy:\'label\' "></select>\n                            <div ng-click="addObject(selectedNewObject)" class="save-button add-mapping-button blueButton">Add Object</div>\n                        </div>\n \n\n                        <content-collapse-wrapper header="object[objectMappingFields.label__c]" open="object.isOpen" ng-repeat="object in objectMappings">\n                            <content>\n                                \n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'string\')" label="\'Street\'" value-field-name="\'Street__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'string\')" label="\'City\'" value-field-name="\'City__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'string\')" label="\'State\'" value-field-name="\'State__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'string\')" label="\'Country\'" value-field-name="\'Country__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'string\')" label="\'Zip Code\'" value-field-name="\'Zipcode__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'double\')" label="\'Latitude\'" value-field-name="\'Latitude__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'double\')" label="\'Longitude\'" value-field-name="\'Longitude__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'datetime\')" label="\'Earliest Start Permitted\'" value-field-name="\'Early_Start__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'datetime\')" label="\'Due Date\'" value-field-name="\'Due_Date__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'reference\', schedulingPolicyName)" label="\'Scheduling Policy\'" value-field-name="\'Scheduling_Policy__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'reference\', \'ServiceTerritory\')" label="\'Service Territory\'" value-field-name="\'Territory__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(object.Name, \'reference\', \'WorkType\')" label="\'Default Work Type\'" value-field-name="\'Default_Type__c\'" setting="object"></custom-settings-wrapper>\n                                <custom-settings-wrapper ng-if="!isParent(object) && !isService(object)" primitive-type="primitiveType.picklist" options="getFilteredPicklist(\'WorkOrder\', \'reference\', object.Name)" label="\'Lookup From Work Order\'" value-field-name="\'ObjectID__c\'" setting="object"></custom-settings-wrapper>\n                                \n                                <div class="delete-button-settings" ng-click="deleteObjectMapping(object)">Delete Mapping</div>\n                                \n                            </content>\n                        </content-collapse-wrapper>';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('globalActionsEmergency', globalActionsEmergency);

    globalActionsEmergency.$inject = [];

    function globalActionsEmergency() {

        controllerFunction.$inject = ['$scope', 'dataService', 'primitiveType'];

        function controllerFunction($scope, dataService, primitiveType) {

            $scope.verifyFunctions.push(function () {
                return console.log('verify - globalActionsEmergency');
            });

            $scope.settings = dataService.getDraftSettings();
            $scope.primitiveType = primitiveType;

            dataService.getSettingsPromise().then(function () {
                $scope.schedulingPolicies = dataService.policies;
                $scope.operatingHours = dataService.operatingHours;
            });
        }

        var template = '\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="schedulingPolicies" label="\'Emergency scheduling policy\'" tooltip-text="The default policy selected in the wizard" value-field-name="\'SchedulingPolicyId__c\'" setting="settings.EmergencySettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="1" max="10000" label="\'Last known location validity\'" tooltip-text="The number of minutes a technician\'s Last Known Location will be considered" value-field-name="\'Breadcrumbs_Validity__c\'" setting="settings.EmergencySettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="1" max="100" label="\'Ideal availability grade\'" tooltip-text="The threshold, in minutes, for an ideal estimated time of arrival" value-field-name="\'Ideal_Availability_Grade__c\'" setting="settings.EmergencySettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="1" max="100" label="\'Good availability grade\'" tooltip-text="The threshold, in minutes, for a acceptable estimated time of arrival" value-field-name="\'Good_Availability_Grade__c\'" setting="settings.EmergencySettings"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="1" max="10000" label="\'Emergency search timeframe\'" tooltip-text="Number of minutes to add to the current time when searching availability" value-field-name="\'Emergency_Due_Date_Offset__c\'" setting="settings.EmergencySettings"></custom-settings-wrapper>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('optimizationActivation', optimizationActivation);

    optimizationActivation.$inject = [];

    function optimizationActivation() {

        controllerFunction.$inject = ['$scope', '$http', 'settingsUtils'];

        function controllerFunction($scope, $http, settingsUtils) {

            $scope.verifyFunctions.push(function () {
                return console.log('verify - optimizationActivation');
            });

            $scope.authorizedNow = location.search.indexOf('result=1') >= 0;
            $scope.startAuthorization = startAuthorization; // ActionFunction
            $scope.auth = {};
            $scope.auth.user = authorizationInfo[fieldNames.AuthorizationInfo.Username__c];
            $scope.auth.moment = new Date(authorizationInfo[fieldNames.AuthorizationInfo.Auth_Date__c]);
            $scope.authorized = $scope.auth.user !== undefined && $scope.auth.user !== null;
            $scope.sessionId = sessionId;
            $scope.orgProps;
            $scope.profileStatus;
            $scope.enableOptimizationBtn;
            $scope.infoMsg;
            $scope.creatingProfile = false;
            $scope.activationMsg = 'Activate Optimization';
            $scope.nameSpace = orgNameSpace;

            if (profile === "FSL Optimization") {
                $scope.profileStatus = "activate";
                $scope.enableOptimizationBtn = true;
                $scope.activationMsg = $scope.authorized ? 'Reactivate Optimization' : $scope.activationMsg;
                $scope.infoMsg = !$scope.authorized ? 'Field Service Lightning Optimization Services' : '';
            } else if (isOptimizationProfileExist === "true") {
                $scope.profileStatus = "switchUser";
                $scope.enableOptimizationBtn = false;
                $scope.activationMsg = $scope.authorized ? 'Optimization Is Active' : $scope.activationMsg;
                $scope.infoMsg = 'Your user profile isn\'t authorized. To enable optimization, log in as the FSL Optimization user.';
            } else {
                $scope.profileStatus = "createProfile";
                $scope.enableOptimizationBtn = true;
                $scope.activationMsg = 'Create Optimization Profile';
                $scope.infoMsg = 'User profile not authorized'; //, To enable optimization create optimization profile by pressing the "Create optimization profile" button';
            }

            $scope.activateOptimization = function () {
                if ($scope.profileStatus == "createProfile") {
                    $scope.creatingProfile = true;

                    settingsUtils.callRemoteAction(remoteActions.getOrgProperties).then(function (orgProp) {
                        $scope.orgProps = orgProp;

                        var baseUrl = window.location.origin;
                        var dataStr = '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><env:Header><SessionHeader xmlns="http://soap.sforce.com/2006/04/metadata"><sessionId>' + $scope.sessionId + '</sessionId></SessionHeader></env:Header><env:Body><readMetadata xmlns="http://soap.sforce.com/2006/04/metadata"><type>Profile</type><fullNames>Admin</fullNames></readMetadata></env:Body></env:Envelope>';

                        $http.post(baseUrl + '/services/Soap/m/38.0', dataStr, {
                            responseType: 'document',
                            headers: { 'SOAPAction': '""', 'Content-Type': 'text/xml', contentType: "text/xml" }
                        }).then(function (res) {
                            $scope.orgProps.fields = res.data.getElementsByTagName('fieldPermissions');
                            $scope.createProfile(baseUrl);
                        }).catch(function () {
                            $scope.creatingProfile = false;
                        });
                    });
                } else if ($scope.profileStatus = "activate") {
                    $scope.startAuthorization();
                }
            };

            $scope.createProfile = function (baseUrl) {
                var settingsTabName = 'Master_Settings';
                var dataStr = '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><env:Header><SessionHeader xmlns="http://soap.sforce.com/2006/04/metadata"><sessionId>' + $scope.sessionId + '</sessionId></SessionHeader></env:Header><env:Body><createMetadata xmlns="http://soap.sforce.com/2006/04/metadata"><metadata xsi:type="Profile"><fullName>FSL Optimization</fullName>';
                dataStr += $scope.addPagesPermission($scope.orgProps.pages);
                dataStr += $scope.addClassesPermission($scope.orgProps.classes);
                dataStr += $scope.addObjectsPermission($scope.orgProps.objects);
                dataStr += $scope.addUserPermissions($scope.orgProps.permissions);
                dataStr += $scope.addRecordTypes($scope.orgProps.recordtypes);
                dataStr += $scope.addApps($scope.orgProps.apps);
                dataStr += $scope.addFieldsPermission($scope.orgProps.fields);
                settingsTabName = $scope.nameSpace != '' ? $scope.nameSpace + settingsTabName : settingsTabName;
                dataStr += '<tabVisibilities><tab>' + settingsTabName + '</tab><visibility>DefaultOn</visibility></tabVisibilities>';
                dataStr += '</metadata></createMetadata></env:Body></env:Envelope>';

                $http.post(baseUrl + '/services/Soap/m/38.0', dataStr, {
                    headers: { 'SOAPAction': '""', 'Content-Type': 'text/xml', contentType: "text/xml" }
                }).then(function (res) {
                    $scope.creatingProfile = false;

                    settingsUtils.callRemoteAction(remoteActions.createOptUser).then(function (optUserId) {
                        alert('Optimization user ' + optUserId + ' was created and optimization profile was assigned to it. Please switch to this user in order to apply optimization');
                        window.location.reload();
                    }, function (err) {
                        $scope.creatingProfile = false;
                        var exceptionObj = JSON.parse(err.message);
                        alert(exceptionObj.msg);

                        if (exceptionObj.eraseProfile) {
                            var dataStr = '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><env:Header><SessionHeader xmlns="http://soap.sforce.com/2006/04/metadata"><sessionId>' + $scope.sessionId + '</sessionId></SessionHeader></env:Header><env:Body><deleteMetadata xmlns="http://soap.sforce.com/2006/04/metadata"><type>Profile</type><fullNames>FSL Optimization</fullNames></deleteMetadata></env:Body></env:Envelope>';
                            $http.post(baseUrl + '/services/Soap/m/38.0', dataStr, {
                                data: dataStr,
                                contentType: "text/xml",
                                headers: { 'SOAPAction': '""' },
                                success: function success(res) {}
                            });
                        } else {
                            window.location.reload();
                        }
                    });
                }).catch(function () {
                    $scope.creatingProfile = false;
                    alert('Something went wrong. Contact to your system administrator for help');
                });
            };

            $scope.addFieldsPermission = function (orgFields) {
                var fieldsAjaxStr = '';

                for (var i = 0; i < orgFields.length; i++) {
                    var fieldStr = orgFields[i].getElementsByTagName('field')[0].textContent;
                    fieldsAjaxStr += '<fieldLevelSecurities><field>' + fieldStr + '</field><editable>false</editable><readable>false</readable><hidden>true</hidden></fieldLevelSecurities>';
                }

                return fieldsAjaxStr;
            };

            $scope.addPagesPermission = function (orgPages) {
                var pagesAjaxStr = '';
                orgPages.disabled.forEach(function (pageStr) {
                    pagesAjaxStr += '<pageAccesses><apexPage>' + pageStr + '</apexPage><enabled>false</enabled></pageAccesses>';
                });

                orgPages.enabled.forEach(function (pageStr) {
                    pagesAjaxStr += '<pageAccesses><apexPage>' + pageStr + '</apexPage><enabled>true</enabled></pageAccesses>';
                });

                return pagesAjaxStr;
            };

            $scope.addUserPermissions = function (orgPermissions) {
                var permAjaxStr = '';
                orgPermissions.disabled.forEach(function (permStr) {
                    permAjaxStr += '<userPermissions><name>' + permStr + '</name><enabled>false</enabled></userPermissions>';
                });

                orgPermissions.enabled.forEach(function (permStr) {
                    permAjaxStr += '<userPermissions><name>' + permStr + '</name><enabled>true</enabled></userPermissions>';
                });

                return permAjaxStr;
            };

            $scope.addApps = function (orgApps) {
                var appsAjaxStr = '';
                orgApps.disabled.forEach(function (appStr) {
                    appsAjaxStr += '<applicationVisibilities><application>' + appStr + '</application><default>false</default><visible>false</visible></applicationVisibilities>';
                });

                orgApps.enabled.forEach(function (appStr) {
                    appsAjaxStr += '<applicationVisibilities><application>' + appStr + '</application><default>true</default><visible>true</visible></applicationVisibilities>';
                });

                return appsAjaxStr;
            };

            $scope.addRecordTypes = function (orgRecTypes) {
                var recAjaxStr = '';
                orgRecTypes.disabled.forEach(function (recType) {
                    recAjaxStr += '<recordTypeVisibilities><recordType>' + recType + '</recordType><visible>false</visible><default>false</default></recordTypeVisibilities>';
                });

                return recAjaxStr;
            };

            $scope.addClassesPermission = function (orgClasses) {
                var classesAjaxStr = '';
                orgClasses.disabled.forEach(function (classStr) {
                    classesAjaxStr += '<classAccesses><apexClass>' + classStr + '</apexClass><enabled>false</enabled></classAccesses>';
                });

                orgClasses.enabled.forEach(function (classStr) {
                    classesAjaxStr += '<classAccesses><apexClass>' + classStr + '</apexClass><enabled>true</enabled></classAccesses>';
                });

                return classesAjaxStr;
            };

            $scope.addObjectsPermission = function (orgObjects) {
                var objectsAjaxStr = '';
                orgObjects.disabled.forEach(function (objStr) {
                    objectsAjaxStr += '<objectPermissions><allowCreate>false</allowCreate><allowDelete>false</allowDelete><allowEdit>false</allowEdit><allowRead>false</allowRead><modifyAllRecords>false</modifyAllRecords><object>' + objStr + '</object><viewAllRecords>false</viewAllRecords></objectPermissions>';
                });

                return objectsAjaxStr;
            };
        }

        var template = '\n            <div id="enableSO">\n\t\t\t\t<span ng-show="!authorized">{{infoMsg}}</span>\n\t\t\t\t<div ng-show="authorized" class="optActive">The optimization service is active.</div>\n\t\t\t\t<span ng-show="authorized" class="activatedText">User {{auth.user}} activated the optimization.<span am-time-ago="auth.moment"></span></span><br/>\n\t\t\t\t<div ng-click="!enableOptimizationBtn||activateOptimization()" ng-hide="!enableOptimizationBtn" ng-class="{authButton: enableOptimizationBtn}" >{{activationMsg}}</div>\n\t\t\t\t\n\n\t\t\t\t<div ng-show="creatingProfile" id="creatingProfileInformer">\n\t\t        \tCreating Optimizaion Profile... Please Wait.\n\t\t        </div>\n\t\t\t</div>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('optimizationJobs', optimizationJobs);

    optimizationJobs.$inject = [];

    function optimizationJobs() {

        controllerFunction.$inject = ['$scope', 'dataService', '$rootScope'];

        function controllerFunction($scope, dataService, $rootScope) {

            $scope.verifyFunctions.push(function () {
                return console.log('verify - optimizationJobs');
            });

            $rootScope.$on('settingsUpdated', function () {
                $scope.automators = dataService.getAutomators('Sched004_OAAS');
            });

            dataService.getSettingsPromise().then(function () {
                $scope.automators = dataService.getAutomators('Sched004_OAAS');
            });
        }

        var template = '\n        <div class="automatorExp">Create scheduled optimization runs.</div>\n        <automators objects="automators" class-names="[\'Sched004_OAAS\']"></automators>\n        ';

        return {
            restrict: 'E',
            scope: {
                formObject: '=',
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('optimizationLogic', optimizationLogic);

    optimizationLogic.$inject = [];

    function optimizationLogic() {

        controllerFunction.$inject = ['$scope', 'dataService', 'primitiveType', 'serviceAppointmentLifeCycleService', '$q', '$rootScope', 'OPTIMIZATION_RUNTIME_VALUES'];

        function controllerFunction($scope, dataService, primitiveType, serviceAppointmentLifeCycleService, $q, $rootScope, OPTIMIZATION_RUNTIME_VALUES) {

            $scope.verifyFunctions.push(function () {
                return console.log('verify - optimizationLogic');
            });
            $scope.pinnedStatuses = {};
            $scope.RsoPinnedStatuses = {};
            $scope.primitiveType = primitiveType;
            $scope.disableOptimizationRunTime = false;

            dataService.getSettingsPromise().then(function () {
                $scope.settings = dataService.getDraftSettings();
                $scope.disableOptimizationRunTime = Object.values(OPTIMIZATION_RUNTIME_VALUES).indexOf($scope.settings.OptimizationSettingsBGO[fieldNames.OptimizationSettings__c.Max_Runtime_Single_Service__c]) == -1;
            });

            $q.all([serviceAppointmentLifeCycleService.loadData(), dataService.getSettingsPromise()]).then(function () {

                $scope.statuses = serviceAppointmentLifeCycleService.settings.StatusList;

                $scope.statuses.forEach(function (status) {
                    //BGO
                    if ($scope.settings.OptimizationSettingsBGO[fieldNames.OptimizationSettings__c.Pinned_Statuses__c]) {
                        $scope.pinnedStatuses[status.value] = $scope.settings.OptimizationSettingsBGO[fieldNames.OptimizationSettings__c.Pinned_Statuses__c].split(',').indexOf(status.value) > -1;
                    }

                    //RSO
                    if ($scope.settings.OptimizationSettingsRSO[fieldNames.OptimizationSettings__c.Pinned_Statuses__c]) {
                        $scope.RsoPinnedStatuses[status.value] = $scope.settings.OptimizationSettingsRSO[fieldNames.OptimizationSettings__c.Pinned_Statuses__c].split(',').indexOf(status.value) > -1;
                    }
                });
            });

            $rootScope.$on('settingsUpdated', function () {
                $scope.statuses.forEach(function (status) {
                    //BGO
                    if ($scope.settings.OptimizationSettingsBGO[fieldNames.OptimizationSettings__c.Pinned_Statuses__c]) {
                        $scope.pinnedStatuses[status.value] = $scope.settings.OptimizationSettingsBGO[fieldNames.OptimizationSettings__c.Pinned_Statuses__c].split(',').indexOf(status.value) > -1;
                    }

                    //RSO
                    if ($scope.settings.OptimizationSettingsRSO[fieldNames.OptimizationSettings__c.Pinned_Statuses__c]) {
                        $scope.RsoPinnedStatuses[status.value] = $scope.settings.OptimizationSettingsRSO[fieldNames.OptimizationSettings__c.Pinned_Statuses__c].split(',').indexOf(status.value) > -1;
                    }
                });
            });

            $scope.optimizationRunTimeOptions = [{ label: 'Low', value: OPTIMIZATION_RUNTIME_VALUES.LOW }, { label: 'Medium', value: OPTIMIZATION_RUNTIME_VALUES.MEDIUM }, { label: 'High', value: OPTIMIZATION_RUNTIME_VALUES.HIGH }];

            $scope.updateSettings = function (which) {

                var statuses = [];

                var pinned = which == 'bgo' ? $scope.pinnedStatuses : $scope.RsoPinnedStatuses;

                for (var key in pinned) {
                    if (pinned[key]) {
                        statuses.push(key);
                    }
                }

                if (which == 'bgo') $scope.settings.OptimizationSettingsBGO[fieldNames.OptimizationSettings__c.Pinned_Statuses__c] = statuses.join(',');else if (which == 'rso') $scope.settings.OptimizationSettingsRSO[fieldNames.OptimizationSettings__c.Pinned_Statuses__c] = statuses.join(',');

                dataService.setDirty();
            };
        }

        var template = '\n            <div class="section-settings" id="__general-opt">General Logic</div>\n\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Enable optimization overlaps prevention\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Enable req overlaps prevention\']" tooltip-text="When checked - overlapping optimization requests will fail"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Change Optimization request status to fail when failing due to org costumizations\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Enable optimization failure\']" tooltip-text="When checked - if part of optimization scheduling failes due to org customization, the request status will be \'Failed\'"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Enable sharing for Optimization request\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Enable sharing for Optimization\']" tooltip-text="When checked - Optimization requests will be shared"></custom-settings-wrapper>\n\n\n            <div class="section-settings" id="__bgo-opt">Optimization Service</div>\n\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" is-disabled="disableOptimizationRunTime" options="optimizationRunTimeOptions" label="\'Optimization run time per service appointment\'" value-field-name="\'Max_Runtime_Single_Service__c\'" setting="settings.OptimizationSettingsBGO" tooltip-text="Optimization results depend on the length of the optimization run and the number of iterations required to get close to an optimal solution. In cases where there are many candidates for each service appointment, or when longer travel calculations are required and SLR is turned on, it is necessary to allow the optimization engine more time to get closer to the optimal solution. In these cases it is recommended to use the Medium or High time levels where Medium will target faster results  and High will run even longer and try to achieve higher optimization quality. When SLR is turned off and there aren\'t many candidates for each service appointment use the Low time level to achieve the quickest results or Medium for a better quality schedule."></custom-settings-wrapper>\n\n\n            Select the statuses that will block the optimization service from changing the Service Appointment<br/>\n            \n            \n            <div id="pinned-status-container">\n                <label for="OptimizationPinnedStatus{{$index}}" class="optimizaion-pinned-label" ng-repeat="status in statuses track by $index">\n                    <input type="checkbox" id="OptimizationPinnedStatus{{$index}}" ng-model="pinnedStatuses[status.value]" ng-change="updateSettings(\'bgo\')" />{{ status.value }}\n                </label>\n            </div>\n\n            <div class="section-settings" id="__rso-opt">Resource Schedule Optimization</div>\n            Select the statuses that will block the resource scheduling optimization service from changing the Service Appointment<br/>\n            \n            \n            <div id="pinned-status-container">\n                <label for="ResourceOptimizationPinnedStatus{{$index}}" class="optimizaion-pinned-label" ng-repeat="status in statuses track by $index">\n                    <input type="checkbox" id="ResourceOptimizationPinnedStatus{{$index}}" ng-model="RsoPinnedStatuses[status.value]" ng-change="updateSettings(\'rso\')" />{{ status.value }}\n                </label>\n            </div>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('optimizationParameters', optimizationParameters);

    optimizationParameters.$inject = ['dataService'];

    function optimizationParameters(dataService) {

        controllerFunction.$inject = ['$scope', 'primitiveType'];

        function controllerFunction($scope, primitiveType) {

            $scope.primitiveType = primitiveType;

            $scope.verifyFunctions.push(function () {
                return console.log('verify - optimizationParameters');
            });

            dataService.getSettingsPromise().then(function () {
                $scope.settings = dataService.getDraftSettings();
                $scope.serviceBoleanFields = angular.copy(dataService.serviceBooleanFields);
                $scope.serviceDateFields = angular.copy(dataService.serviceDateFields);
                $scope.serviceIntegerFields = angular.copy(dataService.serviceIntegerFields);
                $scope.serviceDoubleFields = angular.copy(dataService.serviceDoubleFields);
                $scope.serviceStringFields = angular.copy(dataService.serviceStringFields);
                $scope.resourceBoleanFields = angular.copy(dataService.resourceCheckboxFields);
                $scope.resourceDateFields = angular.copy(dataService.resourceDateFields);
                $scope.resourceIntegerFields = angular.copy(dataService.resourceIntegerFields);
                $scope.resourceDoubleFields = angular.copy(dataService.resourceDoubleFields);
                $scope.resourceStringFields = angular.copy(dataService.resourceStringFields);

                $scope.serviceBoleanFields[0] = { value: null, label: '--- Select a field ---' };
                $scope.serviceDateFields[0] = { value: null, label: '--- Select a field ---' };
                $scope.serviceIntegerFields[0] = { value: null, label: '--- Select a field ---' };
                $scope.serviceDoubleFields[0] = { value: null, label: '--- Select a field ---' };
                $scope.serviceStringFields[0] = { value: null, label: '--- Select a field ---' };
                $scope.resourceBoleanFields[0] = { value: null, label: '--- Select a field ---' };
                $scope.resourceDateFields[0] = { value: null, label: '--- Select a field ---' };
                $scope.resourceIntegerFields[0] = { value: null, label: '--- Select a field ---' };
                $scope.resourceDoubleFields[0] = { value: null, label: '--- Select a field ---' };
                $scope.resourceStringFields[0] = { value: null, label: '--- Select a field ---' };
            });
        }

        var template = '\n            <content-collapse-wrapper header="\'Service Optimization - Additional properties\'" open="false">\n                <content>\n                    <custom-settings-wrapper options="serviceBoleanFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Service__Boolean1"></custom-settings-wrapper>    \n                    <custom-settings-wrapper options="serviceBoleanFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Service__Boolean2"></custom-settings-wrapper>\n                    <custom-settings-wrapper options="serviceDateFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Service__Date1"></custom-settings-wrapper>    \n                    <custom-settings-wrapper options="serviceDateFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Service__Date2"></custom-settings-wrapper>\n                    <custom-settings-wrapper options="serviceIntegerFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Service__Integer1"></custom-settings-wrapper>    \n                    <custom-settings-wrapper options="serviceIntegerFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Service__Integer2"></custom-settings-wrapper>\n                    <custom-settings-wrapper options="serviceDoubleFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Service__Double1"></custom-settings-wrapper>    \n                    <custom-settings-wrapper options="serviceDoubleFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Service__Double2"></custom-settings-wrapper>\n                    <custom-settings-wrapper options="serviceStringFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Service__String1"></custom-settings-wrapper>    \n                    <custom-settings-wrapper options="serviceStringFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Service__String2"></custom-settings-wrapper>\n                </content>\n           </content-collapse-wrapper>\n           \n           <content-collapse-wrapper header="\'Resource Optimization - Additional properties\'" open="false">\n                <content>\n                    <custom-settings-wrapper options="resourceBoleanFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Resource__Boolean1"></custom-settings-wrapper>    \n                    <custom-settings-wrapper options="resourceBoleanFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Resource__Boolean2"></custom-settings-wrapper>\n                    <custom-settings-wrapper options="resourceDateFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Resource__Date1"></custom-settings-wrapper>    \n                    <custom-settings-wrapper options="resourceDateFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Resource__Date2"></custom-settings-wrapper>\n                    <custom-settings-wrapper options="resourceIntegerFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Resource__Integer1"></custom-settings-wrapper>    \n                    <custom-settings-wrapper options="resourceIntegerFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Resource__Integer2"></custom-settings-wrapper>\n                    <custom-settings-wrapper options="resourceDoubleFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Resource__Double1"></custom-settings-wrapper>    \n                    <custom-settings-wrapper options="resourceDoubleFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Resource__Double2"></custom-settings-wrapper>\n                    <custom-settings-wrapper options="resourceStringFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Resource__String1"></custom-settings-wrapper>    \n                    <custom-settings-wrapper options="resourceStringFields" primitive-type="primitiveType.picklist" label-field-name="\'Label__c\'" value-field-name="\'SF_Field_Name__c\'" setting="settings.SoFieldsMapping.Resource__String2"></custom-settings-wrapper>\n                </content>\n           </content-collapse-wrapper>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('schedulingDynamicGantt', schedulingDynamicGantt);

    schedulingDynamicGantt.$inject = [];

    function schedulingDynamicGantt() {

        controllerFunction.$inject = ['$scope', 'primitiveType', 'dataService'];

        function controllerFunction($scope, primitiveType, dataService) {

            // nothing to check here, all good
            $scope.verifyFunctions.push(function () {
                return false;
            });

            $scope.primitiveType = primitiveType;
            $scope.settings = dataService.getDraftSettings();

            $scope.queryOrderBy = [{ label: 'Priority', value: 'priority' }, { label: 'Distance', value: 'distance' }];

            $scope.fixOverLapsTreat = [{ label: 'Leave on Gantt and set In-jeopardy', value: 'On Reschedule Failure Set Service To In Jeopardy' }, { label: 'Unschedule the appointment(s)', value: 'Leave service unscheduled' }, { label: 'Reshuffle other assignments', value: 'Call reshuffle' }];

            $scope.onOverlapDetection = [{ label: 'Schedule to original resource only', value: 'Schedule To Original Resource Only' }, { label: 'Schedule to all resources', value: 'Schedule To All Resources' //value: 'Consider all Resources' }
            }];

            $scope.onServicesReschedule = [{ label: 'Chronological Order', value: 'Chronological Order' }, { label: 'Priority', value: 'Priority' }];

            $scope.onReschduleGroupNearBy = [{ label: 'Schedule to original resource only', value: 'Schedule To Original Resource Only' }, { label: 'Schedule to all resources', value: 'Schedule To All Resources' //value: 'Consider all Resources' }
            }];

            dataService.getSettingsPromise().then(function () {
                $scope.saBooleanFields = angular.copy(dataService.serviceBooleanFields);
                $scope.saBooleanFields.shift();

                $scope.woBooleanFields = angular.copy(dataService.woBooleanFields);
                $scope.woBooleanFields.shift();

                $scope.woliBooleanFields = angular.copy(dataService.woliBooleanFields);
                $scope.woliBooleanFields.shift();
            });
        }

        var template = '\n            \n            <div class="section-settings" id="__fix-overlaps">Fix Overlaps</div>\n            <p>\n                Fix overlap will reschedule appointments that overlap another appointment or an absence\n            </p>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Automatically fix overlaps when an appointment overlaps with another appointment or absence\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Enable Dynamic Gantt Fix Overlaps\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="onOverlapDetection" label="\'When attempting to fix overlaps\'" value-field-name="\'Reschedule_Options__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Overlap Settings\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="onServicesReschedule" label="\'After unscheduling services reschedule them by\'" value-field-name="\'Reschedule_Method__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Overlap Settings\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="fixOverLapsTreat" label="\'When unable to find a valid schedule for an appointment\'" value-field-name="\'Reschedule_Failure_Treatment__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Overlap Settings\']"></custom-settings-wrapper>\n   \n            <div class="section-settings" id="__fill-in">Fill-in Schedule</div>\n            <p>\n                Fill-in schedule will schedule work for an idle resource. You can trigger this service from the dispatcher console or through API <br>\n                When trying to fill in an idle resource\'s daily schedule, only service appoinments where the folllowing three fields evaluate to true will be considered as candidates. \n            </p>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="saBooleanFields" label="\'Service Appoinment candidate Boolean field\'" value-field-name="\'SA_Candidate_Boolean_Field__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Fill In Settings\']" tooltip-text="Select a Boolean field that indicates if a Service Appointment is a candidate to fill in schedule"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="woBooleanFields" label="\'Work Order candidate Boolean field\'" value-field-name="\'WO_Candidate_Boolean_Field__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Fill In Settings\']" tooltip-text="In the case of Work Order as an appoinment\'s parent - this field should be true for the service appointment be a candidate."></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="woliBooleanFields" label="\'Work Order Line Item candidate Boolean field\'" value-field-name="\'WOLI_Candidate_Boolean_Field__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Fill In Settings\']" tooltip-text="In the case of Work Order Line Item as an appoinment\'s parent - this field should be true for the service appointment be a candidate."></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="queryOrderBy" label="\'Order candidate appointments by\'" value-field-name="\'Order_Candidate_Appointments_By__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Fill In Settings\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="1" max="50" label="\'Max appointments to schedule\'" value-field-name="\'Max_Services_Limit__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Fill In Settings\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="5" max="60" label="\'Max runtime (seconds)\'" value-field-name="\'Max_Running_Time__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Fill In Settings\']"></custom-settings-wrapper>\n           \n            <div class="section-settings" id="__group-near-by">Group Nearby Appointments</div>\n            <p>\n                Group near-by appointments will schedule work that is close to a given appointment together. The service may unassign lower priority appointments in order to make room for the near-by appointments.\n            </p>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="saBooleanFields" label="\'Service Appoinment candidate Boolean field\'" value-field-name="\'SA_Candidate_Boolean_Field__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Group Near By Settings\']" tooltip-text="Select a Boolean field that indicates if a Service Appointment is a candidate to fill in schedule"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="woBooleanFields" label="\'Work Order candidate Boolean field\'" value-field-name="\'WO_Candidate_Boolean_Field__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Group Near By Settings\']" tooltip-text="In the case of Work Order as an appoinment\'s parent - this field should be true for the service appointment be a candidate."></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="woliBooleanFields" label="\'Work Order Line Item candidate Boolean field\'" value-field-name="\'WOLI_Candidate_Boolean_Field__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Group Near By Settings\']" tooltip-text="In the case of Work Order Line Item as an appoinment\'s parent - this field should be true for the service appointment be a candidate."></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="1" max="50" label="\'Max appointments to schedule\'" value-field-name="\'Max_Services_Limit__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Group Near By Settings\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="5" max="60" label="\'Max runtime (seconds)\'" value-field-name="\'Max_Running_Time__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Group Near By Settings\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="onReschduleGroupNearBy" label="\'When attempting to schedule the unscheduled service after the nearby services\'" value-field-name="\'Reschedule_Options__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Group Near By Settings\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="fixOverLapsTreat" label="\'When unable to arrange schedule\'" value-field-name="\'Reschedule_Failure_Treatment__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Group Near By Settings\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Radius for nearby appointments\'" value-field-name="\'Max_Services_Radius__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Group Near By Settings\']" tooltip-text="The radius in which appointments are considered \'near-by\'"></custom-settings-wrapper>\n            \n            <div class="section-settings" id="__reshuffle">Reshuffle assignments</div>\n            <custom-settings-wrapper primitive-type="primitiveType.number" min="1" max="7" label="\'Max time horizon (days) in which the appointment can be scheduled\'" value-field-name="\'Max_Running_Time__c\'" setting="settings.DynamicGanttSettings[\'Dynamic Gantt Reshuffle Settings\']"></custom-settings-wrapper>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();

// <custom-settings-wrapper primitive-type="primitiveType.boolean" label="'Try to reshuffle unsuccessful reschedulings'" value-field-name="'Enable_Reshuffle__c'" setting="settings.DynamicGanttSettings['Dynamic Gantt Group Near By Settings']"></custom-settings-wrapper>
// <custom-settings-wrapper primitive-type="primitiveType.picklist" options="onOverlapDetection" label="'When services overlap is detected'" value-field-name="'Reschedule_Options__c'" setting="settings.DynamicGanttSettings['Dynamic Gantt Group Near By Settings']"></custom-settings-wrapper>
'use strict';

(function () {

    angular.module('SettingsApp').directive('schedulingJobs', schedulingJobs);

    schedulingJobs.$inject = [];

    function schedulingJobs() {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {

            $scope.verifyFunctions.push(function () {
                return console.log('verify - schedulingJobs');
            });
        }

        var template = '';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('schedulingLogic', schedulingLogic);

    schedulingLogic.$inject = [];

    function schedulingLogic() {

        controllerFunction.$inject = ['$scope', 'primitiveType', 'dataService', 'settingsUtils', 'serviceAppointmentLifeCycleService', '$q', '$rootScope'];

        function controllerFunction($scope, primitiveType, dataService, settingsUtils, serviceAppointmentLifeCycleService, $q, $rootScope) {

            $scope.errors = {};

            // nothing to check here, all good
            $scope.verifyFunctions.push(function () {
                return false;
            });

            $scope.primitiveType = primitiveType;
            $scope.settings = dataService.getDraftSettings();

            $scope.pinnedStatuses = {};

            $scope.startOfWeek = [{ label: 'Sunday', value: 'Sunday' }, { label: 'Monday', value: 'Monday' }];

            $scope.PushTopicProps = ['FSL_Operation__c'];

            $scope.sharingObjectSettingsStatus = 'Validating';

            $scope.sharingObjects = [{
                SharingObjectAPI: "FSL_Operation__Share",
                SharingObjectName: "FSL Operation",
                Status: 'NotUpdated'
            }];

            $scope.buttonStateLabels = {
                update: 'Update push topic',
                updated: 'Push topic updated',
                validate: 'Validating push topic',
                failed: 'Failed to validate Push Topic for complex work'
            };

            $scope.$watch("sharingObjects", function (newValue, oldValue) {
                var privateSettingsCounter = 0;
                for (var i in newValue) {
                    if (newValue[i].Status == 'NotUpdated' || newValue[i].Status == 'ERROR') {
                        return;
                    }

                    if (newValue[i].Status == 'Public') {
                        $scope.sharingObjectSettingsStatus = 'Public';
                        return;
                    }

                    if (newValue[i].Status == 'Private') {
                        privateSettingsCounter++;
                    }
                }

                if (newValue.length == privateSettingsCounter) {
                    $scope.sharingObjectSettingsStatus = 'Private';
                }
            }, true);

            $q.all([serviceAppointmentLifeCycleService.loadData(), dataService.getSettingsPromise()]).then(function () {

                $scope.statuses = serviceAppointmentLifeCycleService.settings.StatusList;

                $scope.statuses.forEach(function (status) {
                    if ($scope.settings.LogicSettings[fieldNames.Logic_Settings__c.Pinned_Statuses_SF__c]) {
                        $scope.pinnedStatuses[status.value] = $scope.settings.LogicSettings[fieldNames.Logic_Settings__c.Pinned_Statuses_SF__c].split(',').indexOf(status.value) > -1;
                    }
                });
            });

            $scope.updateSettings = function () {
                var statuses = [];

                for (var key in $scope.pinnedStatuses) {
                    if ($scope.pinnedStatuses[key]) {
                        statuses.push(key);
                    }
                }

                $scope.settings.LogicSettings[fieldNames.Logic_Settings__c.Pinned_Statuses_SF__c] = statuses.join(',');
                dataService.setDirty();
            };

            $rootScope.$on('settingsUpdated', function () {
                $scope.automators = dataService.getAutomators('Sched009_STMIntegrityChecker');
                // if (dataService.getDraftSettings().LogicSettings[fieldNames.Logic_Settings__c.Use_SLR__c]) {
                //     $scope.automators = $scope.automators.concat(dataService.getAutomators('Sched006_SLRPurge'));
                // }

                $scope.statuses.forEach(function (status) {
                    if ($scope.settings.LogicSettings[fieldNames.Logic_Settings__c.Pinned_Statuses_SF__c]) {
                        $scope.pinnedStatuses[status.value] = $scope.settings.LogicSettings[fieldNames.Logic_Settings__c.Pinned_Statuses_SF__c].split(',').indexOf(status.value) > -1;
                    }
                });
            });

            dataService.getSettingsPromise().then(function () {
                $scope.booleanFields = angular.copy(dataService.serviceBooleanFields);
                $scope.booleanFields.shift();
                $scope.woNumberFields = dataService.woNumberFields;
                $scope.woliNumberFields = dataService.woliNumberFields;
                $scope.automators = dataService.getAutomators('Sched009_STMIntegrityChecker');
                $scope.classNames = ['Sched009_STMIntegrityChecker'];
                $scope.hideIntegrityCheckerAutomator = JSON.parse($scope.settings.GeneralConfig['Hide Integrity Checker Automator'][fieldNames.General_Config__c.Value__c]);

                // if (dataService.getDraftSettings().LogicSettings[fieldNames.Logic_Settings__c.Use_SLR__c])
                // {
                //     $scope.classNames.push('Sched006_SLRPurge');
                //     $scope.automators = $scope.automators.concat(dataService.getAutomators('Sched006_SLRPurge'));
                // }
            });
        }

        var template = '\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="booleanFields" label="\'Multiday service appointment field\'" value-field-name="\'MDT_Boolean_Field__c\'" setting="settings.LogicSettings" tooltip-text="Select which Boolean field indicates that a Service Appointment can span over multi days"></custom-settings-wrapper>\n            \n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="woNumberFields" label="\'Work order priority field\'" value-field-name="\'WO_Priority_Field__c\'" setting="settings.LogicSettings" tooltip-text="A numeric field on the service appointment\'s work order to set the priority"></custom-settings-wrapper>\n            \n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="woliNumberFields" label="\'Work Order Line Item priority field\'" value-field-name="\'WOLI_Priority_Field__c\'" setting="settings.LogicSettings" tooltip-text="A numeric field on the service appointment\'s work order line item to set the priority"></custom-settings-wrapper>\n            \n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Set the hour that starts a new day based on the Availability rule(s)\'" value-field-name="\'Enable_Start_Of_Day__c\'" setting="settings.LogicSettings" tooltip-text="The default, if this is not set, is 12AM"></custom-settings-wrapper>\n            \n            <custom-settings-wrapper primitive-type="primitiveType.number" label="\'Maximum days to get candidates or to book an appointment\'" min="1" max="31" value-field-name="\'Search_slot_max_days__c\'" setting="settings.LogicSettings" tooltip-text="The maximum number of days possible to request an appointment or get candidates. Increasing the maximum decreases performance"></custom-settings-wrapper>\n            \n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Auto schedule - Wait for geocode cleaning\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Wait for clean state\']" tooltip-text="Scheduling with auto schedule starts after the service appointment is successfully geocoded"></custom-settings-wrapper>\n\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Activate Approval confirmation on resource absences\'" value-field-name="\'Approved_Absences__c\'" setting="settings.LogicSettings"></custom-settings-wrapper>\n\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Enable resource crew skill grouping\'" value-field-name="\'Enable_Crew_Members_Skill_Aggregation__c\'" setting="settings.LogicSettings"></custom-settings-wrapper>\n\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" options="booleanFields" label="\'Avoid aerial calculation upon callout DML exception\'" value-field-name="\'Alert_On_Callout_Failure__c\'" setting="settings.GeocodeSettings"></custom-settings-wrapper>\n\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Respect secondary STM operating hours\'" value-field-name="\'Include_Secondary_Calendar__c\'" setting="settings.LogicSettings"></custom-settings-wrapper>\n\n            Select which statuses are considered as pinned, or unmovable, for scheduling<br> \n            \n            <div id="pinned-status-container">\n                <label for="SchedulingPinnedStatus{{$index}}" class="optimizaion-pinned-label" ng-repeat="status in statuses track by $index">\n                    <input type="checkbox" id="SchedulingPinnedStatus{{$index}}" ng-model="pinnedStatuses[status.value]" ng-change="updateSettings()" />{{ status.value }}\n                </label>\n            </div>\n\n            <automators objects="automators" class-names="classNames" hide-section="hideIntegrityCheckerAutomator"></automators>\n\n            <div class="section-settings" id="__complex-work">Complex Work</div>\n            <br>\n            <div class="alert-warning-banner" ng-show="sharingObjectSettingsStatus == \'Public\'">\n                The object below has public sharing.<br>\n                To enable complex work, set sharing to private for that object.\n            </div>\n            <br>\n\n            <object-sharing-status-directive ng-repeat="sharingObject in sharingObjects" object-sharing-props="sharingObject"></object-sharing-status-directive>\n            <push-topics-creator-directive push-topics-props="PushTopicProps" button-state-labels="buttonStateLabels" push-topics-tool-tip="Complex Work relies on push topic object that query for changes made for the relevant object. The push topic is created with a script upon installation. In some cases, such as when creating a sandbox from an instance with the package installed, the push topic isn\u2019t created. Click Update push topic to create the push topic."></push-topics-creator-directive>\n\n            <custom-settings-wrapper is-disabled="sharingObjectSettingsStatus != \'Private\'" primitive-type="primitiveType.boolean" label="\'Enable complex work\'" value-field-name="\'Use_New_MST_Data_Model__c\'" setting="settings.LogicSettings" tooltip-text="Allow modeling of scheduling dependencies between service appointments. Once this setting is enabled the related service, dependency type, same resource and same day fields will be deprecated and replaced by the new multi stage work model (available in the vf739_ComplexWork page)."></custom-settings-wrapper>\n            <custom-settings-wrapper is-disabled="sharingObjectSettingsStatus != \'Private\'" primitive-type="primitiveType.boolean" label="\'Related service appoinments - schedule all or nothing\'" value-field-name="\'Fail_On_Schedule__c\'" setting="settings.LogicSettings" tooltip-text="This setting prevents a chain of related services (with dependencies between them) from being scheduled separately. It will only be possible to schedule such a chain as a whole unit."></custom-settings-wrapper>\n            \n            \n            <div class="section-settings" id="__complex-work">Limit Apex Opertaions</div>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Enable Limit Apex Operations\'" value-field-name="\'Limit_Apex_Operations__c\'" setting="settings.LogicSettings" tooltip-text="To avoid max cpu time, enable this setting to dictate how many seconds to spend on each of the following opertions and return the received results in the time limit. "></custom-settings-wrapper>\n            \n            <custom-settings-wrapper is-text="false" primitive-type="primitiveType.number" min="1" max="100" label="\'Get candidates total CPU limit\'" value-field-name="\'Value__c\'" setting="settings.ApexLimits[\'GetCandidatesTotalCpuLimit\']" ></custom-settings-wrapper>\n            <custom-settings-wrapper is-text="false" primitive-type="primitiveType.number" min="1" max="100" label="\'Appointment booking total CPU limit\'" value-field-name="\'Value__c\'" setting="settings.ApexLimits[\'ABTotalCpuLimit\']" ></custom-settings-wrapper>\n            <custom-settings-wrapper is-text="false" primitive-type="primitiveType.number" min="1" max="100" label="\'Schedule total CPU limit\'" value-field-name="\'Value__c\'" setting="settings.ApexLimits[\'ScheduleTotalCpuLimit\']"></custom-settings-wrapper>\n            \n\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('schedulingPolicies', schedulingPolicies);

    schedulingPolicies.$inject = [];

    function schedulingPolicies() {

        controllerFunction.$inject = ['$scope', 'schedulingService'];

        function controllerFunction($scope, schedulingService) {

            $scope.verifyFunctions.push(function () {
                return console.log('verify - schedulingPolicies');
            });

            schedulingService.loadData().then(function () {
                $scope.schedulingSettings = schedulingService.settings;
            });
        }

        var template = '\n            <p>\n                When building and maintaining the schedule, the Field Service Lightning scheduling and optimization engine apply logic that is defined in various scheduling policies. \n            <br />\n                Scheduling policies are configurable and you can have several policies for the same territory in different times or in multiple territories.\n\n            <br />\n                A <a target="_blank" ng-href="../{{schedulingSettings.schedulingPoliciesPrefix}}">Scheduling Policy</a> is a collection of two elements: scheduling rules and weighted business objectives.\n            </p>\n            \n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('schedulingRouting', schedulingRouting);

    schedulingRouting.$inject = [];

    function schedulingRouting() {

        controllerFunction.$inject = ['$scope', 'primitiveType', 'dataService', '$rootScope', '$http', 'settingsUtils', '$timeout', 'OPTIMIZATION_RUNTIME_VALUES'];

        function controllerFunction($scope, primitiveType, dataService, $rootScope, $http, settingsUtils, $timeout, OPTIMIZATION_RUNTIME_VALUES) {

            $scope.sessionId = sessionId;
            $scope.EnableSLRIsDisabled = true;
            $scope.GISRemoteIsInactive = false;
            $scope.ShowRegisterBtn = false;
            // nothing to check here, all good
            $scope.verifyFunctions.push(function () {
                return false;
            });

            $scope.primitiveType = primitiveType;
            $scope.settings = dataService.getDraftSettings();
            $scope.classNames = [];

            $scope.distanceUnits = [{ label: 'KM', value: 'km' }, { label: 'Mile', value: 'mile' }];

            $scope.speedUnits = [{ label: 'KM/h', value: 'km' }, { label: 'MPH', value: 'mile' }];

            $rootScope.$on('settingsUpdated', function () {
                $scope.useSLR = dataService.getDraftSettings().LogicSettings[fieldNames.Logic_Settings__c.Use_SLR__c];
                $scope.lowOptimizationRunTime = dataService.getDraftSettings().OptimizationSettingsBGO[fieldNames.OptimizationSettings__c.Max_Runtime_Single_Service__c] == OPTIMIZATION_RUNTIME_VALUES.LOW;

                if ($scope.useSLR) {
                    $scope.automators = dataService.getAutomators('Sched006_SLRPurge');
                }
            });

            $scope.RegisterSLRBtnDisabled = false;

            $scope.registerSLR = function () {
                settingsUtils.callRemoteAction(remoteActions.registerSLR);
                $scope.RegisterSLRBtnDisabled = true;

                $timeout(function () {
                    $scope.RegisterSLRBtnDisabled = false;
                }, 5000);

                console.log('Registered SLR');
            };

            dataService.getSettingsPromise().then(function () {
                $scope.useSLR = dataService.getDraftSettings().LogicSettings[fieldNames.Logic_Settings__c.Use_SLR__c];
                $scope.ShowRegisterBtn = dataService.getDraftSettings().LogicSettings[fieldNames.Logic_Settings__c.Show_Register_Btn__c];
                $scope.lowOptimizationRunTime = dataService.getDraftSettings().OptimizationSettingsBGO[fieldNames.OptimizationSettings__c.Max_Runtime_Single_Service__c] == OPTIMIZATION_RUNTIME_VALUES.LOW;

                var baseUrl = window.location.origin;
                var dataStr = '<soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:met="http://soap.sforce.com/2006/04/metadata">' + '<soapenv:Header>' + '<met:SessionHeader>' + '<met:sessionId>' + $scope.sessionId + '</met:sessionId>' + '</met:SessionHeader>' + '</soapenv:Header>' + '<soapenv:Body>' + '<met:readMetadata>' + '<met:type>RemoteSiteSetting</met:type>' + '<met:fullNames>' + orgNameSpace + 'FSL_GIS</met:fullNames>' + '</met:readMetadata>' + '</soapenv:Body>' + '</soapenv:Envelope>';

                $http.post(baseUrl + '/services/Soap/m/38.0', dataStr, { headers: { 'SOAPAction': '""',
                        'Content-Type': 'text/xml',
                        contentType: "text/xml" }
                }).then(function (res) {
                    var parser = new DOMParser();
                    var xmlDoc = parser.parseFromString(res.data, "text/xml");
                    var res = xmlDoc.getElementsByTagName("isActive");

                    if (res == undefined || res.length == 0 || res[0] == undefined || res[0].innerHTML == "false") {
                        $scope.GISRemoteIsInactive = true;
                        $scope.EnableSLRIsDisabled = true;
                    } else {
                        $scope.GISRemoteIsInactive = false;
                        $scope.EnableSLRIsDisabled = false;
                    }
                }, function (res) {
                    // console.log(res);
                });

                if ($scope.useSLR) {
                    $scope.classNames.push('Sched006_SLRPurge');
                    $scope.automators = dataService.getAutomators('Sched006_SLRPurge');
                }
            });
        }

        var template = '\n            <div class="alert-warning-banner" ng-show="lowOptimizationRunTime && useSLR">\n              When using SLR, it is highly recommended to change the optimization time to Medium or High.<br/>\n              To change the optimization runtime go to Optimization -> Logic<br/>\n            </div>\n\n            <div class="setting-row-container" ng-show="ShowRegisterBtn"><label class="select-label">Please click to register to the SLR service</label><input type="button" ng-disabled="RegisterSLRBtnDisabled" class="register-button select-container" ng-click="registerSLR()" value="Register"></div>\n\n            <custom-settings-wrapper is-beta="true" is-disabled="EnableSLRIsDisabled" primitive-type="primitiveType.boolean" label="\'Enable Street Level Routing\'" value-field-name="\'Use_SLR__c\'" setting="settings.LogicSettings" tooltip-text="Enable Street Level Routing to calculate travel distance and time more accurately than the default aerial routing"></custom-settings-wrapper>\n            \n            <div class="setting-row-container smallSettingsError" ng-show="GISRemoteIsInactive">Your remote site FSLGIS is Inactive please activate it before trying to enable SLR.</div>\n\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Calculate travel and breaks\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Travel Time\']" tooltip-text="Calculates and displays travel time on the Gantt chart and automatically creates breaks according to your Resource Availability work rule."></custom-settings-wrapper>\n\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="speedUnits" label="\'Travel speed unit\'" value-field-name="\'Travel_Speed_Unit__c\'" setting="settings.LogicSettings"></custom-settings-wrapper>\n\n            <custom-settings-wrapper primitive-type="primitiveType.number" label="\'Default travel speed\'" min="0" max="1500" value-field-name="\'Travel_Speed__c\'" setting="settings.LogicSettings" tooltip-text="If a different travel speed isn\'t specified on the resource, this value is used to calculate the travel time"></custom-settings-wrapper>\n\n            <div class="section-settings" id="__map">Map</div>\n            <custom-settings-wrapper primitive-type="primitiveType.booleanText" label="\'Show map\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Map available on gantt\']" tooltip-text="Enables map tab"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.booleanText" label="\'Show street level routing in the Service Resource map tab\'" value-field-name="\'Value__c\'" setting="settings.GeneralConfig[\'Show SLR in resource map\']" tooltip-text="If checked, resource\'s planned travel will be shown on the street level. Otherwise a straight polyline will be shown"></custom-settings-wrapper>\n            \n            <automators objects="automators" class-names="classNames" no-change="useSLR" ng-show="useSLR"></automators>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('lifeCycleCreation', lifeCycleCreation);

    lifeCycleCreation.$inject = ['serviceAppointmentLifeCycleService'];

    function lifeCycleCreation(serviceAppointmentLifeCycleService) {

        controllerFunction.$inject = ['$scope', '$rootScope', 'primitiveType', 'dataService'];

        function controllerFunction($scope, $rootScope, primitiveType, dataService) {

            $scope.verifyFunctions.push(function () {
                return console.log('verify - lifeCycleCreation');
            });
            $scope.primitiveType = primitiveType;

            $scope.HighOrLow = [{ label: 'Highest', value: 'Highest' }, { label: 'Lowest', value: 'Lowest' }];

            $scope.useHighOrLowPolicy = false;

            $rootScope.$on('settingsUpdated', function () {
                $scope.useHighOrLowPolicy = dataService.getDraftSettings().TriggerConfigurations['Enable Service Auto Classification'][fieldNames.triggerConf.Run__c];
            });

            dataService.getSettingsPromise().then(function () {
                $scope.useHighOrLowPolicy = dataService.getDraftSettings().TriggerConfigurations['Enable Service Auto Classification'][fieldNames.triggerConf.Run__c];
            });

            $scope.settings = dataService.getDraftSettings();
        }

        var template = '\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Service Type Derive Due Date\']" tooltip-text="The Service appointment Due Date field will be defaulted to NOW() + the due date offset defined for the work type used"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Pinned Service Not Changed\']" tooltip-text="Pinned Service appointments will not be rescheduled by the scheduling engine"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Service Duration Longer Than Minute\']" tooltip-text="In case the Duration field is blank upon Service appointment creation, set the duration to one hour"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Enable Service Auto Classification\']" tooltip-text="The service territory field on service appointment will be update according to the polygons on the org" is-beta="true"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.picklist" options="HighOrLow" label="\'Territory classification policy\'" value-field-name="\'Low_Or_High_Territory_Classification__c\'" setting="settings.LogicSettings" ng-show="useHighOrLowPolicy"></custom-settings-wrapper>\n        ';

        return {
            restrict: 'E',
            scope: {
                formObject: '=',
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('lifeCycleStatusDefinitions', lifeCycleStatusDefinitions);

    lifeCycleStatusDefinitions.$inject = ['serviceAppointmentLifeCycleService'];

    function lifeCycleStatusDefinitions(serviceAppointmentLifeCycleService) {

        controllerFunction.$inject = ['$scope', 'primitiveType', 'dataService'];

        function controllerFunction($scope, primitiveType, dataService) {
            $scope.verifyFunctions.push(function () {
                return console.log('verify - lifeCycleCreation');
            });
            $scope.primitiveType = primitiveType;
            $scope.settings = dataService.getDraftSettings();

            serviceAppointmentLifeCycleService.loadData().then(function () {
                $scope.serverSettings = serviceAppointmentLifeCycleService.settings;
            });
        }

        var template = '\n            <custom-settings-wrapper ng-repeat="status in settings.Dictionaries track by $index" \n                                        primitive-type="primitiveType.picklist" \n                                        label-field-name="\'Default_Value__c\'" \n                                        value-field-name="\'Value__c\'"\n                                        options="serverSettings.StatusList" \n                                        setting="status" ></custom-settings-wrapper>\n        ';

        return {
            restrict: 'E',
            scope: {
                formObject: '=',
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('lifeCycleStatusTransition', lifeCycleStatusTransition);

    lifeCycleStatusTransition.$inject = ['serviceAppointmentLifeCycleService'];

    function lifeCycleStatusTransition(serviceAppointmentLifeCycleService) {

        controllerFunction.$inject = ['$scope', 'dataService', 'primitiveType', '$rootScope'];

        function controllerFunction($scope, dataService, primitiveType, $rootScope) {

            //$scope.verifyFunctions.push( () => console.log('verify - lifeCycleStatusTransition'));
            $scope.primitiveType = primitiveType;
            $scope.settings = dataService.getDraftSettings();
            $scope.showMore = false;
            $scope.invalid = false;
            $scope.errorMsg = '';
            $scope.statusMap = {};

            serviceAppointmentLifeCycleService.loadData().then(function () {
                $scope.serverSettings = serviceAppointmentLifeCycleService.settings;
                $scope.apexPagesList = angular.copy($scope.serverSettings.ApexPages);
                $scope.apexPagesList.unshift({ value: null, label: '--- Select custom VisualForce page ---' });

                for (var i = 0; i < $scope.serverSettings.StatusList.length; i++) {
                    $scope.statusMap[$scope.serverSettings.StatusList[i].value] = $scope.serverSettings.StatusList[i].label;
                }
            });

            $scope.setPlaceholder = function (allowedProf) {
                if (allowedProf && allowedProf.split(',').length > 0) return allowedProf.split(',').length + ' profiles selected';else return 'All profiles allowed';
            };

            $scope.setBorderClass = function (status) {
                var classString = 'left-border left-border-';

                if (status) {
                    var statBoy = $scope.statusMap[status] || status;
                    return classString + statBoy.replace(' ', '').toLowerCase();
                } else return classString + 'default';
            };

            $scope.addFlow = function (from, to, profiles, apexPage) {
                from = from || $scope.serverSettings.StatusList[0].value;
                to = to || $scope.serverSettings.StatusList[1].value;
                profiles = profiles || '';
                var status = {
                    'Name': from + '-' + to
                };

                status[fieldNames.statusTransitions.From_Status__c] = from;
                status[fieldNames.statusTransitions.To_Status__c] = to;
                status[fieldNames.statusTransitions.Allowed_Profiles__c] = profiles;
                status[fieldNames.statusTransitions.Custom_VF__c] = apexPage;
                $scope.settings.ServiceLegalStatuses.push(status);
            };

            $scope.removeStatusFlow = function (index) {
                $scope.invalid = false;
                delete $scope.settings.ServiceLegalStatuses[index];
                $scope.settings.ServiceLegalStatuses.splice(index, 1);
            };

            $scope.checkFlow = function (status) {
                $scope.invalid = false;
            };

            $rootScope.$on('transitionsError', function (event, args) {

                if (args.msg == null) {
                    $scope.invalid = false;
                    return;
                }

                $scope.errorMsg = args.msg;
                $scope.invalid = true;
            });

            $scope.getPackagedFieldName = function (field) {
                return fieldNames.statusTransitions[field];
            };

            $scope.getTriggerConfFieldName = function (field) {
                return fieldNames.triggerConf[field];
            };

            $scope.setDiagram = function () {
                var diagramText = '';

                if ($scope.settings && !$scope.settings.ServiceLegalStatuses) return diagramText;

                function setDiagramClass(status) {
                    return '<' + status.replace(' ', '').toLowerCase() + '>';
                }

                diagramText = '                \n                #.none: fill=#a5e2d6\n                #.scheduled: fill=#F9D058\n                #.dispatched: fill=#8DD8FA\n                #.inprogress: fill=#DCC984\n                #.completed: fill=#95D055\n                #.cannotcomplete: fill=#EA8288\n                #.canceled: fill=#BEBCBA\n                #.default: fill=#B7C9EA\n                #stroke: #232323\n                #lineWidth: 2\n                #arrowSize: 0.7\n                #fontSize: 10\n                #zoom: 1\n                #fill: #f4f6f9\n                ';

                for (var i = 0; i < $scope.settings.ServiceLegalStatuses.length; i++) {
                    var from = $scope.statusMap[$scope.settings.ServiceLegalStatuses[i][fieldNames.statusTransitions.From_Status__c]],
                        to = $scope.statusMap[$scope.settings.ServiceLegalStatuses[i][fieldNames.statusTransitions.To_Status__c]];
                    diagramText += '[' + from + ']->[' + to + ']\n';
                }

                return diagramText;
            };

            $scope.closeAllOthers = function (status, index) {
                $rootScope.$broadcast('closeAllOthers', { status: status, index: index });
            };
        }

        var template = '\n        <div class="section-settings">Service Appointment Status Transitions\n          <checkbox class="transitions-checkbox" label="" object="settings.GeneralConfig[\'Status Transitions Policy\']" value-field="\'Run__c\'"></checkbox>\n        </div>\n        <div class="slds transitions-table" ng-show="settings.GeneralConfig[\'Status Transitions Policy\'][getTriggerConfFieldName(\'Run__c\')]">\n            <table class="slds-table slds-table--fixed-layout" id="transitions-table">\n  <thead>\n    <tr class="slds-text-title--caps">\n      \n      <th class="header-picklist">\n          <span class="slds-truncate" title="From">From</span>\n      </th>\n      <th class="header-picklist">\n          <span class="slds-truncate" title="To">To</span>\n      </th>\n      <th class="header-profiles" ng-show="showMore">\n          <span class="slds-truncate" title="Allowed Profiles">Allowed Profiles</span>\n      </th>\n      <th class="header-custom-vf" ng-show="showMore">\n          <span class="slds-truncate" title="Custom Visual Force">Custom Visual Force</span>\n      </th>\n    </tr>\n  </thead>\n  <tbody>\n    <tr ng-repeat="status in settings.ServiceLegalStatuses track by $index">\n      <td>\n        <div class="from-cell">\n            <custom-settings-wrapper ng-class="setBorderClass(status[getPackagedFieldName(\'From_Status__c\')])"\n                    primitive-type="primitiveType.picklist" \n                    value-field-name="\'From_Status__c\'"\n                    options="serverSettings.StatusList" \n                    setting="status" \n                    change="checkFlow(status)"\n                    >\n                </custom-settings-wrapper>\n        </div>\n      </td>\n      <td>\n        <div class="to-cell">\n            <custom-settings-wrapper  ng-class="setBorderClass(status[getPackagedFieldName(\'To_Status__c\')])"\n                    primitive-type="primitiveType.picklist" \n                    value-field-name="\'To_Status__c\'"\n                    options="serverSettings.StatusList" \n                    setting="status" \n                    change="checkFlow(status)"\n                    >\n                </custom-settings-wrapper>\n        </div>\n      </td>\n      <td ng-show="showMore">\n        <div class="profiles-cell">\n            <custom-settings-wrapper \n                primitive-type="primitiveType.multi" \n                value-field-name="\'Allowed_Profiles__c\'"\n                options="serverSettings.AllProfiles"\n                placeholder="setPlaceholder(status[getPackagedFieldName(\'Allowed_Profiles__c\')])"\n                setting="status" \n                ng-click="closeAllOthers(status, $index)">\n            </custom-settings-wrapper>\n        </div>\n      </td>\n      <td ng-show="showMore">\n        <div class="customvf-cell">\n            <custom-settings-wrapper  \n                primitive-type="primitiveType.picklist" \n                value-field-name="\'Custom_VF__c\'"\n                options="apexPagesList" \n                setting="status" >\n            </custom-settings-wrapper>\n        </div>\n      </td>\n\n        <td>\n        <div class="delete-cell">\n            <a href="javascript:void(0);" ng-click="removeStatusFlow($index)">\n                <svg aria-hidden="true" class="delete-icon" ng-class="{\'showless\': showMore == false}">\n                    <use xlink:href="' + settings.icons.delete + '"></use>\n                </svg>\n            </a>\n        </div>\n      </td>\n    </tr>\n  </tbody>\n</table>\n<div class="newAutomatorError" ng-if="invalid">\n    <ui-error>\n        <main-content>\n            <div>{{errorMsg}}</div>\n        </main-content>\n    </ui-error>\n</div>\n</div>\n\n<div class="table-buttons" ng-show="settings.GeneralConfig[\'Status Transitions Policy\'][getTriggerConfFieldName(\'Run__c\')]">\n  <div class="add-flow-button" ng-click="addFlow()">Add Flow</div>\n  <a href="javascript:void(0);" ng-show="!showMore" ng-click="showMore = true;">More details</a>\n  <a href="javascript:void(0);" ng-show="showMore" ng-click="showMore = false;">Less details</a>\n</div>\n<div id="statusDiagram" ng-if="settings.ServiceLegalStatuses" ng-show="settings.GeneralConfig[\'Status Transitions Policy\'][getTriggerConfFieldName(\'Run__c\')]">\n  <canvas nomnoml nomnoml-model="setDiagram()"</canvas>\n</div>\n  ';

        return {
            restrict: 'E',
            scope: {
                formObject: '=',
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('sharingAutomation', sharingAutomation);

    sharingAutomation.$inject = ['sharingService', 'primitiveType'];

    function sharingAutomation(sharingService, primitiveType) {

        controllerFunction.$inject = ['$scope', 'dataService', '$rootScope'];

        function controllerFunction($scope, dataService, $rootScope) {
            $scope.primitiveType = primitiveType;
            $scope.settings = dataService.getDraftSettings();
            dataService.getSettingsPromise().then(function () {
                $scope.automators = dataService.getAutomators('Sched008_TimePhaseSharing');
            });

            $rootScope.$on('settingsUpdated', function () {
                $scope.automators = dataService.getAutomators('Sched008_TimePhaseSharing');
            });
        }

        var template = '\n            <custom-settings-wrapper id="__sharingtriggers" primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Status Actions\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Enable workorder parent sharing\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Enable account parent sharing\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Enable opportunity parent sharing\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Enable asset parent sharing\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Location Based Sharing\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'User Locations\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Allow follow\']"></custom-settings-wrapper>\n            <custom-settings-wrapper primitive-type="primitiveType.boolean" label-field-name="\'Description__c\'" value-field-name="\'Run__c\'" setting="settings.TriggerConfigurations[\'Edit Sharing For Crew Members\']"></custom-settings-wrapper>\n            <div class="automatorExp">Time Based Sharing Scheduled Jobs - will share and remove sharing for Service Resources based on time-phased Resource Memberships</div>\n            <automators id="__tbssj" objects="automators" class-names="[\'Sched008_TimePhaseSharing\']"></automators>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('sharingCalendarSync', sharingCalendarSync);

    sharingCalendarSync.$inject = ['sharingService'];

    function sharingCalendarSync(sharingService) {

        controllerFunction.$inject = ['$scope', 'primitiveType', 'dataService'];

        function controllerFunction($scope, primitiveType, dataService) {

            $scope.verifyFunctions.push(function () {
                return console.log('verify - sharingCalendarSync');
            });
            $scope.primitiveType = primitiveType;
            $scope.settings = dataService.getDraftSettings();
        }

        var template = '\n            <content-collapse-wrapper header="\'Service Appointment\'" open="true">\n                <content>\n                    <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Synchronize Services from Salesforce calendar events\'" value-field-name="\'From_Salesforce__c\'" setting="settings.Synchronize.ServiceAppointment" ></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Synchronize Services to Salesforce calendar events\'" value-field-name="\'To_Salesforce__c\'" setting="settings.Synchronize.ServiceAppointment" ></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Calendar Event type\'" tooltip-text="This event type will create a Work Order and a Service appointment" value-field-name="\'Display_Name__c\'" setting="settings.Synchronize.ServiceAppointment"  ></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Enforce validations when syncing Service Appointments and Salesforce calendar events\'" value-field-name="\'Enforce_Validations__c\'" setting="settings.Synchronize.ServiceAppointment" ></custom-settings-wrapper>\n                </content>\n            </content-collapse-wrapper>\n\n            <content-collapse-wrapper header="\'Resource Absence\'" open="true">\n                <content>\n                    <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Synchronize Absences from Salesforce calendar\'" value-field-name="\'From_Salesforce__c\'" setting="settings.Synchronize.ResourceAbsence" ></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Synchronize Absences to Salesforce calendar\'" value-field-name="\'To_Salesforce__c\'" setting="settings.Synchronize.ResourceAbsence" ></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.text" label="\'Calendar Event type\'" tooltip-text="This event type will create a Resource Absence" value-field-name="\'Display_Name__c\'" setting="settings.Synchronize.ResourceAbsence" ></custom-settings-wrapper>\n                    <custom-settings-wrapper primitive-type="primitiveType.boolean" label="\'Enforce validation rules when syncing resource absences and Salesforce calendar events\'" value-field-name="\'Enforce_Validations__c\'" setting="settings.Synchronize.ResourceAbsence" ></custom-settings-wrapper>\n                   \n                </content>\n            </content-collapse-wrapper>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').service('sharingService', sharingService);

    sharingService.$inject = ['settingsUtils', 'dataService'];

    function sharingService(settingsUtils, dataService) {

        var prom = null;

        var instance = {
            settings: {},
            save: function save() {
                return dataService.saveSettings({
                    TriggerConfigurations: {
                        'Status Actions': dataService.getDraftSettings().TriggerConfigurations['Status Actions'],
                        'Location Based Sharing': dataService.getDraftSettings().TriggerConfigurations['Location Based Sharing'],
                        'User Locations': dataService.getDraftSettings().TriggerConfigurations['User Locations'],
                        'Enable workorder parent sharing': dataService.getDraftSettings().TriggerConfigurations['Enable workorder parent sharing'],
                        'Enable account parent sharing': dataService.getDraftSettings().TriggerConfigurations['Enable account parent sharing'],
                        'Enable opportunity parent sharing': dataService.getDraftSettings().TriggerConfigurations['Enable opportunity parent sharing'],
                        'Enable asset parent sharing': dataService.getDraftSettings().TriggerConfigurations['Enable asset parent sharing'],
                        'Allow follow': dataService.getDraftSettings().TriggerConfigurations['Allow follow'],
                        'Edit Sharing For Crew Members': dataService.getDraftSettings().TriggerConfigurations['Edit Sharing For Crew Members']

                    },
                    Synchronize: {
                        'ServiceAppointment': dataService.getDraftSettings().Synchronize['ServiceAppointment'],
                        'ResourceAbsence': dataService.getDraftSettings().Synchronize['ResourceAbsence']
                    },
                    // need all 3 for automators to save
                    AutomatorConfig: dataService.getAutomatorsMap('Sched008_TimePhaseSharing'),
                    DeletedAutomators: dataService.getDraftSettings().DeletedAutomators,
                    Territories: dataService.getDraftSettings().Territories
                });
            },
            restore: function restore() {
                return dataService.restoreDefaultSettings({
                    TriggerConfigurations: {
                        'Status Actions': {},
                        'Location Based Sharing': {},
                        'User Locations': {},
                        'Enable workorder parent sharing': {},
                        'Enable account parent sharing': {},
                        'Enable opportunity parent sharing': {},
                        'Enable asset parent sharing': {},
                        'Allow follow': {},
                        'Edit Sharing For Crew Members': {},
                        'Update AR when service is reassigned': {},
                        'Update AR when service is dispatched': {}
                    },
                    Synchronize: {},
                    RestoreAutomatorSettings: ['Sched008_TimePhaseSharing']
                });
            },
            loadData: function loadData() {
                if (prom) return prom;

                prom = settingsUtils.callRemoteAction(remoteActions.sharingLoadData).then(function (res) {
                    instance.settings = res;
                });

                return prom;
            }
        };

        return instance;
    }
})();
'use strict';

(function () {

    angular.module('SettingsApp').directive('sharingUserTerritories', sharingUserTerritories);

    sharingUserTerritories.$inject = ['sharingService'];

    function sharingUserTerritories(sharingService) {

        controllerFunction.$inject = ['$scope'];

        function controllerFunction($scope) {
            $scope.verifyFunctions.push(function () {
                return console.log('verify - sharingUserTerritories');
            });
            $scope.sharingService = sharingService;
        }

        var template = '\n        <div class="pWrapper">\n            Assign your users with a <a target="_blank" ng-href="../{{sharingService.settings.UserTerritoriesPreFix}}">user territory</a> record per each service territory that they need to access as part of their role.\n            <br/>\n            User territory records provide access (using apex rules) to the following objects:  \n            <br/>\n            <ul>\n                <li>The specified Service Territory</li>\n                <li>The service territory members for that territory and their assigned resources</li>\n                <li>Related Employee Absences</li>\n                <li>Related Service Appointments</li>\n            </ul>\n            Note: Sharing is only applicable for private objects.  <br/>\n        </div>\n        ';

        return {
            restrict: 'E',
            scope: {
                verifyFunctions: '='
            },
            controller: controllerFunction,
            template: template
        };
    }
})();
'use strict';

(function () {

    angular.module('UIDirectives', []).directive('fslDatePicker', function () {
        return function (scope, element, attributes, s) {

            var currDate = null;
            var currTimeZone = null;

            scope.$watch(attributes.myModel, function (newValue, oldValue) {
                if (newValue !== oldValue) {
                    currDate = newValue;
                    writeToInput();
                }
            });

            scope.$watch(attributes.timeZone, function (newValue, oldValue) {
                if (newValue !== oldValue) {
                    currTimeZone = newValue;
                    writeToInput();
                }
            });

            var datePicker = $(element).datepicker({
                inline: true,
                onSelect: function onSelect() {
                    var date = datePicker.datepicker("getDate");
                    currDate = moment.tz({
                        year: date.getFullYear(),
                        month: date.getMonth(),
                        date: date.getDate(),
                        hours: date.getHours(),
                        minutes: date.getMinutes()

                    }, currTimeZone).tz('GMT');

                    scope.$eval(attributes.myModel + "=date", { date: currDate });

                    writeToInput();

                    scope.$apply();
                }
            });

            function writeToInput() {
                if (currTimeZone && currDate) element.val(currDate.tz(currTimeZone).format('ll'));
            }
        };
    });
})();