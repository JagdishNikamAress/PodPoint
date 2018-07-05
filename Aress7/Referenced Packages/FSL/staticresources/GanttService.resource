'use strict';

function GanttService(sobject, copy) {

    // used to copying
    if (copy) {
        return;
    }

    // SET TYPE
    this.sfdcType = 'service';

    // STUFF THAT ARE RETRIVED FROM SALESFORCE
    this.fields = {};
    for (var k in sobject.Fields) {
        this.fields[k] = sobject.Fields[k];
    }
    this.id = sobject.Fields.Id || null;
    this.name = sobject.Fields.AppointmentNumber || null;
    this.AssignedResourceLastModifiedDate = sobject.AssignedResourceLastModifiedDate || null;
    this.ServiceAppointmentLastModifiedDate = sobject.ServiceAppointmentLastModifiedDate || null;
    this.accountName = sobject.Fields['Account.Name'] || null;
    this.accountId = sobject.Fields.AccountId || null;
    this.latitude = sobject.Fields.Latitude || null;
    this.longitude = sobject.Fields.Longitude || null;
    this.arrivalWindowEndTime = sobject.Fields.ArrivalWindowEndTime || null;
    this.arrivalWindowStartTime = sobject.Fields.ArrivalWindowStartTime || null;
    this.dueDate = sobject.Fields.DueDate || null;
    //this.durationInMinutes                  = sobject.Fields.Duration || null;
    this.durationType = sobject.Fields.DurationType || null;
    this.earliestStartTime = sobject.Fields.EarliestStartTime || null;
    this.estDuration = sobject.Fields.Duration || null;
    this.travelTimeFrom = sobject.Fields.EstimatedTravelTimeFrom__c || null;
    this.travelTimeTo = sobject.Fields.EstimatedTravelTime || null;
    this.ganttLabel = sobject.Fields.GanttLabel__c || null;
    this.jeopardy = sobject.Fields.InJeopardy__c || null;
    this.jeopardyReason = sobject.Fields.InJeopardyReason__c || null;
    this.parentRecord = sobject.Fields.ParentRecordId || null;
    this.parentRecordStatus = sobject.Fields.ParentRecordStatusCategory || null;
    this.parentRecordType = sobject.Fields.ParentRecordType || null;
    this.pinned = sobject.Fields.Pinned__c || false;
    this.schedEndTime = sobject.Fields.SchedEndTime || null;
    this.schedStartTime = sobject.Fields.SchedStartTime || null;
    this.serviceTerritory = sobject.Fields.ServiceTerritory || null;
    this.serviceTerritoryName = sobject.Fields['ServiceTerritory.Name'] || null;
    this.status = sobject.Fields.Status || null;
    this.statusCategory = sobject.Fields.StatusCategory || null;
    this.subject = sobject.Fields.Subject || null;
    this.ganttColor = sobject.Fields.GanttColor__c || null;
    this.resource = sobject.Resource || null;
    this.resourceName = sobject.ResourceName || null;
    this.resourceContractor = sobject.ResourceContractor || null;
    this.isAssignToCrew = sobject.IsAssignToCrew || null;
    this.assignedResource = sobject.AssignedResource || null;
    this.violations = null;
    this.relatedTo = sobject.relatedTo || null;
    this.relatedFather = null;
    this.priority = this.minPriority;
    this.relatedFather = sobject.relatedFather;
    this.policyUsed = sobject.Fields.Scheduling_Policy_Used__c || null;
    this.scheduleMode = sobject.Fields.Schedule_Mode__c || null;
    this.emergency = sobject.Fields.Emergency__c || false;
    this.isServiceInChain = usingNewMstModel && sobject.isServiceInChain;
    this.relatedService2 = sobject.relatedService2 || null;
    this.relatedService1 = sobject.relatedService1 || null;

    var parentPriorityField = sobject.Fields.ParentRecordType == 'WorkOrder' ? CustomSettings.woPriorityField : CustomSettings.woliPriorityField;

    if (parentPriorityField && sobject.ParentFields && sobject.ParentFields[parentPriorityField]) this.priority = sobject.ParentFields[parentPriorityField];

    // MDT
    var realMdtBooleanField = fslNamespace ? mdtBooleanField.replace(fslNamespace + '__', '') : mdtBooleanField;
    this.isMDT = sobject.Fields[realMdtBooleanField] ? true : false;

    if (sobject.Fields.MDT_Operational_Time__c) {
        this.calculateMdtTimes(sobject.Fields.MDT_Operational_Time__c);
    } else if (this.isMDT) {
        this.mdtTimes = {
            travel: [],
            working: []
        };
    }

    // SET PARENT FIELDS
    this.parentFields = {};
    for (var key in sobject.ParentFields) {
        this.parentFields[key] = sobject.ParentFields[key];
    }

    // SET STUFF FOR GANTT (Scheduler + Timezones)
    this.setSchedulerProperties();

    // SET FIELD SET FIELDS
    addFieldSetToServiceObject(GanttService.prototype.allFieldSetsSet, sobject.Fields, this);

    // if mdt - don't show travel
    if (this.isMDT) {
        this.travelTimeFrom = 0;
        this.travelTimeTo = 0;
    }
}

