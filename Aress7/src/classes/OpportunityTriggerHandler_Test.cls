@isTest
public class OpportunityTriggerHandler_Test{

    
    public static testmethod void test2(){
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),lastName = 'test',type = 'Prospect');
        insert acc;
        
        Opportunity opp = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId(),Name = 'Test Opp',AccountId = acc.id,closedate = Date.today(),Billing_City__c = 'Test',
                                          Billing_Country_Picklist__c = SObjectType.Opportunity.Fields.Billing_Country_Picklist__c.PicklistValues[0].getValue(),Billing_Postal_Code__c = 'Test',Billing_Street__c = 'Test',Shipping_City__c = 'Test',
                                          Shipping_Country_PickList__c = SObjectType.Opportunity.Fields.Billing_Country_Picklist__c.PicklistValues[0].getValue(),Shipping_Postal_Code__c = 'Test',Shipping_Street__c = 'Test',StageName = 'New');
        insert opp;  
        opp.Survey_Status__c='Scheduled';
        opp.StageName = 'Survey Requested';
        update opp;
        Opportunity opp1 = new Opportunity(recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Charge').getRecordTypeId(),Name = 'Test Opp',AccountId = acc.id,closedate = Date.today(),Billing_City__c = 'Test',Billing_Country_Picklist__c = SObjectType.Opportunity.Fields.Billing_Country_Picklist__c.PicklistValues[0].getValue(),
                                           Billing_Postal_Code__c = 'Test',Billing_Street__c = 'Test',Shipping_City__c = 'Test',
                                           Shipping_Country_PickList__c = SObjectType.Opportunity.Fields.Billing_Country_Picklist__c.PicklistValues[0].getValue(),Shipping_Postal_Code__c = 'Test',Shipping_Street__c = 'Test',StageName = 'New');
        insert opp1;
        List<String> oppIdStringList=new List<String>();
        oppIdStringList.add(String.valueOf(opp1.id));
        oppIdStringList.add(String.valueOf(opp.id));

        
        Product2 pro2 = new Product2(Name='BXCD', isActive=true,ProductCode='Mngd_Inst');
        pro2.Family= 'Charging Cables';
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem2;
        OpportunityLineItem OPplineitem3 = new OpportunityLineItem (Quantity=2, OpportunityId=opp1.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
        insert OPplineitem3;
        
        Contact con = new Contact (lastName ='con',email='test@yopmail.com');
        insert con;
        
        OpportunityContactRole orl = new OpportunityContactRole(ContactId = con.id,OpportunityId = opp.Id,IsPrimary = True);
        insert orl;
        
        Quote quttest = new Quote (Name = 'qoutetest' , OpportunityId = opp.id , Pricebook2Id = Test.getStandardPricebookId(),Survey_Option__c = 'Survey Option 1',status = 'Accepted',shippingstreet='Test',shippingcity='Test',shippingpostalcode='123654789',shippingcountry='India',billingstreet='Test',billingcity='Test',billingpostalcode='12364',billingcountry='India',Notes_about_your_order__c='Test');
        insert quttest ;
        
        Case cs = new Case(street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey');
        insert cs;
        List<Case> csl = new List<Case>();
        csl.add(cs);
        
        List<Quote> cql = new List<Quote>();
        cql.add(quttest);
        
        opp.Install_Status_New__c ='Requested';
        opp.Survey_Status__c = 'Requested';
        
        opp.StageName = 'Won';
        //opp.Install_Status_New__c ='Requested';
        //opp.Survey_Status__c = 'Requested';
        //update opp;
        WorkType wt= new WorkType(name=' Install (Domestic) & Additional Works',DurationType='Hours',EstimatedDuration=2);
        WorkType wt2= new WorkType(name= 'Install (Domestic)',DurationType='Hours',EstimatedDuration=2);
        List<WorkType> WTList=new List<WorkType>();
        WTList.add(wt);
        WTList.add(wt2);
        insert WTList;
        
        List<Id> oppIds=new List<Id>();
        oppIds.add(opp.Id);
        
        test.startTest();
        //opp.Install_Status_New__c='Scheduled';
        
        //opp.Install_Status_New__c='';
          //  update opp;
        OpportunityTriggerHandler.createInstallCase(acc.id,opp.id,opp.name,csl,cql);
        OpportunityTriggerHandler.createInstallCase(acc.id,opp.id,opp.name,null,cql);
        csl.clear();
        OpportunityTriggerHandler.createInstallCase(acc.id,opp.id,opp.name,csl,cql);
        OpportunityTriggerHandler.afterinsertOpp(oppIds);
        OpportunityTriggerHandler.syncSurveyInstallStatToStage(oppIds);
        OpportunityTriggerHandler.createCloneOnlineOppty(oppIds);
        OpportunityTriggerHandler.createOrder(opp1,Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId(),'Ready for Helen',csl,cql,csl);
        OpportunityTriggerHandler.createOrder(Opp,Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId(),'Ready for Helen',csl,cql,csl);
        OpportunityTriggerHandler.createOrder(Opp,Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId(),'Ready for Helen',null,cql,csl);
        csl.add(cs);
        opp.RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId();
        opp.StageName='Qualified';
        //opp.Survey_Status__c='Scheduled';
        //update opp;
        update opp;
        OpportunityTriggerHandler.afterinsertOpp(oppIds);
        //OpportunityTriggerHandler.handleAfterUpdate();
        OpportunityTriggerHandler.createOrder(Opp,Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId(),'Ready for Helen',csl,cql,csl);
        OpportunityTriggerHandler.createOrder(Opp,Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId(),'Ready for Helen',csl,cql,csl);
        OpportunityTriggerHandler.handleAfterUpdate(oppIdStringList,csl);
        test.stopTest();
    }
}