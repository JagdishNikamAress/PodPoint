@isTest
public class QuoteTriggerHandlerNew_Test {
    
    static testMethod void createCommCaseTest2(){
        
        
        
        Account Acc = new Account(Name='Test Account');
        insert Acc;
        Contact con = new Contact(Lastname = 'Test Contact',accountid=acc.id, email = 'test@test.com');
        insert con;
        Product2 prod = new Product2(Name = 'Accommodation',Sockets__c=5,ProductCode = 'Mngd_Inst', Family = 'Twin Units',CurrencyIsoCode='GBP',IsActive=true);
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Podpoint - Meetings & Events', isActive=true);
        insert customPB;
        
        // PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        //  insert customPrice;
        
        //  Pricebook2 customPB1 = new Pricebook2(Name='Podpoint - OnlinePayment', isActive=true);
        //   insert customPB1;
        
        //  PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB1.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        //  insert customPrice1;
        
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName='new';
        opp.AccountId=acc.Id;
        opp.CloseDate=system.today();
        opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;
        Insert opp;
        //(Name='Test Opportunity',accountid=acc.id,closedate=System.today(),StageName='Qualification',shipping_street__c='TestStreet',Shipping_City__c='TestCity', Shipping_Postal_Code__c='TestPostalCode', Shipping_Country_Picklist__c='United Kingdom');
        //opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;
        //Insert opp;
        
        OpportunityLineItem ol = new OpportunityLineItem();
        ol.OpportunityId=opp.Id;
        ol.PricebookEntryId=standardPrice.Id;
        ol.Product2Id=prod.Id;
        ol.UnitPrice=12;
        ol.Quantity=1;
        insert ol;
        
        //(OpportunityId = opp.id,PricebookEntryId = customPrice1.id,Product2Id = prod.id,UnitPrice = 10,Quantity = 2);
        //List<OpportunityLineItem> olList = new List<OpportunityLineItem>();
        //olList.add(ol);
        //insert olList;
        //insert ol;
        List<String> OpptyIds = new List<String>();
        OpptyIds.add(String.valueOf(opp.Id));
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
        case cs = new case(AccountId=opp.AccountId,RecordTypeId=CaseRecordTypeId, Type='Commercial', Opportunity__c=opp.Id, ContactId=con.Id,Street__c=opp.Shipping_Street__c, City__c=opp.Shipping_City__c, PostalCode__c=opp.Shipping_Postal_Code__c, Country_Picklist__c=opp.Shipping_Country_Picklist__c);
        cs.Project_Manager__c = 'Kostas';
        //Insert cs;
        //cs.Project_Manager__c = 'Kostas';
        //update cs;
        
        //WorkType data
        WorkType wt= new WorkType(Name='Install (Commercial)',DurationType='Hours',EstimatedDuration=2);
        wt.ShouldAutoCreateSvcAppt=true;
        Insert wt;
        WorkType wt1= new WorkType(Name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        Insert wt1;
        
        
        Opportunity opp2 = new Opportunity();
        opp2.Name='test';
        opp2.StageName='new';
        opp2.AccountId=acc.Id;
        opp2.CloseDate=system.today();
        opp2.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;
        Insert opp2;
        //(Name='Test Opportunity',accountid=acc.id,closedate=System.today(),StageName='Qualification',shipping_street__c='TestStreet',Shipping_City__c='TestCity', Shipping_Postal_Code__c='TestPostalCode', Shipping_Country_Picklist__c='United Kingdom');
        //opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;
        //Insert opp;
        
        OpportunityLineItem ol2 = new OpportunityLineItem();
        ol2.OpportunityId=opp2.Id;
        ol2.PricebookEntryId=standardPrice.Id;
        ol2.Product2Id=prod.Id;
        ol2.UnitPrice=12;
        ol2.Quantity=1;
        insert ol2;
        OpportunityContactRole ocr2 = new OpportunityContactRole(opportunityid=opp2.id,contactid=con.id,IsPrimary=true);
        insert ocr2;
        List<String> OpptyIds2 = new List<String>();
        OpptyIds2.add(String.valueOf(opp2.Id));
        
        
        test.startTest();
        // QuoteTriggerHandlerNew.createCommCase(OpptyIds);
          Quote qt = new Quote(name='Test Quote',opportunityid=opp.id,shippingstreet='test street',billingstreet='test street',shippingcity = 'City',billingcity = 'City',shippingpostalcode = '123',billingpostalcode = '123' ,Notes_about_your_order__c='test note');
        Insert qt;
        Map<Id,Quote> test2=new Map<Id,Quote>();
        test2.put(opp.id,qt);
        QuoteTriggerHandlerNew.createCommCase(test2);
        test.stopTest();
    }
    
    static testMethod void createCommCaseTest3(){
        Account Acc = new Account(Name='Test Account');
        insert Acc;
        Contact con = new Contact(Lastname = 'Test Contact',accountid=acc.id);
        insert con;
        Product2 prod = new Product2(Name = 'Accommodation',Sockets__c=5,ProductCode = 'Mngd_Inst', Family = 'Twin Units',CurrencyIsoCode='GBP',IsActive=true);
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Podpoint - Meetings & Events', isActive=true);
        insert customPB;
        
        // PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        //  insert customPrice;
        
        //  Pricebook2 customPB1 = new Pricebook2(Name='Podpoint - OnlinePayment', isActive=true);
        //   insert customPB1;
        
        //  PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB1.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        //  insert customPrice1;
        
        
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName='new';
        opp.AccountId=acc.Id;
        opp.CloseDate=system.today();
        opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;
        Insert opp;
        //(Name='Test Opportunity',accountid=acc.id,closedate=System.today(),StageName='Qualification',shipping_street__c='TestStreet',Shipping_City__c='TestCity', Shipping_Postal_Code__c='TestPostalCode', Shipping_Country_Picklist__c='United Kingdom');
        //opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;
        //Insert opp;
        
        OpportunityLineItem ol = new OpportunityLineItem();
        ol.OpportunityId=opp.Id;
        ol.PricebookEntryId=standardPrice.Id;
        ol.Product2Id=prod.Id;
        ol.UnitPrice=12;
        ol.Quantity=1;
        insert ol;
        
        //(OpportunityId = opp.id,PricebookEntryId = customPrice1.id,Product2Id = prod.id,UnitPrice = 10,Quantity = 2);
        //List<OpportunityLineItem> olList = new List<OpportunityLineItem>();
        //olList.add(ol);
        //insert olList;
        //insert ol;
        List<String> OpptyIds = new List<String>();
        OpptyIds.add(String.valueOf(opp.Id));
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
        case cs = new case(AccountId=opp.AccountId,RecordTypeId=CaseRecordTypeId, Type='Commercial', Opportunity__c=opp.Id, ContactId=con.Id,Street__c=opp.Shipping_Street__c, City__c=opp.Shipping_City__c, PostalCode__c=opp.Shipping_Postal_Code__c, Country_Picklist__c=opp.Shipping_Country_Picklist__c);
        cs.Project_Manager__c = 'Kostas';
        Insert cs;
        //cs.Project_Manager__c = 'Kostas';
        //update cs;
        
        //WorkType data
        WorkType wt= new WorkType(Name='Install (Commercial)',DurationType='Hours',EstimatedDuration=2);
        Insert wt;
        WorkType wt1= new WorkType(Name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        Insert wt1;
        
        test.startTest();
                  Quote qt = new Quote(name='Test Quote',opportunityid=opp.id,shippingstreet='test street',billingstreet='test street',shippingcity = 'City',billingcity = 'City',shippingpostalcode = '123',billingpostalcode = '123' ,Notes_about_your_order__c='test note');
        Insert qt;
        Map<Id,Quote> test2=new Map<Id,Quote>();
        test2.put(opp.id,qt);
                Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());

        QuoteTriggerHandlerNew.createCommCase(test2);
        // QuoteTriggerHandlerNew.createCommCase(OpptyIds2);
        test.stopTest();
    }
    
  /*  public static testmethod void test03(){
        Set<Id> WOId = new Set<Id>();
        List<String> OppId = new List<String>();
        
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
          Contact con = new Contact(Lastname = 'Test Contact',accountid=acc.id, email = 'test@test.com');
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
         OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        Case cs = new Case(street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',UUID__c='1223456');
        cs.OLEV__c=true;
        insert cs;
        
        List<worktype> wtList=new List<WorkType>();
        worktype wt =new worktype(Name='Install (Commercial)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt);
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt1);
        worktype wt2 =new worktype(Name='Additional Works (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt2);
        insert wtList;
        
        Id hcInstallWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        List<WorkOrder> woList=new List<WorkOrder>();
        WorkOrder wo1= new WorkOrder(Status='Active',RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id);
        woList.add(wo1) ;
        //WorkOrder wo2= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id);
        //woList.add(wo2) ;
        insert woList;
        
        ServiceAppointment sa = new ServiceAppointment();
        sa.EarliestStartTime=System.today();
        sa.DueDate=System.today()+1;
        sa.Status='Completed';
        sa.SchedStartTime=System.today();
        sa.SchedEndTime=System.today()+1;
        sa.ParentRecordId=wo1.id;
        sa.ArrivalWindowStartTime=System.today();
        sa.ArrivalWindowEndTime=System.today()+1;
        sa.Main_SA__c=true;
        insert sa;
        
        
        
        List<FSL_Tasks__c> fslTaskList = new List<FSL_Tasks__c>();
        FSL_Tasks__c fslTask = new FSL_Tasks__c(Name = 'Unit PSL/PG Number',Work_Type__c =wt1.Id);
        FSL_Tasks__c fslTask1 = new FSL_Tasks__c(Name = 'Annex D Form',Work_Type__c =wt1.Id);
        fslTaskList.add(fslTask);
        fslTaskList.add(fslTask1);
        Insert fslTaskList;
        
        List<Work_Order_Task__c> wotaskList1= new List<Work_Order_Task__c>();
        Work_Order_Task__c wot = new Work_Order_Task__c(Work_Order__c=wo1.Id, Signee_Name__c='testSignee', Signee_Relationship__c='TestRelationship', Unit_PSL_PG_number__c='testPgNo', Annex_D_Form__c='testForm1', Task__c=fslTask.Id);
        wot.Status__c='Completed';
        Work_Order_Task__c wot1 = new Work_Order_Task__c(Work_Order__c=wo1.Id, Signee_Name__c='testSignee', Signee_Relationship__c='TestRelationship1', Unit_PSL_PG_number__c='testPgNo1', Annex_D_Form__c='testForm2', Task__c=fslTask1.Id);
        wot1.Status__c='Completed';
        wotaskList1.add(wot);
        wotaskList1.add(wot1);
        Insert wotaskList1;
        
        
        List<WorkOrder> woListToUpdate=new List<WorkOrder>();
        wo1.Status='Completed';
        //update wo1;
        woListToUpdate.add(wo1);
        //wo2.Status='Confirmed';
        //woListToUpdate.add(wo2);
        //update woListToUpdate;
        
        List<Work_Order_Task__c> wotaskList= new List<Work_Order_Task__c>([SELECT Work_Order__c, Status__c, Id, Task__c FROM Work_Order_Task__c where Work_Order__c=:wo1.Id]);
        // for(Work_Order_Task__c wot : wotaskList){
        //     wot.Status__c='Completed';
        
        // }
        //  delete wotaskList;
        List<ServiceAppointment> saList= new List<ServiceAppointment>([SELECT Id, ParentRecordId, Status FROM ServiceAppointment where ParentRecordId=:wo1.Id]);
        // for(ServiceAppointment sa: saList){
        //     sa.Status='Completed';
        // }
        delete saList;        
        
        
        
        
        WOId.add(wo1.Id);
        //WOId.add(wo2.Id);
        //WOId.add(wo2.Id);
        
        OppId.add(opp.Id);
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Quantity = 5;
        oli.PricebookEntryId = pbEntry.Id;
        oli.Product2Id=prod.id;
        oli.OpportunityId=opp.Id;
        // oli.TotalPrice=Quantity * pbEntry.UnitPrice;
        oli.TotalPrice=oli.Quantity * pbEntry.UnitPrice;
        insert oli;
        
        List<ProductRequired> Prodlst = new List<ProductRequired>(); 
        
        ProductRequired pr = new ProductRequired();
        pr.ParentRecordId = wo1.Id;
        pr.Product2Id = oli.Product2Id;
        pr.Opportunity__c = oli.OpportunityId;
        pr.QuantityRequired = oli.Quantity;
        system.debug('pr.QuantityRequired' + pr.QuantityRequired);
        pr.WO_OppLineItem_Id__c = oli.id;
        Prodlst.add(pr);
        
        Map<Id,WorkOrder> WOMap = new Map<Id,WorkOrder>();
        WOMap.put(wo1.Id, wo1);
        
        Map<Id, OpportunityLineItem> oliMap = new Map<Id, OpportunityLineItem>();
        oliMap.put(oli.Id, oli);
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
                         Quote qt = new Quote(name='Test Quote',opportunityid=opp.id,shippingstreet='test street',billingstreet='test street',shippingcity = 'City',billingcity = 'City',shippingpostalcode = '123',billingpostalcode = '123' ,Notes_about_your_order__c='test note');
        Insert qt;
        Map<Id,Quote> test2=new Map<Id,Quote>();
        test2.put(opp.id,qt);
        QuoteTriggerHandlerNew.createCommCase(test2);
       // QuoteTriggerHandlerNew.createCommCase(OppId);
        Test.stopTest();
    }*/
    
    static testMethod void test04(){
        Account Acc = new Account(Name='Test Account');
        insert Acc;
        Contact con = new Contact(Lastname = 'Test Contact',accountid=acc.id);
        insert con;
        Product2 prod = new Product2(Name = 'Accommodation',Sockets__c=5,ProductCode = 'Mngd_Inst', Family = 'Twin Units',CurrencyIsoCode='GBP',IsActive=true);
        insert prod;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        Pricebook2 customPB = new Pricebook2(Name='Podpoint - Meetings & Events', isActive=true);
        insert customPB;
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName='new';
        opp.AccountId=acc.Id;
        opp.CloseDate=system.today();
        
        opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;
        Insert opp;
        
        OpportunityLineItem ol = new OpportunityLineItem();
        ol.OpportunityId=opp.Id;
        ol.PricebookEntryId=standardPrice.Id;
        ol.Product2Id=prod.Id;
        ol.UnitPrice=12;
        ol.Quantity=1;
        insert ol;
        List<String> OpptyIds = new List<String>();
        OpptyIds.add(String.valueOf(opp.Id));
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
        case cs = new case(AccountId=opp.AccountId,RecordTypeId=CaseRecordTypeId, Type='Commercial', Opportunity__c=opp.Id, ContactId=con.Id,Street__c=opp.Shipping_Street__c, City__c=opp.Shipping_City__c, PostalCode__c=opp.Shipping_Postal_Code__c, Country_Picklist__c=opp.Shipping_Country_Picklist__c);
        cs.Project_Manager__c = 'Kostas';
        Insert cs;
        
        case cs2 = new case(AccountId=opp.AccountId,RecordTypeId=CaseRecordTypeId, Type='Commercial', Opportunity__c=opp.Id, ContactId=con.Id,Street__c=opp.Shipping_Street__c, City__c=opp.Shipping_City__c, PostalCode__c=opp.Shipping_Postal_Code__c, Country_Picklist__c=opp.Shipping_Country_Picklist__c);
        cs2.Project_Manager__c = 'Kostas';
        Insert cs2;
        
        WorkType wt= new WorkType(Name='Install (Commercial)',DurationType='Hours',EstimatedDuration=2);
        Insert wt;
        WorkType wt1= new WorkType(Name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        Insert wt1;
        
        
        Opportunity opp2 = new Opportunity();
        opp2.Name='test';
        opp2.StageName='new';
        opp2.AccountId=acc.Id;
        opp2.CloseDate=system.today();
        opp2.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;
        Insert opp2;
        
        OpportunityLineItem ol2 = new OpportunityLineItem();
        ol2.OpportunityId=opp2.Id;
        ol2.PricebookEntryId=standardPrice.Id;
        ol2.Product2Id=prod.Id;
        ol2.UnitPrice=12;
        ol2.Quantity=1;
        insert ol2;
        OpportunityContactRole ocr2 = new OpportunityContactRole(opportunityid=opp2.id,contactid=con.id,IsPrimary=true);
        insert ocr2;
        List<String> OpptyIds2 = new List<String>();
        OpptyIds2.add(String.valueOf(opp2.Id));
        
        Id workOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
        
        WorkOrder wo=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs.id,Status='Incomplete');
        
        
        List<WorkOrder> woList=new List<WorkOrder>();
        woList.add(wo);
        Map<String,List<WorkOrder>> caseWOMap = new Map<String,List<WorkOrder>>();
        caseWOMap.put(String.valueOf(cs.id), woList);
        
        test.startTest();
        QuoteTriggerHandler.createCommercialCase(String.valueOf(acc.id), caseWOMap, opp);
        QuoteTriggerHandler.afterUpdateQuoteHandle(OpptyIds);
        QuoteTriggerHandler.createCommercialCase(String.valueOf(acc.id), caseWOMap, opp2);
        
        test.stopTest();
    }
    
    
    /*   
static testMethod void createCommCaseTest()
{
//Create a test account
Account Acc = new Account(Name='Test Account');
insert Acc;

Contact con = new Contact(Lastname = 'Test Contact',accountid=acc.id);
insert con;

Product2 prod = new Product2(Name = 'Accommodation',Sockets__c=5,ProductCode = 'Mngd_Inst', Family = 'Twin Units',CurrencyIsoCode='GBP',IsActive=true);
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

//Create a test opportunity
List<String> OpptyIds = new List<String>();
Opportunity opp = new Opportunity(Name='Test Opportunity',accountid=acc.id,closedate=System.today(),StageName='Qualification',shipping_street__c='TestStreet',Shipping_City__c='TestCity', Shipping_Postal_Code__c='TestPostalCode', Shipping_Country_Picklist__c='United Kingdom');
opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;
Insert opp;

OpportunityLineItem ol = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = customPrice1.id,Product2Id = prod.id,UnitPrice = 10,Quantity = 2);
//List<OpportunityLineItem> olList = new List<OpportunityLineItem>();
//olList.add(ol);
//insert olList;
insert ol;

OpptyIds.add(opp.Id);

OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
insert ocr1;


Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
case cs = new case(AccountId=opp.AccountId,RecordTypeId=CaseRecordTypeId, Type='Commercial', Opportunity__c=opp.Id, ContactId=con.Id,Street__c=opp.Shipping_Street__c, City__c=opp.Shipping_City__c, PostalCode__c=opp.Shipping_Postal_Code__c, Country_Picklist__c=opp.Shipping_Country_Picklist__c);
cs.Project_Manager__c = 'Kostas';
Insert cs;
//cs.Project_Manager__c = 'Kostas';
//update cs;

//WorkType data
WorkType wt= new WorkType(Name='Install (Commercial)',DurationType='Hours',EstimatedDuration=2);
Insert wt;
WorkType wt1= new WorkType(Name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
Insert wt1;

Id woRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
WorkOrder w1= new WorkOrder(ContactId=con.Id,AccountId=opp.AccountId,RecordTypeId = woRecordTypeId ,Priority='Medium',WorkTypeId = wt.Id ,Status = 'Unassigned',CaseId = cs.id);
Insert w1;

//Create a test quote
Quote qt = new Quote(name='Test Quote',opportunityid=opp.id,shippingstreet='test street',billingstreet='test street',shippingcity = 'City',billingcity = 'City',shippingpostalcode = '123',billingpostalcode = '123' ,Notes_about_your_order__c='test note');
Insert qt;

String bodyStr='Test Body';

Attachment att=new Attachment();
att.Body=Blob.valueOf(bodyStr);
att.Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
att.parentId=qt.id;
insert att;

opp.SyncedQuoteId =qt.id;
update opp;       
//Change the status to accepted. It will custom error written in the trigger as there will be no attachment.
//qt.Status = 'Accepted';
//qt.IsSyncing='True';

//update qt;
QuoteTriggerHandlerNew.createCommCase(OpptyIds);

}

*/
    
}