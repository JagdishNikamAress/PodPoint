'use strict';

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

(function () {

    AbsencesService.$inject = ['$q', 'TimePhasedDataService', 'sfdcService', 'DeltaService', 'servicesService', 'utils'];

    angular.module('serviceExpert').factory('AbsencesService', AbsencesService);

    function AbsencesService($q, TimePhasedDataService, sfdcService, DeltaService, servicesService, utils) {

        var nonAvailabilityTypes = {};

        // saving changes to absence and returns the updated absence or the original one if there was an error
        function saveChangesToAbsence(originalAbsence, changedAbsence) {

            var deffered = $q.defer(),
                start = new Date(changedAbsence.start_date.getTime() + changedAbsence.travelTo * 1000),
                end = new Date(changedAbsence.end_date.getTime() - changedAbsence.travelFrom * 1000);

            if (useLocationTimezone) {
                //get territory offset by SRST
                var resourceTerritoryOffset = TimePhasedDataService.getIntersectingSrstOffset(changedAbsence, changedAbsence.getGanttResource());

                var userStartOffset = utils.getUserOffset(start);
                var userEndOffset = utils.getUserOffset(end);

                //set times accordingly
                start.setMinutes(start.getMinutes() + userStartOffset - resourceTerritoryOffset);
                end.setMinutes(end.getMinutes() + userEndOffset - resourceTerritoryOffset);
            }

            // snapToId, snapToType, snapDirection

            sfdcService.saveChangesToAbsence(changedAbsence.id, changedAbsence.getGanttResource(), start, end, changedAbsence.absenceType, changedAbsence.ganttLabel, changedAbsence.snapToId || null, changedAbsence.snapToType || null, changedAbsence.snapDirection || null).then(function (updatedObjects) {

                if (updatedObjects.error) {
                    deffered.reject([updatedObjects, originalAbsence]);
                    return;
                }

                var parsedUpdatedObjects = {};

                parsedUpdatedObjects.absences = TimePhasedDataService.updateTimePhaseData(updatedObjects.resourceAbsences, 'na').absences;
                parsedUpdatedObjects.services = TimePhasedDataService.updateTimePhaseData(updatedObjects.services, 'service').services;

                var combinedServicesAndAbsences = [];
                combinedServicesAndAbsences.push.apply(combinedServicesAndAbsences, _toConsumableArray(parsedUpdatedObjects.services).concat(_toConsumableArray(parsedUpdatedObjects.absences)));

                var servicesToCheckRules = combinedServicesAndAbsences.map(function (service) {
                    return service.id;
                });
                servicesToCheckRules.length && servicesService.checkRules(utils.getRelatedServices(servicesToCheckRules)).then(function () {
                    return scheduler.updateView();
                });

                deffered.resolve(parsedUpdatedObjects);
            }).catch(function (err) {
                deffered.reject([err, originalAbsence]);
            });

            return deffered.promise;
        }

        function saveNewAbsence(draggedAbsence) {

            var deffered = $q.defer();

            if (useLocationTimezone) {
                //get territory offset by SRST
                var resourceTerritoryOffset = TimePhasedDataService.getIntersectingSrstOffset(draggedAbsence, draggedAbsence.resource);

                var userStartOffset = utils.getUserOffset(draggedAbsence.start_date);
                var userEndOffset = utils.getUserOffset(draggedAbsence.end_date);

                //set times accordingly
                draggedAbsence.start_date.setMinutes(draggedAbsence.start_date.getMinutes() + userStartOffset - resourceTerritoryOffset);
                draggedAbsence.end_date.setMinutes(draggedAbsence.end_date.getMinutes() + userEndOffset - resourceTerritoryOffset);
            }

            sfdcService.saveChangesToAbsence(null, draggedAbsence.resource, draggedAbsence.start_date, draggedAbsence.end_date, draggedAbsence.absenceType, draggedAbsence.ganttLabel, draggedAbsence.snapToId || null, draggedAbsence.snapToType || null, draggedAbsence.snapDirection || null).then(function (updatedObjects) {

                if (updatedObjects.error) {
                    deffered.reject(updatedObjects);
                    return;
                }

                var parsedUpdatedObjects = {};

                parsedUpdatedObjects.absences = TimePhasedDataService.updateTimePhaseData(updatedObjects.resourceAbsences, 'na').absences;
                parsedUpdatedObjects.services = TimePhasedDataService.updateTimePhaseData(updatedObjects.services, 'service').services;

                var combinedServicesAndAbsences = [];
                combinedServicesAndAbsences.push.apply(combinedServicesAndAbsences, _toConsumableArray(parsedUpdatedObjects.services).concat(_toConsumableArray(parsedUpdatedObjects.absences)));

                var servicesToCheckRules = combinedServicesAndAbsences.map(function (service) {
                    return service.id;
                });
                servicesToCheckRules.length && servicesService.checkRules(utils.getRelatedServices(servicesToCheckRules)).then(function () {
                    return scheduler.updateView();
                });

                deffered.resolve(parsedUpdatedObjects);
            }).catch(function (err) {
                deffered.reject(err);
            });

            return deffered.promise;
        }

        function deleteAbsence(id) {

            var deffered = $q.defer();

            sfdcService.deleteResourceAbsence(id).then(function (isDeleted) {

                DeltaService.getDelta();
            }).catch(function (err) {
                deffered.reject(err);
            });

            return deffered.promise;
        }

        // get NA types
        function getEmployeeAbsenceTypes() {
            var deffered = $q.defer();

            sfdcService.getEmployeeAbsenceTypes().then(function (eaTypes) {
                if (!eaTypes) {
                    return;
                }
                // for (var key in eaTypes) {
                nonAvailabilityTypes = eaTypes; // return an object(value,label).
                // }
                deffered.resolve(nonAvailabilityTypes);
            }).catch(function (err) {
                deffered.reject(err);
            });

            return deffered.promise;
        };

        // This will be our factory
        return {
            saveChangesToAbsence: saveChangesToAbsence,
            saveNewAbsence: saveNewAbsence,
            deleteAbsence: deleteAbsence,
            //nonAvailabilityTypes
            getEmployeeAbsenceTypes: getEmployeeAbsenceTypes
        };
    }
})();