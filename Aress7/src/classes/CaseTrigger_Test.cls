@isTest
public class CaseTrigger_Test 
{
    static testMethod void TestMethodCaseTrigger() {
        Id standardPbID = Test.getStandardPricebookId();
        
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        //   insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        //  insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        // insert prd3;
        list <Product2> productList=new List<Product2>();
        productList.add(prd1);
        productList.add(prd2);
        productList.add(prd3);
        insert productList;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(email='test@test.com',FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id,FieldAware_ID__c='Test',Location_ID__c='Test Location');
        Insert con;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        // insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        //  insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        // insert pbe3;
        
        list <PricebookEntry> priceBookList=new List<PricebookEntry>();
        priceBookList.add(pbe1);
        priceBookList.add(pbe2);
        priceBookList.add(pbe3);
        insert priceBookList;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        // insert oppitem1;
        OpportunityLineItem oppitem2 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        //insert oppitem2;
        list <OpportunityLineItem> oliList=new List<OpportunityLineItem>();
        oliList.add(oppitem1);
        oliList.add(oppitem2);
        // oliList.add(pbe3);
        insert oliList;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        Order qt1 = new Order(accountid=acc.id,recordtypeid='01224000000LNKm',OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt1;
        
        Order qt2 = new Order(accountid=acc.id,recordtypeid='01224000000LNKm',OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt2;
        
        
        Opportunity opp1 = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp1;
        
        OpportunityLineItem oppitem3 = new OpportunityLineItem(opportunityid = opp1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        // insert oppitem1;
        OpportunityLineItem oppitem4 = new OpportunityLineItem(opportunityid = opp1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        //insert oppitem2;
        list <OpportunityLineItem> oliList1=new List<OpportunityLineItem>();
        oliList1.add(oppitem3);
        oliList1.add(oppitem4);
        // oliList.add(pbe3);
        insert oliList1;
        
        OpportunityContactRole ocr2 = new OpportunityContactRole(opportunityid=opp1.id,contactid=con.id,IsPrimary=true);
        insert ocr2;
        
        Order qt3 = new Order(accountid=acc.id,recordtypeid='01224000000LNKm',OpportunityId=opp1.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt3;
        
        Order qt4 = new Order(accountid=acc.id,recordtypeid='01224000000LNKm',OpportunityId=opp1.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt4;
        
        
        Case caseObj1 = new Case(contactid=con.id,External_ID__c = 'J001',Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp.id,Type='Survey');
        Case caseObj2 = new Case(contactid=con.id,External_ID__c = 'J002',Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp.id,Type='Install');
        
        WorkType wt= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        insert wt;
        
        Id contrCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Contractor Case').getRecordTypeId();
        Id commCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
        Id installCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Install Case').getRecordTypeId();
        Id SupportCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId();
        Case caseObj3 = new Case(RecordTypeId=contrCaseRecordTypeId1,contactid=con.id,External_ID__c = 'J001',Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp.id,Type='Survey',Approve_Survey_Option_2__c=true);
        Case caseObj4 = new Case(RecordTypeId=installCaseRecordTypeId1,contactid=con.id,External_ID__c = 'J001',Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp.id,Type='Survey',Approve_Survey_Option_1__c=true);
        Case caseObj5 = new Case(RecordTypeId=SupportCaseRecordTypeId1,contactid=con.id,External_ID__c = 'J001',Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp1.id,Type='Commercial');
        
        list <case> csList=new List<case>();
        csList.add(caseObj1);
        csList.add(caseObj2);
        csList.add(caseObj3);
        csList.add(caseObj4);
        csList.add(caseObj5);
        insert csList;
        
        caseObj5.Approve_Survey_Option_1__c=true;
        caseObj5.Approve_Survey_Option_2__c=true;
        update caseObj5;
        Test.startTest();
        //insert caseObj1;
        // insert caseObj2;
        //  insert caseObj3;
        //  insert caseObj4;
        caseObj2.status = 'Awaiting Schedule';
        caseObj2.Approve_Survey_Option_1__c=true;
        
        update caseObj2;
        
        // caseObj1.status = 'Awaiting Schedule';
        // update caseObj1;
        
        caseObj1.status = 'Closed';
        caseObj2.status = 'Closed';
        
        //update caseObj1;
        //update caseObj2;
        update csList;
        delete caseObj1;
        delete caseObj2;
        delete caseObj5;
        Test.stopTest();
        
    }
    static testMethod void TestMethodCaseTrigger1() {
        Id standardPbID = Test.getStandardPricebookId();
        
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        //   insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        //  insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        // insert prd3;
        list <Product2> productList=new List<Product2>();
        productList.add(prd1);
        productList.add(prd2);
        productList.add(prd3);
        insert productList;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Account acc1 = new Account(Name='Test Account1');
        insert acc1;
        
        Contact con = new Contact(email='test@test.com',FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id,FieldAware_ID__c='Test',Location_ID__c='Test Location');
        Insert con;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        // insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        //  insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        // insert pbe3;
        
        list <PricebookEntry> priceBookList=new List<PricebookEntry>();
        priceBookList.add(pbe1);
        priceBookList.add(pbe2);
        priceBookList.add(pbe3);
        insert priceBookList;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        // insert oppitem1;
        OpportunityLineItem oppitem2 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        //insert oppitem2;
        list <OpportunityLineItem> oliList=new List<OpportunityLineItem>();
        oliList.add(oppitem1);
        oliList.add(oppitem2);
        // oliList.add(pbe3);
        insert oliList;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        Order qt1 = new Order(accountid=acc.id,recordtypeid='01224000000LNKm',OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt1;
        
        Order qt2 = new Order(accountid=acc.id,recordtypeid='01224000000LNKm',OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt2;
        
        
        Opportunity opp1 = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp1;
        
        OpportunityLineItem oppitem3 = new OpportunityLineItem(opportunityid = opp1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        // insert oppitem1;
        OpportunityLineItem oppitem4 = new OpportunityLineItem(opportunityid = opp1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        //insert oppitem2;
        list <OpportunityLineItem> oliList1=new List<OpportunityLineItem>();
        oliList1.add(oppitem3);
        oliList1.add(oppitem4);
        // oliList.add(pbe3);
        insert oliList1;
        
        OpportunityContactRole ocr2 = new OpportunityContactRole(opportunityid=opp1.id,contactid=con.id,IsPrimary=true);
        insert ocr2;
        
        Order qt3 = new Order(accountid=acc.id,recordtypeid='01224000000LNKm',OpportunityId=opp1.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt3;
        
        Order qt4 = new Order(accountid=acc.id,recordtypeid='01224000000LNKm',OpportunityId=opp1.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt4;
        
        Case caseObj1 = new Case(contactid=con.id,External_ID__c = 'J001',Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp.id,Type='Survey');
        Case caseObj2 = new Case(contactid=con.id,External_ID__c = 'J002',Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp.id,Type='Install');
        
        WorkType wt= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        insert wt;
        
        Id contrCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Contractor Case').getRecordTypeId();
        Id commCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
        // Id installCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Install Case').getRecordTypeId();
        
        Case caseObj3 = new Case(RecordTypeId=contrCaseRecordTypeId1,contactid=con.id,External_ID__c = 'J001',Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp.id,Type='Survey',Approve_Survey_Option_2__c=true);
        // Case caseObj4 = new Case(RecordTypeId=installCaseRecordTypeId1,contactid=con.id,External_ID__c = 'J001',Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp.id,Type='Survey',Approve_Survey_Option_1__c=true);
        Case caseObj5 = new Case(RecordTypeId=commCaseRecordTypeId1,contactid=con.id,External_ID__c = 'J001',Status = 'Closed' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp1.id,Type='Commercial',Install_Status__c='Requested');
        
        list <case> csList=new List<case>();
        csList.add(caseObj1);
        csList.add(caseObj2);
        csList.add(caseObj3);
        // csList.add(caseObj4);
        csList.add(caseObj5);
        insert csList;
        //caseObj5.AccountId= acc1.Id;
        caseObj5.Approve_Survey_Option_1__c=true;
        caseObj5.Approve_Survey_Option_2__c=true;
        caseObj5.Survey_Status__c = 'Requested';
        caseObj5.Install_Status__c = NULL;
        update caseObj5;
        Test.startTest();
        //insert caseObj1;
        // insert caseObj2;
        //  insert caseObj3;
        //  insert caseObj4;
        caseObj2.status = 'Awaiting Schedule';
        caseObj2.Approve_Survey_Option_1__c=true;
        
        update caseObj2;
        
        // caseObj1.status = 'Awaiting Schedule';
        // update caseObj1;
        
        caseObj1.status = 'Closed';
        caseObj2.status = 'Closed';
        
        //update caseObj1;
        //update caseObj2;
        update csList;
        delete caseObj1;
        delete caseObj2;
        delete caseObj5;
        Test.stopTest();
        
    }
    static testMethod void TestMethodCaseTrigger2() {
        Test.startTest();
        Id standardPbID = Test.getStandardPricebookId();
        
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        //   insert prd1;
        list <Product2> productList=new List<Product2>();
        productList.add(prd1);
        insert productList;
        
               Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
      
       // Contact con = new Contact(email='test@test.com',FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id,FieldAware_ID__c='Test',Location_ID__c='Test Location');
        //Insert con;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        // insert pbe1;
        
        list <PricebookEntry> priceBookList=new List<PricebookEntry>();
        priceBookList.add(pbe1);
        insert priceBookList;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        
        list <OpportunityLineItem> oliList=new List<OpportunityLineItem>();
        oliList.add(oppitem1);
        insert oliList;
        
       // OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        //insert ocr1;
        
        Id supportCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId();

        Case caseObj1 = new Case(RecordTypeId=supportCaseRecordTypeId1,Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp.id,Type='Survey');
        insert caseObj1;
        
        Test.stopTest();
    }
}