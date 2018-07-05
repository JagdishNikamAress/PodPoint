@isTest
public class CloneSA_Test {
    public static testMethod void testClone(){
        Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        // WorkType wtInstallDom =[SELECT Id, name from WorkType where name='Install (Domestic)'];
        
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
        
        Case cs = new Case(street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey');
        insert cs;

        
    worktype wt2 =new worktype();
         worktype wt1 =new worktype();
        wt1.Name='Install (Domestic)';
        wt1.EstimatedDuration=4.0;
        wt1.DurationType='hours';
        wt1.Appointment_Start_Offset__c=20;
        insert wt1;
        
        wt2.Name='Additional Works (Domestic)';
        wt2.EstimatedDuration=4.0;
        wt2.DurationType='hours';
        insert wt2;
        worktype wt3 =new worktype();
        wt3.Name='Install (Domestic) & Additional Works';
        wt3.EstimatedDuration=4.0;
        wt3.DurationType='hours';
        insert wt3;
        
        WorkOrder wo1= new WorkOrder();
        wo1.WorkTypeId=wt1.Id;
        wo1.AccountId=acc.Id;
        wo1.CaseId=cs.Id;
        wo1.Status='Unassigned';
        insert wo1;
        
        ServiceAppointment sa = new ServiceAppointment();
        sa.EarliestStartTime=System.today();
        sa.DueDate=System.today()+1;
        sa.Status='Unassigned';
        sa.SchedStartTime=System.today();
        sa.SchedEndTime=System.today()+1;
        sa.ParentRecordId=wo1.id;
        sa.ArrivalWindowStartTime=System.today();
        sa.ArrivalWindowEndTime=System.today()+1;
        insert sa;
    test.startTest();
        CloneSA.cloneME(sa.Id);
    test.stopTest();
        }
}