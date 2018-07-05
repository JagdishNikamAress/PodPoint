@isTest
private class OppExtensionController_Test 
{
    static testMethod void TestrequestSurvey() 
    {
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        insert prd3;
        
        Id standardPbID = Test.getStandardPricebookId();
        
        
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook',Description='Test Pricebook', isActive=true);
        insert pbk1;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe3;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id,FieldAware_ID__c='Test',Location_ID__c='Test Location');
        Insert con;
        
        More_FieldAware_Address__c moreaddress = new More_FieldAware_Address__c(City__c='City',Contact__c=con.Id,Country__c='Country',State__c='State',Location_ID__c='',Postal_Code__c='123');
        insert moreaddress;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        insert oppitem1;
        OpportunityLineItem oppitem2 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        insert oppitem2;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        Order qt1 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt1;
        
        Order qt2 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt2;
        
        
        Order ord1 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPbID);
        insert ord1;
        
        Order ord2 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPbID);
        insert ord2;
        
        orderitem qtln1 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id,dispatch_status__c='Draft');
        insert qtln1;
        orderitem qtln2 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id,dispatch_status__c='Draft');
        insert qtln2;
        WorkType wt= new WorkType(name='Survey (Commercial)',DurationType='Hours',EstimatedDuration=2);
        insert wt;
        WorkType wt2= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        insert wt2;
        
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OppExtensionController e = new OppExtensionController(sc);
        
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        e.requestSurvey();
        e.confirm();     
        e.getLocationID(con.MailingStreet, con.MailingCity, con.MailingPostalCode, con.MailingCountry);
        e.getCountries();
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        res.setBody('{"Contacts":{"website": null, "fax": null, "discount": null, "billingLocation": null, "link":'+
                    '{"url": "https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0", "rel": "detail"},'+
                    ' "taxable": true, "customFields": {}, "uuid": "a6a6d9abd41a46cd91b505f5048945d0", "account": null, "glAccount":'+
                    ' null, "name": "Api3 Latency Ben Speakman", "phone": null, "notes": null, "email": null, "location": {"isBilling": '+
                    ' false, "customer": {"uuid": "a6a6d9abd41a46cd91b505f5048945d0"}, "name": "Head", "locality": "Ecublens", "country": '+
                    ' "Switzerland", "region": null, "_links": [{"url": "https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0",'+
                    ' "rel": "customer"}, {"url": "https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4", "rel": "self"}], "postcode":'+
                    ' "1024", "lat": null, "link": {"url": "https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4", "rel": "detail"}, "lng":'+
                    ' null, "type": null, "customFields": {}, "streetName": "Avenue du Tir Federal 80", "uuid": "1653f44183004f2a86aa15fa92ae27d4"}, "onHold": '+
                    'false, "customerId": 163}}');  
        String response = e.getLocatoinIDfromJSONResponse(res);
        e.createCaseInSF(acc, res, opp.Id, opp.Name);
        e.updateResponseinSF(con,res,'PrimaryAddress');
        
        
        
        
        
        
        //System.assertEquals(e.acct, a);
    }
    public static testMethod void TestrequestSurvey1() {
                WorkType wt= new WorkType(name='Survey (Commercial)',DurationType='Hours',EstimatedDuration=2);
        insert wt;
        //Add some products
        Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        insert prd3;
        
        Id standardPbID = Test.getStandardPricebookId();
        
        
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook',Description='Test Pricebook', isActive=true);
        insert pbk1;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe3;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id,FieldAware_ID__c='Test',Location_ID__c='Test Location');
        Insert con;
        
        More_FieldAware_Address__c moreaddress = new More_FieldAware_Address__c(City__c='City',Contact__c=con.Id,Country__c='Country',State__c='State',Location_ID__c='',Postal_Code__c='123');
        insert moreaddress;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        OpportunityLineItem oppitem1 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
        insert oppitem1;
        OpportunityLineItem oppitem2 = new OpportunityLineItem(opportunityid = opp.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
        insert oppitem2;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        Order qt1 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt1;
        
        Order qt2 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft');
        insert qt2;
        
        
        Order ord1 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPbID);
        insert ord1;
        
        Order ord2 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Draft',effectivedate=datetime.now().date(),pricebook2id=standardPbID);
        insert ord2;
        
        orderitem qtln1 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id,dispatch_status__c='Draft');
        insert qtln1;
        orderitem qtln2 = new orderitem(Include_in_CSV__c=true,orderid = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id,dispatch_status__c='Draft');
        insert qtln2;
                      Id CommCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
        Case caseObj1 = new Case(contactid=con.id,External_ID__c = 'J001',Status = 'New' ,Origin = 'Phone',accountid = acc.id,opportunity__c = opp.id,Type='Survey',RecordTypeId=CommCaseRecordTypeId);
        insert caseObj1;

        WorkType wt2= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        insert wt2;
        
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OppExtensionController e = new OppExtensionController(sc);
        
        
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        e.requestSurvey();
        //e.confirm();     
        e.getLocationID(con.MailingStreet, con.MailingCity, con.MailingPostalCode, con.MailingCountry);
        e.getCountries();
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        res.setBody('{"Contacts":{"website": null, "fax": null, "discount": null, "billingLocation": null, "link":'+
                    '{"url": "https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0", "rel": "detail"},'+
                    ' "taxable": true, "customFields": {}, "uuid": "a6a6d9abd41a46cd91b505f5048945d0", "account": null, "glAccount":'+
                    ' null, "name": "Api3 Latency Ben Speakman", "phone": null, "notes": null, "email": null, "location": {"isBilling": '+
                    ' false, "customer": {"uuid": "a6a6d9abd41a46cd91b505f5048945d0"}, "name": "Head", "locality": "Ecublens", "country": '+
                    ' "Switzerland", "region": null, "_links": [{"url": "https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0",'+
                    ' "rel": "customer"}, {"url": "https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4", "rel": "self"}], "postcode":'+
                    ' "1024", "lat": null, "link": {"url": "https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4", "rel": "detail"}, "lng":'+
                    ' null, "type": null, "customFields": {}, "streetName": "Avenue du Tir Federal 80", "uuid": "1653f44183004f2a86aa15fa92ae27d4"}, "onHold": '+
                    'false, "customerId": 163}}');  
        String response = e.getLocatoinIDfromJSONResponse(res);
        
        e.updateResponseinSF(con,res,'PrimaryAddress');
        
        
    }
    
    
}