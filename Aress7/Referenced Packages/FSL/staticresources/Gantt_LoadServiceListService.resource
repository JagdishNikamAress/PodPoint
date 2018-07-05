'use strict';

/*

 LoadServiceListService
 Service to aggregate all service list loading functions

 */

(function () {

    LoadServiceListService.$inject = ['$q', 'sfdcService', 'utils', 'TimePhasedDataService', 'servicesService'];

    angular.module('serviceExpert').factory('LoadServiceListService', LoadServiceListService);

    function LoadServiceListService($q, sfdcService, utils, TimePhasedDataService, servicesService) {

        function loadServiceAppointmentsToList(servicesObjects, servicesListVisitedDays, endDate, backHorizon) {
            //console.log('loadServiceAppointmentsToList');

            var deferred = $q.defer();

            var horizon = getBackHorizonToFetch(servicesListVisitedDays, endDate, backHorizon);

            if (horizon.horizon <= 0) {
                var resultServices = {
                    scheduledServices: [],
                    unscheduledServices: [],
                    remainingCount: 0,
                    newStart: utils.addDaysToDate(horizon.date, -horizon.horizon + 1),
                    horizon: horizon
                };
                deferred.resolve(resultServices);
                return deferred.promise;
            }

            var newStart = utils.addDaysToDate(horizon.date, -horizon.horizon + 1),
                inRange = countServicesInTimeInterval(servicesObjects, endDate, backHorizon),
                toLoad = CustomSettings.maxServiceAppointmentsToLoad - inRange.length;

            if (toLoad <= 0) {
                utils.addNotification(customLabels.Too_Many_Services_Header_Services_List, customLabels.Too_Many_Services_Services_List);

                deferred.reject();
                return deferred.promise;
            }

            sfdcService.loadServiceAppointmentsToList(horizon.date, horizon.horizon, toLoad, inRange).then(function (res) {
                TimePhasedDataService.updateTimePhaseData(res.stms, 'stm');
                var updatedServices = TimePhasedDataService.updateTimePhaseData(res.ganttServiceAppointments, 'service'),
                    resourcesAndTerritories = TimePhasedDataService.resourcesAndTerritories(),
                    resultServices = {
                    scheduledServices: [],
                    unscheduledServices: [],
                    remainingCount: res.remainingCount,
                    newStart: newStart,
                    horizon: horizon
                };

                // split to 2 arrays, scheduled services (should be on the gantt) and unscheduled (not on the gantt)
                updatedServices.services.forEach(function (appointment) {

                    // not scheduled
                    if (!appointment.isScheduled()) {

                        // service got unscheduled
                        if (scheduler._events[appointment.id]) {
                            delete scheduler._events[appointment.id];
                        }

                        resultServices.unscheduledServices.push(appointment);
                    } else {
                        // set the GANTT resource id based on timephase
                        appointment.setGanttResource(resourcesAndTerritories, utils.generateResourceId);
                        resultServices.scheduledServices.push(appointment);
                    }
                });

                servicesService.drawServicesAndAbsences(resultServices.scheduledServices, [], [], []);

                deferred.resolve(resultServices);
            }).catch(function (error) {
                deferred.reject(error);
                console.warn('loadServiceAppointmentsToList: something went wrong');
                utils.addNotification(customLabels.Action_Could_Not_Be_Performed, error.message || customLabels.user_is_not_allowed_to_perform_action);
            });

            return deferred.promise;
        }

        function getBackHorizonToFetch(servicesListVisitedDays, endDate, backHorizon) {
            var diffInDays = void 0,
                currDT = void 0,
                newStart = utils.addDaysToDate(endDate, -backHorizon + 1),
                newFinish = endDate;

            // base date is inside an interval we got, go right and figure what is the latest date in that interval
            if (servicesListVisitedDays[newStart]) {
                currDT = newStart;

                while (currDT <= newFinish) {
                    if (servicesListVisitedDays[currDT]) currDT = utils.addDaysToDate(currDT, 1);else break;
                }

                diffInDays = (newFinish.getTime() - currDT.getTime()) / (1000 * 60 * 60 * 24);
                diffInDays++;

                return {
                    date: newFinish,
                    horizon: diffInDays
                };
            }

            // base date is not inside an interval we got, go from end date to the left
            else {
                    currDT = newFinish;

                    while (currDT >= newStart) {
                        if (servicesListVisitedDays[currDT]) currDT = utils.addDaysToDate(currDT, -1);else break;
                    }

                    diffInDays = (currDT.getTime() - newStart.getTime()) / (1000 * 60 * 60 * 24);
                    diffInDays++;

                    return {
                        date: currDT,
                        horizon: diffInDays
                    };
                }
        };

        function serviceInTimeRange(service, endDate, backHorizon) {

            var start = utils.addDaysToDate(endDate, -backHorizon);

            if (service.earlyStart && service.earlyStart > start && service.earlyStart <= endDate) {
                return true;
            }

            if (service.dueDate && service.dueDate > start && service.dueDate <= endDate) {
                return true;
            }

            if (service.appStart && service.appStart > start && service.appStart <= endDate) {
                return true;
            }

            if (service.appEnd && service.appEnd > start && service.appEnd <= endDate) {
                return true;
            }

            if (service.finish && service.finish > start && service.finish <= endDate) {
                return true;
            }

            if (service.start && service.start > start && service.start <= endDate) {
                return true;
            }

            return false;
        };

        function countServicesInTimeInterval(servicesObjects, endDate, backHorizon) {
            var inRange = [];

            for (var key in servicesObjects) {
                if (serviceInTimeRange(servicesObjects[key], endDate, backHorizon)) inRange.push(key);
            }

            return inRange;
        };

        return {
            loadServiceAppointmentsToList: loadServiceAppointmentsToList,
            getBackHorizonToFetch: getBackHorizonToFetch
        };
    }
})();