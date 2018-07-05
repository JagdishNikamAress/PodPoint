'use strict';

/*

    ResourceService
    The resource service keeps all stuff related to the resources and territories

 */

(function () {

    ResourcesAndTerritoriesService.$inject = ['$q', 'sfdcService'];

    angular.module('serviceExpert').factory('ResourcesAndTerritoriesService', ResourcesAndTerritoriesService);

    function ResourcesAndTerritoriesService($q, sfdcService) {

        // hold promises
        var deferredObjects = {
            territories: $q.defer(),
            resources: $q.defer(),
            operatingHours: $q.defer()
        },


        // active territories map
        territories = {},


        // all territories
        allTerritories = {},


        // resource map
        resources = {},


        // contractorResources array of Ids
        contractorResources = [],


        // operating hours map
        operatingHours = {},


        // crew resources array of Ids
        crewResources = {},
            crewToResources = {};

        function getResources() {
            return resources;
        }

        function getOperatingHours() {
            return operatingHours;
        }

        function getCapacityBasedResources() {
            return contractorResources;
        }

        function getCrewResources() {
            return crewResources;
        }

        function getCrewToResources() {
            return crewToResources;
        }

        // factory init - getting resources and territories
        function getResourceAndTerritories() {

            var gotResourcesDeferred = $q.defer();

            sfdcService.GetResourcesAndTerritories().then(function (resourcesAndTerrtories) {

                gotResourcesDeferred.resolve();

                // get ALL territories
                resourcesAndTerrtories.territories.forEach(function (territory) {
                    if (territory.IsActive) territories[territory.Id] = new ServiceTerritory(territory);

                    allTerritories[territory.Id] = new ServiceTerritory(territory);
                });

                // get resources of loaded territories
                resourcesAndTerrtories.resources.forEach(function (resource) {
                    resources[resource.Id] = new ServiceResource(resource);

                    if (resources[resource.Id].isCapacityBased) contractorResources.push(resource.Id);

                    if (resources[resource.Id].serviceCrew) {
                        crewResources[resource.Id] = resource;
                        crewToResources[resources[resource.Id].serviceCrew] = resource;
                    }
                });

                // get operating hours and timeslots of resources in loaded territories
                resourcesAndTerrtories.operatingHours.forEach(function (oph) {
                    operatingHours[oph.Id] = new OperatingHours(oph);
                });

                deferredObjects.territories.resolve(territories);
                deferredObjects.resources.resolve(resources);
                deferredObjects.operatingHours.resolve(operatingHours);
            }).catch(function (ex) {
                gotResourcesDeferred.reject(ex);
                deferredObjects.resources.reject();
                deferredObjects.territories.reject();
                deferredObjects.operatingHours.reject();
                console.warn('GetResourcesAndTeritorries: unable to load resources, territories, or operating hours');
                bootstrap.handleError(ex);
            });

            return gotResourcesDeferred.promise;
        }

        // run when service loads
        getResourceAndTerritories();

        // this will reset the data, used when locations are loaded/unloaded
        function reset() {
            territories = {};
            resources = {};
            operatingHours = {};
            contractorResources = [];
            crewResources = {};
            crewToResources = {};
        }

        // This will be our resource factory
        return {
            promises: {
                territories: function territories() {
                    return deferredObjects.territories.promise;
                },
                resources: function resources() {
                    return deferredObjects.resources.promise;
                },
                operatingHours: function operatingHours() {
                    return deferredObjects.operatingHours.promise;
                }
            },
            territories: territories,
            allTerritories: allTerritories,
            getResources: getResources,
            operatingHours: operatingHours,
            getOperatingHours: getOperatingHours,
            getCapacityBasedResources: getCapacityBasedResources,
            getCrewResources: getCrewResources,
            getCrewToResources: getCrewToResources,
            contractorResources: contractorResources,
            crewResources: crewResources,
            crewToResources: crewToResources,
            getResourceAndTerritories: getResourceAndTerritories,
            reset: reset
        };
    }
})();