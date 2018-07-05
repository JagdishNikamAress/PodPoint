trigger SocailPostTrigger on SocialPost (after insert,after Update) {
    Id SupportCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId();
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            Map<Id,List<SocialPost>> CaseIdSpMap = new Map<Id,List<SocialPost>>();
            Map<ID, Case> caseIsCaseMap = new Map<ID, Case>();
            List<Case> caseList = [SELECT ID, Status,(SELECT ID, Status,IsOutbound, MessageType,ParentId,Handle FROM Posts WHERE ID IN: Trigger.newMap.keySet()) FROM Case WHERE RecordTypeId =:SupportCaseRecordTypeId];
            for(Case caseRec1:caseList){
                for(SocialPost spRec:caseRec1.Posts){
                    CaseIdSpMap.put(spRec.ParentId,caseRec1.Posts);
                    caseIsCaseMap.put(caseRec1.Id,caseRec1);
                }
            }
            
            //List<Case> caseList = [SELECT ID, Status FROM Case WHERE ID IN:CaseIdSpMap.keySet()];
            if(!CaseIdSpMap.isEmpty()){
                for(ID caseId :CaseIdSpMap.keySet()){
                    List<socialPost> socialPostList = CaseIdSpMap.get(caseId);
                    for(SocialPost postRec:socialPostList){
                        //postRec.MessageType=='Tweet' && CaseIdSpMap.keySet().Contains(postRec.ParentId)
                        //Reply from PodPoint
                        if(postRec.IsOutbound == True){
                            caseIsCaseMap.get(postRec.ParentId).Status = 'Pending';
                        }
                        
                        //Reply from Customer
                        if(postRec.IsOutbound == False){
                            caseIsCaseMap.get(postRec.ParentId).Status = 'Open';
                        }
                        
                        //if(postRec.MessageType=='Reply' && CaseIdSpMap.keySet().Contains(postRec.ParentId)){
                        //Direct from Podpoint
                       /* 
                        if(postRec.MessageType=='Direct' && postRec.Handle=='StagingPP'){
                            caseIsCaseMap.get(postRec.ParentId).Status = 'Pending';
                            //Case caseRec2 = caseIsCaseMap.get(postRec.ParentId);
                            //caseRec2.Status = 'Open';
                        }
                        //Direct from Customer
                        if(postRec.MessageType=='Direct' && postRec.Handle!='StagingPP'){
                            caseIsCaseMap.get(postRec.ParentId).Status = 'Open';
                        }
                        
                        //Tweet from PodPoint
                        if(postRec.MessageType=='Tweet' && postRec.Handle=='StagingPP'){
                            caseIsCaseMap.get(postRec.ParentId).Status = 'Pending';
                        }
                        //Tweet from Customer
                        if(postRec.MessageType=='Tweet' && postRec.Handle!='StagingPP'){
                            caseIsCaseMap.get(postRec.ParentId).Status = 'Open';
                        }*/
                    }
                }
                update caseIsCaseMap.values();
            }
        }
    }
    
    
     /*
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
           
            Set<Id> caseIdset= new Set<Id>();
            for(SocialPost sopo: Trigger.new){
                if(sopo.Handle!=Trigger.oldMap.get(sopo.Id).Handle && sopo.Handle=='StagingPP' ){
                    caseIdset.add(sopo.ParentId);
                }
            }
            if(!caseIdset.isEmpty()){
                List<Case> caseList= new List<case>([Select id, Status from case where Id in: caseIdset]);
                List<Case> caseLisToUpdate= new List<case>();
                if(!caseList.isEmpty()){
                    for(case cs: caseList){
                        cs.Status='Pending';
                        caseLisToUpdate.add(cs);
                    }
                    if(!caseLisToUpdate.isEmpty()){
                        Update caseLisToUpdate;
                    }
                    
                }
                
            }
            
        }
    }
            
            
            */
            
            
            
          
}