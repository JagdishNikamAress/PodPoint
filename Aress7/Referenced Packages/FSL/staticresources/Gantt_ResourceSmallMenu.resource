'use strict';

(function () {

    ResourceSmallMenu.$inject = ['$rootScope', 'ResourcesAndTerritoriesService', '$compile', 'utils', 'ResourceLightboxService', 'sfdcService', 'StateService', 'DeltaService', 'TimePhasedDataService', 'rdOptimizeLightboxService'];

    angular.module('serviceExpert').factory('ResourceSmallMenu', ResourceSmallMenu);

    function ResourceSmallMenu($rootScope, ResourcesAndTerritoriesService, $compile, utils, ResourceLightboxService, sfdcService, StateService, DeltaService, TimePhasedDataService, rdOptimizeLightboxService) {

        // create a new scope
        var $scope = null;

        function open(id, section, targetElement) {

            // create new isolated scope
            $scope = $rootScope.$new(true);

            $scope.menuResource = ResourcesAndTerritoriesService.getResources()[id];
            $scope.resourceId = id;
            $scope.section = section;
            $scope.openResourceLightbox = openResourceLightbox;
            $scope.runDynamicGanttFunction = runDynamicGanttFunction;
            $scope.hasCustomPermission = utils.hasCustomPermission;
            $scope.showCrew = showCrew;
            $scope.openResourceDayOptimizationLightbox = openResourceDayOptimizationLightbox;
            $scope.isCrew = false;

            if (ResourcesAndTerritoriesService.getCrewResources()[id] !== undefined) {
                $scope.isCrew = true;
            }

            // add to body
            var resourceMenuDomElement = generateTemplate();
            var $target = $($(targetElement).closest('.resourceMenuBtn'));
            var offset = $target.offset();

            angular.element('body').append(resourceMenuDomElement);
            $('.resourceMenuContainer').css({ top: offset.top, left: offset.left });

            $scope.$on('$destroy', function () {
                return resourceMenuDomElement.remove();
            });

            angular.element('body').on('mousedown', function (e) {
                var classNames = ["resMenuSingleAction"];
                for (var i = 0; i < classNames.length; i++) {
                    if (e.target.classList.contains(classNames[i]) || e.target.parentNode && e.target.parentNode.classList.contains(classNames[i])) return;
                }

                closeResourceMenu();
                e.stopPropagation();
                angular.element('body').off('mousedown');
            });

            // compile
            $compile(resourceMenuDomElement)($scope);
            utils.safeApply($scope);
        }

        function closeResourceMenu() {
            $scope.$destroy();
        }

        function openResourceLightbox() {
            ResourceLightboxService.open($scope.resourceId, $scope.section);
        }

        function runDynamicGanttFunction(functionParam) {
            var startDate = void 0,
                policyId = void 0;

            // set dates
            startDate = new Date(scheduler.getState().min_date.getFullYear(), scheduler.getState().min_date.getMonth(), scheduler.getState().min_date.getDate(), 0, 0, 0);
            policyId = StateService.selectedPolicyId;

            var menuFunctions = {
                'FillInSchedule': {
                    'FunctionName': sfdcService.runFillInSchedule,
                    'NotificationHeaderText': customLabels.x_request_sent.replaceAll(customLabels.Fill_in_Schedule),
                    'NotificationText': customLabels.RequestNotificationSent.replaceAll(customLabels.Fill_in_Schedule, $scope.menuResource.name, moment(startDate).format('L'))
                },
                'FixOverlaps': {
                    'FunctionName': sfdcService.runFixOverlaps,
                    'NotificationHeaderText': customLabels.x_request_sent.replaceAll(customLabels.FixOverlaps),
                    'NotificationText': customLabels.RequestNotificationSent.replaceAll(customLabels.FixOverlaps, $scope.menuResource.name, moment(startDate).format('L'))
                }
            };

            if (useLocationTimezone) {

                var start = startDate,
                    end = addDaysToDate(startDate, 1),
                    interval = {
                    start_date: start,
                    end_date: end
                    //get territory offset by SRST
                };var resourceTerritoryOffset = TimePhasedDataService.getIntersectingSrstOffset(interval, $scope.resourceId);

                //set times accordingly
                var userStartOffset = utils.getUserOffset(start);
                var userEndOffset = utils.getUserOffset(end);

                startDate.setMinutes(start.getMinutes() + userStartOffset - resourceTerritoryOffset);
            }

            var functionToCall = menuFunctions[functionParam].FunctionName;

            // run 
            functionToCall(startDate, $scope.resourceId, policyId).then(function (req_obj) {
                if (!req_obj) {
                    utils.addNotification(customLabels.Action_Could_Not_Be_Performed, customLabels.user_is_not_allowed_to_perform_action);
                } else {

                    if (req_obj[fieldNames.Optimization_Request.Status__c] != customLabels.failed) {
                        utils.addNotification(menuFunctions[functionParam].NotificationHeaderText, menuFunctions[functionParam].NotificationText, function (id) {
                            utils.openSObjectLink('../' + id);
                        }, req_obj.Id);
                    } else {
                        utils.addNotification(customLabels.Optimization_Failed, customLabels.error_in_opt, function (id) {
                            utils.openSObjectLink('../' + id);
                        }, req_obj.Id);
                    }

                    DeltaService.updateOptimizationRequest(req_obj);
                }
            }).then(function () {}).catch(function (err) {
                console.warn(functionParam + ' failed :(');
                console.log(err);
                utils.addNotification(customLabels.Action_Could_Not_Be_Performed, err.message);
            }).finally(function () {});

            closeResourceMenu();
        }

        function showCrew() {

            var ganttResources = ResourcesAndTerritoriesService.getResources();
            var currentCrewToShow = TimePhasedDataService.currentCrewToShow;
            currentCrewToShow = {};
            var crewMembers = TimePhasedDataService.crewToServiceCrewMembers()[$scope.menuResource.serviceCrew];

            currentCrewToShow[$scope.resourceId] = $scope.menuResource;

            for (var key in crewMembers) {
                currentCrewToShow[crewMembers[key].serviceResource] = ganttResources[crewMembers[key].serviceResource];

                if (currentCrewToShow[crewMembers[key].serviceResource].members === undefined) {
                    currentCrewToShow[crewMembers[key].serviceResource].members = {};
                }

                currentCrewToShow[crewMembers[key].serviceResource].members[key] = crewMembers[key];
            }

            TimePhasedDataService.currentCrewToShow = currentCrewToShow;
            closeResourceMenu();
            $rootScope.$broadcast('moveToCrewView');
        }

        function openResourceDayOptimizationLightbox() {
            rdOptimizeLightboxService.open($scope.resourceId);
        }

        function generateTemplate() {
            return angular.element('\n                    <div id="resourceMenu" class="resourceMenuContainer">\n                        <div class="truncate resMenuSingleAction" ng-click="openResourceLightbox()" title="' + customLabels.Details + '">\n                            <svg aria-hidden="true" class="slds-icon resMenuSingleIcon">\n                                <use xlink:href="' + lsdIcons.info + '"></use>\n                            \u2028</svg>\n                            ' + customLabels.Details + '</div>\n                        <div class="truncate resMenuSingleAction" ng-click="openResourceDayOptimizationLightbox()" ng-hide="menuResource.isCapacityBased || !hasCustomPermission(\'Resource_Schedule_Optimization\')" title="' + customLabels.RDOptimize + '">\n                            <svg aria-hidden="true" class="slds-icon resMenuSingleIcon">\n                                <use xlink:href="' + lsdIcons.magicwand + '"></use>\n                            \u2028</svg>\n                            ' + customLabels.RDOptimize + '</div>\n                        <div class="truncate resMenuSingleAction" ng-click="runDynamicGanttFunction(\'FixOverlaps\')" ng-hide="menuResource.isCapacityBased || !hasCustomPermission(\'Fix_Overlaps\')" title="' + customLabels.FixOverlaps + '">\n                            <svg aria-hidden="true" class="slds-icon resMenuSingleIcon">\n                                <use xlink:href="' + lsdIcons.crossfilter + '"></use>\n                            \u2028</svg>\n                            ' + customLabels.FixOverlaps + '</div>\n                        <div class="truncate resMenuSingleAction" ng-click="runDynamicGanttFunction(\'FillInSchedule\')" ng-hide="!hasCustomPermission(\'Fill_in\')" title="' + customLabels.Fill_in_Schedule + '">\n                            <svg aria-hidden="true" class="slds-icon resMenuSingleIcon">\n                                <use xlink:href="' + lsdIcons.summarydetail + '"></use>\n                            \u2028</svg>\n                            ' + customLabels.Fill_in_Schedule + '\n                        </div>\n                        <div class="truncate resMenuSingleAction" ng-click="showCrew()" ng-show="isCrew" title="' + customLabels.showCrewAndHisMemebers + '">\n                            <svg aria-hidden="true" class="slds-icon crew-icon-menu">\n                                <use xlink:href="' + lsdIcons.crew + '"></use>\n                            \u2028</svg>\n                            ' + customLabels.showCrew + '\n                        </div>\n                    </div>\n                ');
        }

        // This will be our factory
        return {
            open: open
        };
    }
})();