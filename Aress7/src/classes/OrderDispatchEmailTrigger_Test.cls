@isTest
public class OrderDispatchEmailTrigger_Test 
{
	static testMethod void OrderDispatchEmailTrigger() 
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
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
        
        Order qt1 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft',Order_Send_Date__c=Datetime.now().date());
        insert qt1;
        
        system.debug('Order Number:'+qt1.id);
        
        Order qt2 = new Order(accountid=acc.id,OpportunityId=opp.Id,pricebook2id=standardPbID,effectivedate=Datetime.now().date(),status='Draft',Order_Send_Date__c=Datetime.now().date());
        insert qt2;
        
        OrderItem orditm1 = new OrderItem(Quantity = 5,PricebookEntryId = pbe2.Id,orderid=qt1.id,UnitPrice=0.0,Include_in_CSV__c=true,Dispatch_Status__c='Draft');
        
        insert orditm1;
        
        system.debug('Order Number:'+qt2.id);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'me@email1.com','you@email2.com'};
        mail.setToAddresses(toAddresses);

        mail.setSubject('My Subject');

        mail.setUseSignature(false);
        mail.setHtmlBody('This is a sample message :- Ref. Order # '+qt1.id);

        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}