@isTest
public class PhaseController_Test 
{
    static testMethod void testMethod1(){
        
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        
        Account account = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
                                  Name = 'test',type = 'Prospect');
        insert account;
                
        Contact con = new Contact(lastName='test',email='test@test.com',phone='9632587410',accountid=account.id);
        insert con;
        
        
        Project__c prj = new Project__c(name='Test Project',Property_Developer__c = account.Id);
        insert prj;
        
        Phases__c ph = new Phases__c(Name='Test Phase', Project__c=prj.id,Start_Date__c=Date.today(),End_Date__c=Date.today());
        insert ph;
        
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
                                            StageName = 'New',Phase__c=ph.id);
        insert opp;     
        
        OpportunityContactRole ocr = new OpportunityContactRole(contactid=con.id,opportunityid=opp.id);
        insert ocr;
        
        ApexPages.StandardController sc = new ApexPages.standardController(ph);
        PhaseController e = new PhaseController(sc);
        
        test.StartTest();
		e.getPhaseContacts();
        test.StopTest();
    }
}