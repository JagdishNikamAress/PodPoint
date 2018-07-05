'use strict';

// appointment booking angular app
(function () {
    angular.module('BookAppointment', ['ChatterAction', 'MstResolver']).config(['MstResolverProvider', function (MstResolverProvider) {

        // set MST configs
        MstResolverProvider.setConfig({
            fslOperationRemoteAction: appBooking.remoteActions.getFslOperation,
            apiVersion: '41.0',
            fieldNames: appBooking.fieldNames.FslOperationFieldNames,
            autoConnect: true
        });
    }]);
})();
'use strict';

(function () {

    angular.module('BookAppointment').controller('mainController', mainController);

    // injections
    mainController.$inject = ['APP_STATES', 'StateAndSettings', 'appState', 'stageType'];

    // controller function
    function mainController(APP_STATES, StateAndSettings, appState, stageType) {

        this.APP_STATES = APP_STATES;
        this.getState = function () {
            return StateAndSettings.state;
        };
        this.controlServiceForm = {};
        StateAndSettings.controlServiceForm = this.controlServiceForm;

        this.isInForm = function () {
            return appState && appState.getStage() == stageType.Form;
        };

        this.onFirstStageCompleted = function (results) {
            return StateAndSettings.onFirstStageComplete(results, this.controlServiceForm);
        };
    }
})();
'use strict';

(function () {

    // service definition
    angular.module('BookAppointment').service('datesService', datesService);

    // actual service c'tor
    function datesService() {

        this.newUtcDate = function (date) {
            var newDate = new Date(date),
                offset = newDate.getTimezoneOffset();

            newDate.setMinutes(newDate.getMinutes() + offset);

            return newDate;
        };

        // add offset of timezone to date
        this.locationBasedDate = function (date, timezone) {

            var offsetInMinutes = moment(date).tz(timezone)._offset,
                newDate = new Date(date);

            // minus here because moment returns the offset with + and not -
            newDate.setMinutes(newDate.getMinutes() - offsetInMinutes);

            return newDate;
        };
    }
})();
'use strict';

(function () {

    // service definition
    angular.module('BookAppointment').service('Labels', labels);

    // actual service c'tor
    function labels() {
        this.getLabel = function (label) {
            return customLabels[label];
        };
    }
})();
'use strict';

