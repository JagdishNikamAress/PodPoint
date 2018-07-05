trigger CaseEquipmentTrigger on Case_Equipment__c (after insert,after update,after delete) {
	if(Trigger.isAfter){
		if(Trigger.isInsert || Trigger.isUpdate){
			CaseEquipmentTriggerHandler.handleAfterUpdate(Trigger.New);
		} 
		if(Trigger.isDelete){
			CaseEquipmentTriggerHandler.handleAfterUpdate(Trigger.Old);
		}        
    }
}