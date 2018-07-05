@isTest
public class TestTriggerToUpdateOpportunity {
    
   /* @isTest static void Testupdateoninsertcase() {
        List<Case> c_list = new List<Case>();
        set<id> oppId = new set<id>();
        case c1 =new case();
        case c2 =new case();
        insert c1;
        insert c2;
       // List<Case> l_co = new List<Case>();
        //case c= l_co[0];
        //account acct = new account(Name='test005');
       // insert acct;
       // Opportunity o1= new Opportunity( Name='test002',StageName='Prospecting',CloseDate=System.today(),AccountId=acct.id);
      //  insert o1;
      //  o1.Date_of_COPS_Approved__c=c.Date_of_COPS_Approved__c;
      //  update o1;
      //  delete o1;
    }
    */
    
    
     public static testmethod void test3(){
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        
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
        Opportunity opp1 = opp.clone();
        insert opp1;
        opp1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Charge').getRecordTypeId();
        update opp1;
        
        Product2 pro2 = new Product2(Name='BXCD', isActive=true,ProductCode='Mngd_Inst');
        insert pro2;

        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;

        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        
        Contact con = new Contact (lastName ='con',email='test@yopmail.com');
        insert con;
        
        OpportunityContactRole orl = new OpportunityContactRole(ContactId = con.id,OpportunityId = opp.Id,IsPrimary = True);
        insert orl;
        
        Quote quttest = new Quote (Name = 'qoutetest' , OpportunityId = opp.id , Pricebook2Id = Test.getStandardPricebookId(),status = 'Accepted'
                                  ,shippingstreet='Test',shippingcity='Test',shippingpostalcode='123654789',shippingcountry='India',
                                  billingstreet='Test',billingcity='Test',billingpostalcode='12364',billingcountry='India',Notes_about_your_order__c='Test');
        insert quttest ;
        
        Case cs = new Case(street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                      Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                      Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey');
        insert cs;
        List<Case> csl = new List<Case>();
        csl.add(cs);
        
        List<Quote> cql = new List<Quote>();
        cql.add(quttest);
        
        opp.StageName = 'Won';
        update opp;
        
        OpportunityTriggerHandler.createInstallCase(acc.id,opp.id,opp.name,csl,cql);
        OpportunityTriggerHandler.createInstallCase(acc.id,opp.id,opp.name,null,cql);
        csl.clear();
        OpportunityTriggerHandler.createInstallCase(acc.id,opp.id,opp.name,csl,cql);
        
        OpportunityTriggerHandler.createOrder(Opp,Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId(),'Ready for Helen',csl,cql);
        OpportunityTriggerHandler.createOrder(Opp,Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId(),'Ready for Helen',null,cql);
        csl.add(cs);
        OpportunityTriggerHandler.createOrder(Opp,Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId(),'Ready for Helen',csl,cql);
        OpportunityTriggerHandler.createOrder(opp1,Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId(),'Ready for Helen',csl,cql);
    }
    
    
    
    
}