GanttService.prototype.setSchedulerProperties = function () {

    var tz_schdStart = void 0,
        tz_schdFinish = void 0,
        tz_actualStart = void 0,
        tz_actualFinish = void 0,
        tz_early = void 0,
        tz_due = void 0,
        tz_app_start = void 0,
        tz_app_finish = void 0;

    // get all offsets for date fields - add when creating new javascript date
    if (this.schedStartTime) tz_schdStart = new Date(this.schedStartTime).getTimezoneOffset() * 60 * 1000;

    if (this.schedEndTime) tz_schdFinish = new Date(this.schedEndTime).getTimezoneOffset() * 60 * 1000;

    if (this.dueDate) tz_due = new Date(this.dueDate).getTimezoneOffset() * 60 * 1000;

    if (this.earliestStartTime) tz_early = new Date(this.earliestStartTime).getTimezoneOffset() * 60 * 1000;

    if (this.arrivalWindowStartTime) tz_app_start = new Date(this.arrivalWindowStartTime).getTimezoneOffset() * 60 * 1000;

    if (this.arrivalWindowEndTime) tz_app_finish = new Date(this.arrivalWindowEndTime).getTimezoneOffset() * 60 * 1000;

    if (this.actualStartTime) tz_actualStart = new Date(this.actualStartTime).getTimezoneOffset() * 60 * 1000;

    if (this.actualEndTime) tz_actualFinish = new Date(this.actualEndTime).getTimezoneOffset() * 60 * 1000;

    // properties with special names to meet the scheduler needs
    this.text = this.ganttLabel ? this.ganttLabel : this.name;

    // properties related to Dates and Times
    this.start = this.schedStartTime ? new Date(this.schedStartTime + tz_schdStart) : null;
    this.finish = this.schedEndTime ? new Date(this.schedEndTime + tz_schdFinish) : null;
    this.dueDate = this.dueDate ? new Date(this.dueDate + tz_due) : null;
    this.earlyStart = this.earliestStartTime ? new Date(this.earliestStartTime + tz_early) : null;
    this.appStart = this.arrivalWindowStartTime ? new Date(this.arrivalWindowStartTime + tz_app_start) : null;
    this.appEnd = this.arrivalWindowEndTime ? new Date(this.arrivalWindowEndTime + tz_app_finish) : null;
    this.actualStartTime = this.actualStartTime ? new Date(this.actualStartTime + tz_actualStart) : null;
    this.actualEndTime = this.actualEndTime ? new Date(this.actualEndTime + tz_actualFinish) : null;

    // custom properties that needs parsing of some sort
    this.type = 'service';
    this.travelTo = this.travelTimeTo ? parseInt(this.travelTimeTo) * 60 : 0;
    this.travelFrom = this.travelTimeFrom ? parseInt(this.travelTimeFrom) * 60 : 0;
    //this.durationInMinutes  = this.durationInMinutes ? parseFloat(this.durationInMinutes) : null;
    this.estDuration = this.estDuration ? parseFloat(this.estDuration) : null;

    // TODO - related service

    // TODO - violations
};

