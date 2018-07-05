trigger ContentDocumentTrigger on ContentDocument (After insert) {
    if(trigger.isAfter && trigger.isInsert){
        string temp = 'SA-';
        list<string> RelatedSA = new list<string>();
        list<ServiceAppointment> UpdateListSA = new list<ServiceAppointment>();
        for(ContentDocument cd: trigger.new){
            if(cd.title.contains(temp)){
                string temptitle;
                temptitle = (cd.title).split('_')[0];
                RelatedSA.add(temptitle);
            }
        }
         
      /*  list<ServiceAppointment> ServiceReportDateUpdate = [select id, Products_Summary__c,Service_Report_Check__c, AppointmentNumber from ServiceAppointment where id IN : ListSaAttid.values()];
        list<ServiceAppointment> UpdateServiceappointment = new list<ServiceAppointment>();
        for(id temp2 :ListSaAttid.Keyset()){
            for(ServiceAppointment SA : ServiceReportDateUpdate){
                if(SA.id == ListSaAttid.get(temp2)){
                    SA.Products_Summary__c = 'test';
                    UpdateServiceappointment.add(SA);
                }
              
            }
        }
        Update UpdateServiceappointment;*/
        
        list<ServiceAppointment> SaList = [select id, Products_Summary__c, Service_Report_Created_Date__c, Service_Report_Check__c, AppointmentNumber from ServiceAppointment where AppointmentNumber IN : RelatedSA];
        for(ServiceAppointment SA : SaList){
            SA.Service_Report_Check__c = true;
            
            UpdateListSA.add(SA);
        }
        
        for(ContentDocument cd: trigger.new){
            if(cd.title.contains(temp)){
                string temptitle;
                temptitle = (cd.title).split('_')[0];
                for(ServiceAppointment SA : SaList){
                    if(SA.AppointmentNumber == temptitle  && SA.Service_Report_Created_Date__c==null){
                        SA.Service_Report_Created_Date__c = cd.CreatedDate;
                    }
                }
                
            }
        }
        update UpdateListSA;
    }
}