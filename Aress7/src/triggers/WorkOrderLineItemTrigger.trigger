trigger WorkOrderLineItemTrigger on WorkOrderLineItem (after insert, after update) {
    
    Set<Id> WOLIId = new Set<Id>();
    Set<Id> OppId = new Set<Id>();
    
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            for(WorkOrderLineItem woli:Trigger.new){
                WOLIId.add(woli.Id);
                OppId.add(woli.Opportunity_Id__c);
            }
            system.debug('WOLI Id -> '+WOLIId);
            system.debug('Opp Id -> '+OppId);
            
            Map<Id, OpportunityLineItem> oliMap = new Map<Id, OpportunityLineItem>([SELECT Id, OpportunityId, Product2Id,Quantity FROM OpportunityLineItem WHERE OpportunityId =: OppId]);
            system.debug('OLI List -> '+oliMap);
            
            Map<Id,WorkOrderLineItem> WOLIMap = new Map<Id,WorkOrderLineItem>([SELECT Id FROM WorkOrderLineItem WHERE Id in : WOLIId]);
            List<ProductRequired> Prod = new List<ProductRequired>();        
            for(WorkOrderLineItem w : WOLIMap.values()){
                for(OpportunityLineItem oli : oliMap.values()){
                    ProductRequired pr = new ProductRequired();
                    pr.ParentRecordId = w.Id;
                    pr.Product2Id = oli.Product2Id;
                    pr.Opportunity__c = oli.OpportunityId;
                    pr.QuantityRequired = oli.Quantity;
                    pr.WOLI_OppLineItem_Id__c = oli.id;
                    Prod.add(pr);
                }
            }
            
            try{
                insert Prod;
                system.debug('Inserted Product Required -> '+Prod);
            }
            catch(exception e){
                system.debug('Exception -> '+e);
            }
        }
    }
}