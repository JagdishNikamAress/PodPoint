@isTest(seeAlldata=true)
public class GDriveFolderCreationQueueableTest {
  /*  
    @testSetup
    static void setupTestData(){
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
        
        Case cs = new Case(accountid=acc.id,street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',UUID__c='1223456',Ready_to_Schedule__c = true);
        cs.Project_Manager__c='Jagdish Nikam';
        cs.OLEV__c=true;
        insert cs;        
        
    }
   */ 
    
    
    static testmethod  void test(){
        checkRecursive.skip_install_statuscheck_whencasecreated = true;
        list<account> acc = [select id, name from account where id in (select accountid from opportunity) limit 1];
        opportunity opp =  [select id, name from opportunity where accountid =: acc[0].id];
        case css=[Select id, CaseNumber from case limit 1];
        Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
        GDriveFolderCreationQueueable toEnq = new GDriveFolderCreationQueueable(opp,acc,css.CaseNumber);
        toEnq.calloutGDRIVE(opp, acc);
    }
}