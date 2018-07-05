@istest
public class SeriveAppointmentTriggerTest {
    
    
    public static testmethod void test1(){    
        
        Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        worktype wt4 =new worktype();
        wt4.Name='Install (Domestic) & Additional Works';
        wt4.EstimatedDuration=4.0;
        wt4.DurationType='hours';
        wt4.Appointment_Start_Offset__c=20;
        insert wt4;
        
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
        
        Case cs = new Case( AccountId = acc.id,street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',Ready_to_Schedule__c = true);
        insert cs;
        
        worktype wt1 =new worktype();
        wt1.Name='Install (Domestic)';
        wt1.EstimatedDuration=4.0;
        wt1.DurationType='hours';
        wt1.Appointment_Start_Offset__c=20;
        insert wt1;
        
        WorkOrder wo1= new WorkOrder();
        wo1.WorkTypeId=wt1.Id;
        wo1.AccountId=acc.Id;
        wo1.CaseId=cs.Id;
        wo1.Status='Unassigned';
        insert wo1;
        worktype wt2 =new worktype();
        wt2.Name='Additional Works (Domestic)';
        wt2.EstimatedDuration=4.0;
        wt2.DurationType='hours';
        insert wt2;
        worktype wt3 =new worktype();
        wt3.Name='Install (Domestic) & Additional Works';
        wt3.EstimatedDuration=4.0;
        wt3.DurationType='hours';
        insert wt3;
        
        ServiceAppointment sa = new ServiceAppointment();
        sa.EarliestStartTime=System.today();
        sa.DueDate=System.today()+1;
        sa.Status='Scheduled';
        sa.SchedStartTime=System.today();
        sa.SchedEndTime=System.today()+1;
        sa.ParentRecordId=wo1.id;
        sa.ArrivalWindowStartTime=System.today();
        sa.ArrivalWindowEndTime=System.today()+1;
        insert sa;
        test.startTest();
        // sa.Customer_Confirmation__c=true;
        //   update sa;
        delete sa;
        Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
        test.stopTest();
        //   delete sa;
    }
    
    public static testmethod void test2(){    
        
        
        Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        // WorkType wtInstallDom =[SELECT Id, name from WorkType where name='Install (Domestic)'];
        
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        worktype wt4 =new worktype();
        wt4.Name='Install (Domestic) & Additional Works';
        wt4.EstimatedDuration=4.0;
        wt4.DurationType='hours';
        wt4.Appointment_Start_Offset__c=20;
        insert wt4;
        
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
        
        Case cs = new Case( AccountId = acc.id,street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',Ready_to_Schedule__c = true);
        insert cs;
        
        worktype wt1 =new worktype();
        wt1.Name='Install (Domestic)';
        wt1.EstimatedDuration=4.0;
        wt1.DurationType='hours';
        wt1.Appointment_Start_Offset__c=20;
        insert wt1;
         worktype wt2 =new worktype();
        wt2.Name='Groundworks (Domestic)';
        wt2.EstimatedDuration=4.0;
        wt2.DurationType='hours';
        wt2.Appointment_Start_Offset__c=20;
        insert wt2;
        WorkOrder wo1= new WorkOrder();
        wo1.WorkTypeId=wt1.Id;
        wo1.AccountId=acc.Id;
        wo1.CaseId=cs.Id;
        wo1.Status='Unassigned';
        insert wo1;
         WorkOrder wo2= new WorkOrder();
        wo2.WorkTypeId=wt2.Id;
        wo2.AccountId=acc.Id;
        wo2.CaseId=cs.Id;
        wo2.Status='Unassigned';
        insert wo2;

        worktype wt3 =new worktype();
        wt3.Name='Install (Domestic) & Additional Works';
        wt3.EstimatedDuration=4.0;
        wt3.DurationType='hours';
        insert wt3;
       
        ServiceAppointment sa = new ServiceAppointment();
        sa.EarliestStartTime=System.today();
        sa.DueDate=System.today()+1;
        sa.Status='Completed';
        sa.SchedStartTime=System.today();
        sa.SchedEndTime=System.today()+1;
        sa.ParentRecordId=wo1.id;
        sa.ArrivalWindowStartTime=System.today();
        sa.ArrivalWindowEndTime=System.today()+1;
        
        insert sa;
        
        // update sa;
        
        ServiceAppointment sa1 = new ServiceAppointment();
        sa1.EarliestStartTime=System.today();
        sa1.DueDate=System.today()+1;
        sa1.Status='Unassigned';
        sa1.SchedStartTime=System.today();
        sa1.SchedEndTime=System.today()+1;
        sa1.ParentRecordId=wo1.id;
        sa1.ArrivalWindowStartTime=System.today();
        sa1.ArrivalWindowEndTime=System.today()+1;
        
        insert sa1;
        

         test.startTest();
		DateTime dt = DateTime.newInstance(2018, 7, 09, 7, 3, 3);
        sa1.SchedStartTime=dt;
        sa1.SchedEndTime=dt.addminutes(600);
        update sa1;
        
        sa1.SchedStartTime=dt.addminutes(180);
   //     sa1.Main_SA__c=true;
        update sa1;
                sa1.SchedStartTime=dt.addminutes(540);
        update sa1;

        test.stopTest();
        
    }
    
    public static testmethod void test3(){
         Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        // WorkType wtInstallDom =[SELECT Id, name from WorkType where name='Install (Domestic)'];
        
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        worktype wt4 =new worktype();
        wt4.Name='Install (Domestic) & Additional Works';
        wt4.EstimatedDuration=4.0;
        wt4.DurationType='hours';
        wt4.Appointment_Start_Offset__c=20;
        insert wt4;
        
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
        
        Case cs = new Case( AccountId = acc.id,street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',Ready_to_Schedule__c = true);
        insert cs;
        
        worktype wt1 =new worktype();
        wt1.Name='Groundworks (Domestic)';
        wt1.EstimatedDuration=4.0;
        wt1.DurationType='hours';
        wt1.Appointment_Start_Offset__c=20;
        insert wt1;

        WorkOrder wo1= new WorkOrder();
        wo1.WorkTypeId=wt1.Id;
        wo1.AccountId=acc.Id;
        wo1.CaseId=cs.Id;
        wo1.Status='Unassigned';
        insert wo1;
    /*     WorkOrder wo2= new WorkOrder();
        wo2.WorkTypeId=wt2.Id;
        wo2.AccountId=acc.Id;
        wo2.CaseId=cs.Id;
        wo2.Status='Unassigned';
        insert wo2;*/

       
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
        
        // update sa;
        
    /*    ServiceAppointment sa1 = new ServiceAppointment();
        sa1.EarliestStartTime=System.today();
        sa1.DueDate=System.today()+1;
        sa1.Status='Unassigned';
        sa1.SchedStartTime=System.today();
        sa1.SchedEndTime=System.today()+1;
        sa1.ParentRecordId=wo1.id;
        sa1.ArrivalWindowStartTime=System.today();
        sa1.ArrivalWindowEndTime=System.today()+1;
        
        insert sa1;
        
        ServiceAppointment sa2 = new ServiceAppointment();
        sa2.EarliestStartTime=System.today();
        sa2.DueDate=System.today()+1;
        sa2.Status='Unassigned';
        sa2.SchedStartTime=System.today();
        sa2.SchedEndTime=System.today()+1;
        sa2.ParentRecordId=wo2.id;
        sa2.ArrivalWindowStartTime=System.today();
        sa2.ArrivalWindowEndTime=System.today()+1;
        
        insert sa2;*/
        
        
         test.startTest();
		DateTime dt = DateTime.newInstance(2018, 7, 09, 7, 3, 3);
          sa.SchedStartTime=dt;
        sa.SchedEndTime=dt.addminutes(600);
        update sa;
        delete sa;
        
        
        test.stopTest();
        
    } 
    /* public static testmethod void test5(){    

Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
// WorkType wtInstallDom =[SELECT Id, name from WorkType where name='Install (Domestic)'];

Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
lastName = 'test',type = 'Prospect');
insert acc;
worktype wt4 =new worktype();
wt4.Name='Install (Domestic) & Additional Works';
wt4.EstimatedDuration=4.0;
wt4.DurationType='hours';
wt4.Appointment_Start_Offset__c=20;
insert wt4;

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

Case cs = new Case( AccountId = acc.id,street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey');
insert cs;

worktype wt1 =new worktype();
wt1.Name='Install (Domestic)';
wt1.EstimatedDuration=4.0;
wt1.DurationType='hours';
wt1.Appointment_Start_Offset__c=20;
insert wt1;

WorkOrder wo1= new WorkOrder();
wo1.WorkTypeId=wt1.Id;
wo1.AccountId=acc.Id;
wo1.CaseId=cs.Id;
wo1.Status='Unassigned';
insert wo1;

worktype wt2 =new worktype();
wt2.Name='Additional Works (Domestic)';
wt2.EstimatedDuration=4.0;
wt2.DurationType='hours';
insert wt2;
worktype wt3 =new worktype();
wt3.Name='Install (Domestic) & Additional Works';
wt3.EstimatedDuration=4.0;
wt3.DurationType='hours';
insert wt3;

ServiceAppointment sa = new ServiceAppointment();
sa.EarliestStartTime=System.today();
sa.DueDate=System.today()+1;
sa.Status='Completed';
sa.SchedStartTime=System.today();
sa.SchedEndTime=System.today()+1;
sa.ParentRecordId=wo1.id;
sa.ArrivalWindowStartTime=System.today();
sa.ArrivalWindowEndTime=System.today()+1;

insert sa;

update sa;
//   delete sa;

}*/
    
}