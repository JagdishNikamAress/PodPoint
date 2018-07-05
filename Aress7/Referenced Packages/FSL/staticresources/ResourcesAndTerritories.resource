"use strict";

function ResourcesAndTerritories(sobject) {
    this.id = sobject.Id;
    this.name = sobject.MemberNumber;
    this.effectiveEndDate = sobject[fieldNames.ServiceTerritoryMember.EffectiveEndDate] || null;
    this.effectiveStartDate = sobject[fieldNames.ServiceTerritoryMember.EffectiveStartDate];
    this.latitude = sobject[fieldNames.ServiceTerritoryMember.Latitude];
    this.longitude = sobject[fieldNames.ServiceTerritoryMember.Longitude];
    this.serviceResource = sobject[fieldNames.ServiceTerritoryMember.ServiceResource];
    this.serviceResource__r = sobject[fieldNames.ServiceTerritoryMember.ServiceResource__r];
    this.serviceTerritory = sobject[fieldNames.ServiceTerritoryMember.ServiceTerritory];
    this.serviceTerritory__r = sobject[fieldNames.ServiceTerritoryMember.ServiceTerritory__r];
    this.serviceTerritoryType = sobject[fieldNames.ServiceTerritoryMember.TerritoryType];
    this.operatingHours = sobject[fieldNames.ServiceTerritoryMember.OperatingHours];
    this.operatingHours__r = sobject[fieldNames.ServiceTerritoryMember.OperatingHours__r];

    var tz_start = void 0,
        tz_finish = void 0;

    if (this.effectiveStartDate) tz_start = new Date(this.effectiveStartDate).getTimezoneOffset() * 60 * 1000;

    if (this.effectiveEndDate) tz_finish = new Date(this.effectiveEndDate).getTimezoneOffset() * 60 * 1000;

    this.effectiveStartDate = this.effectiveStartDate ? new Date(this.effectiveStartDate + tz_start) : new Date(0);
    this.effectiveEndDate = this.effectiveEndDate ? new Date(this.effectiveEndDate + tz_finish) : new Date(2400000000000);

    this.timezone = sobject[fieldNames.ServiceTerritoryMember.ServiceTerritory__r][fieldNames.ServiceTerritory.OperatingHours__r][fieldNames.OperatingHours.Timezone];
}