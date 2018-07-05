@isTest
public class OpportunityProductTrigger_Test 
{
    static testMethod void TestMethodOpportunityProductTrigger() {
        Id standardPbID = Test.getStandardPricebookId();
        
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'Mngd_Inst', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        prd3.Family='Solo Units';
        insert prd3;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id,FieldAware_ID__c='Test',Location_ID__c='Test Location');
        Insert con;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe3;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        insert oppitem1;
        OpportunityLineItem oppitem2 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        insert oppitem2;
        
        Id caseid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Homecharge Case').getRecordTypeId();
        case cs= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested');
        insert cs;
        case cs1= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested');
        insert cs1;
        
        List<WorkType> WorkTypeList= new List<WorkType>();
        WorkType wt= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2,ShouldAutoCreateSvcAppt=true);
        
        WorkTypeList.add(wt);
        /* WorkType wt2= new WorkType(name='Survey (Domestic)',DurationType='Hours',EstimatedDuration=2);
WorkTypeList.add(wt2);
WorkType wt3= new WorkType(name='Maintenance (Domestic)',DurationType='Hours',EstimatedDuration=2);
WorkTypeList.add(wt3);
WorkType wt4= new WorkType(name='Install (Commercial)',DurationType='Hours',EstimatedDuration=2);
WorkTypeList.add(wt4);*/
        insert WorkTypeList;
        
        Id workOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        
        SET<Id> woIdSet = new SET<Id>();
        WorkOrder wo=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=WorkTypeList[0].id,CaseId=cs.id,Status='Unassigned');
        insert wo;
        woIdSet.add(wo.id);
        
        WorkOrderLineItem woli = new WorkOrderLineItem(WorkOrderId=wo.id, Status=wo.Status);
        Insert woli;	
        
        Test.startTest();
        OpportunityLineItem oppitem3 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        oppitem3.Product2Id=prd3.id;
        insert oppitem3;
        oppitem2.Quantity=4;
        update oppitem2;
        delete oppitem2;
        delete oppitem1;
        
        Test.stopTest();
        
    }
    
}