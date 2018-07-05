'use strict';

/*

    Wrapping DHTMLX scheduler

*/

(function () {
    angular.module('serviceExpert').directive('dhxScheduler', ['$rootScope', '$timeout', 'userSettingsManager', '$q', 'sfdcService', 'ResourcesAndTerritoriesService', 'FieldSetFieldsService', function ($rootScope, $timeout, userSettingsManager, $q, sfdcService, ResourcesAndTerritoriesService, FieldSetFieldsService) {
        return {
            restrict: 'C',
            transclude: true,
            template: '<div class="dhx_cal_navline" ng-transclude></div><div class="dhx_cal_header"></div><div class="dhx_cal_data"></div>',

            link: function link($scope, $element, $attrs) {
                // set global utils for gantt js
                window.utils = angular.element('#serviceExpertApp').injector().get('utils');

                // watch for employees/resources
                $scope.$watch($attrs.resources, function (collection) {
                    scheduler.updateCollection('resources', collection);
                }, true);

                //styling for dhtmlx scheduler
                $element.addClass('dhx_cal_container');

                // config timeline views
                schedulerConfig.configTimelines();

                // scheduler configurations
                schedulerConfig.setConfigurations();

                // custom daily hours
                var GanttHourStart = userSettingsManager.GetUserSettingsProperty('Gantt_View_Start_Hour__c');
                var GanttHourFinish = userSettingsManager.GetUserSettingsProperty('Gantt_View_Finish_Hour__c');
                var RowHeight = userSettingsManager.GetUserSettingsProperty('Resource_Row_Height__c');
                var CapacityType = userSettingsManager.GetUserSettingsProperty('View_Capacity_Type__c');
                var includeWeekends = userSettingsManager.GetUserSettingsProperty('Include_Weekends__c');
                var loadOnToday = userSettingsManager.GetUserSettingsProperty('Load_On_Today__c');
                var lockGantt = userSettingsManager.GetUserSettingsProperty('Lock_Gantt__c');

                if (lockGantt != null) schedulerConfig.setReadOnly(lockGantt);

                if (RowHeight != null) schedulerConfig.setRowHeights(RowHeight, false);

                if (CapacityType != null) setCapacityFilter(CapacityType);

                if (GanttHourStart != null && GanttHourFinish != null) {
                    setHoursToDisplay(GanttHourStart, GanttHourFinish, includeWeekends);
                }

                $rootScope.policy = defaultPolicy;

                var readyToLoadCalendar = $q.all([ResourcesAndTerritoriesService.promises.territories(), ResourcesAndTerritoriesService.promises.resources(), FieldSetFieldsService.fieldsSetFields()]);

                readyToLoadCalendar.then(function () {

                    // init scheduler
                    scheduler.init($element[0], new Date(), 'ZoomLevel3');

                    // save scope
                    $scope.scheduler = scheduler;

                    // attach events that doesn't require any data from the controller
                    $scope.datalessMethods = attchDatalessSchedulerEvents();

                    $timeout(function () {

                        if (loadOnToday) scheduler.setCurrentView(new Date());

                        $scope.getTimePhasedObjects().then(function () {
                            $('#FirstTimeLoading').remove();
                        }).catch(function (ex) {
                            bootstrap.handleError(ex);
                        });

                        // set name on timeline selector
                        switch (scheduler._mode) {
                            case 'ZoomLevel2':
                                $scope.timelineName = customLabels.In_Day;
                                break;

                            case 'ZoomLevel3':
                                $scope.timelineName = customLabels.Daily;
                                break;

                            case 'ZoomLevel4':
                                $scope.timelineName = customLabels.X2_Days;
                                break;

                            case 'ZoomLevel5':
                                $scope.timelineName = customLabels.X3_Days;
                                break;

                            case 'ZoomLevel6':
                                $scope.timelineName = customLabels.Weekly;
                                break;
                        }
                    }, 0);

                    $rootScope.$broadcast('initCompleted');
                }), function (err) {
                    console.log('err:' + err);
                };
            }
        };
    }]);
})();