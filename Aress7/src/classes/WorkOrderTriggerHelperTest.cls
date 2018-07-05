@isTest
public class WorkOrderTriggerHelperTest {
    
    static testmethod void test1(){
        checkRecursive.skip_install_statuscheck_whencasecreated = true;
        Account acc = new Account(Name='Testing',CurrencyIsoCode='GBP',BillingCity='London',BillingCountry='United Kingdom',BillingPostalCode='123456',BillingStreet='JNStreet',Phone='123446569',ShippingCity='London',ShippingCountry='United Kingdom',ShippingPostalCode='123456',ShippingStreet='JNStreet');
        insert acc;
        
        Contact con = new Contact(FirstName='Test',LastName='Test',AccountId= acc.id,email = 'reuben1.lomas@destiny.com.au');
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
        case cs= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested',Ready_to_Schedule__c = true);
        insert cs;
        case cs1= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested',Ready_to_Schedule__c = true);
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
        Id surveyWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
        Id commWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
        Id maintenanceWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        //Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        
        //WorkOrder recordds with Homecharge Install record type
        WorkOrder wo=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs.id,Status='Unassigned',AccountId=acc.id);
        WorkOrder wo11=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs1.id,Status='Scheduled',AccountId=acc.id);
        WorkOrder wo12=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs.id,Status='Confirmed',AccountId=acc.id);
        WorkOrder wo13=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs.id,Status='Completed',AccountId=acc.id);
        WorkOrder wo14=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs1.id,Status='Active',AccountId=acc.id);
        WorkOrder wo15=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs.id,Status='Incomplete',AccountId=acc.id);
        WorkOrder wo16=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs.id,Status='On Hold',AccountId=acc.id);
        WorkOrder wo17=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs1.id,Status='Rejected',AccountId=acc.id);
        List<WorkOrder> woList = new List<WorkOrder>();
        woList.add(wo);
        woList.add(wo11);
        woList.add(wo12);
        woList.add(wo13);
        woList.add(wo14);
        woList.add(wo15);
        woList.add(wo16);
        woList.add(wo17);
        insert woList;
        
        Set<Id> woIdSet=new set<Id>();
        woIdSet.add(wo.id);
        Set<Id> caseIdSet=new set<Id>();
        caseIdSet.add(cs.id);
        
        test.startTest();
        //   WorkOrderTriggerHelper.copyAttachmentsFrommCaseWo(woList);
        WorkOrderTriggerHelper.oneWoForeachRecType(woList);
        WorkOrderTriggerHelper.syncProdrequiredOnWoInsert(woList);
        
        
        
        
        
        
        
        // wo.status='Unassigned';
        wo11.status='Scheduled';
        wo12.status='Confirmed';
        wo13.status='Completed';
        wo14.status='Active';
        wo15.status='Incomplete';
        wo16.status='On Hold';
        wo17.status='Rejected';
        List<WorkOrder> updatedwoList = new List<WorkOrder>();
        //  updatedwoList.add(wo);
        updatedwoList.add(wo11);
        updatedwoList.add(wo12);
        updatedwoList.add(wo13);
        updatedwoList.add(wo14);
        updatedwoList.add(wo15);
        updatedwoList.add(wo16);
        updatedwoList.add(wo17);
        update updatedwoList;
        // wo.status='Confirmed';
        // update wo;
        
        WorkOrderTriggerHelper.syncProdrequiredOnWoInsert(woList);
        WorkOrderTriggerHelper.afterUpdateHandle(woIdSet, caseIdSet);
        test.stopTest();
        
    }
    
    static testmethod void test2(){
        Account acc = new Account(Name='Testing',CurrencyIsoCode='GBP',BillingCity='London',BillingCountry='United Kingdom',BillingPostalCode='123456',BillingStreet='JNStreet',Phone='123446569',ShippingCity='London',ShippingCountry='United Kingdom',ShippingPostalCode='123456',ShippingStreet='JNStreet');
        insert acc;
        
        Contact con = new Contact(FirstName='Test',LastName='Test',AccountId= acc.id,email = 'reuben1.lomas@destiny.com.au');
        insert con;
        
        Product2 prod = new Product2(Name = 'Accommodation', Family = 'Twin Units',CurrencyIsoCode='GBP');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        List<Pricebook2> Pricebook2List= new List<Pricebook2>();
        Pricebook2 customPB = new Pricebook2(Name='Podpoint - Meetings & Events', isActive=true);
        Pricebook2List.add(customPB) ;
        Pricebook2 customPB1 = new Pricebook2(Name='Podpoint - OnlinePayment', isActive=true);
        Pricebook2List.add(customPB1) ;
        insert Pricebook2List;
        
        List<PricebookEntry> PricebookEntryList= new List<PricebookEntry>();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        PricebookEntryList.add(standardPrice) ;
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB1.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        PricebookEntryList.add(customPrice1) ;
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        PricebookEntryList.add(customPrice) ;
        insert PricebookEntryList;
        
        Id bookingid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();
        Opportunity opp = new Opportunity(Name = 'Testing',AccountId = acc.Id,CurrencyIsoCode='GBP',StageName = 'New',CloseDate = date.parse('09/08/2017'),RecordtypeId= bookingid);
        insert opp;
        
        // OpportunityLineItem ol = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = customPrice1.id,Product2Id = prod.id,UnitPrice = 10,Quantity = 2);
        //  List<OpportunityLineItem> olList = new List<OpportunityLineItem>();
        //  olList.add(ol);
        //  insert olList;
        
        Id caseid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Homecharge Case').getRecordTypeId();
        case cs= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested',Ready_to_Schedule__c = true);
        insert cs;
        case cs1= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested',Ready_to_Schedule__c = true);
        insert cs1;
        
        
        
        List<WorkType> WorkTypeList= new List<WorkType>();
        WorkType wt= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        WorkTypeList.add(wt);
        WorkType wt2= new WorkType(name='Survey (Domestic)',DurationType='Hours',EstimatedDuration=2);
        WorkTypeList.add(wt2);
        WorkType wt3= new WorkType(name='Maintenance (Domestic)',DurationType='Hours',EstimatedDuration=2);
        WorkTypeList.add(wt3);
        WorkType wt4= new WorkType(name='Install (Commercial)',DurationType='Hours',EstimatedDuration=2);
        WorkTypeList.add(wt4);
        insert WorkTypeList;
        
        Id workOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        Id surveyWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
        Id commWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
        Id maintenanceWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        //Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        
        SET<Id> woIdSet = new SET<Id>();
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        insert wt1;
        
        
        Id hcInstallWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        WorkOrder wo1= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id);
        insert wo1;
        
        String bodyStr='Test Body';
        Attachment att=new Attachment();
        att.Body=Blob.valueOf(bodyStr);
        att.Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
        att.parentId=wo1.id;
        insert att;

        
        woIdSet.add(wo1.id);
        wo1.Status='Scheduled';
      //  update wo1;
        wo1.Status='Confirmed';
      //  update wo1;
		//  wo1.Status='Active';
     //   update wo1;
       // wo1.Status='Incomplete';
       // update wo1;
        //   Id surveyWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
        //     Id commWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
        //     Id maintenanceWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        
         test.startTest();
        
        WorkOrderTriggerHelper.syncAttachmentsFromWoToCase(woIdSet);
        WorkOrderTriggerHelper.checkforperticularWOTask(woIdSet);
        SET<Id> CaseIdSet2 = new SET<Id>();
        CaseIdSet2.add(cs.id);
        SET<Id> woIdSet2 = new SET<Id>();
        WorkOrder wo2= new WorkOrder(RecordtypeId = surveyWORecordTypeId,WorkTypeId=wt2.Id,AccountId=acc.Id,CaseId=cs.Id);
        insert wo2;
        woIdSet2.add(wo2.id);
        SET<Id> woIdSet3 = new SET<Id>();
        WorkOrder wo3= new WorkOrder(RecordtypeId = maintenanceWORecordTypeId,WorkTypeId=wt3.Id,AccountId=acc.Id,CaseId=cs.Id);
        insert wo3;
       
        woIdSet3.add(wo3.Id);
        WorkOrderTriggerHelper.afterUpdateHandle(woIdSet2, caseIdSet2);
        WorkOrderTriggerHelper.afterUpdateHandle(woIdSet3, caseIdSet2);
        WorkOrderTriggerHelper.syncAttachmentsFromWoToCase(woIdSet3);
        WorkOrderTriggerHelper.checkforperticularWOTask(woIdSet3);
        // wo2.Status='Scheduled';
        // update wo2;
        //        WorkOrderTriggerHelper.afterUpdateHandle(woIdSet2, caseIdSet2);
        //wo2.Status='Confirmed';
        // update wo2;
        //         WorkOrderTriggerHelper.afterUpdateHandle(woIdSet2, caseIdSet2);
        
        
        test.stopTest();
        
    }
    
}