(function () {

    angular.module('BookAppointment').service('StateAndSettings', StateAndSettings);

    // inject
    StateAndSettings.$inject = ['APP_STATES', 'datesService', '$q', 'MstResolver'];

    // actual service c'tor
    function StateAndSettings(APP_STATES, datesService, $q, MstResolver) {
        var _this = this;

        this.slots = {};
        this.schedulingResults = null;
        this.scheduledService = null;
        this.splitSlotsWorking = false;
        this.state = APP_STATES.BOOKING_FORM;
        this.fslOpId = null;
        this.PartialResults = [];
        this.getPartialResults = function () {
            return _this.PartialResults;
        };

        this.extendDates = function () {

            var defer = $q.defer(),
                numberOfSlots = _this.numberOfSlots;

            _this.service.DueDate += 1000 * 60 * 60 * 24;

            _this.controlServiceForm.doFirstStage({
                secondCall: true,
                DueDate: _this.service.DueDate
            }, true).then(function (results) {
                handleFirstStage.call(_this, results);

                // no slots found? reject
                if (numberOfSlots === _this.numberOfSlots) {
                    defer.reject();
                }

                defer.resolve();
            }).catch(function () {
                defer.reject();
            });

            return defer.promise;
        };

        this.onFirstStageComplete = function (results) {

            var mstDefer = $q.defer();

            // check if mst
            if (results.firstStageResult.Data.Slots.FSLOperationId) {
                _this.fslOpId = results.firstStageResult.Data.Slots.FSLOperationId;
            }

            console.log(results);

            var slottkeys = Object.keys(_this.slots);
            slottkeys.forEach(function (val) {
                return delete _this.slots[val];
            });

            if (!_this.fslOpId) {
                handleFirstStage.call(_this, results);
            } else {

                // mst :(
                if (!window.noMstPushTopic) {
                    MstResolver.getUpdates(_this.fslOpId).then(function (resultsMst) {

                        console.log(resultsMst);

                        mstDefer.resolve();
                        results.firstStageResult.Data.Slots = resultsMst.fslOperation.result;

                        handleFirstStage.call(_this, results);
                    }).catch(function (rejectMessage) {
                        mstDefer.reject({ message: rejectMessage });
                    });
                } else {
                    mstDefer.reject({ message: window.customLabels.NoMstPushTopic });
                }

                return mstDefer.promise;
            }

            // check if we need to lazy load more stuff
            if (results.firstStageResult.Data.NeedAnotherCall) {
                _this.splitSlotsWorking = true;

                // this.controlServiceForm is set on MainController.js
                _this.controlServiceForm.doFirstStage({ secondCall: true }, true).then(function (results2ndStage) {
                    handleFirstStage.call(_this, results2ndStage);
                });
            }
        };

        function handleFirstStage(results) {

            this.splitSlotsWorking = false;

            // this is the service that we currently scheduling (new or existing)
            this.service = results.firstStageResult.Service;

            // the slots for the scheduling service
            var ABResponseObject = results.firstStageResult.Data.Slots;

            // only 1 related was scheduled
            this.failedToScheduleRelated = ABResponseObject.IsFallback;

            // actual slots
            var virtualSlots = ABResponseObject.Slots;

            // partial results
            this.PartialResults = ABResponseObject.PartialResults;

            // our slots, saved locally
            this.slots = this.slots || {};

            // (re)init
            for (var k in this.slots) {
                this.slots[k] = [];
            }

            // format slots and stuff
            for (var i = 0; i < virtualSlots.length; i++) {
                var dateKey = datesService.newUtcDate(virtualSlots[i].Interval.Start);
                dateKey = dateKey.getDate() + '_' + dateKey.getMonth() + '_' + dateKey.getFullYear();

                this.slots[dateKey] = this.slots[dateKey] || [];
                this.slots[dateKey].push(virtualSlots[i]);
            }

            this.numberOfSlots = ABResponseObject.Slots.length;

            // change to slots view
            this.state = APP_STATES.SLOTS;

            this.service.isRelated = results.firstStageResult.Data.isRelated;
            this.numberOfServices = ABResponseObject.NumberOfServices;
        }
    }
})();
'use strict';

(function () {

    angular.module('BookAppointment').directive('schedulingResults', function () {

        return {
            restrict: 'E',
            template: resultsTemplate,
            controller: resultsCtrl,
            controllerAs: 'resultsCtrl',
            link: function link(scope, element, attributes) {
                scope.resultsCtrl.icon = attributes.icon;
                scope.resultsCtrl.iconError = attributes.iconerror;
            }
        };
    });

    resultsCtrl.$inject = ['StateAndSettings', 'Labels', 'chatterActionUtils'];

    function resultsCtrl(StateAndSettings, Labels, chatterActionUtils) {
        var _this = this;

        // label service
        this.getLabel = Labels.getLabel;

        this.scheduledSuccessfully = function () {
            return StateAndSettings.schedulingResults.schedulingResult.Results && StateAndSettings.schedulingResults.schedulingResult.Results.length > 0 ? true : false;
        };

        this.viewService = function () {
            chatterActionUtils.openService(StateAndSettings.scheduledService.Id);
        };

        function generateResultDate(isFinish) {

            var dateType = isFinish ? 'ArrivalWindowEndTime' : 'ArrivalWindowStartTime',
                date = StateAndSettings.scheduledService[dateType];

            return chatterActionUtils.changeDateToTerritoryTZ(moment(date)).format('llll');
        }

        this.generateBookingResults = function () {
            if (_this.scheduledSuccessfully()) {
                return Labels.getLabel('AppBookingResults').replace('{0}', generateResultDate()).replace('{1}', generateResultDate(1));
            } else {
                return customLabels.SlotTaken;
            }
        };
    }

    var resultsTemplate = '<div id="AN-ResultsContainer">\n\n        <svg aria-hidden="true" class="slds-icon">\n            <use ng-if="resultsCtrl.scheduledSuccessfully()" xlink:href="{{resultsCtrl.icon}}"></use>\n            <use ng-if="!resultsCtrl.scheduledSuccessfully()" xlink:href="{{resultsCtrl.iconError}}"></use>\n        </svg>\n\n        <div id="ResultTextLine">{{ resultsCtrl.generateBookingResults() }}</div>\n\n        <div class="AN-WhiteButton" ng-click="resultsCtrl.viewService()">{{ :: resultsCtrl.getLabel(\'View_Service\') }}</div>\n\n\n    </div>';
})();
'use strict';

