trigger OpportunityTrigger on Opportunity (after update,after insert,before update,before Insert) {
    System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
    List<String> opptyids = new List<String>();
    List<String> oppIdList = new List<String>();
    List<String> oppIdsForOp = new List<String>();
    Id hcRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Charge').getRecordTypeId();
    Id opRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId();
    Id commRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();
    Id CommcaseRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
    if(Trigger.isBefore){
        if(Trigger.isUpdate ){
         //   System.debug('');
        //Condition checks whether the Syrvey & Install status is changed
        for(Opportunity opptyRec : Trigger.new){
            
            
                       SET<ID> accIdSet = new SET<ID>();
            for(Opportunity oppRec1:Trigger.New){
                if(oppRec1.AccountId!=Trigger.oldMap.get(oppRec1.Id).AccountId && oppRec1.AccountId!=NULL)
                accIdSet.add(oppRec1.AccountId);
            }
            
            if(!accIdSet.isEmpty()){
                Map<ID,Account> accIdAccountMap = new Map<ID,Account>([SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingCountryCode, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCountryCode FROM Account WHERE ID IN: accIdSet]);
                for(Opportunity oppRec : Trigger.new){
                    System.debug('oppRec.AccountId=>'+oppRec.AccountId +oppRec.Account.BillingStreet +oppRec.Account.BillingCity +oppRec.Account.BillingPostalCode +oppRec.Account.BillingCountry );
                    if(oppRec.AccountId!=NULL){
                        oppRec.Billing_Street__c =accIdAccountMap.get(oppRec.AccountId).BillingStreet;
                        oppRec.Billing_City__c =accIdAccountMap.get(oppRec.AccountId).BillingCity;
                        oppRec.Billing_Postal_Code__c = accIdAccountMap.get(oppRec.AccountId).BillingPostalCode;
                        oppRec.Billing_Country_Picklist__c = accIdAccountMap.get(oppRec.AccountId).BillingCountry;
                        oppRec.Billing_State__c = accIdAccountMap.get(oppRec.AccountId).BillingState;
                        oppRec.Shipping_Street__c = accIdAccountMap.get(oppRec.AccountId).ShippingStreet;
                        oppRec.Shipping_City__c = accIdAccountMap.get(oppRec.AccountId).ShippingCity;
                        oppRec.Shipping_Postal_Code__c = accIdAccountMap.get(oppRec.AccountId).ShippingPostalCode;
                        oppRec.Shipping_Country_Picklist__c = accIdAccountMap.get(oppRec.AccountId).ShippingCountry;
                        oppRec.Shipping_State__c = accIdAccountMap.get(oppRec.AccountId).ShippingState;
                    }
                }
            }

            
            
            System.debug(Trigger.oldMap.get(opptyRec.Id).Install_Status_New__c != opptyRec.Install_Status_New__c);
            System.debug(Trigger.oldMap.get(opptyRec.Id).Survey_Status__c != opptyRec.Survey_Status__c );
            if(Trigger.oldMap.get(opptyRec.Id).Survey_Status__c != opptyRec.Survey_Status__c || Trigger.oldMap.get(opptyRec.Id).Install_Status_New__c != opptyRec.Install_Status_New__c){
                 if(opptyRec.StageName!='Closed'){
                system.debug('Trigger.oldMap.get(opptyRec.Id).Survey_Status__c=>' +Trigger.oldMap.get(opptyRec.Id).Survey_Status__c);
                     if(opptyRec.Install_Status_New__c==NUll && opptyRec.RecordTypeId==commRecordTypeId && opptyRec.Probability < 100){
                            if(opptyRec.Survey_Status__c=='Requested')
                                opptyRec.StageName = 'Survey Requested';
                            if(opptyRec.Survey_Status__c=='Scheduled')
                                opptyRec.StageName = 'Survey Scheduled';
                            if(opptyRec.Survey_Status__c=='Completed')
                                opptyRec.StageName = 'Survey Completed';
                            if(opptyRec.Survey_Status__c=='Incomplete')
                                opptyRec.StageName = 'Survey Incomplete';
                            if(opptyRec.Survey_Status__c=='On Hold')
                                opptyRec.StageName = 'Survey On Hold';
                            if(opptyRec.Survey_Status__c=='Rejected')
                                opptyRec.StageName = 'Survey Cancelled';
                            if(opptyRec.Survey_Status__c=='Quoted')
                                opptyRec.StageName = 'Survey Quoted';
                        }  
                        
                        if(opptyRec.StageName!='Invoiced'){
                            if(opptyRec.RecordTypeId==commRecordTypeId && opptyRec.Probability < 1){
                                if(opptyRec.Survey_Status__c=='Requested')
                                    opptyRec.StageName = 'Survey Requested';
                                if(opptyRec.Survey_Status__c=='Scheduled')
                                    opptyRec.StageName = 'Survey Scheduled';
                                if(opptyRec.Survey_Status__c=='Completed')
                                    opptyRec.StageName = 'Survey Completed';
                                if(opptyRec.Survey_Status__c=='Incomplete')
                                    opptyRec.StageName = 'Survey Incomplete';
                                if(opptyRec.Survey_Status__c=='On Hold')
                                    opptyRec.StageName = 'Survey On Hold';
                                if(opptyRec.Survey_Status__c=='Rejected')
                                    opptyRec.StageName = 'Survey Cancelled';
                                if(opptyRec.Survey_Status__c=='Quoted')
                                    opptyRec.StageName = 'Survey Quoted';
                            }
                            if(opptyRec.Install_Status_New__c=='Requested')
                                opptyRec.StageName = 'Install Requested';
                            if(opptyRec.Install_Status_New__c=='Scheduled')
                                opptyRec.StageName = 'Install Scheduled';
                            if(opptyRec.Install_Status_New__c=='Completed')
                                opptyRec.StageName = 'Install Completed';
                            if(opptyRec.Install_Status_New__c=='Incomplete')
                                opptyRec.StageName = 'Install Incomplete';
                            if(opptyRec.Install_Status_New__c=='On Hold')
                                opptyRec.StageName = 'Install On Hold';
                            if(opptyRec.Install_Status_New__c=='Rejected')
                                opptyRec.StageName = 'Install Cancelled';
                            if(opptyRec.Install_Status_New__c=='Verified')
                                opptyRec.StageName = 'Install Verified';
                             if(opptyRec.Install_Status_New__c=='Confirmed')
                                opptyRec.StageName = 'Install Confirmed';
                        }  
                 }
            }
        }
        if(OpportunityTriggerHandler.run == true){
            if(!oppIdList.isEmpty()){
              //  OpportunityTriggerHandler.syncSurveyInstallStatToStage(oppIdList);
              
            }
        }
        }
        if(Trigger.isInsert  && AvoidRecursion.OpptyBeforeInsert()){
            SET<ID> accIdSet = new SET<ID>();
            for(Opportunity oppRec1:Trigger.New){
                accIdSet.add(oppRec1.AccountId);
            }
            
            if(!accIdSet.isEmpty()){
                Map<ID,Account> accIdAccountMap = new Map<ID,Account>([SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingCountryCode, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCountryCode FROM Account WHERE ID IN: accIdSet]);
                for(Opportunity oppRec : Trigger.new){
                    System.debug('oppRec.AccountId=>'+oppRec.AccountId +oppRec.Account.BillingStreet +oppRec.Account.BillingCity +oppRec.Account.BillingPostalCode +oppRec.Account.BillingCountry );
                    if(oppRec.AccountId!=NULL){
                        oppRec.Billing_Street__c =accIdAccountMap.get(oppRec.AccountId).BillingStreet;
                        oppRec.Billing_City__c =accIdAccountMap.get(oppRec.AccountId).BillingCity;
                        oppRec.Billing_Postal_Code__c = accIdAccountMap.get(oppRec.AccountId).BillingPostalCode;
                        oppRec.Billing_Country_Picklist__c = accIdAccountMap.get(oppRec.AccountId).BillingCountry;
                        oppRec.Billing_State__c = accIdAccountMap.get(oppRec.AccountId).BillingState;
                        oppRec.Shipping_Street__c = accIdAccountMap.get(oppRec.AccountId).ShippingStreet;
                        oppRec.Shipping_City__c = accIdAccountMap.get(oppRec.AccountId).ShippingCity;
                        oppRec.Shipping_Postal_Code__c = accIdAccountMap.get(oppRec.AccountId).ShippingPostalCode;
                        oppRec.Shipping_Country_Picklist__c = accIdAccountMap.get(oppRec.AccountId).ShippingCountry;
                        oppRec.Shipping_State__c = accIdAccountMap.get(oppRec.AccountId).ShippingState;
                    }
                }
            }
        }
            
    }
    
    if(Trigger.isAfter && Trigger.isUpdate ){
        System.debug('Inside Trigger=>');
        
        
        //List<Opportunity> opportunities = [SELECT Id,Recordtype.Name FROM Opportunity WHERE ID IN:trigger.new];
        //The OR condition is added for handling the stage 'Qualified' and 'Home charge' record type.
        for(Opportunity o : Trigger.new){//opportunities){
            System.debug('Inside For=>');
            System.debug('o=>'+o);
            System.debug('o.StageName=>'+o.StageName);
            System.debug('Trigger.oldMap.get(o.Id).stagename=>'+Trigger.oldMap.get(o.Id).stagename);
            System.debug('hcRecordTypeId=>'+hcRecordTypeId);
            System.debug('o.RecordTypeId=>'+o.RecordTypeId);
            
            //Condition checks whether the Syrvey & Install status is changed
           /* if(Trigger.oldMap.get(o.Id).Survey_Status__c != o.Survey_Status__c || Trigger.oldMap.get(o.Id).Install_Status_New__c != o.Install_Status_New__c){
                system.debug('Trigger.oldMap.get(o.Id).Survey_Status__c=>' +Trigger.oldMap.get(o.Id).Survey_Status__c);
                oppIdList.add(o.id);
            }*/
            
            //Adding OpptyIds for Create/Clone Workorders
            if(o.StageName == 'Won' && Trigger.oldMap.get(o.Id).stagename != o.StageName && o.RecordTypeId ==opRecordTypeId){
                system.debug('o.id=>'+o.id);
                oppIdsForOp.add(o.id);
            }
            system.debug('oppIdsForOp=>' +oppIdsForOp);
            
            //The OR condition is added to handle the copndition when stage becomes 'Qualified' for 'Home charge' record type on Opportunity.
            if((o.StageName == 'Won' && Trigger.oldMap.get(o.Id).stagename != o.StageName) ||
                (o.StageName == 'Qualified' && Trigger.oldMap.get(o.Id).stagename != o.StageName && o.RecordTypeId ==hcRecordTypeId) ||
                (o.StageName == 'Install Requested' && Trigger.oldMap.get(o.Id).stagename != o.StageName && o.RecordTypeId ==hcRecordTypeId)||
              (o.StageName == 'Install Requested' && Trigger.oldMap.get(o.Id).stagename != o.StageName && o.RecordTypeId ==commRecordTypeId )){
                    System.debug('Inside If=>WON');
                    opptyids.add(o.id);
            }
            
            
         }
         if(OpportunityTriggerHandler.run == true){
            if(!oppIdsForOp.isEmpty()){
                system.debug('oppIdsForOp=>' +oppIdsForOp);
                //OpportunityTriggerHandler.createCloneOnlineOppty(oppIdsForOp);
            }
        }
        if(OpportunityTriggerHandler.run == true){
            if(!opptyids.isEmpty()){
                        list<case> Caselist = [select id, Opportunity__c from case where Opportunity__c IN : opptyids and recordtypeid =: CommcaseRecordTypeId ]; 

                OpportunityTriggerHandler.handleAfterUpdate(opptyids,caselist);
            }
        }
        /*if(OpportunityTriggerHandler.run == true){
            if(!oppIdList.isEmpty()){
                OpportunityTriggerHandler.syncSurveyInstallStatToStage(oppIdList);
            }
        }*/
     }
    
    
    /*logic for Quick action button in progress
    Set<Id> OppId = new Set<Id>();
    // Set<Id> OppId = new Set<Id>();
    if(trigger.isAfter && trigger.isInsert){
        
        for(Opportunity opp:Trigger.new){
            OppId.add(opp.Id);
            
        }
        Map<Id,Opportunity> OppMap = new Map<Id,Opportunity>([SELECT Id, IsCreatedByQuickAction__c FROM Opportunity WHERE Id in : OppId]);
        
    }
    
    
  */     
    /*
    if(Trigger.isAfter && Trigger.isInsert){
        System.debug('Inside after Insert Trigger=>');
        
        //List<Opportunity> opportunities = [SELECT Id,Recordtype.Name FROM Opportunity WHERE ID IN:trigger.new];
        //The OR condition is added for handling the stage 'Qualified' and 'Home charge' record type.
        for(Opportunity o : Trigger.new){//opportunities){
            //The OR condition is added to handle the copndition when stage becomes 'Qualified' for 'Home charge' record type on Opportunity.
            if((o.StageName == 'Qualified' && o.RecordTypeId ==hcRecordTypeId))
            {
                System.debug('Inside after insert If=>WON');
                ls.add(o.id);
            }
         }
        if(OpportunityTriggerHandler.run == true){
            OpportunityTriggerHandler.handleAfterUpdate(ls);
        }
    }*/
    /*
    Set<String> oldVals = new Set<String>{'Won','Intsall Requested','Install Scheduled','Install Complete','Invoiced'};
    Set<String> newVals = new Set<String>{'Qualification','Developing Proposal','Awaiting Sign Off','Negotiation','Survey Requested', 
                                            'Survey Scheduled','Survey Quoted','Survey Complete'};
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Opportunity opp:Trigger.new){
            try{
            if(oldVals.contains(Trigger.oldMap.get(opp.Id).StageName) && newVals.contains(opp.StageName)){
                
                    opp.StageName.addError('You can not change stage');
                }
                
            }catch(Exception e){}
        }
    }*/
    /*
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            for(Opportunity oppRec : Trigger.new){
                if(oppRec.AccountId!=NULL){
                    if((oppRec.Billing_Street__c==NULL || oppRec.Billing_City__c==NULL|| oppRec.Billing_Postal_Code__c==NULL|| oppRec.Billing_Country_Picklist__c==NULL|| oppRec.Billing_State__c==NULL) && oppRec.RecordTypeId ==commRecordTypeId){
                        oppRec.Billing_Street__c =oppRec.Account.BillingStreet;
                        oppRec.Billing_City__c =oppRec.Account.BillingCity;
                        oppRec.Billing_Postal_Code__c = oppRec.Account.BillingPostalCode;
                        oppRec.Billing_Country_Picklist__c = oppRec.Account.BillingCountry;
                        oppRec.Billing_State__c = oppRec.Account.BillingState;
                    }
                }
            }
        }
    }*/
  System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
}