global class CloneSA {
    webservice static String cloneME(String SAId){
        
        ServiceAppointment m = [SELECT Id, OwnerId, AppointmentNumber, 
            LastViewedDate, LastReferencedDate, ParentRecordId, 
            ParentRecordType, AccountId, WorkTypeId, ContactId, Street, City, State, PostalCode, Country, StateCode,CurrencyIsoCode,
            CountryCode, Latitude, Longitude, GeocodeAccuracy, Address, Description, EarliestStartTime, DueDate,
            Duration, ArrivalWindowStartTime, ArrivalWindowEndTime, Status, SchedStartTime, SchedEndTime, ActualStartTime,
            ActualEndTime, ActualDuration, DurationType, DurationInMinutes, ServiceTerritoryId, Subject, 
            ParentRecordStatusCategory, StatusCategory, ServiceNote, FSL__Appointment_Grade__c, FSL__Auto_Schedule__c,
            FSL__Emergency__c, FSL__GanttColor__c, FSL__GanttLabel__c, FSL__InJeopardyReason__c, FSL__InJeopardy__c,
            FSL__InternalSLRGeolocation__Latitude__s, FSL__InternalSLRGeolocation__Longitude__s, 
            FSL__InternalSLRGeolocation__c, FSL__IsFillInCandidate__c, FSL__IsMultiDay__c, FSL__MDS_Calculated_length__c,
            FSL__MDT_Operational_Time__c, FSL__Pinned__c, FSL__Prevent_Geocoding_For_Chatter_Actions__c, 
            FSL__Related_Service__c, FSL__Same_Day__c, FSL__Same_Resource__c, FSL__Schedule_Mode__c, 
            FSL__Schedule_over_lower_priority_appointment__c, FSL__Scheduling_Policy_Used__c, FSL__Time_Dependency__c,
            FSL__UpdatedByOptimization__c, FSL__Virtual_Service_For_Chatter_Action__c, Customer_Confirmation__c,
            Actual_Duration_Hours__c, Case__c, Incomplete_Reason_Other__c, Incomplete_Reason__c, Main_SA__c,
            Opportunity__c, Products_Summary__c, Technician__c, Arrival_Window_End_Time__c, Arrival_Window_Start_Time__c,
            Scheduled_Start_Date__c, Scheduled_Start_Time_Minute__c, Scheduled_Start_Time__c, Technician_Email__c FROM ServiceAppointment WHERE ID =: SAId];
        
    
        ServiceAppointment m1 = new ServiceAppointment();
        m1.OwnerId = m.OwnerId;
        m1.CurrencyIsoCode = m.CurrencyIsoCode;
        m1.ParentRecordId = m.ParentRecordId;
        m1.ContactId = m.ContactId;
        m1.Street = m.Street;
        m1.City = m.City;
        m1.State = m.State;
        m1.PostalCode = m.PostalCode;
        m1.Country = m.Country;
        m1.CountryCode=m.CountryCode;
        m1.StateCode = m.StateCode;
        m1.CountryCode = m.CountryCode;
        m1.Latitude = m.Latitude;
        m1.Longitude = m.Longitude;
        m1.GeocodeAccuracy = m.GeocodeAccuracy;
        m1.Description = m.Description;
        m1.EarliestStartTime = m.EarliestStartTime;
        m1.DueDate = m.DueDate;
        m1.Duration = m.Duration;
        m1.ArrivalWindowStartTime = m.ArrivalWindowStartTime;
        m1.ArrivalWindowEndTime = m.ArrivalWindowEndTime;
        m1.Status = 'Unassigned';
        m1.SchedStartTime = m.SchedStartTime;
        m1.SchedEndTime = m.SchedEndTime;
      //  m1.ActualStartTime = m.ActualStartTime;
      //  m1.ActualEndTime = m.ActualEndTime;
     //   m1.ActualDuration = m.ActualDuration;
        m1.DurationType = m.DurationType;
        m1.ServiceTerritoryId = m.ServiceTerritoryId;
        m1.Subject = m.Subject;
        m1.ServiceNote = m.ServiceNote;
        m1.Customer_Confirmation__c = false;
        m1.Case__c = m.Case__c;
        m1.Incomplete_Reason_Other__c = m.Incomplete_Reason_Other__c;
        m1.Incomplete_Reason__c = m.Incomplete_Reason__c;
        m1.Main_SA__c = False;
        m1.Products_Summary__c = m.Products_Summary__c;
        m1.Technician__c = m.Technician__c;
        m1.Technician_Email__c  = m.Technician_Email__c ;
        insert m1;
        //String m1Id = m1.Id;
        //m1Id = m1Id.substring(0,m1Id.length() - 3);
        //System.debug('m1Id -> '+m1Id);
        //return String.valueOf( new PageReference('/'+m1.Id).getUrl());
        return m1.Id;
    }
}