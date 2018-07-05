'use strict';

(function () {

    LocationFilteringService.$inject = ['$compile', '$rootScope', 'ResourcesAndTerritoriesService', 'userSettingsManager', 'sfdcService', 'utils', 'TimePhasedDataService', 'StateService', 'calendarsService', 'monthlyViewHelperService', 'ResourceCrewsService', 'ResourceCapacitiesService'];

    angular.module('serviceExpert').factory('LocationFilteringService', LocationFilteringService);

    function LocationFilteringService($compile, $rootScope, ResourcesAndTerritoriesService, userSettingsManager, sfdcService, utils, TimePhasedDataService, StateService, calendarsService, monthlyViewHelperService, ResourceCrewsService, ResourceCapacitiesService) {

        // create new isolated scope
        var $scope = $rootScope.$new(true);

        // add to body
        var lightboxDomElement = generateTemplate().hide();
        lightboxDomElement.find('#LocationFilteringLightbox').draggable({ handle: '#LocationFilteringLightboxHeader' });
        angular.element('body').append(lightboxDomElement);

        // init stuff
        $scope.trust = utils.trust;
        $scope.showOrphanServices = true;
        $scope.locationSearchTerm = '';
        $scope.showLocationFiltering = false;
        $scope.noLocationsLoad = false;
        $scope.locationFilter = {};
        $scope.locationFilterCopy = {};
        $scope.locationsFlat = [];
        $scope.territoriesSortedByTree = [];
        $scope.showSecondaryTimezoneNotice = showSecondarySTMs && useLocationTimezone;

        // compile
        $compile(lightboxDomElement)($scope);

        // add ESC shortcut
        $scope.$on('keypress', function (broadcastData, e) {
            if (e.which == 27) {
                $scope.closeLightbox();
            }
        });

        // open the UI
        function open() {
            lightboxDomElement.show();
            StateService.setLightBoxStatus(); // set lightbox state to open
        }

        // close the UI (only if we have at least 1 loaded location)
        $scope.closeLightbox = function () {
            if (!$scope.noLocationsLoad) {
                for (var key in $scope.locationFilterCopy) {
                    $scope.locationFilter[key] = $scope.locationFilterCopy[key];
                }

                $scope.showOrphanServices = $scope.showOrphanServicesOldValue;

                lightboxDomElement.hide();
                StateService.setLightBoxStatus(false); // set lightbox state to open
            }
        };

        // this object will make the indentations on the tree UI
        $scope.styleForLocationTree = function (depth) {
            return {
                'margin-left': depth * 20 + 'px'
            };
        };

        // ready data for display - should happen only once when finished loading the territories list
        ResourcesAndTerritoriesService.promises.territories().then(function () {

            var treeData = {},
                m_locationTreeDataUnflatten = [],
                userSettingLocations = [],
                showLocations = [];

            // start build unflatten tree for location filtering hierarchy
            for (var id in ResourcesAndTerritoriesService.territories) {
                treeData[id] = {
                    id: id,
                    parent: ResourcesAndTerritoriesService.territories[id].parentTerritory ? ResourcesAndTerritoriesService.territories[id].parentTerritory : 0,
                    text: ResourcesAndTerritoriesService.territories[id].name,
                    items: []
                };
            }

            // build data stuctures (tree + flat)
            for (var key in treeData) {

                var node = treeData[key];
                var activeParent = getFirstActiveParent(node);

                if (node.parent !== 0 && activeParent) {
                    treeData[activeParent.id].items.push(node);
                } else {
                    m_locationTreeDataUnflatten.push(node);
                }
            }

            function getFirstActiveParent(node) {
                if (!node.id || !node.parent) return;

                if (treeData[node.parent.id]) return node.parent;else {

                    //check if territory is even available for user
                    var parentNode = {};
                    if (ResourcesAndTerritoriesService.allTerritories[node.parent.id]) parentNode = {
                        id: ResourcesAndTerritoriesService.allTerritories[node.parent.id].id,
                        parent: ResourcesAndTerritoriesService.allTerritories[node.parent.id].parentTerritory ? ResourcesAndTerritoriesService.allTerritories[node.parent.id].parentTerritory : 0
                    };

                    return getFirstActiveParent(parentNode);
                }
            }

            $scope.locationsTree = m_locationTreeDataUnflatten;

            for (var i = 0; i < m_locationTreeDataUnflatten.length; i++) {
                setNodeDepth(m_locationTreeDataUnflatten[i], 0, $scope.locationsFlat);
            }

            // check if we need to show services without locations (and without resource)
            $scope.showOrphanServices = JSON.parse(userSettingsManager.GetUserSettingsProperty('Show_Orphan_Services__c'));
            $scope.showOrphanServicesOldValue = $scope.showOrphanServices;

            $scope.territoriesSortedByTree = sortLocationsByTree(ResourcesAndTerritoriesService.territories, $scope.locationsFlat);

            // we have something saved, lets parse it
            if (userSettingsManager.GetUserSettingsProperty('locations') != null) {
                userSettingLocations = userSettingsManager.GetUserSettingsProperty('locations');
            }

            sfdcService.getUnPrivilegeUserSettingsFields().then(function (result) {

                if (result.length > 1) {

                    var errMsg = customLabels.Unprivileged_Usersettings_Fields_Msg.split('{1}'),
                        originalMsg = errMsg[0],
                        fields = '',
                        maxFields = 3;

                    for (var _i = 0; _i < result.length && _i < maxFields; ++_i) {
                        fields += '<br>' + result[_i];
                    }

                    if (maxFields < result.length) {
                        var additionalFields = result.length - maxFields;
                        fields += '<br>';
                        originalMsg += errMsg[1].replace('{2}', additionalFields);
                    }

                    originalMsg = originalMsg.replace('{0}', fields);
                    utils.addNotification(customLabels.Unprivileged_Usersettings_Fields, originalMsg);
                }
            }).catch(function (err) {
                console.warn('GetUserSettingsProperty failed :-(');
                console.error(err);
            });

            for (var _i2 = 0; _i2 < $scope.locationsFlat.length; _i2++) {

                // no local storage, show location filtering box
                if (userSettingLocations.length === 0) {
                    $scope.showLocationFiltering = true;
                    $scope.noLocationsLoad = true;
                    open();
                    return;
                }

                $scope.noLocationsLoad = false;
                $scope.locationFilter[$scope.locationsFlat[_i2].id] = userSettingLocations.indexOf($scope.locationsFlat[_i2].id) > -1;

                if ($scope.locationFilter[$scope.locationsFlat[_i2].id]) showLocations.push($scope.locationsFlat[_i2].id);
            }

            // make a copy, used when user closing without save
            $scope.locationFilterCopy = angular.copy($scope.locationFilter);
            userSettingsManager.SetUserSettingsProperty('locations', JSON.stringify(showLocations));
        });

        // set node depth on each location (will be used to indent in the UI)
        function setNodeDepth(current, depth, arr) {
            current.depth = depth;
            arr.push(current);

            if (current.items) {
                for (var i = 0, len = current.items.length; i < len; i++) {
                    current.items[i].depth = depth;
                    setNodeDepth(current.items[i], depth + 1, arr);
                }
            }
        }

        // apply location filtering (clean memorym bring new objects)
        $scope.applyFilterLocation = function () {

            var showLocations = [],
                hideLocations = [];

            for (var key in $scope.locationFilter) {
                if ($scope.locationFilter[key]) {
                    showLocations.push(key);
                } else {
                    hideLocations.push(key);
                }
            }

            if (showLocations.length === 0) {
                alert(customLabels.One_loaded_location);
                return;
            }

            $scope.noLocationsLoad = false;
            angular.extend($scope.locationFilterCopy, $scope.locationFilter);
            $scope.showOrphanServicesOldValue = $scope.showOrphanServices;

            StateService.isLoadingNewLocations = true;

            // save settings
            userSettingsManager.SetUserSettingProperties($scope.parseLocationSettings(JSON.stringify(showLocations), $scope.showOrphanServices)).then(function () {

                // reset monthly
                monthlyViewHelperService.reset();

                // reset resource and territories
                ResourcesAndTerritoriesService.reset();

                // reset all gantt events
                scheduler._events = {};
                // delete all calendars, relocations...
                scheduler.deleteMarkedTimespan();

                // reset timephased object
                TimePhasedDataService.reset();

                // calendars, relocations... crew members... capacity white markings...
                calendarsService.reset();
                ResourceCrewsService.reset();
                ResourceCapacitiesService.reset();

                ResourcesAndTerritoriesService.getResourceAndTerritories().then(function () {

                    var start = new Date(scheduler.getState().min_date),
                        finish = new Date(scheduler.getState().max_date);

                    start.setDate(start.getDate() - 1);
                    finish.setDate(finish.getDate() + 1);

                    TimePhasedDataService.getTimePhasedObjects(start, finish).then(function () {
                        scheduler.updateView();
                        $rootScope.$broadcast('gotNewResources', { show: showLocations });
                        StateService.isLoadingNewLocations = false;
                    });
                });
            }).catch(function (err) {
                // console.warn('SetUserSettingProperties failed :-(');
                // console.error(err);
                var msg = customLabels.territories_r_failure_msg + '\n';
                var FailedLocations = JSON.parse(err.FailedLocations);

                for (var i = 0; i < FailedLocations.length; i++) {
                    msg += FailedLocations[i].Name + '\n';
                }

                utils.addNotification(customLabels.territories_r_failure, msg);
                StateService.isLoadingNewLocations = false;
            });

            $scope.closeLightbox();
        };

        $scope.parseLocationSettings = function (locations, showOrphanServices) {
            return {
                locations: locations,
                Show_Orphan_Services__c: showOrphanServices
            };
        };

        // for location filter
        $scope.selectLocation = function (locationId) {
            var bool = $scope.locationFilter[locationId],
                parentLocation = findLocationInTree($scope.locationsTree, locationId);

            if (parentLocation) {
                selectLocationTree(parentLocation, bool);
            }
        };

        // find parent location in the tree
        function findLocationInTree(locationsTree, locationId) {

            var child = null;

            for (var i = 0; i < locationsTree.length; i++) {
                if (locationsTree[i].id === locationId) {
                    return locationsTree[i];
                } else {
                    child = findLocationInTree(locationsTree[i].items, locationId);
                    if (child) {
                        return child;
                    }
                }
            }

            return child;
        }

        // check / uncheck the locations.
        function selectLocationTree(location, bool) {
            for (var i = 0; i < location.items.length; i++) {
                $scope.locationFilter[location.items[i].id] = bool;
                selectLocationTree(location.items[i], bool);
            }
        }

        // select all available locations
        $scope.selectAllLocations = function (isSelectAll) {
            angular.forEach($scope.filteredLocations, function (item) {
                $scope.locationFilter[item.id] = isSelectAll;
            });
        };

        function sortLocationsByTree(territories, flatLocations) {
            var territoriesArray = Object.keys(territories).map(function (key) {
                return territories[key];
            }).sort(function (a, b) {

                var a_pos = 0,
                    b_pos = 0;

                flatLocations.forEach(function (location, index) {
                    if (location.id === a.id) {
                        a_pos = index;
                    }

                    if (location.id === b.id) {
                        b_pos = index;
                    }
                });

                if (a_pos > b_pos) return 1;
                if (a_pos < b_pos) return -1;
                return 0;
            });

            return territoriesArray;
        }

        // DOM element
        function generateTemplate() {
            return angular.element('<div class="LightboxBlackContainer">\n                        <div class="LightboxContainer LightboxContainerAnimation" id="LocationFilteringLightbox">\n\n                            <div class="lightboxHeaderContainer" id="LocationFilteringLightboxHeader">\n                                <h1 class="light-box-header">' + customLabels.Location_filtering + '</h1>\n                                <svg ng-click="closeLightbox()" aria-hidden="true" class="slds-icon CloseLightbox" ng-hide="noLocationsLoad">\n                                    \u2028\u2028<use xlink:href="' + lsdIcons.close + '"></use>\n                                </svg>\n                            </div>\n\n                            <div class="lightboxContentContainer">\n\n                                <p>' + customLabels.LocationFilteringParagraph + '</p>\n\n                                <div class="LocationsTreeContainer">\n                                    <p id="secondary-notice" ng-show="showSecondaryTimezoneNotice">' + customLabels.Stms_with_different_tz + '</p>\n\n                                    <div class="locationFilterRow addBorderBottom">\n                                        <input type="checkbox" ng-model="showOrphanServices" id="servicesNoLocations" />\n                                        <label for="servicesNoLocations">' + customLabels.unassosiated_filtering + '</label><br/>\n                                    </div>\n\n                                    <input id="locationFilteringSearch" type="text" ng-model="locationSearchTerm.text" placeholder="' + customLabels.Search_location + '" />\n                                    <span class="selectAllLocations" ng-click="selectAllLocations(true)" title="' + customLabels.Select_all + '">' + customLabels.All + '</span>\n                                    <span class="selectAllLocations" ng-click="selectAllLocations(false)" title="' + customLabels.Select_none + '">' + customLabels.None + '</span>\n\n                                    <div ng-repeat="l in filteredLocations = (locationsFlat | filter:locationSearchTerm)" class="locationFilterRow" ng-style="{{ styleForLocationTree(l.depth) }}" ng-click="selectLocation(l.id)">\n                                        <input type="checkbox" ng-model="locationFilter[l.id]" id="location_{{ l.id }}" />\n                                        <label for="location_{{ l.id }}" ng-bind="l.text"></label><br/>\n                                    </div>\n\n                                </div>\n\n                            </div>\n\n                            <div class="lightboxControllers">\n                                <div class="lightboxSaveButton" ng-click="applyFilterLocation()">' + customLabels.Save + '</div>\n                            </div>\n\n                        </div>\n                    </div>');
        }

        function getFlatTerritoriesArray() {
            return $scope.locationsFlat;
        }

        function getTerritoriesSortedByTree() {
            return $scope.territoriesSortedByTree;
        }

        // This will be our factory
        return {
            open: open,
            getFlatTerritoriesArray: getFlatTerritoriesArray,
            getTerritoriesSortedByTree: getTerritoriesSortedByTree
        };
    }
})();