(function () {

    angular.module('BookAppointment').directive('slots', function () {

        return {
            restrict: 'E',
            template: slotsTemplate,
            controller: slotsCtrl,
            controllerAs: 'slotsCtrl',
            scope: true,
            link: function link(scope, element, attribues) {
                scope.slotsCtrl.infoIcon = attribues.infoicon;
                scope.slotsCtrl.noSlotsIcon = attribues.noslotsicon;
                scope.slotsCtrl.spinner = attribues.spinner;
            }
        };
    });

    slotsCtrl.$inject = ['$q', 'StateAndSettings', 'APP_STATES', 'Labels', '$timeout', 'chatterActionUtils', 'MstResolver'];

    function slotsCtrl($q, StateAndSettings, APP_STATES, Labels, $timeout, chatterActionUtils, MstResolver) {
        var _this = this;

        String.prototype.replaceAll = function () {

            var target = this;

            for (var _len = arguments.length, args = Array(_len), _key = 0; _key < _len; _key++) {
                args[_key] = arguments[_key];
            }

            for (var i = 0; i < args.length; i++) {
                target = target.replace('$' + i, args[i]);
            }

            return target;
        };

        this.generatePartialResult = function (p) {
            return customLabels.partialResults[p.Operation].replaceAll(p.Processed, p.Total);
        };

        this.ShowExtendMessage = false;
        this.showingTooltip = false;
        this.displayTooltipId = null;
        this.ShowNoMoreSlots = false;
        this.slots = StateAndSettings.slots;
        this.partialResults = StateAndSettings.getPartialResults;
        this.grading = {
            recommended: appBooking.appBookingSettings[appBooking.fieldNames.settings.Recommended_Threshold__c],
            ideal: appBooking.appBookingSettings[appBooking.fieldNames.settings.Ideal_Threshold__c]
        };

        this.shouldShowExp = function () {
            return appBooking.appBookingSettings[appBooking.fieldNames.settings.Show_Grade_Explanation__c];
        };

        // label service
        this.getLabel = Labels.getLabel;
        this.formatTooltipHeader = function (str1) {

            var totalSlots = 0;

            for (var day in _this.slots) {
                totalSlots += _this.slots[day].length;
            }return Labels.getLabel('AB_Explanation_Header').replace('{0}', str1).replace('{1}', totalSlots);
        };

        this.getIcon = function (name) {
            return appBooking.icons[name];
        };

        this.schedule = function (slot) {

            // don't allow clicking on a slot until finished running (or extending)
            if (StateAndSettings.splitSlotsWorking || _this.ShowExtendMessage) {
                return;
            }

            var mstPromise = $q.defer();

            StateAndSettings.controlServiceForm.doSecondStage({
                Start: slot.Interval.Start,
                Finish: slot.Interval.Finish,
                Grade: null || slot.Grade,
                DueDate: StateAndSettings.service.DueDate,
                NumberOfServices: StateAndSettings.numberOfServices
            }, mstPromise.promise).then(function (results) {

                console.log(results);

                // check if mst
                if (results.secondStageResult.Data.schedulingResult.Results && results.secondStageResult.Data.schedulingResult.Results[0] && results.secondStageResult.Data.schedulingResult.Results[0].LongOperationId) {

                    var fslOpScheduling = results.secondStageResult.Data.schedulingResult.Results[0].LongOperationId;

                    MstResolver.getUpdates(fslOpScheduling).then(function (mstSchedResult) {

                        console.log('MST results of getUpdates:');
                        console.log(mstSchedResult);

                        // need to check which of the two is our service
                        var resService = null;

                        if (mstSchedResult.fslOperation.result && mstSchedResult.fslOperation.result[0] && mstSchedResult.fslOperation.result[0].Service.Id === StateAndSettings.service.Id) {
                            resService = mstSchedResult.fslOperation.result[0].Service;
                        } else if (mstSchedResult.fslOperation.result && mstSchedResult.fslOperation.result[1] && mstSchedResult.fslOperation.result[0].Service.Id === StateAndSettings.service.Id) {
                            resService = mstSchedResult.fslOperation.result[1].Service;
                        } else {
                            mstPromise.reject({ message: 'Error while scheduling MSW.' });
                            return;
                        }

                        StateAndSettings.state = APP_STATES.RESULTS;
                        StateAndSettings.schedulingResults = results.secondStageResult.Data;
                        StateAndSettings.scheduledService = resService; //results.secondStageResult.Data.service;

                        mstPromise.resolve();
                    }).catch(function (message) {
                        mstPromise.reject({ message: message });
                    });
                } else {
                    StateAndSettings.state = APP_STATES.RESULTS;
                    StateAndSettings.schedulingResults = results.secondStageResult.Data;
                    StateAndSettings.scheduledService = results.secondStageResult.Data.service;
                    mstPromise.resolve();
                }
            }).catch(function (ex) {
                console.warn(ex);
            });
        };

        this.extendDate = function () {

            // don't allow clicking on a extend button until finished running (or extending)
            if (StateAndSettings.splitSlotsWorking || _this.ShowExtendMessage) {
                return;
            }

            _this.ShowExtendMessage = true;

            StateAndSettings.extendDates().then(function () {}).catch(function () {

                // if we are here, no more slots were found

                _this.ShowNoMoreSlots = true;

                $timeout(function () {
                    _this.ShowNoMoreSlots = false;
                }, 3000);
            }).finally(function () {
                _this.ShowExtendMessage = false;
            });
        };

        this.explainIconClicked = function ($event, id) {
            $event.stopPropagation();

            if (_this.displayTooltipId != id) {
                _this.showingTooltip = true;
                _this.displayTooltipId = id;
            } else {
                _this.showingTooltip = false;
                _this.displayTooltipId = null;
            }
        };

        this.isCommunitiesPage = function () {
            return isCommunitiesPage;
        };

        this.formatDueDate = function () {
            return _this.getLabel('DueDateExtendTo').replace('$0', moment(StateAndSettings.service.DueDate).format('lll'));
        };

        this.noSlots = function () {
            return Object.keys(_this.slots).length === 0 || StateAndSettings.numberOfSlots === 0;
        };

        this.isMobile = function () {
            return typeof sforce !== 'undefined' && sforce.one;
        };

        this.formatAsapObjective = function (date) {
            return chatterActionUtils.changeDateToTerritoryTZ(moment(parseInt(date))).format('lll');
        };

        this.isDateSplitStillRunning = function () {
            return StateAndSettings.splitSlotsWorking;
        };

        this.isRelatedService = function () {
            return StateAndSettings.service.isRelated;
        };

        this.getExtendButtonText = function () {
            return _this.ShowExtendMessage ? _this.getLabel('SearchingAppointments') : _this.getLabel('Extend_dates');
        };

        this.relatedSchedulingFailed = function () {
            return StateAndSettings.failedToScheduleRelated;
        };

        this.generateRelatedFailText = function () {
            return Labels.getLabel('UnableToScheduleRelated').replace('$0', StateAndSettings.service.RelatedServiceLabel);
        };

        this.userHasAdminPermissions = userHasAdminPermissions;
    }

    var slotsTemplate = '<div id="AN-SlotsContainer">\n\n        <div id="AN-PartialResults" ng-show="slotsCtrl.partialResults().length > 0">\n            <div>\n                {{ slotsCtrl.getLabel(\'particalCouldntProcessAll\') }}\n                <u ng-show="slotsCtrl.userHasAdminPermissions" ng-click="showPartialData = !showPartialData">{{ slotsCtrl.getLabel(\'ShowDetails\') }}</u>\n            </div>\n\n            <div ng-show="showPartialData">\n                <ul>\n                    <li ng-repeat="partial in slotsCtrl.partialResults()">\n                        {{ slotsCtrl.generatePartialResult(partial) }}\n                    </li>\n                </ul>\n            </div>\n        </div>\n\n\n        <div id="AN-RelatedFailed" ng-if="slotsCtrl.relatedSchedulingFailed()">\n            {{ slotsCtrl.generateRelatedFailText() }}\n        </div>\n\n        <div id="AN-StillGettingSlots" ng-show="slotsCtrl.isDateSplitStillRunning()">\n            <img ng-src="{{ slotsCtrl.getIcon(\'spinner\') }}">\n            {{ :: slotsCtrl.getLabel(\'StillGettingSlots\') }}\n        </div>\n\n\n\n\n        <div id="AN-NoSlots" ng-show="slotsCtrl.noSlots() && !slotsCtrl.isDateSplitStillRunning()">\n            <svg class="slds-icon" aria-hidden="true">\n                <use xlink:href="{{ slotsCtrl.noSlotsIcon }}"></use>\n            </svg>\n            {{ :: slotsCtrl.getLabel(\'NoSlotsFound\') }}\n            \n            \n        </div>\n        \n        \n        \n\n        <div ng-hide="$parent.slotsCtrl.noSlots()" ng-repeat="dailySlots in slotsCtrl.slots" class="AN-SlotContainer">\n\n            <div class="AN-SlotTitle">{{ dailySlots[0].Interval.Start | date2:\'day\'}}</div>\n\n            <div ng-repeat="slot in dailySlots" class="AN-Interval" ng-click="slotsCtrl.schedule(slot)"\n            ng-class="{\'AN-NoSlotsExplain\': $parent.slotsCtrl.isRelatedService() || $parent.slotsCtrl.isDateSplitStillRunning() || slotsCtrl.isCommunitiesPage() || !slot.BestSlotGrades || !slotsCtrl.shouldShowExp(), \'AN-NoPointerCursor\': $parent.slotsCtrl.isDateSplitStillRunning() || $parent.slotsCtrl.ShowExtendMessage}">\n                {{ slot.Interval.Start | date2:\'hour\'}}\n                <span ng-show="slot.Interval.Finish !== slot.Interval.Start">- {{ slot.Interval.Finish | date2:\'hour\'}}</span>\n                <div class="AN-Recommended" ng-show="!slotsCtrl.isDateSplitStillRunning() && !slotsCtrl.isCommunitiesPage() && slot.Grade >= slotsCtrl.grading.recommended && slot.Grade < slotsCtrl.grading.ideal">\n                    {{ :: slotsCtrl.getLabel(\'Recommended\') }}\n                </div>\n                <div class="AN-Ideal" ng-show="!slotsCtrl.isDateSplitStillRunning() && !slotsCtrl.isCommunitiesPage() && slot.Grade >= slotsCtrl.grading.ideal">\n                    {{ :: slotsCtrl.getLabel(\'Ideal\') }}\n                </div>\n\n                <svg class="AN-InfoIcon slds-icon" aria-hidden="true"\n                    ng-show="!slotsCtrl.isDateSplitStillRunning() && !slotsCtrl.isCommunitiesPage() && slot.BestSlotGrades && slot.BestSlotGrades.length > 0 && slotsCtrl.shouldShowExp() && !slotsCtrl.isRelatedService()"\n                    ng-click="slotsCtrl.explainIconClicked($event,$id)">\n                    <use xlink:href="{{ slotsCtrl.infoIcon }}"></use>\n                </svg>\n\n                <div class="AN-TooltipMobile" ng-show="slotsCtrl.displayTooltipId === $id" ng-click="$event.stopPropagation()">\n                    <div class="AN-SlotSingleInfo" ng-repeat="info in slot.BestSlotGrades" ng-if="info.Text">\n                        <div class="AN-ObjectGrade" ng-class="{\n                            \'AN-ObjectGradeGood\': info.Grade >= slotsCtrl.grading.ideal,\n                            \'AN-ObjectGradeAverage\': info.Grade >= slotsCtrl.grading.recommended && info.Grade < slotsCtrl.grading.ideal,\n                            \'AN-ObjectGradeBad\': info.Grade <= slotsCtrl.grading.recommended,\n                        }"></div>\n                        <b>{{info.HeaderText}}</b> <span ng-hide="info.IsYesOrNoObjective">{{ slotsCtrl.formatTooltipHeader(info.RankInAppointments) }}</span><br/>\n                        <span ng-if="info.ObjectiveRecordTypeName !== \'Objective_Asap\'">{{ info.Text }}</span>\n                        <span ng-if="info.ObjectiveRecordTypeName === \'Objective_Asap\'">{{ slotsCtrl.formatAsapObjective(info.Text) }}</span>\n                    </div>\n                </div>\n\n            </div>\n\n        </div>\n\n        <!--<div\n            id="AN-TooltipBackgroundForMobile"\n            ng-if="slotsCtrl.showingTooltip"\n            ng-click="$event.stopPropagation(); slotsCtrl.displayTooltipId = null; slotsCtrl.showingTooltip = false;">\n        </div>-->\n\n        <div id="AN-DueDateExtendMessage" ng-show="slotsCtrl.ShowExtendMessage">{{ slotsCtrl.formatDueDate() }}</div>\n        <div id="AN-NoMoreSlots" ng-show="slotsCtrl.ShowNoMoreSlots && !slotsCtrl.ShowExtendMessage">{{ :: slotsCtrl.getLabel(\'NoMoreSlots\') }}</div>\n\n        <div class="AN-BlueButton" ng-class="{\'AN-ExtendInProgress\': slotsCtrl.ShowExtendMessage }" ng-hide="slotsCtrl.isDateSplitStillRunning()" ng-click="slotsCtrl.extendDate()">\n            <img ng-show="slotsCtrl.ShowExtendMessage" ng-src="{{ slotsCtrl.spinner }}" />\n            {{ slotsCtrl.getExtendButtonText() }}\n        </div>\n\n    </div>';
})();
'use strict';

(function () {

    angular.module('BookAppointment').filter('date2', dateFilter);

    dateFilter.$inject = ['$filter', 'datesService'];

    function dateFilter($filter, datesService) {

        return function (interval, type) {
            var date = datesService.newUtcDate(interval);

            if (type === 'hour') {
                if (appBooking.isAMPM) return $filter('date')(date, 'h:mma');else return $filter('date')(date, 'HH:mm');
            } else if (type === 'day') return moment(date).format("dddd, MMMM Do YYYY");
        };
    }
})();
'use strict';

(function () {

    angular.module('BookAppointment')

    // app states
    .constant('APP_STATES', {
        FATAL: -1,
        ERROR: 0,
        LOADING: 1,
        BOOKING_FORM: 2,
        SLOTS: 3,
        NO_SLOTS: 4,
        RESULTS: 5
    });
})();