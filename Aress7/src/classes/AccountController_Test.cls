@isTest
public class AccountController_Test {
    static testMethod void testMethod1(){
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect',Route_to_Market__c = 'test');
        insert acc;
        
        Project__c p = new Project__c(name='Test Project',Start_Date__c=Date.today(),End_Date__c=Date.today(),Property_Developer__c=acc.id);
        insert p;
        
        Phases__c phs = new Phases__c(Name = 'test Phase',project__c =p.id,Start_Date__c=Date.today(),End_Date__c=Date.today());
        insert phs;
        Opportunity opp = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId(),
                                            Name = 'Test Opp',
                                            AccountId = acc.id,
                                            closedate = Date.today(),
                                            Billing_City__c = 'Test',
                                            Billing_Country_Picklist__c = SObjectType.Opportunity.Fields.Billing_Country_Picklist__c.PicklistValues[0].getValue(),
                                            Billing_Postal_Code__c = 'Test',
                                            Billing_Street__c = 'Test',
                                            Shipping_City__c = 'Test',
                                            Shipping_Country_PickList__c = SObjectType.Opportunity.Fields.Billing_Country_Picklist__c.PicklistValues[0].getValue(),
                                            Shipping_Postal_Code__c = 'Test',
                                            Shipping_Street__c = 'Test',
                                            StageName = 'New',
                                         	phase__c = phs.id);
        insert opp;
        
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        AccountController e = new AccountController(sc);
        
        test.StartTest();
        e.getProjectDetails();
        e.getBids();
        e.getPhases();
        test.StopTest();
        
    }
}