@isTest
public class CaseEquipmentTriggerHandler_Test {
	public static testmethod void test1(){
    	 Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        
        Opportunity opp = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId(),
                                            Name = 'Test Opp',
                                            AccountId = acc.id,
                                            closedate = Date.today(),
                                            StageName = 'New',
                                            amount=100.00);
        insert opp;     
       Case c = new Case(street__c='test',city__c='test',postalcode__c='1236547',OpportunityID__c=opp.Id,
                      Type = 'Survey',Opportunity__c=opp.Id);
       insert c;
       Equipment__c eq = new Equipment__c(Name='Test',Equipment_Family__c ='Fixings', Cost__c=10.2);
        insert eq;
       Case_Equipment__c ce= new Case_Equipment__c(Case__c = c.id,Total_Cost__c=10.00,Equipment__c = eq.id, Quantity__c=10, Equipment_Location__c='Site');
       insert ce;
    }
}