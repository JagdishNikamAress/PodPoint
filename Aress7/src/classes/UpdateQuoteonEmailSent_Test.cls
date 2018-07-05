@isTest

private class UpdateQuoteonEmailSent_Test{
static testMethod void testcreateTasks(){
       
		test.startTest();
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
     	
        Contact con = new Contact(Lastname = 'Test Contact',accountid=acc.id);
        insert con;
    
    	Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
  		insert opp;
    	
    	OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
    	insert ocr1;
    
    	Quote qt1 = new Quote(Name='Test Quote1',OpportunityId=opp.Id,pricebook2id=standardPbID,shippingstreet='test street',shippingcity = 'City',billingcity = 'City',shippingpostalcode = '123',billingpostalcode = '123' ,billingstreet='test street',Notes_about_your_order__c='test note');
    	insert qt1;
    
        Quote qt2 = new Quote(Name='Test Quote2',OpportunityId=opp.Id,pricebook2id=standardPbID,shippingstreet='test street',billingstreet='test street',shippingcity = 'City',billingcity = 'City',shippingpostalcode = '123',billingpostalcode = '123' ,Notes_about_your_order__c='test note');
    	insert qt2;
    
    
    	QuoteLineItem qtln1 = new QuoteLineItem(QuoteId = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe1.id);
    	insert qtln1;
    	QuoteLineItem qtln2 = new QuoteLineItem(QuoteId = qt1.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe2.id);
    	insert qtln2;
    
    	QuoteLineItem qtln3 = new QuoteLineItem(QuoteId = qt2.id , Quantity = 3.00 , UnitPrice = 12 , PricebookEntryId = pbe3.id);
    	insert qtln3;
    
    List<Task> tasks = new List<Task>{};
     
    Task t1 = new task();
    Task t2 = new task();
    t1.Subject = 'POD Point Quote :';
    t1.Priority = 'Normal';
    t1.ActivityDate = Datetime.now().addDays(3).Date();
    t1.ReminderDateTime = Datetime.now().addDays(1);
    t1.IsReminderSet = true;
    t1.WhatId=qt1.id;
    
    t2.Subject = 'POD Point Quote :';
    t2.Priority = 'Normal';
    t2.ActivityDate = Datetime.now().addDays(3).Date();
    t2.ReminderDateTime = Datetime.now().addDays(1);
    t2.IsReminderSet = true;
    t2.WhatId=qt2.id;
        
   
    tasks.add(t1);
    tasks.add(t2);
    
    System.debug('Before Insert');
    
    // Start the test, this changes governor limit context to 
    // that of trigger rather than test. 

		
    // Insert the Account records that cause the trigger to execute.
    insert tasks; 
		
    // Stop the test, this changes limit context back to test from trigger.
    test.stopTest();
		
    // Query the database for the newly inserted records.
   
}
}