@isTest
public class WorkOrderLineItemTriggerTest {

     public static testmethod void test01(){
        Set<Id> WOLIId = new Set<Id>();
        Set<Id> OppId = new Set<Id>();
        
        Account acc = new Account(Name='Testing',CurrencyIsoCode='GBP',BillingCity='London',BillingCountry='United Kingdom',BillingPostalCode='123456',BillingStreet='JNStreet',Phone='123446569',ShippingCity='London',ShippingCountry='United Kingdom',ShippingPostalCode='123456',ShippingStreet='JNStreet');
        insert acc;
        
        Contact con = new Contact(FirstName='Test',LastName='Test',AccountId= acc.id,email = 'reuben1.lomas@destiny.com.au');
        insert con;
        
        Product2 prod = new Product2(Name = 'Accommodation', Family = 'Twin Units',CurrencyIsoCode='GBP');
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
        Opportunity opp = new Opportunity(Name = 'Testing',AccountId = acc.Id,CurrencyIsoCode='GBP',StageName = 'New',CloseDate = date.parse('09/08/2017'),RecordtypeId= bookingid);
        insert opp;
        
        
        OpportunityLineItem ol = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = customPrice1.id,Product2Id = prod.id,UnitPrice = 10,Quantity = 2);
        List<OpportunityLineItem> olList = new List<OpportunityLineItem>();
        olList.add(ol);
        insert olList;    
        
        Case cs = new Case(street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey');
        insert cs;
        
        worktype wt1 =new worktype();
        wt1.Name='Install (Domestic)';
        wt1.EstimatedDuration=4.0;
        wt1.DurationType='hours';
        insert wt1;

    
        WorkOrder wo1= new WorkOrder();
        wo1.WorkTypeId=wt1.Id;
        wo1.AccountId=acc.Id;
        wo1.CaseId=cs.Id;
        // wo1.Opportunity_Id__c=opp.Id;
        insert wo1;
    
         WorkOrderLineItem woli1= new WorkOrderLineItem();
         woli1.WorkTypeId=wt1.Id;
         woli1.WorkOrderId=wo1.Id;
         woli1.Account__c=acc.Id;
     	 woli1.Case__c=cs.Id;
        insert woli1;
    
     }   
}