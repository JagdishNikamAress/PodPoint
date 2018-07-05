@isTest
public class AccountTriggerTest {
    public testMethod static void accTest(){
        List<Account> accList = new List<Account>();
        List<Case> csList = new List<Case>();
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
                                  Name = 'test',type = 'Prospect');
        accList.add(acc);
        insert accList;
       	acc.Name = 'testAcc';
        update acc;
        
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        insert wt1;
        
        Case cs = new Case(street__c='Test',city__c='test',country_picklist__c='India',PostalCode__c='735101',type='Commercial',AccountId = acc.Id);
        csList.add(cs);
        insert csList;
        List<Case> updatedCaseList = new List<Case>();
        cs.Subject= 'Commercial Case - '+acc.Name+' ('+cs.PostalCode__c+')';
        updatedCaseList.add(cs);
        update updatedCaseList;
        
    }
}