@isTest
public class AddAttendees_Test {
    static testMethod void testMethod1(){
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
        
        Contact con = new Contact(FirstName = 'Test',LastName = 'Test', accountid = acc.id);
        insert con;
        
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
        
        Event ev = new Event(Subject = 'Call', Location = 'Test', StartDateTime = datetime.now() ,EndDateTime = datetime.now() , type = 'Call' , description ='Test',IsAllDayEvent= false ,IsReminderSet =false);
        
        
        PageReference pageRef = Page.Create_Event;
        pageRef.getParameters().put('RelatedToAccountid',acc.id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(ev);
        AddAttendees a = new AddAttendees(sc);
        a.Customsave();
        AddAttendees.AttendeeWrap aw = new AddAttendees.AttendeeWrap(con);
        aw.isSelected = true;
        
        List<AddAttendees.AttendeeWrap> awl = new List<AddAttendees.AttendeeWrap>();
        awl.add(aw);
        a.AssociatedContacts = awl;
        a.AddAttendees();
    }
}