public class QuoteTriggerHandler {
public static boolean run = true;

//Create Commercial Case for commercial oppty and Bid oppty
//@Future(Callout=true)
public static void createCommercialCase(String AccountID,Map<String,List<WorkOrder>> caseWOMap,Opportunity oppty ){//,List<Case> CommercialCases,List<OpportunityContactRole> contRoles){
    Case cs = new Case();
    WorkOrder wOrder = new WorkOrder();
    
    //List<Opportunity> oppties = [SELECT ID,Name,Shipping_City__c,Shipping_Street__c,Shipping_State__c, Shipping_Country__c FROM Opportunity WHERE ID =:oppty.Id];
    
   // List<Case> commCases = [SELECT Id,(SELECT ID,RecordType.Name FROM WorkOrders WHERE RecordType.Name='Commercial Install'),RecordType.Name FROM Case WHERE RecordType.Name='Commercial Case'];
    List<WorkOrder> wOrders = new List<WorkOrder>();
    WorkType wt = [select id, name from WorkType where name='Install (Commercial)' LIMIT 1];
    Id cwoRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
    Id ccRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
    System.debug('caseWOMap=>'+caseWOMap);
    System.debug('oppty=>'+oppty);
    
    List<Opportunity> opptyList = [SELECT ID,Name,Shipping_City__c,Shipping_Street__c,Shipping_State__c, Shipping_Country__c,
    (SELECT Id,RecordTypeId,Opportunity__c,AccountId,Street__c,City__c,Country_Picklist__c,Type FROM Cases__r)
    FROM Opportunity WHERE ID =:oppty.Id];
    
    List<Case> caseList= [select id,casenumber,street__c,city__c,country_picklist__c,postalcode__c,Opportunity__c,
                  Install_Cost_Quote_2__c,Install_Cost_Quote__c,Install_Hours_2__c,Install_Hours__c,
                  Scope_of_Work__c,Scope_of_Works_2__c,
                  (SELECT ID,RecordType.Name,Status FROM WorkOrders WHERE RecordType.Name='Commercial Install' AND (Status='Completed' OR Status='Incomplete' OR Status='Rejected'))
                  from case where Type = 'Commercial' AND Opportunity__c =:oppty.Id];
    
    for(Opportunity opptyRec:opptyList){
        if(caseList.isEmpty()){
            cs.RecordTypeId = ccRecordTypeId;
            cs.Opportunity__c = oppty.Id;
            cs.AccountId = AccountID;
            //cs.ContactId = contRoles[0].Id;
            cs.Street__c = opptyRec.Shipping_Street__c;
            cs.City__c = opptyRec.Shipping_City__c;
            cs.Country_Picklist__c = opptyRec.Shipping_Country__c;
            //PostalCode__c = oppties[0].
            cs.Type = 'Commercial';
            
            insert cs;
            
            wOrder.RecordTypeId = cwoRecordTypeId;
            wOrder.WorkTypeId = wt.Id ;
            wOrder.Status = 'Confirmed';
            wOrder.CaseId = cs.Id;
            wOrders.add(wOrder);
           // insert wOrders;
        }else{
            for(Case caseRec:caseList){
                if(caseRec.WorkOrders.size()>0){
                    for(WorkOrder wo:caseRec.WorkOrders){
                        if(wo.Status=='Complete'||wo.Status=='Incomplete'||wo.Status=='Rejected'){
                                wOrders.add(new WorkOrder(RecordTypeId = cwoRecordTypeId,WorkTypeId = wt.Id ,Status = 'Confirmed',CaseId = caseRec.Id));
                            }else{
                            caseRec.addError('There is already a pending Install.');
                        }
                    }
                }//else{
                 //    caseRec.addError('There is already a pending Install.');
                 //   }
            }
        }
    }
    insert wOrders;
    /*if(CommercialCases != null){
        if(CommercialCases.size()>0){
            //List<Case> commCases = [SELECT Id,(SELECT ID,RecordType.Name FROM WorkOrders WHERE RecordType.Name='Commercial Install'),RecordType.Name FROM Case WHERE RecordType.Name='Commercial Case'];
            for(Case c:commCases){
                for(WorkOrder wo:c.WorkOrders){
                    if(wo.Status=='Complete'||wo.Status=='Incomplete'||wo.Status=='Rejected'){
                        wOrders.add(new WorkOrder(RecordTypeId = cwoRecordTypeId,WorkTypeId = wt.Id ,Status = 'Confirmed',CaseId = c.Id));
                    }
                    else{
                        wo.addError('There is already a pending Install.');
                    }
                }
            }
            insert wOrders;
        }
        else{
            cs.RecordTypeId = ccRecordTypeId;
            cs.Opportunity__c = OppID;
            cs.AccountId = AccountID;
            //cs.ContactId = contRoles[0].Id;
            cs.Street__c = oppties[0].Shipping_Street__c;
            cs.City__c = oppties[0].Shipping_City__c;
            cs.Country_Picklist__c = oppties[0].Shipping_Country__c;
            //PostalCode__c = oppties[0].
            cs.Type = 'Commercial';
            
            insert cs;
            
            wOrder.RecordTypeId = cwoRecordTypeId;
            wOrder.WorkTypeId = wt.Id ;
            wOrder.Status = 'Confirmed';
            wOrder.CaseId = cs.Id;
            wOrders.add(wOrder);
            insert wOrders;
        }
    }  */      
    //else{
        
    //}
   // return cs;
}

public static Map<id,Opportunity> oppMap;
Public static void afterUpdateQuoteHandle(List<String> opptIds){//,List<OpportunityContactRole> OpptycontactRoles){
    boolean hasManagedInstallProduct = false;
    Integer i = 0;
    
    //Commercial Case creation
    /*Map<Integer,Case> mapCommCaseToCreate = new Map<Integer,Case>();
    List<Case> cases= [select id,casenumber,street__c,city__c,country_picklist__c,postalcode__c,Opportunity__c,
                  Install_Cost_Quote_2__c,Install_Cost_Quote__c,Install_Hours_2__c,Install_Hours__c,
                  Scope_of_Work__c,Scope_of_Works_2__c from case where Type = 'Commercial' AND Opportunity__c IN : opptIds];
    Map<String,List<Case>> oppCommCaseMap = new Map<String,List<Case>>();
    for(Case c : cases){
        if(oppCommCaseMap.keySet().contains(c.Opportunity__c)){
            oppCommCaseMap.get(c.Opportunity__c).add(c);
        } else {
            List<Case> cl = new List<case>();
            cl.add(c);
            oppCommCaseMap.put(c.Opportunity__c, cl);
        }
    }*/
    
    List<Case> caseList= [select id,casenumber,street__c,city__c,country_picklist__c,postalcode__c,Opportunity__c,
                  Install_Cost_Quote_2__c,Install_Cost_Quote__c,Install_Hours_2__c,Install_Hours__c,
                  Scope_of_Work__c,Scope_of_Works_2__c,
                  (SELECT ID,RecordType.Name FROM WorkOrders WHERE RecordType.Name='Commercial Install' )//OR Status='Complete' OR Status='Incomplete' OR Status='Rejected')
                  from case where Type = 'Commercial' AND Opportunity__c IN : opptIds];
                  
    System.debug('caseList=>'+caseList);
    Map<String,Map<String,List<WorkOrder>>> oppCaseWoMap = new Map<String,Map<String,List<WorkOrder>>>();
    for(String str:opptIds){
        for(Case caseRec:caseList){
            for(WorkOrder wo:caseRec.WorkOrders){
                oppCaseWoMap.put(str,new Map<String,List<WorkOrder>>{caseRec.Id=>caseRec.WorkOrders});
            }
        }
    }
    
    
    
    oppMap = new Map<id,Opportunity>([select Id,Name,recordtype.name,StageName,accountid,account.type, Pricebook2Id,  
                                      account.shippingstreet,account.shippingcity,account.shippingcountry,account.shippingpostalcode,
                                      account.billingstreet,account.billingcity,account.billingcountry,account.billingpostalcode,
                                      Shipping_City__c,Shipping_Street__c,Shipping_State__c, Shipping_Country__c,
                                      (SELECT Id,product_family__c,productcode,quantity,unitprice, PricebookEntryId  FROM opportunitylineitems WHERE ProductCode = 'Mngd_Inst'),
                                      (SELECT Id FROM orders),
                                      (select contactid from opportunitycontactroles where IsPrimary = true),
                                      (SELECT Id,shippingstreet,shippingcity,shippingpostalcode,shippingcountry,billingstreet,billingcity,billingpostalcode,billingcountry FROM quotes where status = 'Accepted')
                                        from Opportunity where id IN : opptIds]);
    
    
    for(String s : opptIds){
        Opportunity opp;
        if(oppMap.keyset().contains(s)){
                    opp = oppMap.get(s);
        }
        if(opp.recordtype.name == 'Commercial' || opp.recordtype.name == 'Bid'){
            //mapCommCaseToCreate.put(i,createCommercialCase(opp.AccountId,opp.id,oppCommCaseMap.get(opp.id)));//,OpptycontactRoles));
            createCommercialCase(opp.AccountId,oppCaseWoMap.get(opp.id),oppMap.get(opp.id));
        }
    }
    //insert mapCommCaseToCreate.values();
}
}