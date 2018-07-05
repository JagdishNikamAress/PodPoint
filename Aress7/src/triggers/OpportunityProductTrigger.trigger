trigger OpportunityProductTrigger on OpportunityLineItem (after insert,after delete,before delete,before insert,before update, after update) {
    system.debug('Inside the OLI trigger ');
    Set<Id> oppIDs = new Set<Id>();
    Set<Id> OppLiId = new Set<Id>();
    Set<Id> oppIDswithSpProducts = new Set<Id>();
    Set<Id> OppsProductsToDelete = new Set<Id>();
    List<Opportunity> OppsUpdate = new List<Opportunity>(); 
    
    if(trigger.isAfter){
        if(trigger.isInsert){
            system.debug('Inside the OLI INSERT Trigger');
            for(OpportunityLineItem oli : trigger.new){
                if((oli.Product_Family__c=='Solo Units' || oli.Product_Family__c=='Twin Units' || oli.Product_Family__c=='Accessories' || oli.Product_Family__c=='Mounts') || test.isRunningTest())
                { 
                    oppIDs.add(oli.OpportunityId);
                OppLiId.add(oli.Id);
                }
            }
            system.debug('Opp Id -> '+ oppIDs);
            system.debug('OppLiId -> '+ OppLiId);
            
            //for child work order
            Map<Id,WorkOrder> WOMap = new Map<Id,WorkOrder>([SELECT Id,Opportunity_Id__c FROM WorkOrder WHERE Opportunity_Id__c in : oppIDs]);
            Map<Id,OpportunityLineItem> OLIMap = new Map<Id,OpportunityLineItem>([SELECT Id, OpportunityId, Product2Id,Quantity FROM OpportunityLineItem WHERE Id in : OppLiId]);
            List<ProductRequired> Prod = new List<ProductRequired>(); 
            system.debug('WOMap ---> '+ WOMap);
            for(WorkOrder wo : WOMap.values()){
                for(OpportunityLineItem oli : trigger.new)
                {
                    ProductRequired pr = new ProductRequired();
                    pr.ParentRecordId = wo.Id;
                    pr.Product2Id = oli.Product2Id;
                    pr.Opportunity__c = oli.OpportunityId;
                    pr.QuantityRequired = oli.Quantity;
                    pr.WO_OppLineItem_Id__c = oli.Id;
                    Prod.add(pr);
                }
            }        
            
            //for child work order line item         
            Map<Id,WorkOrderLineItem> WOLIMap = new Map<Id,WorkOrderLineItem>([SELECT Id,Opportunity_Id__c FROM WorkOrderLineItem WHERE Opportunity_Id__c in : oppIDs]);
            system.debug('WOLIMap ---> '+ WOLIMap);
            List<ProductRequired> Prod2 = new List<ProductRequired>(); 
            for(WorkOrderLineItem woli : WOLIMap.values()){
                for(OpportunityLineItem oli : trigger.new)
                {
                    ProductRequired pr = new ProductRequired();
                    pr.ParentRecordId = woli.Id;
                    pr.Product2Id = oli.Product2Id;
                    pr.Opportunity__c = oli.OpportunityId;
                    pr.QuantityRequired = oli.Quantity;
                    pr.WOLI_OppLineItem_Id__c= oli.Id;
                    Prod2.add(pr);
                }
            }
            try{
                insert Prod;
                system.debug('Inserted Product Required -> '+Prod);
                insert Prod2;
                system.debug('Inserted Product Required -> '+Prod2);
            }
            catch(exception e){
                system.debug('Exception -> '+e);
            }
        }
        
        if(trigger.isUpdate){
            /*system.debug('Inside the OLI UPDATE Trigger');
            for(OpportunityLineItem oli : trigger.new){
                oppIDs.add(oli.OpportunityId);
                OppLiId.add(oli.Id);
            }
            system.debug('Opp Id -> '+ oppIDs);
            system.debug('OppLiId -> '+ OppLiId);
            
            
            //for work order
            Map<Id,WorkOrder> WOMap = new Map<Id,WorkOrder>([SELECT Id,Opportunity_Id__c FROM WorkOrder WHERE Opportunity_Id__c in : (oppIDs)]);
            system.debug('WOMap -> '+ WOMap);
            Set<Id> WOid = new Set<Id>();
            for(WorkOrder w : WOMap.values()){
                WOid.add(w.Id);
            }
            system.debug('WOid -> '+ WOid);
            //List<ProductRequired> Prod = new List<ProductRequired>(); 
            Map<Id,ProductRequired> ProdReqMap = new Map<Id,ProductRequired>([SELECT Id,ParentRecordId,Product2Id, WO_OppLineItem_Id__c, WOLI_OppLineItem_Id__c,Opportunity__c FROM ProductRequired WHERE ParentRecordId in : WOid AND WO_OppLineItem_Id__c in : OppLiId]);
            system.debug('ProdReq -> '+ ProdReqMap);
             for(ProductRequired prreq : ProdReqMap.values()){
               // prreq.ParentRecordId = w.Id;
               // prreq.Product2Id = oli.Product2Id;
               // prreq.Opportunity__c = oli.OpportunityId;
               prreq.QuantityRequired = oli.Quantity;*/
              List<ProductRequired> prodReq = [select id,WOLI_OppLineItem_Id__c,WO_OppLineItem_Id__c,QuantityRequired from ProductRequired Where (WOLI_OppLineItem_Id__c IN : Trigger.NewMap.keyset() OR WO_OppLineItem_Id__c IN : Trigger.NewMap.keyset())];  
            for(OpportunityLineItem oli : Trigger.New){
                for(ProductRequired pr : prodReq){
                    if(pr.WO_OppLineItem_Id__c == oli.Id || pr.WOLI_OppLineItem_Id__c == oli.Id){
                        pr.QuantityRequired = oli.Quantity;
                    }
                }
            }                 
            update prodReq;
            }
            
            
        }
        
        
        if(trigger.isbefore){
        if(trigger.isdelete){
          List<ProductRequired> prodReq = [select id,WOLI_OppLineItem_Id__c,WO_OppLineItem_Id__c,QuantityRequired from ProductRequired Where (WOLI_OppLineItem_Id__c IN : Trigger.OldMap.keyset() OR WO_OppLineItem_Id__c IN : Trigger.OldMap.keyset())];  
            for(OpportunityLineItem oli : Trigger.Old){
                for(ProductRequired pr : prodReq){
                    if(pr.WO_OppLineItem_Id__c == oli.Id || pr.WOLI_OppLineItem_Id__c == oli.Id){
                        pr.QuantityRequired = oli.Quantity;
                    }
                }
            }                 
            delete prodReq;
            }
            
        }
        
        
    
    
    
    
    
    
    
    
    // methods written by Prasun
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            for(OpportunityLineItem ol : Trigger.new){
                oppIDs.add(ol.opportunityid);
            }
        } else if(trigger.isDelete){
            for(OpportunityLineItem ol : Trigger.old){
                oppIDs.add(ol.opportunityid);
            }
        }
        
        Map<String,Opportunity> oppMap = new Map<String,Opportunity>([select id,stagename,recordtype.name from opportunity where id IN : oppIds]);
        
        if(trigger.isInsert || trigger.isUpdate)
        {
            for(OpportunityLineItem ol : Trigger.new)
            {
                if(!oppMap.isEmpty()){
                if(oppMap.get(ol.opportunityid).stagename == 'Won' && oppMap.get(ol.opportunityid).recordtype.name == 'Online Payment')
                {
                    if(trigger.isInsert || trigger.isUpdate)
                    {
                        ol.addError('Opportunity is Alredy WON');
                    } 
                }
                }
            }
        }
        
        
        if(trigger.isDelete){
            for(OpportunityLineItem ol : Trigger.old){
                if(oppMap.get(ol.opportunityid).stagename == 'Won' && oppMap.get(ol.opportunityid).recordtype.name == 'Online Payment'){
                    if(trigger.isDelete){
                        ol.addError('Opportunity is Alredy WON');
                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Opportunity is Alredy WON'));
                    }
                }
            }
        }
    }
    
    //Get all opps product items where a Managed install product is deleted, in that case the flag on Opp need to be unchecked.    
    if(Trigger.isDelete && Trigger.isAfter)
    {
        for (OpportunityLineItem olt : Trigger.old)
        {
            if(olt.ProductCode == 'Mngd_Inst')
                oppIDs.add(olt.opportunityid);
            
            if(olt.ProductCode == 'S7-UP-OFFER' || olt.ProductCode == 'S7-UP-2-OFFER')
                oppIDswithSpProducts.add(olt.opportunityid);
        }
        
        
        List<Opportunity> lstOpps = [select id,Managed_Installation__c from opportunity where ID IN :oppIDs];
        
        //Pulls all opp product line item which are either 'S7-UP-2-OFFER' OR 'S7-UP-OFFER'
        Map<Id,Opportunity> oppWithProducts = new Map<Id,Opportunity>(
            [SELECT id,(SELECT Id,ProductCode FROM opportunitylineitems where ProductCode = 'S7-UP-2-OFFER' or ProductCode = 'S7-UP-OFFER') FROM Opportunity WHERE Id IN :oppIDswithSpProducts]);
        
        
        //Checks if there is any other product with product code 'S7-UP-2-OFFER' OR 'S7-UP-OFFER'
        for(ID oppid : oppWithProducts.keyset()){
            if(oppWithProducts.get(oppid).opportunitylineitems.size() == 0)
                OppsProductsToDelete.add(oppid);
        }
        
        
        List<OpportunityLineItem> lstOppsLineItemsToDelete = [select id from OpportunityLineItem where opportunityid IN :OppsProductsToDelete and productcode = 'Mngd_Inst'];
        
        for(opportunity opp : lstOpps)
        {
            opp.Managed_Installation__c = false;
            
            OppsUpdate.add(opp);
        }
        
        update OppsUpdate;
        
        //Deletes the managed product if all products with code 'S7-UP-2-OFFER' OR 'S7-UP-OFFER' are deleted
        delete lstOppsLineItemsToDelete;
    }
    
    
}