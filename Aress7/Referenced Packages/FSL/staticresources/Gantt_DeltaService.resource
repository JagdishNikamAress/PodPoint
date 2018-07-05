'use strict';

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

(function () {

    DeltaService.$inject = ['sfdcService', '$interval', 'TimePhasedDataService', 'LastKnownPositionService', 'StateService', 'utils', 'MstResolver'];

    angular.module('serviceExpert').factory('DeltaService', DeltaService);

    function DeltaService(sfdcService, $interval, TimePhasedDataService, LastKnownPositionService, StateService, utils, MstResolver) {

        var lastModifiedDate = null,
            deltaIntervalRateInSeconds = deltaInterval || 10,
            registeredFunctions = {
            services: [],
            absences: [],
            capacities: [],
            positions: [],
            optimizationRequests: [],
            rules: []
        };

        function getDelta() {

            if (StateService.getStreamingActiveState() == false) {

                sfdcService.getDelta(lastModifiedDate).then(function (delta) {

                    lastModifiedDate = delta.updateTime;

                    var servicesIdsToCheckRules = [];

                    // check if got absences
                    if (delta.deletedAbsence && delta.deletedAbsence.length > 0 || delta.updatedAbsence && delta.updatedAbsence.length > 0) {

                        var absences = {};

                        if (delta.deletedAbsence.length > 0) {
                            absences.deleted = TimePhasedDataService.deleteTimePhaseData(delta.deletedAbsence, 'na').absences;

                            servicesIdsToCheckRules.push.apply(servicesIdsToCheckRules, _toConsumableArray(utils.getRelatedServices(absences.deleted)));
                            //servicesIdsToCheckRules.push(...utils.getRelatedServices(utils.getIdsOfSObjectsAbsence(absences.deleted)));
                        }

                        if (delta.updatedAbsence.length > 0) {
                            absences.updated = TimePhasedDataService.updateTimePhaseData(delta.updatedAbsence, 'na').absences;

                            var resourceIds = absences.updated.map(function (v) {
                                return v.resource;
                            }).join(',');
                            servicesIdsToCheckRules.push.apply(servicesIdsToCheckRules, _toConsumableArray(utils.getRelatedServices(utils.getIdsOfSObjects(absences.updated), resourceIds)));

                            //servicesIdsToCheckRules.push(...utils.getRelatedServices(utils.getIdsOfSObjects(absences.updated)));
                        }

                        // run registered function (only if something was really updated)
                        if (absences.updated || absences.deleted) {
                            registeredFunctions.absences.forEach(function (absenceFunction) {
                                return absenceFunction(absences);
                            });
                        }
                    }

                    // check if got services
                    if (delta.updatedGanttServices && delta.updatedGanttServices.length > 0 || delta.deletedGanttServices && delta.deletedGanttServices.length > 0) {

                        var services = {};

                        if (delta.deletedGanttServices.length > 0) {
                            services.deleted = TimePhasedDataService.deleteTimePhaseData(delta.deletedGanttServices, 'service').services;
                            servicesIdsToCheckRules.push.apply(servicesIdsToCheckRules, _toConsumableArray(utils.getRelatedServices(services.deleted)));
                        }

                        if (delta.updatedGanttServices.length > 0) {
                            services.updated = TimePhasedDataService.updateTimePhaseData(delta.updatedGanttServices, 'service').services;
                            servicesIdsToCheckRules.push.apply(servicesIdsToCheckRules, _toConsumableArray(utils.getRelatedServices(utils.getIdsOfSObjects(services.updated))));
                        }

                        // run registered function (only if something was really updated)
                        if (services.updated || services.deleted) {
                            registeredFunctions.services.forEach(function (serviceFunction) {
                                return serviceFunction(services);
                            });
                        }
                    }

                    // check for live position
                    if (delta.updatedLivePositions) {

                        var updateRes = LastKnownPositionService.updatePositions(delta.updatedLivePositions);

                        if (updateRes.isUpdated) {
                            registeredFunctions.positions.forEach(function (posFunction) {
                                return posFunction(updateRes.dic);
                            });
                        }
                    }

                    // check if we need to check rules {
                    if (servicesIdsToCheckRules.length > 0) {
                        registeredFunctions.rules.forEach(function (posFunction) {
                            return posFunction(servicesIdsToCheckRules);
                        });
                    }

                    // check if got capacities
                    if (StateService.areContractorsSupported) {
                        if (delta.deletedCapacities && delta.deletedCapacities.length > 0 || delta.updatedCapacities && delta.updatedCapacities.length > 0) {

                            var capacities = {};

                            if (delta.deletedCapacities.length > 0) {
                                capacities.deleted = TimePhasedDataService.deleteTimePhaseData(delta.deletedCapacities, 'capacity').capacities;
                            }

                            if (delta.updatedCapacities.length > 0) {
                                capacities.updated = TimePhasedDataService.updateTimePhaseData(delta.updatedCapacities, 'capacity').capacities;
                            }

                            // run registered function (only if something was really updated)
                            if (capacities.updated || capacities.deleted) {
                                registeredFunctions.capacities.forEach(function (capacityFunction) {
                                    return capacityFunction(capacities);
                                });
                            }
                        }
                    }

                    // check if got optimization requests
                    if (StateService.isOptimizationEnabled && delta.optimizationRequests && delta.optimizationRequests.length > 0) {
                        registeredFunctions.optimizationRequests.forEach(function (requestFunction) {
                            return requestFunction(delta.optimizationRequests);
                        });
                    }
                }).catch(function (ex) {
                    console.warn(ex);
                });
            }
        }

        // start delta
        $interval(getDelta, deltaIntervalRateInSeconds * 1000);

        function updateOptimizationRequest(req) {
            registeredFunctions.optimizationRequests.forEach(function (requestFunction) {
                return requestFunction([req]);
            });
        }

        // register for updates  |  TYPES: absences, services, capacities
        function register(type, callback) {
            return registeredFunctions[type] && registeredFunctions[type].push(callback);
        }

        function unRegister(type, callback) {
            registeredFunctions[type].splice(registeredFunctions[type].indexOf(callback), 1);
        }

        // This will be our factory
        return {
            register: register,
            unRegister: unRegister,
            getDelta: getDelta,
            updateOptimizationRequest: updateOptimizationRequest
        };
    }
})();