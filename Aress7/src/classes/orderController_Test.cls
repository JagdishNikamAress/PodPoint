@isTest
private class orderController_Test {
    static testMethod void validateorderController() 
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
       
       Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id);
       Insert con;
       
       Case c = new Case(accountid=acc.id,Street__c = 'Street', City__c = 'City', Country__c ='Country',PostalCode__c ='1235645',type='Survey');
       Insert c;
        
       Opportunity opp = new Opportunity(Name='Test Opp',StageName='Negotiation',closedate=datetime.now().date(),accountid=acc.id);
       insert opp;
        
       OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        
    
        Order ord1 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Dispatched');
        insert ord1;
        
        Order ord2 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Ready for Dispatch');
        insert ord2;
        
        orderitem qtln1 = new orderitem(Dispatch_Address__c='test street,test city,test,test',Include_in_CSV__c=true,orderid = ord1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id,dispatch_status__c='Draft',Dispatch_Date__c=Datetime.now().date());
        insert qtln1;
        
        
        orderitem qtln2 = new orderitem(Dispatch_Address__c='test street,test city,test,test',Include_in_CSV__c=true,orderid = ord2.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id,dispatch_status__c='Draft',Dispatch_Date__c=Datetime.now().date());
        insert qtln2;
        
            
        
        ApexPages.StandardController sc = new ApexPages.standardController(ord1);
        orderController e = new orderController(sc);
        
       	e.getAddress();
        e.getOrderProductsforExport();
        e.getAllOrdersforiPro();
        e.saveiProChanges();
        e.save();
        e.createInstallCase();

        
        //System.assertEquals(e.acct, a);
    }
}