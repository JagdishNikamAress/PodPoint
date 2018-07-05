@isTest
public class ScheduleSAPin_Test {
    static testMethod void myUnitTest() {
           
        Id personAccountType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       
    	Database.QueryLocator QL;
        Database.BatchableContext BC;
    	String accMail = 'nilesh.more@aress.com';
    	Account acc = new Account(LastName='Testing',CurrencyIsoCode='GBP',BillingCity='London',BillingCountry='United Kingdom',BillingPostalCode='123456',BillingStreet='JNStreet',Phone='123446569',ShippingCity='London',ShippingCountry='United Kingdom',ShippingPostalCode='123456',ShippingStreet='JNStreet');
        acc.RecordTypeId=personAccountType;
        acc.PersonEmail = 'abc@gmail.com';
        insert acc;
        Account acc2 = new Account(Name='Testing',CurrencyIsoCode='GBP',BillingCity='London',BillingCountry='United Kingdom',BillingPostalCode='123456',BillingStreet='JNStreet',Phone='123446569',ShippingCity='London',ShippingCountry='United Kingdom',ShippingPostalCode='123456',ShippingStreet='JNStreet');
        insert acc2;
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
        case cs= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested',Ready_to_Schedule__c=true);
        insert cs;

        WorkType wt= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        wt.ShouldAutoCreateSvcAppt=true;
        insert wt;


        Id workOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        //Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        
        //WorkOrder recordds with Homecharge Install record type
        WorkOrder wo=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs.id,Status='Scheduled',Customer_Confirmation__c=True);
        wo.AccountId=acc.Id;
        List<WorkOrder> woList = new List<WorkOrder>();
        woList.add(wo);
        
        insert woList;
                 Test.StartTest();
		List<ServiceAppointment> sa=new list<ServiceAppointment>([Select id, SchedStartTime from ServiceAppointment]);
       
      //  sa[0].status='Scheduled';
        sa[0].SchedStartTime=system.now();
        sa[0].SchedEndTime=system.now().adddays(1);
        
        try{
        update sa;
        }catch(Exception e){}
        //Calling for ScheduleWorkOrderBatch
        ScheduleSAPin newTopicsUpdate = new ScheduleSAPin();
        ID batchprocessid = Database.executeBatch(newTopicsUpdate);
     	
     	newTopicsUpdate.start(BC);
     	newTopicsUpdate.execute(BC, sa);
        
	    //Calling for ScheduleWorkOrderBatch2
	    //ScheduleWorkOrderBatch2 newTopicsUpdate2 = new ScheduleWorkOrderBatch2();
        //ID batchprocessid2 = Database.executeBatch(newTopicsUpdate2);
     	
     	//newTopicsUpdate2.start(BC);
     	//newTopicsUpdate2.execute(BC, woList);
	    
	    Test.StopTest();   
    }
}