trigger AssignedResourceTrigger on AssignedResource (after insert,after update,before insert, before update) {
   if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            set<Id> arSetId=new set<Id>();
            for(AssignedResource ar: Trigger.new){
                if(trigger.isInsert){
                   arSetId.add(ar.ServiceResourceId);
                }else if(trigger.Isupdate && trigger.oldmap.get(ar.id).ServiceResourceId != ar.ServiceResourceId){
                   arSetId.add(ar.ServiceResourceId);
                }
            }
            if(!arSetId.isempty()){
               Map<Id,ServiceResource> arMap=new Map<Id,ServiceResource>([SELECT Id, role__c FROM ServiceResource where Id in : arSetId]);
               for(AssignedResource ar: Trigger.new){
                ar.role__c = arMap.get(ar.ServiceResourceId).role__c;
            }
               }
            }
   }
    
    
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            
            set<Id> arSetId=new set<Id>();
            for(AssignedResource ar: Trigger.new){
                arSetId.add(ar.Id);
            }
             Map<Id,AssignedResource> arMap=new Map<Id,AssignedResource>([SELECT Id, ServiceAppointmentId,ServiceAppointment.NumberOfAssingedCrewMembers__c,ServiceAppointment.Technician__c,servicecrew.NumberOfCrewMember__c,ServiceResource.ResourceType, ServiceResourceId,ServiceResource.role__c,ServiceResource.Name,ServiceResource.RelatedRecord.email FROM AssignedResource where Id in : arSetId]);
            List<ServiceAppointment> saList= new List<ServiceAppointment>();
            for(AssignedResource ar: arMap.values()){
                ar.ServiceAppointment.Technician__c= ar.ServiceResource.name;
                ar.ServiceAppointment.Technician_Email__c =ar.ServiceResource.RelatedRecord.email;
                ar.ServiceAppointment.Role__c = ar.ServiceResource.role__c;
                System.debug('dfhdfh======================'+ar.ServiceResource.ResourceType);
                if(ar.ServiceResource.ResourceType == 'C'){
                ar.ServiceAppointment.NumberOfAssingedCrewMembers__c = ar.servicecrew.NumberOfCrewMember__c;
                } else{
                ar.ServiceAppointment.NumberOfAssingedCrewMembers__c = 1;
                }
                if(!salist.contains(ar.ServiceAppointment)){  
                    saList.add(ar.ServiceAppointment);
                }
                
            }
            if(saList.size()>0)
            {
                update saList;
            }
        }
    }
    
    
    /*if(Trigger.isBefore){
      if(Trigger.isDelete){
                        set<Id> arSetId=new set<Id>();
            for(AssignedResource ar: Trigger.old){
                arSetId.add(ar.Id);
            }
            Map<Id,AssignedResource> arMap=new Map<Id,AssignedResource>([SELECT Id, ServiceAppointmentId,ServiceAppointment.Technician__c, ServiceResourceId,ServiceResource.Name FROM AssignedResource where Id in : arSetId]);
            List<ServiceAppointment> saList= new List<ServiceAppointment>();
            for(AssignedResource ar: arMap.values()){
                ar.ServiceAppointment.Technician__c= '';
                saList.add(ar.ServiceAppointment);
            }
            update saList;
        }
    }*/
    
    
    
}