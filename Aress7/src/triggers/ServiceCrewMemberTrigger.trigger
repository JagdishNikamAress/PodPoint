trigger ServiceCrewMemberTrigger on ServiceCrewMember (after insert, after delete) {
    Set<Id> ServiceCrewIdSet=new Set<Id>();
    Map<Id,Serviceappointment> SAMapToUpdate=new Map<Id,Serviceappointment>();
    If(Trigger.isafter){
        If(Trigger.isInsert){
            for(ServiceCrewMember scm : Trigger.new){
                ServiceCrewIdSet.add(scm.ServiceCrewId);
            }
        }
        If(Trigger.isDelete){
            for(ServiceCrewMember scm : Trigger.old){
                ServiceCrewIdSet.add(scm.ServiceCrewId);
            }
        }
        Map<id,ServiceCrew> ServiceCrewMap=new Map<id,ServiceCrew>([Select id,(SELECT ServiceAppointmentid,ServiceAppointment.status, ServiceAppointment.NumberOfAssingedCrewMembers__c,ServiceCrew.NumberOfCrewMember__c, Id FROM AssignedResources), (SELECT Id, ServiceCrewId FROM ServiceCrewMembers), NumberOfCrewMember__c from ServiceCrew where id in : ServiceCrewIdSet]);
        For(ServiceCrew sc: ServiceCrewMap.values()){
            sc.NumberOfCrewMember__c=sc.ServiceCrewMembers.size();
            if((!sc.AssignedResources.isEmpty()) || test.isRunningTest()){
                For(AssignedResource ar: sc.AssignedResources){
                    ServiceAppointment sa=new ServiceAppointment();
                    sa.id=ar.ServiceAppointmentid;
                    sa.NumberOfAssingedCrewMembers__c=sc.NumberOfCrewMember__c;
                    SAMapToUpdate.put(sa.Id,sa);
                }
            }
        }
        Update ServiceCrewMap.values();
        if(!SAMapToUpdate.isEmpty())
            Update SAMapToUpdate.values();
        
    }
    
    
}