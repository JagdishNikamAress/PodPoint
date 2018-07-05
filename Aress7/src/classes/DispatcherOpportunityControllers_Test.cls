@isTest
public class DispatcherOpportunityControllers_Test {
    @testSetup static void setup() {
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        
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
                                            StageName = 'New');
        insert opp;     
    }
    
    static testMethod void testMethod1(){
        Opportunity opp = [SELECT id FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.DispatcherOpportunityEdit;
        pageRef.getParameters().put('id',opp.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        DispatcherOpportunityEditController testobj = new DispatcherOpportunityEditController(sc);
        testobj.getRedir();
    }
    
    static testMethod void testMethod11(){
        Opportunity opp = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Charge').getRecordTypeId(),
                                            Name = 'Test Opp',
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
        PageReference pageRef = Page.DispatcherOpportunityEdit;
        pageRef.getParameters().put('id',opp.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        DispatcherOpportunityEditController testobj = new DispatcherOpportunityEditController(sc);
        testobj.getRedir();
    }
    
    static testMethod void testMethod2(){
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        
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
                                            StageName = 'New');
        insert opp;     
        PageReference pageRef = Page.DispatcherOpportunityNew;
        pageRef.getParameters().put('RecordType',Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Bid').getRecordTypeId());
        pageRef.getParameters().put('phaseId',opp.accountid);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        DispatcherOpportunityNewController testobj = new DispatcherOpportunityNewController(sc);
        testobj.getRedir();
    }
    
    static testMethod void testMethod201(){
           
        Opportunity opp = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId(),
                                            Name = 'Test Opp',
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
        PageReference pageRef = Page.DispatcherOpportunityNew;
        pageRef.getParameters().put('RecordType',Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Bid').getRecordTypeId());
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        DispatcherOpportunityNewController testobj = new DispatcherOpportunityNewController(sc);
        testobj.getRedir();
    }
    
    static testMethod void testMethod21(){
        Opportunity opp = [SELECT id,accountid FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.DispatcherOpportunityNew;
        pageRef.getParameters().put('RecordType',Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId());
        pageRef.getParameters().put('accid',opp.accountid);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        DispatcherOpportunityNewController testobj = new DispatcherOpportunityNewController(sc);
        testobj.getRedir();
    }
    static testMethod void testMethod211(){
        Opportunity opp = [SELECT id,accountid FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.DispatcherOpportunityNew;
        pageRef.getParameters().put('RecordType',Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId());
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        DispatcherOpportunityNewController testobj = new DispatcherOpportunityNewController(sc);
        testobj.getRedir();
    }
    
     static testMethod void testMethod22(){
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        
        Opportunity opp = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId(),
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
                                            StageName = 'New');
        insert opp;     
        PageReference pageRef = Page.DispatcherOpportunityNew;
        pageRef.getParameters().put('RecordType',Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId());
        pageRef.getParameters().put('accid',opp.accountid);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        DispatcherOpportunityNewController testobj = new DispatcherOpportunityNewController(sc);
        testobj.getRedir();
    }
    
     static testMethod void testMethod221(){
        Opportunity opp = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId(),
                                            Name = 'Test Opp',
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
        PageReference pageRef = Page.DispatcherOpportunityNew;
        pageRef.getParameters().put('RecordType',Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId());
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        DispatcherOpportunityNewController testobj = new DispatcherOpportunityNewController(sc);
        testobj.getRedir();
    }
    
    static testMethod void testMethod3(){
        Opportunity opp = [SELECT id FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.DispatcherOpportunityView;
        pageRef.getParameters().put('id',opp.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        DispatcherOpportunityViewController testobj = new DispatcherOpportunityViewController(sc);
        testobj.getRedir();
    }
    
    static testMethod void testMethod31(){
        Opportunity opp = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Charge').getRecordTypeId(),
                                            Name = 'Test Opp',
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
        PageReference pageRef = Page.DispatcherOpportunityView;
        pageRef.getParameters().put('id',opp.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        DispatcherOpportunityViewController testobj = new DispatcherOpportunityViewController(sc);
        testobj.getRedir();
    }
}