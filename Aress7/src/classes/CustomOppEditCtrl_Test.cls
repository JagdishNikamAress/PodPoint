@isTest
public class CustomOppEditCtrl_Test{
    public static testMethod void testMyController(){
        Account acc = new Account(
        recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
        Name = 'Test Account',
        billingCity = 'test',
       // billingState='Luanda',
        billingCountry=SObjectType.Opportunity.Fields.Billing_Country_Picklist__c.PicklistValues[0].getValue(),
        billingStreet = 'test',
        billingPostalCode = '700001',
        shippingCity = 'test',
       // shippingState='Luanda',
        shippingCountry=SObjectType.Opportunity.Fields.Billing_Country_Picklist__c.PicklistValues[0].getValue(),
        shippingStreet = 'test',
        ShippingPostalCode = '700001'
        );
        insert acc;
        
        Opportunity opp = new Opportunity(
        recordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId()
        );
        //insert opp;
        
        Contact con = new Contact (lastName ='con',email='test@yopmail.com');
        insert con;
        
        PageReference pageRef = Page.CustomOppEditPg;
        pageRef.getParameters().put('RecordType',Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId());
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        CustomOppEditCtrl testobj = new CustomOppEditCtrl(sc);
        testobj.opp.AccountId = acc.id;
        testobj.opp.StageName = 'Won';
        testobj.opp.CloseDate = date.today();
        testobj.opp.Name = 'test';
        testobj.ocr.contactid = con.id;
        
        testobj.populateAddress();
        testobj.doSave();
        testobj.changestagename();
    }
}