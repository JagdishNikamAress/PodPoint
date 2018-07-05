trigger TaskTrigger on Task (before insert, before update, after insert) {
    Map<id,Lead> Updatefinalmap = new Map<id,Lead>();
    list<lead> updateleadlist2 = new list<lead>();
    String desiredNewLeadStatus = 'Contact Attempted';
    /*if(trigger.isbefore && trigger.isinsert){
        
        List<Id> leadIds=new List<Id>();
        for(Task t:trigger.new){
            system.debug('value of email'+t.TaskSubtype);
            if(t.TaskSubtype=='Email' || t.TaskSubtype=='call'){
                if(t.whoId != null && String.valueOf(t.whoId).startsWith('00Q')==TRUE){//check if the task is associated with a lead
                    leadIds.add(t.whoId);
                }
            }
        }
        List<Lead> leadsToUpdate=[SELECT Id, Status FROM Lead WHERE Id IN :leadIds AND status = 'Open'];
        For (Lead l:leadsToUpdate){
            l.Status=desiredNewLeadStatus;
            updateleadlist2.add(l);
        }
        if(Updateleadlist2.size()>0){
           Update updateleadlist2;
        }
        
    }*/
    
    if(trigger.isafter && trigger.isinsert){
        set<id> Leadset = new set<id>(); 
        list<lead> updateleadlist = new list<lead>();
        for(Task t:trigger.new){
            system.debug('value of email after'+t.TaskSubtype);
            if(t.TaskSubtype =='call' || t.TaskSubtype =='Email'){
                if(t.whoId != null && String.valueOf(t.whoId).startsWith('00Q')==TRUE){//check if the task is associated with a lead
                    Leadset.add(t.whoId);
                }
            }
        }
        Map<id,lead> Leadlist = new Map<id,Lead>([SELECT Id, Status, Contact_Attempts__c, (SELECT id,TaskSubtype FROM Tasks ) FROM Lead where id in: Leadset]);
        
        for(Lead l : Leadlist.values()){
            integer temp = l.Tasks.size();
            l.Contact_Attempts__c = string.valueof(temp);
            if(l.Status == 'open'){
               l.Status = desiredNewLeadStatus;
            }
            updateleadlist.add(l);
        }
        if(Updateleadlist.size()>0){
            Update Updateleadlist;
        }
    }
  
}