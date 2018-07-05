/**
    * @author:          Prasun Banerjee
    * @date:            28/01/2016
    * @description:     The status of a quote must not be changed to Accepted if there is no purchase order save as attachement. This trigger will throw
                        an error if there is no attachment while updating the status to Accepted.
    * @param:           N/A 
    * @moficationlog:   N/A
    */

trigger Trigger_Quote on Quote (before insert, before update,After update){       
    List<String> OpptyIdList = new List<String>();
    Map<Id,Quote> QuoteIdMap=new Map<Id,Quote>();
    if(trigger.IsBefore){
        if(Trigger.isInsert && AvoidRecursion.quoteBeforeInsert())
        {
            for(Quote q : Trigger.new)
            {   
                system.debug('q:>>'+q);
                system.debug('q.OpportunityId:>>'+q.OpportunityId);
                Opportunity opp = [select recordtype.name from opportunity where id =: q.OpportunityId];
                system.debug('opp:>>'+opp);
                
                system.debug('ID value : '+q.opportunityid);
                boolean locked = Approval.isLocked(q.opportunityid);
                if(locked)
                    q.adderror('You cannot create a quote when the opportunity is in pending approval.');
                
                if(opp.RecordType.name != 'Online Payment')
                {
                    List<OpportunityContactRole> lstOppContactRoles = [SELECT ContactId,opportunity.recordtype.name,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRole where OpportunityId =: q.opportunityid and IsPrimary = True];
                    if(lstOppContactRoles.size() ==0)
                    q.adderror('You cannot create a quote when there is no primary contact role added in the opportunity.');
                }
                    
            }
            

            
        }
    
    
        if(Trigger.isUpdate && AvoidRecursion.quoteBeforeUpdate())
        {
            
            //Fetch the record type id for Commercial record type.
            RecordType RecTypeCommercial = [Select Id From RecordType  Where SobjectType = 'Opportunity' and DeveloperName = 'Commercial' ];
            RecordType RecTypeBid = [Select Id From RecordType  Where SobjectType = 'Opportunity' and DeveloperName = 'Bid' ];
            
            List<Quote> listQuotes = [select Id,opportunity.recordtypeid from quote where id IN : Trigger.newMap.keyset()];
            
            
            //Validation Rule that you can't accept Quote if another Quote is synced
            //Set contains Quote Id's
            SET<String> quoteIdset = new SET<String>();
            //Set 
            SET<String> OpptyIdSet = new SET<String>();
            for(Quote quotRec:Trigger.new){
                quoteIdset.add(quotRec.Id);
                OpptyIdSet.add(quotRec.OpportunityId);
            }
            
            List<Opportunity> opptyList = [SELECT ID,(SELECT ID,IsSyncing FROM Quotes WHERE ID IN:quoteIdset AND IsSyncing=False) FROM Opportunity WHERE ID IN:OpptyIdSet AND RecordTypeId=:RecTypeCommercial.id];
            List<Quote> QuoteList = new List<Quote>();
            for(Opportunity oppRec:opptyList){
                if(!oppRec.Quotes.isEmpty()){
                    for(Quote quoteRec:oppRec.Quotes){
                        Quote qt = trigger.newMap.get(quoteRec.id);
                        if(Trigger.oldMap.get( quoteRec.Id ).status != Trigger.newMap.get( quoteRec.Id ).status && Trigger.newMap.get(quoteRec.Id ).status=='Accepted'){
                            qt.adderror('Sync this Quote before you can change it to "Accepted"');
                        }
                    }
                }
            }
            
            //List<Quote> listQuotes = [select id from quote where id IN : trigger.new.keyset()];
            for(Quote q : listQuotes)
            {
                //In case of commercial record type only , the attachment is mandatory.
                if(q.Opportunity.recordtypeid == RecTypeCommercial.id || q.Opportunity.recordtypeid == RecTypeBid.id)
                {
                    //Check if the status field is changed to Accepted.
                    if(Trigger.oldMap.get( q.Id ).status != Trigger.newMap.get( q.Id ).status && Trigger.newMap.get(q.Id ).status=='Accepted')
                    {
                        
                        //Fetch all attachments for the quote.
                        //List<Attachment> lstAttachments = [SELECT Id,Name,ParentId FROM Attachment where parentId =:q.Id];
                        List<ContentDocumentLink > lstAttachments = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:q.Id];
                        
                        //IF there is no attachment, throw error to user.
                        if(lstAttachments.size() == 0)
                        {
                            Quote qt = trigger.newMap.get(q.id);

                            //throw new Exception('Please upload the PURCHASE ORDER from the customer before accepting the quote.');
                            qt.adderror('Please upload the PURCHASE ORDER from the customer before accepting the quote');
                        }
                        
                    }
                }                
            }      
        }
    
    }
    if(Trigger.isAfter && Trigger.isUpdate && AvoidRecursion.quoteAfterUpdate()){
        //List<OpportunityContactRole> lstOppContactRoles= new List<OpportunityContactRole>();
        for(Quote qt : Trigger.new){
            system.debug('qt.OpportunityId:>>'+qt.OpportunityId);
            if(qt.OpportunityId != null){
                //Opportunity opp = [select recordtype.name from opportunity where id =: qt.OpportunityId];
                
                if((qt.Status == 'Accepted' && Trigger.oldMap.get(qt.Id).Status != qt.Status)){
                    system.debug('ID value : '+qt.opportunityid);
                    //if(opp.RecordType.name != 'Commercial' || opp.RecordType.name != 'Bid' ){
                     //lstOppContactRoles = [SELECT ContactId,opportunity.recordtype.name,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRole where OpportunityId =: qt.opportunityid AND IsPrimary = True];
                    OpptyIdList.add(qt.OpportunityId);
                    QuoteIdMap.put(qt.OpportunityId, qt);
                    //OpptyIdList.add(opp.Id);
                                System.debug('OpptyIdList=>'+OpptyIdList);
    
                //}
                }
            }
        }
        if(QuoteTriggerHandler.run == true){
            System.debug('OpptyIdList=>'+OpptyIdList);
            //QuoteTriggerHandler.afterUpdateQuoteHandle(OpptyIdList);//,lstOppContactRoles);
            if(!OpptyIdList.isEmpty()){
                 System.debug('OpptyIdList=>'+OpptyIdList);
                //QuoteTriggerHandlerNew.createCommCase(OpptyIdList);
                QuoteTriggerHandlerNew.createCommCase(QuoteIdMap);
            }
        }
    }
}