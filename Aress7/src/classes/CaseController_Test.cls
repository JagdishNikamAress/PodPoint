@isTest
public class CaseController_Test {
    static testMethod void testMethod1(){
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        
         Account account = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
                                  Name = 'test',type = 'Prospect');
        insert account;
        
        Opportunity opp = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId(),
                                            Name = 'Test Opp',
                                            AccountId = account.id,
                                            closedate = Date.today(),
                                            Billing_City__c = 'Test',
                                            Billing_Country_Picklist__c = SObjectType.Opportunity.Fields.Billing_Country_Picklist__c.PicklistValues[0].getValue(),
                                            Billing_Postal_Code__c = 'Test',
                                            Billing_Street__c = 'Test',
                                            Shipping_City__c = 'Test',
                                            Shipping_Country_PickList__c = SObjectType.Opportunity.Fields.Billing_Country_Picklist__c.PicklistValues[0].getValue(),
                                            Shipping_Postal_Code__c = 'Test',
                                            Shipping_Street__c = 'Test',
                                            StageName = 'New');
        insert opp;     
        
        Contact con = new Contact(lastName='test',email='test@test.com',phone='9632587410',accountid=account.id);
        insert con;
        
        Case c = new Case(description='test',street__c='test',city__c='test',
                          Country_Picklist__c = SObjectType.Case.Fields.Country_Picklist__c.PicklistValues[0].getValue(),
                          PostalCode__c='1236',accountid=account.id,Opportunity__c=opp.id,contactid=con.id,Maintenance_Type__c='Domestic');
        insert c;
        
        ApexPages.StandardController sc = new ApexPages.standardController(c);
        CaseController e = new CaseController(sc);
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        e.createInstallCase();
        e.createMaintenanceCase();
        test.StopTest();
    }
}