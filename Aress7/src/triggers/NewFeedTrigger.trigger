trigger NewFeedTrigger on FeedItem (after Insert,after Delete,after Update) {
    
    if(Trigger.isAfter){
        if((Trigger.isInsert && AvoidRecursion.feedAfterInsert())|| (Trigger.isUpdate && AvoidRecursion.feedAfterUpdate())){
            System.debug('in feed trigger');
            Set<Id> feeditemIDWOSet= new Set<Id>();
            for(FeedItem fe : Trigger.New){
                feeditemIDWOSet.add(fe.ParentId);
                System.debug('fe.ParentId==>'+fe.ParentId);
            }
            Map <Id,WorkOrder> woMap=new  Map <Id,WorkOrder>([SELECT ID, Missing_Comment__c ,(select id, body from feeds order by CreatedDate)FROM WorkOrder WHERE ID in: feeditemIDWOSet]);
            System.debug('woMap==>'+woMap);
            Map <Id,WorkOrder> woList= new Map <Id,WorkOrder>();
            for(WorkOrder wo: woMap.values()){
                System.debug(' wo==>'+wo);
                for(WorkOrderFeed feRec: wo.feeds){
                    System.debug(' feRec==>'+feRec);
                    if(feRec.Body==null && feRec.Id!=wo.feeds.get(1).Id && feRec.Id!=wo.feeds.get(0).Id){
                        System.debug(' feRec.body==>'+feRec.Body);
                        //wo.Missing_Comment__c = True;
                        woList.put(wo.Id,wo);
                    }
                }
                if(!woList.isEmpty()){
                    wo.Missing_Comment__c=true;
                } else if(woList.isEmpty()){
                    wo.Missing_Comment__c=false;
                }
            }
            
            update woMap.values();
        }
        
        
         if(Trigger.isDelete && AvoidRecursion.feedAfterDelete()){
            System.debug('in feed trigger');
            Set<Id> feeditemIDWOSet= new Set<Id>();
            for(FeedItem fe : Trigger.Old){
                feeditemIDWOSet.add(fe.ParentId);
                System.debug('fe.ParentId==>'+fe.ParentId);
            }
            Map <Id,WorkOrder> woMap=new  Map <Id,WorkOrder>([SELECT ID, Missing_Comment__c ,(select id, body from feeds order by CreatedDate)FROM WorkOrder WHERE ID in: feeditemIDWOSet]);
            System.debug('woMap==>'+woMap);
            Map <Id,WorkOrder> woList= new Map <Id,WorkOrder>();
            for(WorkOrder wo: woMap.values()){
                System.debug(' wo==>'+wo);
                for(WorkOrderFeed feRec: wo.feeds){
                    System.debug(' feRec==>'+feRec);
                    if(feRec.Body==null && feRec.Id!=wo.feeds.get(1).Id && feRec.Id!=wo.feeds.get(0).Id){
                        System.debug(' feRec.body==>'+feRec.Body);
                        //wo.Missing_Comment__c = True;
                        woList.put(wo.Id,wo);
                    }
                }
                if(!woList.isEmpty()){
                    wo.Missing_Comment__c=true;
                } else if(woList.isEmpty()){
                    wo.Missing_Comment__c=false;
                }
            }
            
            update woMap.values();
        }
        
    }       

    
    
    /* if(Trigger.isAfter){
if(Trigger.isInsert){
WorkOrder woToUpdate;
for(FeedItem f : Trigger.New){  
woToUpdate = [SELECT ID, Missing_Comment__c FROM WorkOrder WHERE ID =: f.ParentId];
if(String.valueof(f.ParentId).substring(0,3) == '0WO'){
if(f.Body==NULL){
If(woToUpdate.Missing_Comment__c == False){
woToUpdate.Missing_Comment__c = True;       
}  
}else{
woToUpdate.Missing_Comment__c = False;
}
} 
}
Update woToUpdate;
}
if(Trigger.isDelete || Trigger.isUpdate){
WorkOrder woToUpdate;
for(FeedItem f : Trigger.Old){  
woToUpdate = [SELECT ID, Missing_Comment__c FROM WorkOrder WHERE ID =: f.ParentId];
if(String.valueof(f.ParentId).substring(0,3) == '0WO'){

woToUpdate.Missing_Comment__c = False;

} 
}
Update woToUpdate;
}
}*/
}