'use strict';

(function () {
	angular.module('serviceExpert').factory('calendarsService', ['ResourcesAndTerritoriesService', 'TimePhasedDataService', '$rootScope', 'utils', function (ResourcesAndTerritoriesService, TimePhasedDataService, $rootScope, utils) {

		var cachedDates = {};
		var relocationsOnGantt = {};
		var resourceToWorkingDates = {};

		$rootScope.$on('gotNewTimePhasedObjects', function (ev, timePhasedObjects) {
			drawOperatingHours(timePhasedObjects.start, timePhasedObjects.finish, timePhasedObjects.resourceToServiceCrewMembers);
		});

		function reset() {
			cachedDates = {};
			relocationsOnGantt = {};
			resourceToWorkingDates = {};

			serviceObject.resourceToWorkingDates = resourceToWorkingDates;
		}

		function drawOperatingHours(start, finish, resourceToServiceCrewMembers) {
			var currDay = new Date(start);
			var resourceLocationData = null;
			var resourceLocationDataWithSecondaries = null;

			while (currDay < finish) {
				var formatedDate = utils.formatDayToString(currDay);

				if (!cachedDates[formatedDate]) {
					cachedDates[formatedDate] = true;
					if (!resourceLocationData) resourceLocationData = buildResourceToLocationsToTimePhased(TimePhasedDataService.resourcesAndTerritories());

					var currFinish = new Date(currDay);
					currFinish.setDate(currFinish.getDate() + 1);

					for (var resourceId in ResourcesAndTerritoriesService.getResources()) {
						drawResourceOperatingHours(new Date(currDay), new Date(currFinish), resourceId, resourceLocationData[resourceId]);
					}
				}

				currDay.setDate(currDay.getDate() + 1);
			}
		}

		function drawResourceOperatingHours(start, finish, resourceId, resourceLocationData, isSecondary) {
			var primariesAndRelocations = { 'P': [], 'R': [], 'S': [] },
			    secondaryIds = {},
			    secondaryWithNoOperatingIds = {};

			for (var resourceLocation in resourceLocationData) {
				var resourceTimeData = resourceLocationData[resourceLocation].slice();
				var sectionId = utils.generateResourceId(resourceId, resourceLocation);
				var currLocationStart = start;

				// make service click. software.
				for (var i = 0; i < resourceTimeData.length; i++) {
					var timePhasedLocation = resourceTimeData[i];
					var timePhasedLocationAndDayIntersection = utils.intersectDates({ start: currLocationStart, finish: finish }, timePhasedLocation);

					primariesAndRelocations[timePhasedLocation.type].push(timePhasedLocation);

					if (timePhasedLocation.type == 'S') {
						secondaryIds[timePhasedLocation.serviceTerritory] = timePhasedLocation;
						continue;

						// this code will continue
					}

					if (timePhasedLocationAndDayIntersection.intersection) {
						for (var j = 0; j < timePhasedLocationAndDayIntersection.remainderFrom1.length; j++) {
							var remainder = timePhasedLocationAndDayIntersection.remainderFrom1[j];

							if (remainder.isStart) {
								// programmed by click software engineer
								addMarkedTimeSpan(remainder.start, remainder.finish, sectionId);
							}
						}

						if (timePhasedLocation.type == 'R' && !relocationsOnGantt[timePhasedLocation.id] && !isSecondary) {
							addRelocation(timePhasedLocation, resourceLocationData, resourceId);
						}

						currLocationStart = timePhasedLocationAndDayIntersection.intersection.finish;
					} else continue;

					// this code by clicksoftware ince
					var calendarId = timePhasedLocation.operatingHours || ResourcesAndTerritoriesService.allTerritories[resourceLocation].operatingHours;

					if (calendarId) drawByCalendarAndTime(timePhasedLocationAndDayIntersection.intersection.start, timePhasedLocationAndDayIntersection.intersection.finish, calendarId, sectionId, isSecondary);else addMarkedTimeSpan(timePhasedLocationAndDayIntersection.intersection.start, timePhasedLocationAndDayIntersection.intersection.finish, sectionId);
				}

				if (currLocationStart.getTime() != finish.getTime() && !secondaryIds[sectionId.split('_')[1]]) {
					addMarkedTimeSpan(currLocationStart, finish, sectionId);
				}
			}

			// clicksoftware rox
			if (showSecondarySTMs && !utils.isEmpty(secondaryIds) && !isSecondary) {
				var secondStmList = findIntersectionsForPsAndRs(primariesAndRelocations, resourceId, secondaryIds);

				var secondaryLocationData = buildResourceToLocationsToTimePhased(secondStmList);

				drawSecondariesOperatingHours(start, finish, resourceId, secondaryLocationData[resourceId], true);
			}
		}

		function findIntersectionsForPsAndRs(primariesAndRelocations, resourceId, secondaryIds) {
			var secondStmList = {};
			secondStmList[resourceId] = {};

			// find intersections with relocations
			for (var i = 0; i < primariesAndRelocations['P'].length; i++) {
				var primary = primariesAndRelocations['P'][i];

				if (primariesAndRelocations['R'].length == 0) {
					secondStmList[resourceId][primary.id] = primary;
					continue;
				}

				for (var j = 0; j < primariesAndRelocations['R'].length; j++) {
					var reloc = primariesAndRelocations['R'][j];

					var intersection = utils.intersectDates(primary, reloc);

					//no intersection? - add primary
					if (!intersection.intersection) {
						secondStmList[resourceId][primary.id] = primary;
					}

					//has remainder? set primary's start and finish according to remainders.
					if (intersection.remainderFrom1.length > 0) {
						for (var inter = 0; inter < intersection.remainderFrom1.length; inter++) {
							var primaryClone = angular.copy(primary);
							primaryClone.start = intersection.remainderFrom1[inter].start;
							primaryClone.finish = intersection.remainderFrom1[inter].finish;

							secondStmList[resourceId][primary.id + '_' + inter] = primaryClone;
						}
					}

					if (!secondStmList[resourceId][reloc.id]) {
						var relocationClone = angular.copy(reloc);
						relocationClone.serviceTerritory = primary.serviceTerritory;
						secondStmList[resourceId][relocationClone.id] = relocationClone;
					}
				}
			}
			// this is some ugly code.

			//iterate on all created primaries and set start and finish according to the secondary
			var thirdStmList = {};
			thirdStmList[resourceId] = {};
			for (var _i = 0; _i < primariesAndRelocations['S'].length; _i++) {
				var currentSecondary = primariesAndRelocations['S'][_i];

				for (var sKey in secondStmList[resourceId]) {
					var currentP = secondStmList[resourceId][sKey];
					var _intersection = utils.intersectDates(currentP, currentSecondary);

					if (_intersection.intersection) {
						var _primaryClone = angular.copy(currentP);
						_primaryClone.start = _intersection.intersection.start;
						_primaryClone.finish = _intersection.intersection.finish;

						//if respect secondary stm on gantt and sec has OH - 
						if (window.isShowSecondaryOperatingHours && currentSecondary.operatingHours) _primaryClone.operatingHours = currentSecondary.operatingHours;

						_primaryClone.ohTerr = _primaryClone.serviceTerritory;
						_primaryClone.serviceTerritory = currentSecondary.serviceTerritory;

						thirdStmList[resourceId][sKey + '_' + _i] = _primaryClone;
					}
				}
			}

			return thirdStmList;
		}

		function drawSecondariesOperatingHours(start, finish, resourceId, resourceLocationData, isSecondary) {
			for (var resourceLocation in resourceLocationData) {
				var resourceTimeData = resourceLocationData[resourceLocation].slice();
				var sectionId = utils.generateResourceId(resourceId, resourceLocation);
				var currLocationStart = start;

				// make service click. software.
				for (var i = 0; i < resourceTimeData.length; i++) {
					var timePhasedLocation = resourceTimeData[i];
					var timePhasedLocationAndDayIntersection = utils.intersectDates({ start: currLocationStart, finish: finish }, timePhasedLocation);

					if (timePhasedLocationAndDayIntersection.intersection) {
						for (var j = 0; j < timePhasedLocationAndDayIntersection.remainderFrom1.length; j++) {
							var remainder = timePhasedLocationAndDayIntersection.remainderFrom1[j];

							if (remainder.isStart) {
								addMarkedTimeSpan(remainder.start, remainder.finish, sectionId);
							}
						}

						currLocationStart = timePhasedLocationAndDayIntersection.intersection.finish;
					} else continue;

					// take operating hours from STM, fallback to territory
					var calendarId = timePhasedLocation.operatingHours || ResourcesAndTerritoriesService.allTerritories[timePhasedLocation.ohTerr].operatingHours;

					if (calendarId) drawByCalendarAndTime(timePhasedLocationAndDayIntersection.intersection.start, timePhasedLocationAndDayIntersection.intersection.finish, calendarId, sectionId, isSecondary);else addMarkedTimeSpan(timePhasedLocationAndDayIntersection.intersection.start, timePhasedLocationAndDayIntersection.intersection.finish, sectionId);
				}

				if (currLocationStart.getTime() != finish.getTime()) {
					addMarkedTimeSpan(currLocationStart, finish, sectionId);
				}
			}
		}

		function convertDtToMomentDt(dt, tz) {
			return utils.convertDtToMomentDt(dt, tz);
		}

		function convertMomentDtToDt(dt) {
			return utils.convertMomentDtToDt(dt);
		}

		function drawByCalendarAndTime(start, finish, calendarId, sectionId, isSecondary) {
			var calendar = ResourcesAndTerritoriesService.getOperatingHours()[calendarId];
			var calendarTZ = calendar.timezone;

			var tz = useLocationTimezone ? calendarTZ : userTimeZone;

			if (isSecondary && useLocationTimezone) {
				var sections = sectionId.split(',');
				for (var i = 0; i < sections.length; i++) {
					var ter = sections[i].split('_')[1];
					var op = ResourcesAndTerritoriesService.territories[ter].operatingHours;
					tz = ResourcesAndTerritoriesService.getOperatingHours()[op].timezone;
				}
			}

			var ganttStart = convertDtToMomentDt(start, tz);
			var ganttFinish = convertDtToMomentDt(finish, tz);

			var resourceStart = ganttStart.clone().tz(calendarTZ);
			var resourceFinish = ganttFinish.clone().tz(calendarTZ);

			var ganttStartJS = convertMomentDtToDt(ganttStart);
			var ganttFinishJS = convertMomentDtToDt(ganttFinish);

			var lastInvalidDate = ganttStartJS;

			var daysOfTheWeek = [ganttStart.clone().add(-1, 'days'), ganttStart.clone(), ganttStart.clone().add(1, 'days')];

			for (var j = 0; j < daysOfTheWeek.length; j++) {
				var dayOfTheWeek = daysOfTheWeek[j];
				var slotsArray = calendar.slots[dayOfTheWeek.get('day')] || [];

				for (var _i2 = 0; _i2 < slotsArray.length; _i2++) {
					var day = slotsArray[_i2];
					var slotStart = getDateBySlotProperties(dayOfTheWeek, day, 'startHour', 'startMinute', calendarTZ, tz, isSecondary);
					var slotFinish = getDateBySlotProperties(dayOfTheWeek, day, 'endHour', 'endMinute', calendarTZ, tz, isSecondary);

					var intersectionWitOuter = utils.intersectDates({ start: slotStart, finish: slotFinish }, { start: ganttStartJS, finish: ganttFinishJS }).intersection;

					if (!intersectionWitOuter) continue;

					slotStart = intersectionWitOuter.start;
					slotFinish = intersectionWitOuter.finish;

					if (day.type == 'Extended') {
						addMarkedTimeSpan(lastInvalidDate, slotStart, sectionId, null);
						addMarkedTimeSpan(slotStart, slotFinish, sectionId, day.type);
					} else {
						addMarkedTimeSpan(lastInvalidDate, slotStart, sectionId, day.type);
					}

					fillResourceToWorkingDates(slotStart, slotFinish, day.type, sectionId);

					lastInvalidDate = slotFinish;
				}
			}

			addMarkedTimeSpan(lastInvalidDate, ganttFinishJS, sectionId, null);
		}

		function getDateBySlotProperties(date, slot, hoursProperty, minutesProperty, calendarTZ, secondaryTZ, isSecondary) {
			var result = convertMomentDtToDt(date);
			result.setHours(slot[hoursProperty]);
			result.setMinutes(slot[minutesProperty]);

			var tz = useLocationTimezone ? calendarTZ : userTimeZone;

			if (isSecondary && useLocationTimezone) tz = secondaryTZ;

			var localDate = convertDtToMomentDt(result, calendarTZ);
			var newDate = convertMomentDtToDt(localDate.tz(tz));

			return newDate;
		}

		function fillResourceToWorkingDates(start, finish, type, sectionId) {
			var timeInMinutes = (finish.getTime() - start.getTime()) / (1000 * 60);

			var resourceDic = resourceToWorkingDates[sectionId];
			if (!resourceDic) {
				resourceDic = {};
				resourceToWorkingDates[sectionId] = resourceDic;
			}

			var dayFormat = utils.formatDayToString(start);
			var resourceCurrDay = resourceDic[dayFormat];

			if (!resourceCurrDay) {
				resourceCurrDay = {
					regular: 0,
					overtime: 0
				};

				resourceDic[dayFormat] = resourceCurrDay;
			}

			if (type == 'Extended') {
				resourceCurrDay.overtime += timeInMinutes;
			} else {
				resourceCurrDay.regular += timeInMinutes;
			}
		}

		function addRelocation(terMember, locationsToTimePhasedDic, resourceId) {
			var otherTerritories = [];
			if (!showSecondarySTMs) otherTerritories = Object.keys(locationsToTimePhasedDic);else {
				for (var key in locationsToTimePhasedDic) {
					for (var i = 0; i < locationsToTimePhasedDic[key].length; i++) {
						if (locationsToTimePhasedDic[key][i].type != 'S' && otherTerritories.indexOf(key) == -1) otherTerritories.push(key);
					}
				}
			}

			otherTerritories.splice(otherTerritories.indexOf(terMember.serviceTerritory), 1);

			var destLocation = terMember.serviceTerritory;
			var toOpHours = ResourcesAndTerritoriesService.territories[destLocation].operatingHours;
			var toTZ = ResourcesAndTerritoriesService.getOperatingHours()[toOpHours].timezone;

			for (var _i3 = 0; _i3 < otherTerritories.length; _i3++) {
				var sections = [utils.generateResourceId(resourceId, otherTerritories[_i3])];
				relocationsOnGantt[terMember.id] = true;
				var start = terMember.start;
				var finish = terMember.finish;

				// convert from arget tz to source tz
				if (useLocationTimezone) {
					var fromOpHours = ResourcesAndTerritoriesService.territories[otherTerritories[_i3]].operatingHours;
					var fromTZ = ResourcesAndTerritoriesService.getOperatingHours()[fromOpHours].timezone;

					start = convertMomentDtToDt(convertDtToMomentDt(start, toTZ).tz(fromTZ));
					finish = convertMomentDtToDt(convertDtToMomentDt(finish, toTZ).tz(fromTZ));
				}

				var relocationTerName = ResourcesAndTerritoriesService.territories[terMember.serviceTerritory].name;
				//var tooltip = customLabels.Relocated_to + ' ' + relocationTerName + ' ' + customLabels.from + ' ' + moment(start).format('llll') + ' ' + customLabels.to + ' ' + moment(finish).format('llll');
				var tooltip = _.escape(customLabels.Relocated_to_many_params.replaceAll(relocationTerName, moment(start).format('llll'), moment(finish).format('llll')));

				var innerHtml = null;
				if (relocationTerName) innerHtml = customLabels.Relocated_to.replace('$0', _.escape(relocationTerName));else innerHtml = customLabels.Relocated_No_Permissions;

				var relocationCss = 'relocation';

				/*
    	Code to drew SCM & relocation half and half (bottom/top) UI CREW
    	var resourceToServiceCrewMembers = TimePhasedDataService.resourceToServiceCrewMembers();
    
    if(resourceToServiceCrewMembers[resourceId] !== undefined){
    	for (let key in resourceToServiceCrewMembers[resourceId]) {
    		let intersection = utils.intersectDates({ start: resourceToServiceCrewMembers[resourceId][key].startDate, finish: resourceToServiceCrewMembers[resourceId][key].endDate}, {start: start, finish: finish}).intersection;
    			if(intersection != null){
    			if(intersection.start.getTime() == start.getTime() && intersection.finish.getTime() == finish.getTime()){
    				relocationCss = 'reloctionCrewMemberTop';
    			}
    		}
    	}
    }
    */

				var relocationMonthlyCss = 'relocation_monthly';

				scheduler.addMarkedTimespan({
					start_date: start,
					end_date: finish,
					sections: {
						ZoomLevel2: sections,
						ZoomLevel3: sections,
						ZoomLevel4: sections,
						ZoomLevel5: sections,
						ZoomLevel6: sections
					},
					html: "<div class='relocatedLabel' title='" + tooltip + "'>" + "<svg aria-hidden='true' class='slds-icon relocationIcon'>" + "<use xlink:href='" + lsdIcons.relocation + "'></use>" + "</svg> " + innerHtml + "</div>",
					css: relocationCss
				});

				scheduler.addMarkedTimespan({
					start_date: start,
					end_date: finish,
					sections: {
						MonthlyView: sections,
						MTDView: sections
					},
					html: "<div class='relocatedLabel' title='" + tooltip + "'>" + "<svg aria-hidden='true' class='slds-icon relocationIcon'>" + "<use xlink:href='" + lsdIcons.relocation + "'></use>" + "</svg></div>",
					css: relocationMonthlyCss
				});
			}
		}

		function isCrewMemberDuringRelocation(start, finish, sectionId, member, stms) {

			var relocation = undefined;
			var primary = undefined;

			for (var key in stms) {

				if (stms[key].serviceTerritoryType === 'P') {
					primary = stms[key];
				}

				if (stms[key].serviceTerritoryType === 'R') {
					relocation = stms[key];
				}
			}

			if (relocation !== undefined) {
				if (sectionId.indexOf(primary.serviceTerritory)) {
					if (start >= relocation.effectiveStartDate && (finish <= relocation.effectiveEndDate || relocation.effectiveEndDate === undefined)) {
						return true;
					}
				}
			}

			return false;
		}

		function addMarkedTimeSpan(start, finish, sectionId, type) {
			if (start.getTime() == finish.getTime()) return;

			var sectionsToDraw = {};
			for (var key in scheduler.matrix) {

				// don't draw calendars on monthly view
				if (key === 'MonthlyView') {
					continue;
				}

				sectionsToDraw[key] = sectionId.indexOf(',') > -1 ? sectionId.split(',') : [sectionId];
			}

			var cssClass = 'gray_section';
			if (type == 'Extended') cssClass = 'overtime_section';

			scheduler.addMarkedTimespan({
				start_date: start,
				end_date: finish,
				sections: sectionsToDraw,
				css: cssClass
			});
		}

		function buildResourceToLocationsToTimePhased(stmList) {
			var resourcesToLocationsToTimePhased = {};
			var resourcesToTimePhasedLocations = stmList || TimePhasedDataService.resourcesByPrimariesAndRelocations();

			for (var resourceId in resourcesToTimePhasedLocations) {
				var timePhasedLocations = resourcesToTimePhasedLocations[resourceId];
				var resourceLocations = {};

				resourcesToLocationsToTimePhased[resourceId] = resourceLocations;

				for (var timePhasedLocId in timePhasedLocations) {
					var timePhasedLoc = timePhasedLocations[timePhasedLocId];

					var timePhasedArray = resourceLocations[timePhasedLoc.serviceTerritory];

					if (!timePhasedArray) {
						timePhasedArray = [];
						resourceLocations[timePhasedLoc.serviceTerritory] = timePhasedArray;
					}

					timePhasedArray.push({
						start: timePhasedLoc.effectiveStartDate || timePhasedLoc.start,
						finish: timePhasedLoc.effectiveEndDate || timePhasedLoc.finish,
						serviceTerritory: timePhasedLoc.serviceTerritory,
						operatingHours: timePhasedLoc.operatingHours,
						type: timePhasedLoc.serviceTerritoryType || timePhasedLoc.type,
						id: timePhasedLoc.id,
						ohTerr: timePhasedLoc.ohTerr || null
					});
				}

				for (var locationId in resourceLocations) {
					var _timePhasedArray = resourceLocations[locationId];
					_timePhasedArray.sort(utils.sortByTime);
				}
			}

			return resourcesToLocationsToTimePhased;
		}

		var serviceObject = {
			resourceToWorkingDates: resourceToWorkingDates,
			relocationsOnGantt: relocationsOnGantt,
			reset: reset
		};

		return serviceObject;
	}]);
})();