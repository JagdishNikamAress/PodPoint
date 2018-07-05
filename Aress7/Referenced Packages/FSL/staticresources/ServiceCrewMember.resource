"use strict";

function ServiceCrewMember(sobject) {
    this.id = sobject.Id;
    this.name = sobject.Name;
    this.endDate = sobject[fieldNames.ServiceCrewMember.EndDate] || null;
    this.startDate = sobject[fieldNames.ServiceCrewMember.StartDate];
    this.serviceResource = sobject[fieldNames.ServiceCrewMember.ServiceResource];
    this.serviceResource__r = sobject[fieldNames.ServiceCrewMember.ServiceResource__r];
    this.serviceCrew = sobject[fieldNames.ServiceCrewMember.ServiceCrew];
    this.serviceCrew__r = sobject[fieldNames.ServiceCrewMember.ServiceCrew__r];
    this.leader = sobject[fieldNames.ServiceCrewMember.Leader];
    this.ganttLabel = sobject[fieldNames.ServiceCrewMember.GanttLabel];

    var tz_start = void 0,
        tz_finish = void 0;

    if (this.startDate) tz_start = new Date(this.startDate).getTimezoneOffset() * 60 * 1000;

    if (this.endDate) tz_finish = new Date(this.endDate).getTimezoneOffset() * 60 * 1000;

    this.startDate = this.startDate ? new Date(this.startDate + tz_start) : new Date(2400000000000);
    this.endDate = this.endDate ? new Date(this.endDate + tz_finish) : new Date(2400000000000);
}