"use strict";

function OptimizationRequest(sobject) {
    this.id = sobject.Id;
    this.lastModifiedDate = sobject.LastModifiedDate;
    this.name = sobject.Name;
    this.scheduledAmount = sobject[fieldNames.Optimization_Request.Objects_Scheduled__c];
    this.objectToScheduled = sobject[fieldNames.Optimization_Request.Objects_To_Schedule__c];
    this.status = sobject[fieldNames.Optimization_Request.Status__c] || null;
    this.statusLabel = sobject.statusLabel || sobject[fieldNames.Optimization_Request.Status__c] || null;
    this.allTasks = sobject[fieldNames.Optimization_Request.All_Tasks_Mode__c] || null;
    this.includeEmptyLocations = sobject[fieldNames.Optimization_Request.Include_Services_With_Empty_Location__c] || null;
    this.type = sobject[fieldNames.Optimization_Request.Type__c] || null;
    this.failureReason = sobject[fieldNames.Optimization_Request.Failure_Reason__c] || null;
    this.optimizationData = sobject[fieldNames.Optimization_Request.Optimization_Data__c] || null;
    this.orgResourceAbsence = sobject[fieldNames.Optimization_Request.Originating_Resource_Absence__c] || null;
    this.orgServiceAppointment = sobject[fieldNames.Optimization_Request.Originating_Service_Appointment__c] || null;
    this.policy = sobject[fieldNames.Optimization_Request.Scheduling_Policy__c] || null;
    this.serviceAppointment = sobject[fieldNames.Optimization_Request.Service_Appointment__c] || null;
    this.resource = sobject[fieldNames.Optimization_Request.Service_Resource__c] || null;
    this.result = sobject[fieldNames.Optimization_Request.Result__c] || null;
    this.timespan = null;

    this.finish = sobject[fieldNames.Optimization_Request.Finish__c] ? new Date(sobject[fieldNames.Optimization_Request.Finish__c]) : null;
    this.start = sobject[fieldNames.Optimization_Request.Start__c] ? new Date(sobject[fieldNames.Optimization_Request.Start__c]) : null;

    if (this.start) {
        var startTz = new Date(this.start).getTimezoneOffset() * 60 * 1000;
        this.start = new Date(this.start.valueOf() + startTz);
    }

    if (this.finish) {
        var finishTz = new Date(this.finish).getTimezoneOffset() * 60 * 1000;
        this.finish = new Date(this.finish.valueOf() + finishTz);
    }
}