GanttService.prototype.setGanttResource = function (timephasedObjects, generateResourceId) {

    // not scheduled
    if (!this.isScheduled()) {
        return;
    }

    var resourceTimePhases = timephasedObjects[this.resource],
        territories = [],
        tz_schdStart = void 0,
        tz_schdFinish = void 0;

    this.resourceId = null;

    if (this.schedStartTime) tz_schdStart = new Date(this.schedStartTime).getTimezoneOffset() * 60 * 1000;

    if (this.schedEndTime) tz_schdFinish = new Date(this.schedEndTime).getTimezoneOffset() * 60 * 1000;

    this.start_date = this.schedStartTime ? new Date(this.schedStartTime + tz_schdStart) : null;
    this.end_date = this.schedEndTime ? new Date(this.schedEndTime + tz_schdFinish) : null;

    // go over all time phases of the specific resource
    for (var tpKey in resourceTimePhases) {

        var timephase = resourceTimePhases[tpKey];

        // if relocation, this will be our drawing place
        if (timephase.serviceTerritoryType === 'R' && (isIntersect(timephase.effectiveStartDate, timephase.effectiveEndDate, this.start_date, this.end_date) || !timephase.effectiveEndDate && timephase.effectiveStartDate < this.end_date)) {

            territories.push(timephase.serviceTerritory);
        }
    }

    // no relocation, must be primary
    if (territories.length === 0) {
        for (var _tpKey in resourceTimePhases) {

            var _timephase = resourceTimePhases[_tpKey];

            if (isIntersect(_timephase.effectiveStartDate, _timephase.effectiveEndDate, this.start_date, this.start_date)) {
                territories.push(_timephase.serviceTerritory);
            }
        }
    } else {
        //there is a relocation but also some secondaries - need to draw service on S rows as well
        if (showSecondarySTMs) {
            for (var _tpKey2 in resourceTimePhases) {

                var _timephase2 = resourceTimePhases[_tpKey2];

                if (_timephase2.serviceTerritoryType === 'S' && isIntersect(_timephase2.effectiveStartDate, _timephase2.effectiveEndDate, this.start_date, this.end_date)) {

                    territories.push(_timephase2.serviceTerritory);
                }
            }
        }
    }

    this.resourceId = generateResourceId(this.resource, territories);

    if (this.isScheduled()) {
        this.updateDatesBasedOnTravel();
    }
};

// updates dates if we have travel
GanttService.prototype.updateDatesBasedOnTravel = function () {

    if (this.resourceId) {
        if (this.travelFrom) {
            if (this.travelFrom <= maxTravelTimeInSeconds) {
                this.end_date.setMinutes(this.end_date.getMinutes() + Math.floor(this.travelFrom / 60));
            } else {
                //this.end_date.setMinutes(this.end_date.getMinutes() + 60);
                this.hiddenTravelFrom = {
                    hiddenMinutes: this.end_date.getMinutes() + Math.floor(this.travelFrom / 60),
                    hiddenTravel: this.travelFrom
                };
                this.travelFrom = maxTravelTimeInSeconds;
                this.end_date.setMinutes(this.end_date.getMinutes() + Math.floor(this.travelFrom / 60));
            }
        }

        if (this.travelTo) {
            if (this.travelTo <= maxTravelTimeInSeconds) {
                this.start_date.setMinutes(this.start_date.getMinutes() - Math.floor(this.travelTo / 60));
            } else {
                //this.start_date.setMinutes(this.start_date.getMinutes() - 60);
                this.hiddenTravelTo = {
                    hiddenMinutes: this.start_date.getMinutes() - Math.floor(this.travelTo / 60),
                    hiddenTravel: this.travelTo
                };
                this.travelTo = maxTravelTimeInSeconds;
                this.start_date.setMinutes(this.start_date.getMinutes() - Math.floor(this.travelTo / 60));
            }
        }
    }
};

GanttService.prototype.isScheduled = function () {
    return this.resource && this.schedEndTime && this.schedStartTime;
};

