@isTest
public class EmailMessageTrigger_Test {
    
    
    public static Blob createAttachmentBody(){
        String body = 'XXXXXXXXXXXXX';
        return Blob.valueof(body);
    }
    
    static testMethod void emailTester1(){
        
        
        
        
        
        Set<String> parentIds = new Set<String>();
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        
        Contact con  = new Contact(LastName='test',Email='test@test.com');
        Insert con;
        
        Contact con1  = new Contact(LastName='test1',Email='test@test.com');
        Insert con1; 
        
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
        Opportunity opp1 = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId(),
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
        
        insert opp1;  
        opp1.StageName= 'Ongoing';
        update opp1;
        
        // Account acc = new Account(FirstName='Test1');
        
        Id caseid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Homecharge Case').getRecordTypeId();
        case cs= new case(RecordTypeId=caseid,Status='new',OpportunityID__c=String.valueOf(opp.Id), Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested');
        cs.RecordTypeId = caseid;
        
        insert cs;
        Id caseid1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Homecharge Norway').getRecordTypeId();
        case cs1= new case(RecordTypeId=caseid,Status='new',OpportunityID__c=String.valueOf(opp1.Id),Opportunity__c=opp1.Id,ContactId=con.id,Survey_Status__c = 'Requested');
        cs1.RecordTypeId = caseid1;
        insert cs1;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,ContactId=con.id,IsPrimary=true);
        insert ocr1;
        OpportunityContactRole ocr2 = new OpportunityContactRole(opportunityid=opp1.id,ContactId=con.id,IsPrimary=true);
        insert ocr2;
        
        Quote qt = new Quote(name='Test Quote',Number_of_Quotes_Presented__c=NULL,opportunityid=opp.id,shippingstreet='test street',billingstreet='test street',shippingcity = 'City',billingcity = 'City',shippingpostalcode = '123',billingpostalcode = '123' ,Notes_about_your_order__c='test note');
        Insert qt;
        Update qt;
        
        Quote qt1 = new Quote(name='Test Quote',Number_of_Quotes_Presented__c=0,opportunityid=opp1.id,shippingstreet='test street',billingstreet='test street',shippingcity = 'City',billingcity = 'City',shippingpostalcode = '123',billingpostalcode = '123' ,Notes_about_your_order__c='test note');
        Insert qt1;
        update qt1;
        
        EmailMessage IncomingMail= new EmailMessage();
        IncomingMail.fromaddress='test@test.com';
        IncomingMail.subject = 'Opt Out Test Message';
        IncomingMail.TextBody= 'This is the message body BR-Interno.';
        IncomingMail.parentid=cs.id;
        IncomingMail.Incoming = True;
        IncomingMail.Status = '0';
        insert IncomingMail;
        
        //Insert emailmessage for case
        EmailMessage outGoingMail= new EmailMessage();
         outGoingMail.fromaddress='test@test.com';
         outGoingMail.toAddress = con.Email;
         outGoingMail.subject = 'Opt Out Test Message';
         outGoingMail.TextBody= 'This is the message body BR-Interno.';
         outGoingMail.parentid=cs.id;
         //outGoingMail.RelatedToId=qt.id;
         insert outGoingMail;    
        
        Attachment att = new Attachment(Name = 'XXXXXXXX', Body = Blob.valueof('XXXXXXXXXXXXXX'), ParentId = cs.Id);
        insert att;
        
        
        EmailMessage outGoingMail1= new EmailMessage();
         outGoingMail1.fromaddress='test@test.com';
         outGoingMail1.toAddress = con1.Email;
         outGoingMail1.subject = 'Opt Out Test Message';
         outGoingMail1.TextBody= 'This is the message body BR-Interno.';
         outGoingMail1.parentid=cs1.id;
         //outGoingMail.RelatedToId=qt.id;
         insert outGoingMail1;     
        
        Attachment a = new Attachment();
        a.name = 'test attachment';
        a.body = blob.valueof('attachment body');
        a.parentid = outGoingMail.id;            
        insert a;
        
        EmailMessage em = [SELECT Id,Status FROM EmailMessage WHERE Id=:outGoingMail1.Id ];
    }
}