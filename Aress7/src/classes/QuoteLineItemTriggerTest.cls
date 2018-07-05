@isTest
public class QuoteLineItemTriggerTest {
    
    static testMethod void test1(){
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
        
        Opportunity opp = new Opportunity(Name='Test Opp',Workplace_Grant__c=true,AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
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
    }
}