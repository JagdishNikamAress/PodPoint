'use strict';

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

(function () {

    utils.$inject = ['$q', '$sce', 'sfdcService', '$rootScope', '$timeout', 'userSettingsManager', 'StateService', 'kpiCalculationsService', 'ResourcesAndTerritoriesService', '$injector'];

    angular.module('serviceExpert').factory('utils', utils);

    function utils($q, $sce, sfdcService, $rootScope, $timeout, userSettingsManager, StateService, kpiCalculationsService, ResourcesAndTerritoriesService, $injector) {

        var _checkBoxFields = void 0,
            woPriorities = [],
            reports = [],
            polygons = [],
            butlerNotifications = [],
            ganttSettings = {},
            statusFlow = {},
            statusTranslations = {},
            statuses = {},
            fieldsTypes = {
            DateTime: 'DATETIME',
            Date: 'DATE',
            String: 'STRING',
            TextArea: 'TEXTAREA',
            Picklist: 'PICKLIST',
            Reference: 'REFERENCE',
            Currency: 'CURRENCY',
            Phone: 'PHONE'
        },
            showServiceList = {
            show: true
        },
            durationTypes = {
            minutes: 'Minutes',
            hours: 'Hours',
            days: 'Days'
        },
            crewsFilter = false;

        // generate resource ids
        function generateResourceId(resourceIds, territoryIds) {

            // resources is array and territories string -> all resources will have the territory ID attached to them
            // EX: res001_ter1,res002_ter1,res003_ter1,
            if (Array.isArray(resourceIds) && !Array.isArray(territoryIds)) {
                return resourceIds.map(function (value) {
                    return value + '_' + territoryIds;
                }).join(',');
            }

            // resources is array and territories is array -> attaching res[i] with ter[i]
            // EX: res001_ter1,res002_ter2,res003_ter3,
            if (Array.isArray(resourceIds) && Array.isArray(territoryIds)) {
                return resourceIds.map(function (value, index) {
                    return value + '_' + territoryIds[index];
                }).join(',');
            }

            // resources and territories string | EX: res001_ter1
            if (!Array.isArray(resourceIds) && !Array.isArray(territoryIds)) {
                return resourceIds + '_' + territoryIds;
            }

            // resource and territories array
            if (!Array.isArray(resourceIds) && Array.isArray(territoryIds)) {
                return territoryIds.map(function (value) {
                    return resourceIds + '_' + value;
                }).join(',');
            }
        }

        sfdcService.getAllFormulaFields().then(function (result) {
            _checkBoxFields = result;
        });

        // get WO priority picklist
        sfdcService.getWorkOrderPriority().then(function (woPrioritiesSf) {
            woPriorities.push.apply(woPriorities, _toConsumableArray(woPrioritiesSf));
        });

        //load reports with geolocation columns
        function getReports() {

            var deferred = $q.defer();

            sfdcService.getReports().then(function (reportsSf) {

                if (!reportsSf) {
                    deferred.resolve(null);
                    return;
                }

                for (var i = 0; i < reportsSf.length; i++) {
                    reports.push(reportsSf[i]);
                }

                deferred.resolve(reports);
            });

            return deferred.promise;
        }

        function getPolygons() {

            var deferred = $q.defer();

            if (!hasCustomPermission('Polygons_view')) {
                deferred.resolve(null);
                return;
            }

            sfdcService.getPolygons().then(function (polygonsResult) {

                if (!polygonsResult) {
                    deferred.resolve(null);
                    return;
                }

                for (var i = 0; i < polygonsResult.length; i++) {
                    polygons.push(polygonsResult[i]);
                }

                deferred.resolve(polygons);
            });

            return deferred.promise;
        }

        // mostly copied from DHTMLX with our addons for filtered hours/resources
        function showOnGantt(id, mode) {

            var ev = typeof id === "number" || typeof id === "string" ? scheduler.getEvent(id) : id,
                currentBusinessHours = getMinAndMaxHoursToDisplay(),
                eventStartTime = ev.start_date.getHours(),
                eventEndTime = ev.end_date.getHours();

            if (scheduler._min_date <= ev.start && ev.start < scheduler._max_date) {
                scheduler.setCurrentView(scheduler._min_date);
            } else {
                scheduler.setCurrentView(new Date(ev.start));
            }

            setTimeout(function () {

                mode = mode || scheduler._mode;

                // checking if business hour filter is filtering our service
                if (ev.end_date.getHours() === 0 && ev.end_date.getDate() > ev.start_date.getDate()) eventEndTime = 24;

                if (mode === 'MonthlyView') {
                    alert(customLabels.serviceCantDisplayMonthlyMsg);
                    return;
                }

                if (scheduler._mode !== 'ZoomLevel2' && (currentBusinessHours.min > eventEndTime || currentBusinessHours.max <= eventStartTime)) {
                    alert(customLabels.serviceCantDisplayMsg);
                    return;
                }

                // service might be available but resource not (service location is loaded but assigned to a resource in filtered location
                var resourceFiltered = true,
                    resources = scheduler.serverList('resources');

                for (var i = 0; i < resources.length; i++) {
                    for (var j = 0; j < resources[i].children.length; j++) {
                        if (ev.resourceId.indexOf(resources[i].children[j].key) > -1) {
                            resourceFiltered = false;
                            break;
                        }
                    }
                }

                if (resourceFiltered) {
                    alert(customLabels.resource_filtered_out);
                    return;
                }

                // get rendered event by territory if Show SecondarySTMs is on
                var renderedEvent = scheduler.getRenderedEvent(id);
                if (showSecondarySTMs && ev.ServiceTerritoryId && ev.resourceId.indexOf(',') > -1) {

                    //get correct section by service territory - 
                    var sections = ev.resourceId.split(',');
                    var correctSection = sections[0]; //set default
                    for (var _i = 0; _i < sections.length; _i++) {
                        if (sections[_i].indexOf(ev.ServiceTerritoryId) > -1) {
                            correctSection = sections[_i];
                            break;
                        }
                    }

                    //find correct rendered
                    renderedEvent = getRenderedEventByIdAndTerritory(id, correctSection.split('_')[1]) || renderedEvent;
                }

                $(renderedEvent).removeClass('ShowEventEffect');

                if (!ev || scheduler.checkEvent("onBeforeEventDisplay") && !scheduler.callEvent("onBeforeEventDisplay", [ev, mode])) return;

                var scroll_hour = scheduler.config.scroll_hour;
                scheduler.config.scroll_hour = ev.start_date.getHours();
                var preserve_scroll = scheduler.config.preserve_scroll;
                scheduler.config.preserve_scroll = false;

                //if service start is not in current view (travel also)
                if (ev.start_date < scheduler._min_date || ev.start_date > scheduler._max_date) {
                    if (StateService.areContractorsSupported() && ev.resourceContractor) scheduler.setCurrentView(new Date(ev.start), mode);else scheduler.setCurrentView(new Date(ev.start), mode);
                }

                scheduler.config.scroll_hour = scroll_hour;
                scheduler.config.preserve_scroll = preserve_scroll;

                //if service is assigned to contractor, show effect on capacity event.
                if (StateService.areContractorsSupported()) {
                    var capacityDurationFiltered = true;
                    if (ev.resourceContractor) {
                        var collidingEvents = scheduler.getEvents(ev.start, ev.finish);
                        for (i = 0; i < collidingEvents.length; i++) {
                            if (collidingEvents[i].resourceId == ev.resourceId && collidingEvents[i].type == 'contractorcapacity' && collidingEvents[i].timePeriod == userSettingsManager.GetUserSettingsProperty('View_Capacity_Type__c')) {
                                ev = collidingEvents[i];
                                id = collidingEvents[i].id;
                                renderedEvent = scheduler.getRenderedEvent(id);

                                $(renderedEvent).removeClass('ShowEventEffect');

                                capacityDurationFiltered = false;
                                break;
                            }
                        }

                        if (capacityDurationFiltered) {
                            alert(customLabels.is_assigned_to_contractor.replaceAll(ev.name, ev.resourceName) + '.\n' + customLabels.This_capacity_duration_is_filtered_out + '.\n' + customLabels.To_change_the_capacity_duration);
                            return;
                        }
                    }
                }

                if (scheduler.matrix && scheduler.matrix[mode]) {
                    scheduler._els.dhx_cal_data[0].scrollTop = 0;
                    scheduler._els.dhx_cal_data[0].scrollTop = getAbsoluteTop(scheduler.getRenderedEvent(ev.id)) - getAbsoluteTop(scheduler._els.dhx_cal_data[0]) - 20;
                }

                scheduler.callEvent("onAfterEventDisplay", [ev, mode]);

                renderedEvent = scheduler.getRenderedEvent(id);
                $(renderedEvent).addClass('ShowEventEffect');

                $timeout(function () {
                    kpiCalculationsService.calculateKpis();
                    $rootScope.$broadcast('afterShowEvent');
                }, 400);
            }, 200);
        };

        function getRenderedEventByIdAndTerritory(id, territoryId) {
            var rendered_events = scheduler._rendered;
            for (var i = 0; i < rendered_events.length; i++) {
                var rendered_event = rendered_events[i];
                if (rendered_event.getAttribute("event_id") == id && rendered_event.children[0].getAttribute("territory_id") == territoryId) {
                    return rendered_event;
                }
            }
        }

        function addDaysToDate(date, days) {
            var msToAdd = 1000 * 60 * 60 * 24 * days;
            return new Date(date.getTime() + msToAdd);
        }

        function setDatesByStartAndMode(start) {
            var end = new Date(start);
            switch (scheduler._mode) {
                case 'ZoomLevel2':
                    end = addDaysToDate(end, 1);
                    break;

                case 'ZoomLevel3':
                    end = addDaysToDate(end, 1);
                    break;

                case 'ZoomLevel4':
                    end = addDaysToDate(end, 2);
                    break;

                case 'ZoomLevel5':
                    end = addDaysToDate(end, 3);
                    break;

                case 'ZoomLevel6':
                    end = addDaysToDate(end, 7);
                    break;

                case 'MonthlyView':
                    end = addDaysToDate(end, 30);
                    break;

                case 'MTDView':
                    end = addDaysToDate(end, 35);
                    break;
            }

            return {
                start: new Date(start),
                end: end };
        }

        function addNotification(title, text, func, p) {

            if (typeof p === 'undefined') p = null;

            butlerNotifications.push({
                title: title,
                text: text,
                action: func,
                when: new Date(),
                unread: true,
                param: p
            });

            var last = butlerNotifications.length - 1;
            //butlerNotifications[last].text = $sce.trustAsHtml(butlerNotifications[last].text);
        };

        // get relevant CSS class for service (by status)
        function getCSSClassForContext(statusOrCategory, statusOrCategoryConst) {

            switch (statusOrCategory) {
                case statusOrCategoryConst.NONE:
                    return 'serviceList_new';

                case statusOrCategoryConst.SCHEDULED:
                    return 'serviceList_assigned';

                case statusOrCategoryConst.DISPATCHED:
                    return 'serviceList_dispatched';

                case statusOrCategoryConst.IN_PROGRESS:
                    return 'serviceList_travel';

                case statusOrCategoryConst.COMPLETED:
                    return 'serviceList_completed';

                case statusOrCategoryConst.COULD_NOT_COMPLETE:
                    return 'serviceList_couldnt_complete';

                case statusOrCategoryConst.CANCELED:
                    return 'serviceList_cancelled';

                default:
                    return 'serviceList_other';
            }
        }

        // set gantt settings from user Settings Manager
        (function setGanttSettingsAndStuff() {

            ganttSettings.startHour = userSettingsManager.GetUserSettingsProperty('Gantt_View_Start_Hour__c');
            if (ganttSettings.startHour == null) ganttSettings.startHour = 0;

            ganttSettings.finishHour = userSettingsManager.GetUserSettingsProperty('Gantt_View_Finish_Hour__c');
            if (ganttSettings.finishHour == null) ganttSettings.finishHour = 24;

            ganttSettings.filterCandidates = userSettingsManager.GetUserSettingsProperty('Filter_Candidates__c');
            if (ganttSettings.filterCandidates == null) ganttSettings.filterCandidates = true;

            ganttSettings.servicesPerPage = userSettingsManager.GetUserSettingsProperty('Services_Per_Page__c');
            if (ganttSettings.servicesPerPage == null) ganttSettings.servicesPerPage = "75";
            ganttSettings.resourceRowHeight = userSettingsManager.GetUserSettingsProperty('Resource_Row_Height__c');
            if (ganttSettings.resourceRowHeight == null) ganttSettings.resourceRowHeight = "medium";

            ganttSettings.capacityDuration = userSettingsManager.GetUserSettingsProperty('View_Capacity_Type__c');
            if (ganttSettings.capacityDuration == null) ganttSettings.capacityDuration = "Day";

            ganttSettings.backHorizon = userSettingsManager.GetUserSettingsProperty('Scheduling_horizon_limit__c');
            if (ganttSettings.backHorizon == null) ganttSettings.backHorizon = 14;

            ganttSettings.loadOnToday = userSettingsManager.GetUserSettingsProperty('Load_On_Today__c');
            if (ganttSettings.loadOnToday == null) ganttSettings.loadOnToday = true;
        })();

        // get custom CSS file and load it
        sfdcService.getCustomizationFiles().then(function (files) {

            if (files && files.CSS) {
                var css = jQuery("<link>");
                css.attr({
                    rel: "stylesheet",
                    type: "text/css",
                    href: files.CSS
                });
                $("head").append(css);
            }

            if (files && files.JS) {
                $.ajax({
                    url: files.JS,
                    dataType: "script"
                });
            }
        });

        function sortByTime(o1, o2) {
            if (o1.start > o2.start) return 1;else if (o1.start.getTime() == o2.start.getTime()) return 0;
            return -1;
        }

        function intersectDates(interval1, interval2) {

            var result = {};
            var remainderFrom1 = [];

            if (interval1.start >= interval2.start && interval1.start < interval2.finish) {
                result.start = interval1.start;

                if (interval1.finish < interval2.finish) {
                    result.finish = interval1.finish;
                } else {
                    result.finish = interval2.finish;
                    remainderFrom1.push({
                        start: interval2.finish,
                        finish: interval1.finish,
                        isStart: false
                    });
                }
            } else if (interval1.finish > interval2.start && interval1.finish <= interval2.finish) {
                if (interval1.start > interval2.start) {
                    result.start = interval1.start;
                } else {
                    result.start = interval2.start;
                    remainderFrom1.push({
                        start: interval1.start,
                        finish: interval2.start,
                        isStart: true
                    });
                }

                result.finish = interval1.finish;
            } else if (interval1.start < interval2.start && interval1.finish > interval2.finish) {
                result = angular.copy(interval2);

                remainderFrom1.push({
                    start: interval1.start,
                    finish: interval2.start,
                    isStart: true
                });

                remainderFrom1.push({
                    start: interval2.finish,
                    finish: interval1.finish,
                    isStart: false
                });
            } else {
                result = null;
            }

            var filteredRemainders = [];

            for (var i = 0; i < remainderFrom1.length; i++) {
                var remainder = remainderFrom1[i];
                if (remainder.start.getTime() != remainder.finish.getTime()) filteredRemainders.push(remainder);
            }

            return {
                intersection: result,
                remainderFrom1: filteredRemainders
            };
        }

        function isEmpty(o) {
            return !Object.keys(o).length;
        }

        function getServiceInfoRowClass(field) {
            if (!field) return;

            var obj = {};

            if (field.Type == fieldsTypes.Reference) obj.resourceOnServiceTT = true;

            return obj;
        }

        function openLink(service, field) {
            if (field.Type != fieldsTypes.Reference) return;

            var fieldName = field.JsAPIName.replace('__r', '__c');
            openSObjectLink(service[fieldName]);
        }

        function openSObjectLink(objectId) {
            var isConsole = openConsoleTab(null, objectId);

            if (!isConsole) window.open('../' + objectId, '_blank');
        }

        // make string trustable as HTML
        function trust(str) {
            if (typeof str == 'string') return $sce.trustAsHtml(str);

            return null;
        }

        // open url in console (if not in console, do nothing)
        function openConsoleTab(e, id) {

            if (StateService.isInConsole()) {

                if (e) e.preventDefault();

                sforce.console.generateConsoleUrl(['/' + id], function (result) {
                    sforce.console.openConsoleUrl(null, result.consoleUrl, true);
                });

                return true;
            }

            return false;
        }

        window.openConsoleTabFromModal = function (url) {
            if (StateService.isInConsole()) {
                sforce.console.generateConsoleUrl([url], function (result) {
                    sforce.console.openConsoleUrl(null, result.consoleUrl, true);
                });
            }
        };

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

        function formatDayToString(date) {
            return date.getDate() + '_' + date.getMonth() + '_' + date.getFullYear();
        }

        function formatDateWithDayOfWeek(date) {
            var options = { weekday: 'short', month: 'long', day: 'numeric', year: 'numeric' };
            var newDate = new Date(date);
            newDate.setHours(12);
            try {
                return newDate.toLocaleDateString(userLocale.replace('_', '-'), options);
            } catch (e) {
                return null;
            }
        }

        function convertDateBetweenTimeZones(dt, sourceTz, destTz) {
            var momentDt = convertDtToMomentDt(dt, sourceTz);

            return convertMomentDtToDt(momentDt.tz(destTz));
        }

        function getUserOffset(dt) {
            return -moment.tz.zone(userTimeZone).offset(convertDtToMomentDt(dt, userTimeZone).valueOf());
        }

        function getLocationOffset(dt, locationId) {
            var location = ResourcesAndTerritoriesService.territories[locationId];
            var tz = ResourcesAndTerritoriesService.operatingHours[location.operatingHours].timezone;
            return -moment.tz.zone(tz).offset(convertDtToMomentDt(dt, tz).valueOf());
        }

        function convertDtToMomentDt(dt, tz) {
            return moment.tz({
                year: dt.getFullYear(),
                month: dt.getMonth(),
                date: dt.getDate(),
                hours: dt.getHours(),
                minutes: dt.getMinutes()

            }, tz);
        }

        function convertMomentDtToDt(dt) {
            return new Date(dt.year(), dt.month(), dt.date(), dt.hours(), dt.minutes());
        }

        function getIdsOfSObjects(arr) {
            var ids = [];
            for (var i = 0; i < arr.length; i++) {
                ids.push(arr[i].id);
            }

            return ids;
        }

        function getIdsOfSObjectsAbsence(arr) {
            var ids = [];
            for (var i = 0; i < arr.length; i++) {
                ids.push(arr[i]);
            }

            return ids;
        }

        function safeApply(scope, fn) {

            var phase = scope.$root.$$phase;

            if (phase == '$apply' || phase == '$digest') {
                if (fn && typeof fn === 'function') {
                    fn();
                }
            } else {
                scope.$apply(fn);
            }
        }

        function getServiceDuration(service) {

            var duration = 0;

            // we need this to the monthly view capacity calculation
            service.resourceBeforeDrag = service.resourceId;
            service.eventBeforeDrag = angular.copy(service);

            // if scheduled
            if (service.isScheduled()) {
                duration = service.finish.getTime() - service.start.getTime();
            } else {

                switch (service.durationType) {

                    case durationTypes.minutes:
                        duration = service.estDuration * 60 * 1000;
                        break;

                    case durationTypes.hours:
                        duration = service.estDuration * 60 * 60 * 1000;
                        break;

                    case durationTypes.days:
                        duration = service.estDuration * 24 * 60 * 60 * 1000;
                        break;

                    default:
                        duration = 60 * 1000;
                        break;
                }
            }

            return duration;
        }

        // get all services related to (used for rule violations! not related services - MST)
        function getRelatedServices(m_ids, resourceIds) {

            var ids = Array.isArray(m_ids) ? m_ids.concat() : [m_ids];

            // get all relevant resourceIds
            // if (!resourceIds)
            // {
            resourceIds += ids.reduce(function (prev, currentId) {

                if (scheduler._events[currentId]) {
                    return prev + ',' + scheduler._events[currentId].resource;
                }

                return prev;
            }, '');
            // }


            for (var key in scheduler._events) {
                var schedulerEvent = scheduler._events[key];

                if (schedulerEvent.type === 'service' && resourceIds.indexOf(schedulerEvent.resource) != -1) {
                    ids.push(schedulerEvent.id);

                    // add related service if available
                    schedulerEvent.relatedTo && ids.push(schedulerEvent.relatedTo);
                    schedulerEvent.relatedFather && ids.push(schedulerEvent.relatedFather);

                    // add closest brother in chain
                    schedulerEvent.relatedService2 && ids.push(schedulerEvent.relatedService2);
                    schedulerEvent.relatedService1 && ids.push(schedulerEvent.relatedService1);
                }
            }

            return ids;
        }

        //ori - not really needed. leaving it here because i like the recursion.
        /*        function getRelatedChainArray(ids, rootService, dependencyField) {
                    if (rootService && rootService[dependencyField] && !ids[rootService[dependencyField]]) {
                        ids[rootService[dependencyField]] = true;
                        return getRelatedChainArray(ids, scheduler._events[rootService[dependencyField]], dependencyField);
                    }
        
                    return Object.keys(ids);
                }*/

        // get services of locations between dates
        function getServicesOfLocations(ids, start, finish) {

            var servicesIds = [];

            ids = Array.isArray(ids) ? ids : [ids];

            // get all relevant resourceIds
            var locationsIds = ids.join(',');

            for (var key in scheduler._events) {
                var schedulerEvent = scheduler._events[key];

                if (schedulerEvent.type === 'service' && locationsIds.indexOf(schedulerEvent.serviceTerritory) && isIntersect(schedulerEvent.start_date, schedulerEvent.end_date, start, finish)) {
                    servicesIds.push(schedulerEvent.id);

                    // add related service if available
                    schedulerEvent.relatedTo && servicesIds.push(schedulerEvent.relatedTo);
                    schedulerEvent.relatedFather && servicesIds.push(schedulerEvent.relatedFather);

                    // add closest brother in chain
                    schedulerEvent.relatedService2 && servicesIds.push(schedulerEvent.relatedService2);
                    schedulerEvent.relatedService1 && servicesIds.push(schedulerEvent.relatedService1);
                }
            }

            return servicesIds;
        }

        // get services between dates
        function getServicesBetweenDates(start, finish) {

            var servicesIds = [];

            for (var key in scheduler._events) {
                var schedulerEvent = scheduler._events[key];

                if (schedulerEvent.type === 'service' && isIntersect(schedulerEvent.start_date, schedulerEvent.end_date, start, finish)) {
                    servicesIds.push(schedulerEvent.id);

                    // add related service if available
                    schedulerEvent.relatedTo && servicesIds.push(schedulerEvent.relatedTo);
                    schedulerEvent.relatedFather && servicesIds.push(schedulerEvent.relatedFather);

                    // add closest brother in chain
                    schedulerEvent.relatedService2 && servicesIds.push(schedulerEvent.relatedService2);
                    schedulerEvent.relatedService1 && servicesIds.push(schedulerEvent.relatedService1);
                }
            }

            return servicesIds;
        }

        function setMapCloseButtonPosition() {
            $timeout(function () {
                // Reference to the DIV which receives the contents of the infowindow using jQuery
                var infoWindowOuter = $('.gm-style-iw');

                // catch the close btn with jQuery
                var infoWindowClose = infoWindowOuter.next();
                infoWindowClose.css({
                    right: '12px', // make it always on the right even when maps are rtl
                    left: '',
                    opacity: 1
                });
            }, 0);
        }

        // get status flow
        sfdcService.getStatusFlow().then(function (flow) {

            if (flow) {
                angular.merge(statusFlow, flow);

                for (var key in statusFlow) {
                    statusFlow[key] = statusFlow[key].sort();
                }
            }
        }).catch(function (err) {
            console.warn('could not get status flow :(');
            console.log(err);
        });

        // get status translations
        sfdcService.getStatusTranslations().then(function (sfSstatusTranslations) {
            angular.merge(statusTranslations, sfSstatusTranslations);
            window.statusTranslations = statusTranslations;
        }).catch(function (err) {
            console.warn('could not get status translations :(');
            console.log(err);
        });

        // get status
        sfdcService.getStatuses().then(function (sFstatuses) {
            angular.merge(statuses, sFstatuses);
        }).catch(function (err) {
            console.warn('could not get status :(');
            console.log(err);
        });

        // get svg icon url
        function getSVGIconHTML(iconName) {
            return '<svg aria-hidden="true" class="slds-icon contextMenuIcon"><use xlink:href="' + iconName + '"></use></svg>';
        }

        // get svg icon url
        function getSVGIconHTMLCustom(iconName) {
            return '<svg aria-hidden="true" class="slds-icon contextMenuIcon"><use width="17px" height="17px" xlink:href="' + iconName + '"></use></svg>';
        }

        function getFilteredLocations() {
            var locations = userSettingsManager.GetUserSettingsProperty('locations');

            if (locations) return locations;

            return [];
        }

        function hoursMinutes(timeInMinutes, labelWithBoth, labelOnlyHours, labelOnlyMinutes) {

            if (timeInMinutes < 60) {
                return labelOnlyMinutes.replaceAll([timeInMinutes]);
            }

            //label should have $1 for minutes and $0 for hours
            var mins = timeInMinutes % 60,
                hours = Math.round(timeInMinutes / 60);

            if (mins === 0) {
                return labelOnlyHours.replaceAll([hours]);
            }

            return labelWithBoth.replace('$0', hours).replace('$1', mins);
        }

        function hasCustomPermission(name) {
            return customPermissions[name];
        }

        function isLightning() {
            return typeof sforce != 'undefined' && sforce && !!sforce.one;
        }

        return {
            getFilteredLocations: getFilteredLocations,
            getSVGIconHTMLCustom: getSVGIconHTMLCustom,
            getSVGIconHTML: getSVGIconHTML,
            getRelatedServices: getRelatedServices,
            getServicesOfLocations: getServicesOfLocations,
            getServicesBetweenDates: getServicesBetweenDates,
            getServiceDuration: getServiceDuration,
            safeApply: safeApply,
            formatDayToString: formatDayToString,
            showOnGantt: showOnGantt,
            openConsoleTab: openConsoleTab,
            trust: trust,
            openLink: openLink,
            openSObjectLink: openSObjectLink,
            getServiceInfoRowClass: getServiceInfoRowClass,
            isEmpty: isEmpty,
            generateResourceId: generateResourceId,
            addNotification: addNotification,
            addDaysToDate: addDaysToDate,
            setDatesByStartAndMode: setDatesByStartAndMode,
            sortByTime: sortByTime,
            getReports: getReports,
            getPolygons: getPolygons,
            intersectDates: intersectDates,
            getCSSClassForContext: getCSSClassForContext,
            fieldsTypes: fieldsTypes,
            ganttSettings: ganttSettings,
            butlerNotifications: butlerNotifications,
            getIdsOfSObjectsAbsence: getIdsOfSObjectsAbsence,
            showServiceList: showServiceList,
            checkBoxFields: function checkBoxFields() {
                return _checkBoxFields;
            },
            woPriorities: woPriorities,
            durationTypes: durationTypes,
            statusFlow: statusFlow,
            statusTranslations: statusTranslations,
            statuses: statuses,
            convertDateBetweenTimeZones: convertDateBetweenTimeZones,
            convertDtToMomentDt: convertDtToMomentDt,
            convertMomentDtToDt: convertMomentDtToDt,
            getUserOffset: getUserOffset,
            getLocationOffset: getLocationOffset,
            setMapCloseButtonPosition: setMapCloseButtonPosition,
            getIdsOfSObjects: getIdsOfSObjects,
            hoursMinutes: hoursMinutes,
            hasCustomPermission: hasCustomPermission,
            formatDateWithDayOfWeek: formatDateWithDayOfWeek,
            isLightning: isLightning,
            crewsFilter: crewsFilter
        };
    }
})();