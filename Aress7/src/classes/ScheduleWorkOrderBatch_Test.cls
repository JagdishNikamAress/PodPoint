@isTest
public class ScheduleWorkOrderBatch_Test {
    static testMethod void myUnitTest() {
        
        
                Id personAccountType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

        
        Test.StartTest();
    	Database.QueryLocator QL;
        Database.BatchableContext BC;
    	
    	//String accRecTypeId='01224000000kGc0AAE';
    	String accMail = 'nilesh.more@aress.com';
    	Account acc = new Account(LastName='Testing',CurrencyIsoCode='GBP',BillingCity='London',BillingCountry='United Kingdom',BillingPostalCode='123456',BillingStreet='JNStreet',Phone='123446569',ShippingCity='London',ShippingCountry='United Kingdom',ShippingPostalCode='123456',ShippingStreet='JNStreet');
        acc.RecordTypeId=personAccountType;
        acc.PersonEmail = 'abc@gmail.com';
        insert acc;
        Account acc2 = new Account(Name='Testing',CurrencyIsoCode='GBP',BillingCity='London',BillingCountry='United Kingdom',BillingPostalCode='123456',BillingStreet='JNStreet',Phone='123446569',ShippingCity='London',ShippingCountry='United Kingdom',ShippingPostalCode='123456',ShippingStreet='JNStreet');
        insert acc2;
        //update acc;
        
        Contact con = new Contact(FirstName='Test',LastName='Test2',AccountId= acc2.id,Email = 'abc@gmail.com');
        insert con;
        
        Product2 prod = new Product2(Name = 'Accommodation', Family = 'Twin Units',CurrencyIsoCode='GBP');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        Pricebook2 customPB = new Pricebook2(Name='Podpoint - Meetings & Events', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        Pricebook2 customPB1 = new Pricebook2(Name='Podpoint - OnlinePayment', isActive=true);
        insert customPB1;
        
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB1.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        Id bookingid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();
        Opportunity opp = new Opportunity(Name = 'Testing',AccountId = acc.Id,CurrencyIsoCode='GBP',StageName = 'New',CloseDate = date.parse('09/08/2017'),RecordtypeId= bookingid);
        insert opp;
        
        
        OpportunityLineItem ol = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = customPrice1.id,Product2Id = prod.id,UnitPrice = 10,Quantity = 2);
        List<OpportunityLineItem> olList = new List<OpportunityLineItem>();
        olList.add(ol);
        insert olList;
        
        Id caseid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Homecharge Case').getRecordTypeId();
        case cs= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested');
        insert cs;
         case cs1= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested');
        insert cs1;
        WorkType wt= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        insert wt;
        WorkType wt2= new WorkType(name='Survey (Domestic)',DurationType='Hours',EstimatedDuration=2);
        insert wt2;
        WorkType wt3= new WorkType(name='Maintenance (Domestic)',DurationType='Hours',EstimatedDuration=2);
        insert wt3;
        
        WorkType wt4= new WorkType(name='Install (Commercial)',DurationType='Hours',EstimatedDuration=2);
        insert wt4;
        
        Id workOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        //Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        
        //WorkOrder recordds with Homecharge Install record type
        WorkOrder wo=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs.id,Status='Scheduled',Customer_Confirmation__c=True);
        wo.AccountId=acc.Id;
        List<WorkOrder> woList = new List<WorkOrder>();
        woList.add(wo);
        
        insert woList;
        
        EmailTemplate et = new EmailTemplate (developerName = 'test', FolderId = '00l24000000Jr4cAAC', TemplateType= 'Text', Name = 'test');
        //String body = 'TEst email'
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(con.Id);
        mail.setWhatId(opp.Id);
        // assuming this Template ID exists in your org
        mail.setPlainTextBody('The report is attached.');
        mail.setTemplateId(et.Id); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		
        //Calling for ScheduleWorkOrderBatch
        ScheduleWorkOrderBatch newTopicsUpdate = new ScheduleWorkOrderBatch();
        ID batchprocessid = Database.executeBatch(newTopicsUpdate);
     	
     	newTopicsUpdate.start(BC);
     	newTopicsUpdate.execute(BC, woList);
        
	    //Calling for ScheduleWorkOrderBatch2
	    //ScheduleWorkOrderBatch2 newTopicsUpdate2 = new ScheduleWorkOrderBatch2();
        //ID batchprocessid2 = Database.executeBatch(newTopicsUpdate2);
     	
     	//newTopicsUpdate2.start(BC);
     	//newTopicsUpdate2.execute(BC, woList);
	    
	    Test.StopTest();   
        //System.AssertEquals(database.countquery('SELECT COUNT()'+' FROM Topic '), 3); 
    }
}