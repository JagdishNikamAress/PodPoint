'use strict';

(function () {

    angular.module('serviceExpert').factory('servicesService', ['$q', '$rootScope', 'sfdcService', 'utils', 'userSettingsManager', 'monthlyViewHelperService', 'TimePhasedDataService', 'ServiceAppointmentLightboxService', 'kpiCalculationsService', 'bulkResultsService', 'SERVICE_STATUS', 'SERVICE_CATEGORY', 'StateService', 'MstResolver', function ($q, $rootScope, sfdcService, utils, userSettingsManager, monthlyViewHelperService, TimePhasedDataService, ServiceAppointmentLightboxService, kpiCalculationsService, bulkResultsService, SERVICE_STATUS, SERVICE_CATEGORY, StateService, MstResolver) {

        var MAX_SERVICES_TO_CHECK_RULES = 200;
        var MAX_DAYS_TO_CHECK_RULES = 7;

        var horizionEndDate = new Date();
        horizionEndDate.setDate(horizionEndDate.getDate() + 3);

        window.globalStatuses = SERVICE_STATUS;
        window.globalCategories = SERVICE_CATEGORY;

        var servicesService = {
            servicesObjects: {},
            recentlyUsed: {},
            flagged: flaggedServices,
            filteredServices: { servicesArray: [] },
            filter: {
                advancedFilter: {
                    statusCheckboxs: {
                        New: true,
                        Assigned: true,
                        Dispatched: true,
                        Travel: true,
                        'On Site': true,
                        Incomplete: true
                    },

                    selectedDates: {
                        dueDate: true,
                        appEnd: true,
                        end_date: true

                    },

                    minDate: new Date(Date.now() - 7 * 86400000), // day in milisceound 86400000
                    maxDate: new Date(Date.now() + 7 * 86400000),
                    servicePriority: 10,
                    jeopardies: true,
                    violations: true,
                    unScheduled: true
                },

                selectedFiled: {
                    appEnd: true,
                    appStart: true,
                    dueDate: true,
                    earlyStart: true,
                    finish: true,
                    start: true
                },

                selectedFilter: userSettingsManager.GetUserSettingsProperty('Selected_List_View__c') || (customPermissions.Service_List_Todo ? 'Todo' : 'All'),
                orderByField: 'start',
                reverse: false,
                SearchText: '',
                endDate: horizionEndDate,
                currentPage: 1,
                servicesPerPage: 200,
                totalServices: 0,
                totalPages: 1
            }
        };

        // set default services per page, default 200
        if (utils.ganttSettings) {
            servicesService.filter.servicesPerPage = parseInt(utils.ganttSettings.servicesPerPage);
        }

        // check rules - sefel gadol
        servicesService.checkRules = function (servicesIds, maxNumberOfChecks) {

            var deferred = $q.defer(),
                violatingKeys = [],
                promises = [],
                serviceIdsBySlice = [],
                numOfSlices = 1,
                servicesCount = 0,
                minServiceStartDate = undefined,
                servicesToSendAgain = [],
                servicesIdsBySliceMap = {};

            if (Array.isArray(servicesIds) && servicesIds.length === 0) {
                deferred.resolve([]);
                return deferred.promise;
            }

            // sort by start
            servicesIds.sort(function (id1, id2) {

                if (!TimePhasedDataService.serviceAppointments()[id1] && !TimePhasedDataService.serviceAppointments()[id2]) {
                    return 0;
                }

                if (!TimePhasedDataService.serviceAppointments()[id1] && TimePhasedDataService.serviceAppointments()[id2]) {
                    return -1;
                }

                if (TimePhasedDataService.serviceAppointments()[id1] && !TimePhasedDataService.serviceAppointments()[id2]) {
                    return 1;
                }

                if (TimePhasedDataService.serviceAppointments()[id1].start == TimePhasedDataService.serviceAppointments()[id2].start) {
                    return 0;
                }

                if (TimePhasedDataService.serviceAppointments()[id1].start > TimePhasedDataService.serviceAppointments()[id2].start) {
                    return 1;
                }

                return -1;
            });

            var clonedServicesIds = servicesIds.slice(0);

            while (clonedServicesIds.length > 0) {
                servicesCount = 0, minServiceStartDate = null;
                servicesIdsBySliceMap[numOfSlices - 1] = {};

                for (var i = 0; i < clonedServicesIds.length; i++) {
                    servicesIdsBySliceMap[numOfSlices - 1][clonedServicesIds[i]] = true;

                    if (!TimePhasedDataService.serviceAppointments()[clonedServicesIds[i]] || !TimePhasedDataService.serviceAppointments()[clonedServicesIds[i]].start) {
                        servicesCount++;
                        continue;
                    }

                    //get min date for each chunk (array is sorted)
                    if (!minServiceStartDate) minServiceStartDate = moment(TimePhasedDataService.serviceAppointments()[clonedServicesIds[i]].start);

                    var current = moment(TimePhasedDataService.serviceAppointments()[clonedServicesIds[i]].start);

                    //check for date diff and max chunk size
                    if (current.diff(minServiceStartDate, 'days') <= MAX_DAYS_TO_CHECK_RULES && servicesCount < MAX_SERVICES_TO_CHECK_RULES) {
                        servicesCount++;
                    } else {
                        break;
                    }
                }

                // cut services ids to chunks 
                serviceIdsBySlice.push(clonedServicesIds.splice(0, servicesCount));

                // create new promise
                promises.push($q.defer());
                numOfSlices++;

                // check rules for each chunk
                promises[promises.length - 1].promise.then(function (index) {

                    sfdcService.checkRules(serviceIdsBySlice[index], StateService.selectedPolicyId).then(function (violations) {

                        for (var key in violations) {

                            delete servicesIdsBySliceMap[index][key];

                            if (violations[key].length > 0) {

                                if (!TimePhasedDataService.serviceAppointments()[key]) {
                                    continue;
                                }

                                TimePhasedDataService.serviceAppointments()[key].violations = violations[key];
                                violatingKeys.push(key);
                            } else if (TimePhasedDataService.serviceAppointments()[key]) {
                                TimePhasedDataService.serviceAppointments()[key].violations = null;
                            }
                        }

                        // these are the services that werent checked because of almost reaching max cpu - need to send again to validate
                        for (var id in servicesIdsBySliceMap[index]) {
                            if (id != 'undefined' && TimePhasedDataService.serviceAppointments()[id] && TimePhasedDataService.serviceAppointments()[id].resourceId) servicesToSendAgain.push(id);
                        }

                        if (promises[index + 1]) {
                            promises[index + 1].resolve(index + 1);
                        } else {
                            kpiCalculationsService.calculateKpis();
                            deferred.resolve(violatingKeys);

                            if (servicesToSendAgain.length > 0) {
                                if (debugMode) console.log('Calling check rules again on ' + servicesToSendAgain.length + ' services');

                                if (!maxNumberOfChecks) maxNumberOfChecks = 10;else maxNumberOfChecks--;

                                servicesService.checkRules(servicesToSendAgain, maxNumberOfChecks).then(function () {
                                    scheduler.updateView();
                                });
                            }
                        }
                    }).catch(function (err) {
                        utils.addNotification(customLabels.Rule_validation_failed, err.message);
                        deferred.reject(err);
                        console.warn('rule checking failed');
                        console.log(err);
                    });
                });
            }

            promises[0].resolve(0);

            return deferred.promise;
        };

        // post to chatter
        servicesService.postToChatter = function (servicesIdsArray, sayWhat) {

            var deferred = $q.defer();

            sfdcService.postToChatter(servicesIdsArray, sayWhat).then(function (numOfMentions) {
                deferred.resolve(numOfMentions);
            });

            return deferred.promise;
        };

        servicesService.sortServicesByPriority = function (servicesIds) {
            var deferred = $q.defer();

            sfdcService.sortServicesByPriority(servicesIds).then(function (sortedIds) {
                deferred.resolve(sortedIds);
            });

            return deferred.promise;
        };

        servicesService.autoScheduleService = function (serviceId) {

            var deffered = $q.defer();

            if (window.userHasAdminPermissions == undefined) {
                sfdcService.userHasAdminPermissions().then(function (res) {
                    window.userHasAdminPermissions = res;
                });
            }

            // this for FSL-978 (catch part)
            sfdcService.autoScheduleService(serviceId, StateService.selectedPolicyId).then(function (updatedObjects) {

                if (updatedObjects.schedulingResult && Array.isArray(updatedObjects.schedulingResult) && updatedObjects.schedulingResult[0]) {
                    var partialResults = updatedObjects.schedulingResult[0].PartialResults || [],
                        message = '';

                    if (window.userHasAdminPermissions) {
                        partialResults.forEach(function (p) {
                            message += customLabels.partialResults[p.Operation].replaceAll(p.Processed, p.Total) + '<br/>';
                        });
                    } else {
                        message += customLabels.ContactSysAdmin;
                    }

                    if (message !== '') {
                        utils.addNotification(customLabels.NotAllResult.replace('$0', updatedObjects.schedulingResult[0].Service.AppointmentNumber), message);
                    }
                }

                // MST scheduling
                if (updatedObjects.schedulingResult && Array.isArray(updatedObjects.schedulingResult) && updatedObjects.schedulingResult[0] && updatedObjects.schedulingResult[0].LongOperationId) {
                    //console.log('Called schedule. Got fsl op id: ' + updatedObjects.schedulingResult[0].LongOperationId);
                    MstResolver.getUpdates(updatedObjects.schedulingResult[0].LongOperationId).then(function (result) {
                        //console.log('Got scheduling result to servicesService.');
                        parseUpdates(result, deffered, serviceId);
                    }).catch(function (ex) {
                        console.error(ex);
                        //return $q.reject({ eventType: 'exception', message: ex });
                        deffered.reject({ eventType: 'exception', message: ex });
                    });
                    return;
                }

                // regular scheduling
                parseUpdates(updatedObjects, deffered, serviceId);
            }).catch(function (err) {
                console.log(err);
                deffered.reject(err);
            });

            return deffered.promise;
        };

        function parseUpdates(updatedObjects, deffered, serviceId) {
            var parsedUpdatedObjects = {};

            if (updatedObjects.schedulingResult && Array.isArray(updatedObjects.schedulingResult) && updatedObjects.schedulingResult[0]) {
                parsedUpdatedObjects.partialResults = updatedObjects.schedulingResult[0].PartialResults || [];
            }

            parsedUpdatedObjects.absences = TimePhasedDataService.updateTimePhaseData(updatedObjects.na, 'na').absences;
            parsedUpdatedObjects.services = TimePhasedDataService.updateTimePhaseData(updatedObjects.services, 'service').services;

            deffered.resolve(parsedUpdatedObjects);

            servicesService.checkRules(utils.getRelatedServices(serviceId)).then(function () {
                return scheduler.updateView();
            });
        }

        // ************************************************************************************************************
        // ************************************************************************************************************
        // *********************************** NEW STUFF FOR NEW DATA MODEL STUFF *************************************
        // ************************************************************************************************************
        // ************************************************************************************************************


        // saving changes to service appiontment and returns the updated object or the original one if there was an error
        servicesService.saveChangesToServiceAppointment = function (originalService, changedService) {

            var deffered = $q.defer(),
                start = new Date(changedService.start_date.getTime() + changedService.travelTo * 1000),
                end = new Date(changedService.end_date.getTime() - changedService.travelFrom * 1000);

            if (useLocationTimezone) {
                //get territory offset by SRST
                var resourceTerritoryOffset = TimePhasedDataService.getIntersectingSrstOffset(changedService, changedService.getGanttResource());

                //set times accordingly

                var userStartOffset = utils.getUserOffset(start),
                    userEndOffset = utils.getUserOffset(end);

                start.setMinutes(start.getMinutes() + userStartOffset - resourceTerritoryOffset);
                end.setMinutes(end.getMinutes() + userEndOffset - resourceTerritoryOffset);
            }

            servicesService.recentlyUsed[originalService.id] = true;

            if (changedService.snapToId) {
                changedService.ServiceAppointmentLastModifiedDate--;
            }

            // check the service we need to calculate travel to
            var calcTravelToLatitude = null,
                calcTravelToLongitude = null;

            if (changedService.snapToId) {

                var resourceServices = [],
                    maxDate = scheduler._events[changedService.snapToId].end || scheduler._events[changedService.snapToId].finish;

                for (var id in scheduler._events) {

                    if (id === changedService.id) {
                        continue;
                    }

                    var ev = scheduler._events[id];

                    if (ev.resourceId === changedService.resourceId && ev.type !== 'break' && ev.latitude && isIntersect(ev.start_date, ev.end_date, scheduler._min_date, maxDate)) {
                        resourceServices.push(id);
                    }
                }

                resourceServices.sort(function (a, b) {

                    // sort by times
                    if (scheduler._events[a].start > scheduler._events[b].start) {
                        return -1;
                    } else if (scheduler._events[a].start < scheduler._events[b].start) {
                        return 1;
                    } else {
                        return 0;
                    }
                });

                if (resourceServices.length > 0) {
                    calcTravelToLatitude = scheduler._events[resourceServices[0]].latitude;
                    calcTravelToLongitude = scheduler._events[resourceServices[0]].longitude;
                }
            }

            sfdcService.saveChangesToServiceAppointment(changedService.id, changedService.getGanttResource(showSecondarySTMs), changedService.assignedResource, start, end, StateService.selectedPolicyId, changedService.scheduleMode, changedService.snapToId || null, changedService.snapToType || null, changedService.snapDirection || null, calcTravelToLatitude, calcTravelToLongitude).then(function (updatedObjects) {

                var parsedUpdatedObjects = {};

                parsedUpdatedObjects.absences = TimePhasedDataService.updateTimePhaseData(updatedObjects.resourceAbsences, 'na').absences;
                parsedUpdatedObjects.services = TimePhasedDataService.updateTimePhaseData(updatedObjects.services, 'service').services;

                if (updatedObjects.ValidationError) {
                    deffered.reject(['', originalService, updatedObjects.ValidationError]);
                }

                deffered.resolve(parsedUpdatedObjects);

                var resourcesStr = '';

                if (originalService.resourceId) resourcesStr = originalService.resourceId + ',';
                if (changedService.resourceId) resourcesStr = resourcesStr + changedService.resourceId;

                servicesService.checkRules(utils.getRelatedServices(changedService.id, resourcesStr)).then(function () {
                    return scheduler.updateView();
                });
            }).catch(function (err) {
                deffered.reject([err, originalService, '']);
                console.warn(err);
            });

            return deffered.promise;
        };

        // handle snapping
        servicesService.handleSnap = function (ev, e) {
            var isUnscheduled = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : false;

            // snap top
            if (e.ctrlKey) {

                var intersectingEvents = [];

                // get all intersecting objects
                for (var id in scheduler._events) {

                    var currentEvent = scheduler._events[id];

                    // only SA and NAs
                    if (currentEvent.type !== 'service' && currentEvent.type !== 'na') {
                        continue;
                    }

                    // not same obj or different resource
                    if (currentEvent.id === ev.id || ev.resourceId && currentEvent.resourceId.indexOf(ev.resourceId) === -1) {
                        continue;
                    }

                    if (isIntersect(currentEvent.start_date, currentEvent.end_date, ev.start_date, ev.end_date)) {
                        intersectingEvents.push(currentEvent);
                    }
                }

                intersectingEvents.sort(function (a, b) {
                    if (a.start > b.start) {
                        return 1;
                    }
                    if (a.start < b.start) {
                        return -1;
                    }
                    return 0;
                });

                var minimumLength = isUnscheduled ? 1 : 0;

                if (intersectingEvents.length > minimumLength) {

                    var startOfDragged = new Date(ev.start_date);

                    if (ev.travelTo) {
                        startOfDragged = startOfDragged.setSeconds(startOfDragged.getSeconds() + ev.travelTo);
                    }

                    var direction = 'right',
                        chooseIndex = intersectingEvents[0].isDummy ? 1 : 0;

                    if (startOfDragged < intersectingEvents[chooseIndex].start) {
                        direction = 'left';
                    }

                    var chooseI = 0;
                    if (intersectingEvents[0].isDummy) {
                        chooseI = 1;
                    }

                    if (intersectingEvents[chooseI]) {
                        ev.snapToId = intersectingEvents[chooseI].id;
                        ev.snapToType = intersectingEvents[chooseI].type;
                        ev.snapDirection = direction;
                    } else {
                        ev.snapToId = null;
                        ev.snapToType = null;
                        ev.snapDirection = null;
                    }
                } else {
                    ev.snapToId = null;
                    ev.snapToType = null;
                    ev.snapDirection = null;
                }
            }
        };

        // unschedule services by ids or locations (if ids are locations, specify start & finish)
        servicesService.unscheduleServices = function (ids, start, finish) {

            var deferred = $q.defer(),
                functionToUnschedule = finish ? sfdcService.unscheduleServicesByLocationsId : sfdcService.unscheduleServicesByServicesId,
                servicesToCheckRules = null;

            // unscheduling by ids, need to get related now
            if (!finish) {
                servicesToCheckRules = utils.getRelatedServices(ids);
            }

            // Salesforce remote action
            functionToUnschedule(ids, start, finish).then(function (unscheduleResult) {

                var parsedUpdatedObjects = {};

                // check if there is nothing to schedule
                if (unscheduleResult.nothingToUnschedule) {
                    deferred.resolve(unscheduleResult);
                    return;
                }

                var fslOpPromise = $q.defer();

                // check if big bulk of services
                if (unscheduleResult.fslOperation) {

                    MstResolver.getUpdates(unscheduleResult.fslOperation).then(function (fslOpResults) {

                        console.log(fslOpResults);
                        var servicesIdsToFetch = fslOpResults.fslOperation.result.services;

                        sfdcService.getServicesById(servicesIdsToFetch).then(function (fetchedServcices) {
                            TimePhasedDataService.updateTimePhaseData(fetchedServcices, 'service').services;

                            fslOpPromise.resolve({
                                services: fetchedServcices,
                                resourceAbsences: [],
                                resourceCapacities: [],
                                failedResults: fslOpResults.fslOperation.result.failedResults
                            });
                        });
                    }).catch(function (ex) {
                        fslOpPromise.reject(ex);
                    });
                } else {
                    fslOpPromise.resolve(unscheduleResult);
                }

                fslOpPromise.promise.then(function (unscheduleResult) {

                    // parse reply
                    parsedUpdatedObjects.absences = TimePhasedDataService.updateTimePhaseData(unscheduleResult.resourceAbsences, 'na', true).absences;
                    parsedUpdatedObjects.services = TimePhasedDataService.updateTimePhaseData(unscheduleResult.services, 'service', true).services;
                    parsedUpdatedObjects.capacities = TimePhasedDataService.updateTimePhaseData(unscheduleResult.resourceCapacities, 'capacity').capacities;
                    parsedUpdatedObjects.failedResults = unscheduleResult.failedResults;

                    // check rules (if ids)
                    !finish && servicesService.checkRules(servicesToCheckRules).then(function () {
                        return scheduler.updateView();
                    });

                    // check rules (if locations)
                    finish && servicesService.checkRules(utils.getServicesOfLocations(ids, start, finish)).then(function () {
                        return scheduler.updateView();
                    });

                    var title = void 0,
                        message = void 0;

                    // add notification (only 1 service was unscheduled)
                    if (ids.length === 1 && !finish) {

                        var name = TimePhasedDataService.serviceAppointments()[ids[0]].name;

                        if (!TimePhasedDataService.serviceAppointments()[ids[0]].isScheduled()) {
                            title = customLabels.was_unscheduled.replaceAll(name);
                            message = customLabels.was_unscheduled_successfully.replaceAll(name);
                        } else {
                            title = customLabels.Couldnt_unschedule.replaceAll(name);
                            message = customLabels.Couldnt_unschedule.replaceAll(name) + '. ' + unscheduleResult.failedResults[ids[0]].errorMessage;
                        }

                        utils.addNotification(title, message, function () {
                            servicesService.recentlyUsed[ids[0]] = true;
                            ServiceAppointmentLightboxService.open(ids[0]);
                        });
                    }

                    // multiple services were unscheduled
                    else {

                            var unscheduledIds = [],
                                stillScheduledIds = [];

                            // by location: check what was scheduled and what wasn't
                            if (finish) {

                                unscheduleResult.services.forEach(function (service) {
                                    if (unscheduleResult.failedResults[service.Id] && TimePhasedDataService.serviceAppointments()[service.Id].isScheduled()) {
                                        stillScheduledIds.push(service.Id);
                                    } else {
                                        unscheduledIds.push(service.Id);
                                    }
                                });
                            }

                            // by ids
                            else {

                                    ids.forEach(function (id) {
                                        if (TimePhasedDataService.serviceAppointments()[id].isScheduled()) {
                                            stillScheduledIds.push(id);
                                        } else {
                                            unscheduledIds.push(id);
                                        }
                                    });
                                }

                            title = customLabels.x_services_were_unscheduled.replaceAll(unscheduledIds.length);

                            // by ids
                            if (!finish) {
                                message = customLabels.x_services_were_unscheduled_out_of_y.replaceAll(unscheduledIds.length, unscheduledIds.length, ids.length);
                            }
                            // by locations
                            else {
                                    message = customLabels.x_services_were_unscheduled_out_of_y.replaceAll(unscheduledIds.length, unscheduledIds.length, stillScheduledIds.length + unscheduledIds.length);
                                }

                            // if some services failed to unschedule
                            if (stillScheduledIds.length > 0) {
                                var failedTooltip = stillScheduledIds.map(function (id) {
                                    return TimePhasedDataService.serviceAppointments()[id].name;
                                }).join(', ');
                                message += '<div title=\'' + failedTooltip + '\' class=\'dashedBorder\' style=\'display:inline-block;\'> ' + customLabels.failed_to_unschedule.replaceAll(stillScheduledIds.length) + '. ' + customLabels.View_services + '</div>';
                            }

                            var butlerUnscheduleResult = angular.copy(unscheduleResult),
                                newUnscheduledServices = [];
                            butlerUnscheduleResult.services.forEach(function (obj) {

                                if (!finish) {
                                    for (var i = 0; i < ids.length; i++) {
                                        if (obj.Id === ids[i]) {
                                            newUnscheduledServices.push(obj);
                                        }
                                    }
                                }

                                // by location
                                else {
                                        if (!obj.Fields.SchedStartTime) {
                                            newUnscheduledServices.push(obj);
                                        }
                                    }
                            });

                            butlerUnscheduleResult.services = newUnscheduledServices;

                            // add notification
                            utils.addNotification(title, message, function () {
                                var labelsForResults = { success: customLabels.SuccessfullyUnscheduled, fail: customLabels.FailToUnschedule };
                                bulkResultsService.open(butlerUnscheduleResult, labelsForResults);
                            });
                        }

                    deferred.resolve(parsedUpdatedObjects);
                });
            }).catch(function (err) {
                deferred.reject(err);
                console.warn(err);
            });

            return deferred.promise;
        };

        servicesService.drawServicesAndAbsences = function (services, absences) {
            var deletedIds = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : [];
            var capacities = arguments[3];


            var mergedGanttObjects = void 0,
                servicesMap = {},
                absencesMap = {},
                capacitiesMap = {},
                returnObject = {
                scheduledServices: [],
                unscheduledServices: [],
                deletedIds: deletedIds
            };

            // make a map if services/absences/capacities is array
            if (Array.isArray(services)) {
                services.forEach(function (ganttEvent) {
                    return servicesMap[ganttEvent.id] = ganttEvent;
                });
            } else {
                servicesMap = services;
            }

            if (Array.isArray(absences)) {
                absences.forEach(function (ganttEvent) {
                    return absencesMap[ganttEvent.id] = ganttEvent;
                });
            } else {
                absencesMap = absences;
            }

            if (Array.isArray(capacities)) {
                capacities.forEach(function (ganttEvent) {
                    return capacitiesMap[ganttEvent.id] = ganttEvent;
                });
            } else {
                capacitiesMap = capacities;
            }

            mergedGanttObjects = angular.extend({}, servicesMap, absencesMap, capacitiesMap);

            // set gantt resourceId based on timephase objects
            for (var id in mergedGanttObjects) {

                var ganttEvent = mergedGanttObjects[id];

                if (setObjectOnGantt(ganttEvent)) {
                    returnObject.scheduledServices.push(ganttEvent);
                } else {
                    returnObject.unscheduledServices.push(ganttEvent);
                }
            }

            // delete if needed
            deletedIds.forEach(function (id) {
                return delete scheduler._events[id];
            });

            // draw
            if (returnObject.scheduledServices.length > 0) {
                scheduler.parse(returnObject.scheduledServices, 'json');
            } else {
                scheduler.updateView();
            }

            return returnObject;
        };

        // updates object to display on gantt. returns false if unscheduled and true if scheduled
        function setObjectOnGantt(ganttObject) {

            // check if scheduled (must be a service... absences must have a resource)
            if (!ganttObject.isScheduled()) {

                // service got unscheduled
                if (scheduler._events[ganttObject.id]) {
                    delete scheduler._events[ganttObject.id];
                }

                return false;
            }

            // set the GANTT resource id based on timephase
            ganttObject.setGanttResource(TimePhasedDataService.resourcesAndTerritories(), utils.generateResourceId);

            return true;
        }

        // change the dispatch status to dispatched or canceled
        servicesService.changeStatus = function (ids, status, start, finish) {

            var deferred = $q.defer(),
                functionToChangeStatus = finish ? sfdcService.changeStatusServicesByLocationsId : sfdcService.changeStatusServicesByServicesId;

            functionToChangeStatus(ids, status, start, finish).then(function (changeStatusResult) {

                var parsedUpdatedObjects = {};

                // check if there is nothing to schedule
                if (changeStatusResult.nothingToDispatch) {
                    deferred.resolve(changeStatusResult);
                    return;
                }

                // parse reply
                parsedUpdatedObjects.services = TimePhasedDataService.updateTimePhaseData(changeStatusResult.services, 'service').services;
                parsedUpdatedObjects.failedResults = changeStatusResult.failedResults;

                var title = void 0,
                    message = void 0;

                // add notification (only 1 service was dispatched)
                if (ids.length === 1 && !finish) {

                    var name = TimePhasedDataService.serviceAppointments()[ids[0]].name;

                    if (TimePhasedDataService.serviceAppointments()[ids[0]].status !== status) {
                        title = customLabels.could_not_change_title.replaceAll(name);

                        if (changeStatusResult.failedResults && Array.isArray(changeStatusResult.failedResults) && changeStatusResult.failedResults.length > 0) {
                            message = customLabels.could_not_change_status.replaceAll(name, utils.statusTranslations[status], changeStatusResult.failedResults[ids[0]].errorMessage);
                        } else {
                            message = customLabels.could_not_change_status.replaceAll(name, utils.statusTranslations[status], '');
                        }

                        utils.addNotification(title, message, function () {
                            ServiceAppointmentLightboxService.open(ids[0]);
                        });
                    }

                    servicesService.recentlyUsed[ids[0]] = true;
                }

                // multiple services were dispatched
                else {

                        var notDispatchedIds = [],
                            gotDispatchedIds = [];

                        // by location: check what was changed and what wasn't
                        if (finish) {

                            changeStatusResult.services.forEach(function (service) {
                                if (TimePhasedDataService.serviceAppointments()[service.Id].status !== status) {
                                    notDispatchedIds.push(service.Id);
                                } else {
                                    gotDispatchedIds.push(service.Id);
                                }
                            });
                        }

                        // by ids
                        else {

                                ids.forEach(function (id) {
                                    if (TimePhasedDataService.serviceAppointments()[id].status === status) {
                                        gotDispatchedIds.push(id);
                                    } else {
                                        notDispatchedIds.push(id);
                                    }
                                });
                            }

                        title = customLabels.x_services_were_changed.replaceAll(gotDispatchedIds.length, utils.statusTranslations[status] || status);
                        message = customLabels.x_services_were_changed_out_of_y.replaceAll(gotDispatchedIds.length, gotDispatchedIds.length, gotDispatchedIds.length + notDispatchedIds.length, utils.statusTranslations[status] || status);

                        // if some services failed
                        if (notDispatchedIds.length > 0) {
                            var failedTooltip = notDispatchedIds.map(function (id) {
                                return TimePhasedDataService.serviceAppointments()[id].name;
                            }).join(', '),
                                failedLabel = customLabels.failed_to_change_status.replaceAll(notDispatchedIds.length);

                            message += '<div title=\'' + failedTooltip + '\' class=\'dashedBorder\' style=\'display:inline-block;\'> ' + failedLabel + '. ' + customLabels.View_services + '</div>';
                        }

                        // add notification
                        utils.addNotification(title, message, function () {
                            var labelsForResults = { success: customLabels.SuccessfullyDispatched, fail: customLabels.FailToDispatch };
                            bulkResultsService.open(changeStatusResult, labelsForResults);
                        });
                    }

                deferred.resolve(parsedUpdatedObjects);
            }).catch(function (err) {
                deferred.reject(err);
                console.warn(err);
            });

            return deferred.promise;
        };

        // change pin
        servicesService.changePin = function (ids, newPin) {

            var deferred = $q.defer();

            sfdcService.changePin(ids, newPin).then(function (pinnedServices) {
                var pinnedField = fieldNames.Service_Appointment.pinned;
                pinnedServices.forEach(function (service) {
                    return TimePhasedDataService.serviceAppointments()[service.Id].pinned = service[pinnedField];
                });
                deferred.resolve();
            }).catch(function (err) {
                deferred.reject(err);
                console.warn(err);
            });

            return deferred.promise;
        };

        // set service appointments as in jeopardy
        servicesService.setInJeopardy = function (ids) {

            var deferred = $q.defer();

            sfdcService.setServiceAppointmentsInJeopardy(ids).then(function (jeopardyServices) {
                jeopardyServices.forEach(function (service) {
                    return TimePhasedDataService.serviceAppointments()[service.Id].jeopardy = service[fieldNames.Service_Appointment.InJeopardy__c];
                });

                // add notification
                utils.addNotification('In Jeopardy Service Appointments', jeopardyServices.length + ' service appointments were marked as in jeopardy');
                deferred.resolve();
            }).catch(function (err) {
                deferred.reject(err);
                console.warn(err);
            });

            return deferred.promise;
        };

        return servicesService;
    }]);
})();