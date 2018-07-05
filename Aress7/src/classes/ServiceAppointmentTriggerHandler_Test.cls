@istest
public class ServiceAppointmentTriggerHandler_Test {
    
    
    public static testmethod void test1(){    
        
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
        
        /* workOrderLineItem woli = new workOrderLineItem();
woli.WorkOrderId=wo1.Id;
woli.WorkTypeId=wt1.Id;
woli.Case__c=cs.id;
woli.Status='Unassigned';
insert woli;

serviceAppointment sa11 = new ServiceAppointment();
sa11.EarliestStartTime=System.today();
sa11.DueDate=System.today()+1;
sa11.Status='Unassigned';
sa11.SchedStartTime=System.today();
sa11.SchedEndTime=System.today()+1;
sa11.ParentRecordId=woli.id;
insert sa11;
*/
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
        sa.Status='Unassigned';
        sa.SchedStartTime=System.today();
        sa.SchedEndTime=System.today()+1;
        sa.ParentRecordId=wo1.id;
        sa.ArrivalWindowStartTime=System.today();
        sa.ArrivalWindowEndTime=System.today()+1;
        insert sa;
        //sa.Main_SA__c = True;
        //update sa;
          delete sa;
 /*       serviceAppointment sa2 = new ServiceAppointment();
        sa2.EarliestStartTime=System.today();
        sa2.DueDate=System.today()+1;
        sa2.Status='Unassigned';
        sa2.SchedStartTime=System.today();
        sa2.SchedEndTime=System.today()+1;
        sa2.ParentRecordId=wo1.id;
        insert sa2;
        
        serviceAppointment sa3 = new ServiceAppointment();
        sa3.EarliestStartTime=System.today();
        sa3.DueDate=System.today()+1;
        sa3.Status='Scheduled';
        sa3.SchedStartTime=System.today();
        sa3.SchedEndTime=System.today()+1;
        sa3.ParentRecordId=wo1.id;
        //sa3.WorkTypeId=wt1.id;
   //     insert sa3;
        
        test.startTest();
        sa2.Main_SA__c=true;
        update sa2;
        //sa3.Status='Unassigned';
        // update sa3;
         sa2.Main_SA__c=true;
        update sa2;
        sa.ArrivalWindowEndTime=system.today()+2;
        update sa;
        // sa.Status='Scheduled';
        // update sa;
        
        //sa.Status='Scheduled';
        //update sa;        
        delete sa;
        test.stopTest();*/
    }
    
 /*   public static testmethod void test2(){    
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
        
        List<Case> csList = new List<Case>();
        SET<Id> caseIdSet = new SET<Id>();
        Case cs = new Case(street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey');
        csList.add(cs);
        insert csList;
        caseIdSet.add(cs.id);
        
        worktype wt1 =new worktype();
        wt1.Name='Install (Domestic)';
        wt1.EstimatedDuration=4.0;
        wt1.DurationType='hours';
        wt1.Appointment_Start_Offset__c=20;
        insert wt1;
        
        worktype wt3 =new worktype();
        wt3.Name='Install (Domestic) & Additional Works';
        wt3.EstimatedDuration=4.0;
        wt3.DurationType='hours';
        insert wt3;
        List<WorkOrder> woList= new List<WorkOrder>();
        SET<Id> woIdSet = new SET<Id>();
        WorkOrder wo1= new WorkOrder();
        wo1.WorkTypeId=wt1.Id;
        wo1.AccountId=acc.Id;
        wo1.CaseId=cs.Id;
        wo1.Status='Unassigned';
        wo1.Missing_Comment__c=true;
        woList.add(wo1);
        insert woList;
        woIdSet.add(wo1.id);
        
        serviceAppointment sa1 = new ServiceAppointment();
        sa1.EarliestStartTime=System.today();
        sa1.DueDate=System.today()+2;
        sa1.Status='Scheduled';
        sa1.SchedStartTime=System.today();
        sa1.SchedEndTime=System.today()+1;
        sa1.ParentRecordId=wo1.id;
        sa1.Main_SA__c=true;
        //sa1.Customer_Confirmation__c=false;
        insert sa1;
        sa1.EarliestStartTime=System.today()+1;
        update sa1;
        //sa1.Customer_Confirmation__c=true;
        //      update sa1;
        // sa1.Status='Confirm';
        //  update sa1;
        
        workOrderLineItem woli = new workOrderLineItem();
        woli.WorkOrderId=wo1.Id;
        woli.WorkTypeId=wt1.Id;
        woli.Case__c=cs.id;
        woli.Status='Unassigned';
        insert woli;
        
        serviceAppointment sa11 = new ServiceAppointment();
        sa11.EarliestStartTime=System.today();
        sa11.DueDate=System.today()+1;
        sa11.Status='Unassigned';
        sa11.SchedStartTime=System.today();
        sa11.SchedEndTime=System.today()+1;
        sa11.ParentRecordId=woli.id;
        //      insert sa11;
        
        
        test.startTest();
        ServiceAppointmentTriggerHandler.createOnlinePayOpptynQuote(woIdSet,caseIdSet);
        test.stopTest();
        
    }*/
    
    
    public static testmethod void test3(){    
        Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),lastName = 'test',type = 'Prospect');
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
        
        List<Case> csList = new List<Case>();
        SET<Id> caseIdSet = new SET<Id>();
        Case cs = new Case(street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey');
        csList.add(cs);
        insert csList;
        caseIdSet.add(cs.id);
        
        worktype wt1 =new worktype();
        wt1.Name='Install (Domestic)';
        wt1.EstimatedDuration=4.0;
        wt1.DurationType='hours';
        wt1.Appointment_Start_Offset__c=20;
        insert wt1;
        
        worktype wt3 =new worktype();
        wt3.Name='Install (Domestic) & Additional Works';
        wt3.EstimatedDuration=4.0;
        wt3.DurationType='hours';
        insert wt3;
        
        List<WorkOrder> woList= new List<WorkOrder>();
        WorkOrder wo1= new WorkOrder();
        wo1.WorkTypeId=wt1.Id;
        wo1.AccountId=acc.Id;
        wo1.CaseId=cs.Id;
        wo1.Status='Unassigned';
        wo1.Missing_Comment__c=true;
        woList.add(wo1);
        insert woList;
        
        serviceAppointment sa1 = new ServiceAppointment();
        sa1.EarliestStartTime=System.today()+2;
        sa1.DueDate=System.today()+3;
        sa1.Status='Scheduled';
        sa1.SchedStartTime=System.today();
        sa1.SchedEndTime=System.today()+2;
        sa1.ParentRecordId=wo1.id;
        sa1.Main_SA__c=true;
        sa1.Customer_Confirmation__c=false;
        insert sa1;
       // sa1.EarliestStartTime=System.today()+1;
     //   update sa1;
        sa1.Customer_Confirmation__c=true;
     //   update sa1;

        
        
        test.startTest();
                 sa1.SchedStartTime=System.today()+1;
      update sa1;
        test.stopTest();
        
    }
    
}