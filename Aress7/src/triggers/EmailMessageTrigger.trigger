trigger EmailMessageTrigger on EmailMessage (after insert, after update) {
  if(AvoidRecursion.isFirstRun() || Test.isRunningTest()){
    Set<String> rectypeNames = new Set<String>{'Support Case','Homecharge Norway','Domestic Survey Case','Norway Support Case','Maintenance Case','Homecharge Case','Commercial Case'};
    Set<String> parentIds = new Set<String>();
    Set<Id> oppIds = new Set<Id>();
    Set<Id> qoteIds = new Set<Id>();
    for(EmailMessage em: Trigger.New){
        parentIds.add(em.ParentId);
        qoteIds.add(em.RelatedToId);
    }
    Map<String,Quote> qoteMap = new Map<String,Quote>([select id,Status,Number_of_Quotes_Presented__c from quote where id in : qoteIds]);
    Map<String,Case> caseMap = new Map<String,Case>([select id,Recordtype.Name,OpportunityID__c,owner.Name from Case where id in : parentIds]);
    for(Case c : caseMap.values()){
        oppIds.add(c.OpportunityID__c);
    }
    Map<String,Opportunity> oppMap = new Map<String,Opportunity>([select id,stagename from Opportunity where id IN : oppIds]);
        
    for(EmailMessage em: Trigger.New){
        if(caseMap.keySet().contains(em.ParentId)){
            if(rectypeNames.contains(caseMap.get(em.ParentId).Recordtype.Name)){
                if(em.Incoming && em.Status== '0'){
                    caseMap.get(em.ParentId).Status = 'Open';
                }
                
                if(em.Status== '3' && caseMap.get(em.ParentId).owner.Name != 'HC Sales Queue' && caseMap.get(em.ParentId).recordtype.name != 'Commercial Case'){
                    caseMap.get(em.ParentId).ownerid = em.CreatedById;
                    caseMap.get(em.ParentId).Status = 'Pending';
                    
                    if((caseMap.get(em.ParentId).Recordtype.Name == 'Homecharge Case' || caseMap.get(em.ParentId).Recordtype.Name == 'Homecharge Norway') && oppMap.keyset().contains(caseMap.get(em.ParentId).OpportunityID__c)){
                        if(oppMap.get(caseMap.get(em.ParentId).OpportunityID__c).stagename == 'New'){
                            oppMap.get(caseMap.get(em.ParentId).OpportunityID__c).stagename = 'Ongoing';   
                        }                       
                    }
                }
                
                if(em.Status== '3' && em.HasAttachment && qoteMap.keySet().contains(em.RelatedToId)){
                    //qoteMap.get(em.RelatedToId).Number_of_Quotes_Presented__c += 1;
                    if(qoteMap.get(em.RelatedToId).Number_of_Quotes_Presented__c == null){
                        qoteMap.get(em.RelatedToId).Number_of_Quotes_Presented__c = 0;
                    }
                    qoteMap.get(em.RelatedToId).Number_of_Quotes_Presented__c += 1;
        
                }
            }
        }
        if(em.Status== '3' && em.HasAttachment && qoteMap.keySet().contains(em.RelatedToId)){
            System.debug('IN EmailMessage=>');
            //qoteMap.get(em.RelatedToId).Number_of_Quotes_Presented__c += 1;
            qoteMap.get(em.RelatedToId).Status='Presented';
            if(qoteMap.get(em.RelatedToId).Number_of_Quotes_Presented__c == null){
                qoteMap.get(em.RelatedToId).Number_of_Quotes_Presented__c = 0;
            }
            qoteMap.get(em.RelatedToId).Number_of_Quotes_Presented__c += 1;
        
        }
    }
    try{
        update caseMap.values();
        update oppMap.values();
        update qoteMap.values();
    } catch(Exception e){
        
    }
    }
}