'use strict';

(function () {
    angular.module('serviceExpert').factory('ResourceCapacitiesService', ['ResourcesAndTerritoriesService', 'TimePhasedDataService', '$rootScope', 'utils', 'StateService', function (ResourcesAndTerritoriesService, TimePhasedDataService, $rootScope, utils, StateService) {

        var cachedContractorDates = {};

        $rootScope.$on('gotNewTimePhasedObjects', function (ev, timePhasedObjects) {
            if (StateService.areContractorsSupported() && Object.keys(timePhasedObjects.resourcesAndTerritories).length) drawContractorsTimeSpans(timePhasedObjects.start, timePhasedObjects.finish);
        });

        function reset() {
            cachedContractorDates = {};
        }

        function drawContractorsTimeSpans(start, finish) {
            var currDay = new Date(start);
            var sectionIds = null;

            while (currDay < finish) {
                var formatedDate = utils.formatDayToString(currDay);

                if (!cachedContractorDates[formatedDate]) {
                    cachedContractorDates[formatedDate] = true;
                    if (!sectionIds) sectionIds = buildSectionIdsArray();

                    var currFinish = new Date(currDay);
                    currFinish.setDate(currFinish.getDate() + 1);

                    for (var i = 0; i <= sectionIds.length; i++) {
                        addMarkedTimeSpan(new Date(currDay), new Date(currFinish), sectionIds[i]);
                    }
                }

                currDay.setDate(currDay.getDate() + 1);
            }
        }

        function addMarkedTimeSpan(start, finish, sectionId) {
            if (start.getTime() == finish.getTime()) return;

            var sectionsToDraw = {};
            for (var key in scheduler.matrix) {
                sectionsToDraw[key] = [sectionId];
            }

            var cssClass = 'capacityPattern';

            scheduler.addMarkedTimespan({
                start_date: start,
                end_date: finish,
                sections: sectionsToDraw,
                css: cssClass
            });
        }

        function buildSectionIdsArray() {
            var sectionIds = [];
            var resourcesToTimePhasedLocations = TimePhasedDataService.resourcesAndTerritories();

            var capacityBasedResources = ResourcesAndTerritoriesService.getCapacityBasedResources();
            for (var i = 0; i <= capacityBasedResources.length; i++) {
                var contractorResourceId = capacityBasedResources[i];

                //get timephased territories of contractor resource
                var timePhasedTerritories = resourcesToTimePhasedLocations[contractorResourceId];

                for (var timePhasedTerId in timePhasedTerritories) {
                    var timePhasedLoc = timePhasedTerritories[timePhasedTerId];
                    sectionIds.push(utils.generateResourceId(contractorResourceId, timePhasedLoc.serviceTerritory));
                }
            }

            return sectionIds;
        }

        return {
            reset: reset
        };
    }]);
})();