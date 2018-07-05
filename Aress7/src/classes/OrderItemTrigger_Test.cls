@isTest
public class OrderItemTrigger_Test 
{
    static testMethod void OrderItemTrigger() 
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
        
            

        
        qtln1.Dispatch_Status__c = 'Dispatched';
        qtln2.Dispatch_Status__c = 'Dispatched';
        
        update qtln1;
        update qtln2;
    }
}