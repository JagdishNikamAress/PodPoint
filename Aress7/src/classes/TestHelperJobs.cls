@isTest(seealldata=true)
Private class TestHelperJobs{
    @isTest Static void  TestgetJobDetails(){
        List<Case>  cases = new List<Case>();  
        Case caseObj = new Case(External_ID__c = 'j001',Status = 'New' ,Origin = 'Phone');
        cases.add(caseObj );
        
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        insert prd3;
        
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        //Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where Name = 'Standard Price Book'];
        if (!standardPb.isActive) {
            standardPb.isActive = true;
            update standardPb;
        }
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook',Description='Test Pricebook', isActive=true);
        insert pbk1;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe3;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id);
        Insert con;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        insert oppitem1;
        OpportunityLineItem oppitem2 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        insert oppitem2;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        Order qt1 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPb.id,effectivedate=Datetime.now().date(),status='Draft');
        insert qt1;
        
        Order qt2 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPb.id,effectivedate=Datetime.now().date(),status='Draft');
        insert qt2;
        
        
        Order ord1 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPb.id);
        insert ord1;
        
        Order ord2 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPb.id);
        insert ord2;
        
        orderitem qtln1 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id,dispatch_status__c='Draft');
        insert qtln1;
        orderitem qtln2 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id,dispatch_status__c='Draft');
        insert qtln2;
        
       
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HelperJobs hj = new HelperJobs();
        hj.getJobDetails(cases);
        hj.getJobAttachments(cases);
        
        test.StopTest();
        
        
    }
    
    public static testmethod void test1(){
        Contact con = new Contact(LastName='test', MailingStreet='test',MailingCity='Pune',MailingPostalCode='411027',MailingCountry='India',Location_ID__c='1');
        insert con;
        More_FieldAware_Address__c mfa = new More_FieldAware_Address__c(name='test',City__c='Pune',Country__c='India',Postal_Code__c='411027',Location_ID__c='1',Contact__c=con.Id);
        insert mfa;
		Case caseObj = new Case(External_ID__c = 'j001',Status = 'New' ,Origin = 'Phone');
		insert caseObj;
        
        new helperJobs().getLocationID(con,con.MailingStreet,con.MailingCity,con.MailingPostalCode,con.MailingCountry);
         String s = '{'+
    '    "startedOn": "2016-09-26T16:26:02+00:00",'+
    '    "tasks": [],'+
    '    "description": "This is how we will install.",'+
    '    "revenue": 0,'+
    '    "signature": null,'+
    '    "jobId": "J378",'+
    '    "invoice": null,'+
    '    "jobLead": {'+
    '        "emailAddress": "ben.speakman@pod-point.com",'+
    '        "telno": "5454545544545",'+
    '        "surname": "testerson",'+
    '        "uuid": "3b14be67d8854df4916c39982e065fbc",'+
    '        "name": "tester"'+
    '    },'+
    '    "scheduledOn": "2016-09-26T16:45:00+00:00",'+
    '    "labor": [],'+
    '    "pre_signature": null,'+
    '    "customer": {'+
    '        "uuid": "5fc3139aa76845fc92bcfa63e55e40f1",'+
    '        "name": "Daniel Kaplansky",'+
    '        "customerId": 405'+
    '    },'+
    '    "estDuration": 0,'+
    '    "uuid": "6ee4bdc8edee40aab8102b2344a30bc8",'+
    '    "createdOn": "2016-09-26T15:45:28+00:00",'+
    '    "crew": ['+
    '        {'+
    '            "workedHours": ['+
    '                {'+
    '                    "start": "2016-09-26T16:26:02+00:00",'+
    '                    "inTransit": false,'+
    '                    "end": "2016-09-26T16:26:02+00:00"'+
    '                }'+
    '            ],'+
    '            "state": "completed",'+
    '            "uuid": "3b14be67d8854df4916c39982e065fbc"'+
    '        }'+
    '    ],'+
    '    "state": ['+
    '        "completed"'+
    '    ],'+
    '    "contact": null,'+
    '    "asset": null,'+
    '    "completedOn": "2016-09-26T16:26:02+00:00",'+
    '    "customFields": {'+
    '        "7424ee65493d40d88498771fee88c314": "(Commercial) Solo Install - Manual"'+
    '    },'+
    '    "location": {'+
    '        "uuid": "f6b50a3118c44598ab5d463352c7ff97",'+
    '        "locality": "London",'+
    '        "country": "United Kingdom",'+
    '        "region": null,'+
    '        "postcode": "EC1Y 8QE",'+
    '        "streetName": "This is my address yay!",'+
    '        "name": "Head"'+
    '    }'+
    '}';
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(s);
        res.setStatusCode(200);
        
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        helperJobs.updateResponseinSF(con,caseObj,res);        
        test.StopTest();
    }
    
    @isTest Static void  TestcreateInstallCaseOnly()
    {
        
        
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        insert prd3;
        
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        //Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where Name = 'Standard Price Book'];
        if (!standardPb.isActive) {
            standardPb.isActive = true;
            update standardPb;
        }
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook',Description='Test Pricebook', isActive=true);
        insert pbk1;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe3;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id);
        Insert con;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        insert oppitem1;
        OpportunityLineItem oppitem2 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        insert oppitem2;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        Order qt1 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPb.id,effectivedate=Datetime.now().date(),status='Draft');
        insert qt1;
        
        Order qt2 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPb.id,effectivedate=Datetime.now().date(),status='Draft');
        insert qt2;
        
        
        Order ord1 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPb.id);
        insert ord1;
        
        Order ord2 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPb.id);
        insert ord2;
        
        orderitem qtln1 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id,dispatch_status__c='Draft');
        insert qtln1;
        orderitem qtln2 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id,dispatch_status__c='Draft');
        insert qtln2;
        
        
        
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HelperJobs hj = new HelperJobs();
        hj.createOnlyCase(ord1.id);
      
        test.StopTest();
        
        
    }
   
    
    @isTest Static void  TestcreateJobafterOrderv2(){
        
        
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        insert prd3;
        
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        //Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where Name = 'Standard Price Book'];
        if (!standardPb.isActive) {
            standardPb.isActive = true;
            update standardPb;
        }
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook',Description='Test Pricebook', isActive=true);
        insert pbk1;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe3;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id);
        Insert con;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        insert oppitem1;
        OpportunityLineItem oppitem2 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        insert oppitem2;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        Order qt1 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPb.id,effectivedate=Datetime.now().date(),status='Draft');
        insert qt1;
        
        Order qt2 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPb.id,effectivedate=Datetime.now().date(),status='Draft');
        insert qt2;
        
        
        Order ord1 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPb.id);
        insert ord1;
        
        Order ord2 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPb.id);
        insert ord2;
        
        orderitem qtln1 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id,dispatch_status__c='Draft');
        insert qtln1;
        orderitem qtln2 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id,dispatch_status__c='Draft');
        insert qtln2;
        
        List<Case>  cases = new List<Case>();  
        //Case caseObj1 = new Case(External_ID__c = 'j001',Status = 'New' ,Origin = 'Phone',Type='Survey',accountid=acc.id);
        Case caseObj2 = new Case(External_ID__c = 'j002',Status = 'New' ,Origin = 'Phone',Type='Install',accountid=acc.id);
        //cases.add(caseObj1 );
        cases.add(caseObj2 );
        //insert cases;
        
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HelperJobs hj = new HelperJobs();
        
        helperJobs.updateJobAddress('j001','Street', 'City', 'Country', 'PostalCode');
        helperJobs.updateJobDescription('j001','Description');
        helperJobs.updateJobProjectManager('j001','ProjectManager');
        
        test.StopTest();
        
        
    }
    
     @isTest Static void  TestcreateJobafterOrder(){
        
        
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        insert prd3;
        
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        //Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where Name = 'Standard Price Book'];
        if (!standardPb.isActive) {
            standardPb.isActive = true;
            update standardPb;
        }
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook',Description='Test Pricebook', isActive=true);
        insert pbk1;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe3;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(email='test@test.com',phone='12345',FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id);
        Insert con;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        insert oppitem1;
        OpportunityLineItem oppitem2 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        insert oppitem2;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        Order qt1 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPb.id,effectivedate=Datetime.now().date(),status='Draft');
        insert qt1;
        
        Order qt2 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPb.id,effectivedate=Datetime.now().date(),status='Draft');
        insert qt2;
        
        
        Order ord1 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPb.id);
        insert ord1;
        
        Order ord2 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPb.id);
        insert ord2;
        
        orderitem qtln1 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id,dispatch_status__c='Draft');
        insert qtln1;
        orderitem qtln2 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id,dispatch_status__c='Draft');
        insert qtln2;
        
        List<Case>  cases = new List<Case>();  
        //Case caseObj1 = new Case(External_ID__c = 'j001',Status = 'New' ,Origin = 'Phone',Type='Survey',accountid=acc.id);
        Case caseObj2 = new Case(street__c='Street',city__c='City',Country_Picklist__c='United Kingdom',PostalCode__c='1234',External_ID__c = 'j002',Status = 'New' ,Origin = 'Phone',Type='Install',accountid=acc.id,contactid=con.id);
        //cases.add(caseObj1 );
        cases.add(caseObj2);
        insert cases;
        
        
         
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HelperJobs hj = new HelperJobs();
        hj.createJobafterOrder_v2(caseObj2,acc,opp);
        hj.createJobMaintenance(caseObj2);
        //helperJobs.updateJobAddress(caseObj2.id,'Street', 'City', 'Country', 'PostalCode');
        hj.createOnlyCase(ord1.id);
        test.StopTest();
        
        
    }
    
    
    @isTest Static void  TestcreateJob_Trigger(){
        List<Case>  cases = new List<Case>();  
        Case caseObj = new Case(External_ID__c = 'j001',Status = 'New' ,Origin = 'Phone');
        cases.add(caseObj );
        
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        insert prd3;
        
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        //Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where Name = 'Standard Price Book'];
        if (!standardPb.isActive) {
            standardPb.isActive = true;
            update standardPb;
        }
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook',Description='Test Pricebook', isActive=true);
        insert pbk1;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe3;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id);
        Insert con;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        insert oppitem1;
        OpportunityLineItem oppitem2 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        insert oppitem2;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        Order qt1 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPb.id,effectivedate=Datetime.now().date(),status='Draft');
        insert qt1;
        
        Order qt2 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPb.id,effectivedate=Datetime.now().date(),status='Draft');
        insert qt2;
        
        
        Order ord1 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPb.id);
        insert ord1;
        
        Order ord2 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPb.id);
        insert ord2;
        
        orderitem qtln1 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id,dispatch_status__c='Draft');
        insert qtln1;
        orderitem qtln2 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id,dispatch_status__c='Draft');
        insert qtln2;
        
        
        
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        //HelperJobs hj = new HelperJobs();
        HelperJobs.createJob_Trigger(acc,'123','TestDescription','Survey');
        
        test.StopTest();
        
        
    }
    
    
    @isTest Static void  TestcreateJob(){
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id);
        Insert con;
        
        List<Case>  cases = new List<Case>();  
        Case caseObj1 = new Case(External_ID__c = 'j001',Status = 'New' ,Origin = 'Phone',Type='Survey',accountid=acc.id);
        Case caseObj2 = new Case(External_ID__c = 'j002',Status = 'New' ,Origin = 'Phone',Type='Install',accountid=acc.id);
        cases.add(caseObj1 );
        cases.add(caseObj2 );
        
        
        
        
        
        test.StartTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HelperJobs hj = new HelperJobs();
        HttpResponse res = hj.createJob(acc,'123','TestDescription','Survey');
        res = hj.createJob('123','TestDescription','Survey');
        
        test.StopTest();
        
        
    }
    
    @isTest Static void  TestHttpRequestGETMethod()
    {
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HelperJobs hj = new HelperJobs();
        HttpResponse res = hj.HttpRequestGETMethod('EndPoint','Method');         
        test.StopTest();
    }
    @isTest Static void  TestHttpRequestPOSTMethod_Static()
    {
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HelperJobs.HttpRequestPOSTMethod_Static('EndPoint','Method','TestBody');         
        test.StopTest();
    }
    @isTest Static void  TestHttpRequestPOSTMethod()
    {
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HelperJobs hj = new HelperJobs();
        HttpResponse res = hj.HttpRequestPOSTMethod('EndPoint','Method','TestBody');         
        test.StopTest();
    }
    
    @isTest Static void  TestcreateCaseInSF()
    {
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id);
        Insert con;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HelperJobs hj = new HelperJobs();
        HttpResponse res = hj.createJob(acc,'123','TestDescription','Survey');
        HelperJobs.createCaseInSF(acc,con,res,opp.id,opp.name,'ScopeofWork1',0,0,'ScopeofWork2',0,0,con.MailingStreet,con.MailingCity,con.MailingPostalCode,'United Kingdom');         
        //Account acc,Contact con,HttpResponse resJob,String OpportunityID,String OpportunityName,String ScopeofWork1,Double InstallCostQuote1,Double InstallHours1,String ScopeofWork2,Double InstallCostQuote2,Double InstallHours2,String MailingStreet, String MailingCity, String MailingPostalCode,String MailingCountry
        test.StopTest();
    }
    
    @isTest Static void  TestcreateCaseInSFDuplicate()
    {
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='Angola',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id);
        Insert con;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HelperJobs hj = new HelperJobs();
        HttpResponse res = hj.createJob(acc,'123','TestDescription','Survey');
        HelperJobs.createCaseInSF(acc,res,opp.id,opp.name);         
        test.StopTest();
    }
    
}