GanttService.prototype.getGanttResource = function (checkResourceArray) {

    if (checkResourceArray) getGanttResourceWithSecondaryStms(this);

    return this.resourceId ? this.resourceId.substr(0, 18) : this.resourceId;
};

GanttService.prototype.getGanttTerritory = function () {
    return this.resourceId ? this.resourceId.substr(19, 37) : this.resourceId;
};

GanttService.prototype.isChanged = function (ganttService) {
    return this.AssignedResourceLastModifiedDate != ganttService.AssignedResourceLastModifiedDate || this.ServiceAppointmentLastModifiedDate != ganttService.ServiceAppointmentLastModifiedDate;
};

GanttService.prototype.isChainChanged = function (ganttService) {
    return this.isServiceInChain != ganttService.isServiceInChain || this.relatedService1 != ganttService.relatedService1 || this.relatedService2 != ganttService.relatedService2;
};

GanttService.prototype.minPriority = 1000000;

function getGanttResourceWithSecondaryStms(ganttService) {

    // when dragging duplicated service/absence on gantt- find the correct resource territory member (resourceId)
    if (showSecondarySTMs) {
        var resourceTerrArray = ganttService.resourceId.split(',');
        if (ganttService.resourceBeforeDrag && ganttService.resourceBeforeDrag != ganttService.resourceId && resourceTerrArray.length > 1) {
            for (var i = 0; i < resourceTerrArray.length; i++) {
                if (ganttService.resourceBeforeDrag.split(',')[i] != resourceTerrArray[i]) {
                    ganttService.resourceId = resourceTerrArray[i];
                    break;
                }
            }
        }
    }
}

function addFieldSetToServiceObject(fieldsList, sourceService, destService) {
    for (var key in fieldsList) {
        var val = null;

        /* if (fieldsList[i].SOQLString.indexOf('.') != -1) {
             var splited = fieldsList[i].SOQLString.split('.');
              var innerObj = sourceService[splited[0]];
             if (innerObj) {
                 val = innerObj[splited[1]];
                  var idPropName = fieldsList[i].APIName.replace('__r', '__c');
                  destService[idPropName] = sourceService[idPropName];
             }
         }
         else {*/
        val = sourceService[fieldsList[key].APIName];
        //}

        if (val || val == false) {
            switch (fieldsList[key].Type) {
                case 'DATE':
                case 'DATETIME':
                    var tz = new Date(val).getTimezoneOffset() * 60 * 1000;
                    val = new Date(val + tz);

                    // for gantt filters date shifts
                    destService.fields[fieldsList[key].APIName] = val.getTime();
                    break;
                case 'REFERENCE':
                    var idPropName = fieldsList[key].JsAPIName.replace('__r', '__c');
                    destService[idPropName] = sourceService[idPropName];
                    break;
            }

            destService[fieldsList[key].APIName] = val;
        }
    }
}

GanttService.copy = function (obj) {

    var gs = new GanttService(null, true);

    angular.merge(gs, obj);

    return gs;
};

GanttService.prototype.calculateMdtTimes = function (mdtTimesJson) {

    try {
        this.mdtTimes = JSON.parse(mdtTimesJson);

        var localOffsetMs = new Date().getTimezoneOffset() * 1000 * 60,
            mdtObject = {
            travel: [],
            working: []
        };

        this.mdtTimes.forEach(function (times) {
            var Start = moment.tz(times.Start, userTimeZone),
                Finish = moment.tz(times.Finish, userTimeZone);

            Start = new Date(Start.valueOf() - Start._offset * 60 * 1000 + localOffsetMs);
            Finish = new Date(Finish.valueOf() - Finish._offset * 60 * 1000 + localOffsetMs);

            times.Start = Start;
            times.Finish = Finish;

            if (times.Type === 'OperationalSlot') {
                mdtObject.working.push(times);
            } else if (times.Type === 'Travel') {
                mdtObject.travel.push(times);
            }
        });

        this.mdtTimes = mdtObject;
    } catch (e) {
        this.mdtTimes = {
            travel: [],
            working: []
        };
    }
};