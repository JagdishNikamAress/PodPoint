trigger AccountTrigger on Account (before insert,after update) {
     System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
    Id commCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
    Id businessAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    if(Trigger.isBefore ){
        if(Trigger.isInsert && AvoidRecursion.accountBeforeInsert()){
            for(Account acRec: Trigger.New){
                if((acRec.BillingStreet!=NULL || acRec.BillingCity!=NULL|| acRec.BillingState!=NULL|| acRec.BillingPostalCode!=NULL||acRec.BillingCountry!=NULL|| acRec.BillingCountryCode!=NULL || acRec.BillingAddress!=NULL)&& acRec.RecordTypeId ==businessAccRecordTypeId){
                    acRec.ShippingStreet=acRec.BillingStreet;
                    acRec.ShippingCity=acRec.BillingCity;
                    acRec.ShippingState=acRec.BillingState;
                    acRec.ShippingPostalCode=acRec.BillingPostalCode;
                    acRec.ShippingCountry=acRec.BillingCountry;
                    acRec.ShippingCountryCode=acRec.BillingCountryCode;
                    //acRec.ShippingAddress=acRec.BillingAddress;
                }
            }
        }
    }
    
  /*  if(Trigger.isafter ){
        if(Trigger.isUpdate && AvoidRecursion.accountAfterUpdate()){
            List<Account> accList =[SELECT Id,Name,(SELECT ID, Case.Account.Name,PostalCode__c,Subject,RecordTypeId FROM Cases WHERE RecordTypeId=:commCaseRecordTypeId) FROM Account WHERE ID IN:Trigger.oldMap.KeySet() AND RecordTypeid =: businessAccRecordTypeId]; 
            List<Case> caseList = new List<Case>();
            if(!accList.isEmpty()){
                for(Account acRec: accList){
                    for(Case caseRec: acRec.Cases){
                        if(Trigger.oldMap.get(acRec.Id).Name != acRec.Name || Trigger.oldMap.get(acRec.Id).Id != Trigger.newMap.get(acRec.Id).Id){
                            caseRec.Subject = 'Commercial Case - '+caseRec.Account.Name+' ('+caseRec.PostalCode__c+')';
                            caseList.add(caseRec);
                        }
                    }
                }
                update caseList;
            }
        }
    }*/
     System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
}