@isTest
public class WorkOrderTriggerTest {
    
    public static testmethod void test01(){
        checkRecursive.skip_install_statuscheck_whencasecreated = true;
        Set<Id> WOId = new Set<Id>();
        Set<Id> OppId = new Set<Id>();
        
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        Account acc2 = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
                                   Name = 'test',type = 'Prospect');
        insert acc2;
        worktype wt1 =new worktype(Name='Install (Commercial)',EstimatedDuration=4.0,DurationType='hours');
        insert wt1;
        worktype wt11 =new worktype(Name='Install (Domestic) & Additional Works',EstimatedDuration=4.0,DurationType='hours');
        insert wt11;
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
        
        Case cs = new Case(accountid=acc2.id,street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',UUID__c='1223456',Ready_to_Schedule__c = true);
        cs.Project_Manager__c='Jagdish Nikam';
        cs.OLEV__c=true;
        insert cs;
       
List<WorkOrder> workOrderList = new List<WorkOrder>();
List<WorkOrder> workOrderListForUpdate = new List<WorkOrder>();
Id hcInstallWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
        WorkOrder wo1= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        wo1.Planned_Duration__c=10;
        wo1.Timesheet_Duration__c=10;
        workOrderList.add(wo1);
        Id hcInstallWorkOrderIddom = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
		WorkOrder wo11= new WorkOrder(RecordtypeId = hcInstallWorkOrderIddom,WorkTypeId=wt11.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        wo11.Planned_Duration__c=10;
        wo11.Timesheet_Duration__c=10;
        workOrderList.add(wo11);
        insert workOrderList;
		wo1.Timesheet_Duration__c=15;
        update wo1;
        wo11.Status='Scheduled';
       // wo11.Customer_Confirmation__c=True;        
        update wo11;

        Test.startTest();
        wo11.Customer_Confirmation__c=True;        
        update wo11;
        Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
        Test.stopTest();
}
    
    public static testmethod void test02(){
                checkRecursive.skip_install_statuscheck_whencasecreated = true;
        Set<Id> WOId = new Set<Id>();
        Set<Id> OppId = new Set<Id>();
        List<worktype> wtList=new List<WorkType>();
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt1);
        worktype wt2 =new worktype(Name='Additional Works (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt2);
        worktype wt3 =new worktype(Name='Install (Domestic) & Additional Works',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt3);
        insert wtList;
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
        insert cs;
        
        
        
        Id hcInstallWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        List<WorkOrder> woList=new List<WorkOrder>();
        WorkOrder wo1= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSFUser__c=True,Customer_Confirmation__c=True);
        woList.add(wo1) ;
        WorkOrder wo2= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSFUser__c=True,Customer_Confirmation__c=True);
        woList.add(wo2) ;
        insert woList;
        
        
        
        List<WorkOrder> woListToUpdate=new List<WorkOrder>();
        wo1.Status='Rejected';
        woListToUpdate.add(wo1);
        wo2.Status='On Hold';
        woListToUpdate.add(wo2);
        update woListToUpdate;
        
        
        WOId.add(wo1.Id);
        WOId.add(wo2.Id);
        //WOId.add(wo2.Id);
        
        OppId.add(opp.Id);
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        //create your opportunity line item.  This assumes you already have an opportunity created, called opp
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.Id;
        oli.Quantity = 5;
        oli.PricebookEntryId = pbEntry.Id;
        oli.Product2Id=prod.id;
        oli.OpportunityId=opp.Id;
        // oli.TotalPrice=Quantity * pbEntry.UnitPrice;
        oli.TotalPrice=oli.Quantity * pbEntry.UnitPrice;
        insert oli;
        
        List<ProductRequired> Prodlst = new List<ProductRequired>(); 
        
        ProductRequired pr = new ProductRequired();
        pr.ParentRecordId = wo1.Id;
        pr.Product2Id = oli.Product2Id;
        pr.Opportunity__c = oli.OpportunityId;
        pr.QuantityRequired = oli.Quantity;
        system.debug('pr.QuantityRequired' + pr.QuantityRequired);
        pr.WO_OppLineItem_Id__c = oli.id;
        Prodlst.add(pr);
        
        Map<Id,WorkOrder> WOMap = new Map<Id,WorkOrder>();
        WOMap.put(wo1.Id, wo1);
        
        Map<Id, OpportunityLineItem> oliMap = new Map<Id, OpportunityLineItem>();
        oliMap.put(oli.Id, oli);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
        Test.stopTest();
    }
    /*public static testmethod void test03(){
Set<Id> WOId = new Set<Id>();
Set<Id> OppId = new Set<Id>();

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
Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',UUID__c='1223456');
cs.OLEV__c=true;
insert cs;

List<worktype> wtList=new List<WorkType>();
worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
wtList.add(wt1);
worktype wt2 =new worktype(Name='Additional Works (Domestic)',EstimatedDuration=4.0,DurationType='hours');
wtList.add(wt2);
worktype wt3 =new worktype(Name='Install (Domestic) & Additional Works',EstimatedDuration=4.0,DurationType='hours');
wtList.add(wt3);
insert wtList;

Id hcInstallWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
List<WorkOrder> woList=new List<WorkOrder>();
WorkOrder wo1= new WorkOrder(Status='Active',RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSFUser__c=True,Customer_Confirmation__c=True);
woList.add(wo1) ;
//WorkOrder wo2= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id);
//woList.add(wo2) ;
insert woList;

ServiceAppointment sa = new ServiceAppointment();
sa.EarliestStartTime=System.today();
sa.DueDate=System.today()+1;
sa.Status='Completed';
sa.SchedStartTime=System.today();
sa.SchedEndTime=System.today()+1;
sa.ParentRecordId=wo1.id;
sa.ArrivalWindowStartTime=System.today();
sa.ArrivalWindowEndTime=System.today()+1;
sa.Main_SA__c=true;
//sa.WorkTypeId = wt1.Id;
insert sa;



List<FSL_Tasks__c> fslTaskList = new List<FSL_Tasks__c>();
FSL_Tasks__c fslTask = new FSL_Tasks__c(Name = 'Unit PSL/PG Number',Work_Type__c =wt1.Id);
FSL_Tasks__c fslTask1 = new FSL_Tasks__c(Name = 'Annex D Form',Work_Type__c =wt1.Id);
fslTaskList.add(fslTask);
fslTaskList.add(fslTask1);
Insert fslTaskList;

List<Work_Order_Task__c> wotaskList1= new List<Work_Order_Task__c>();
Work_Order_Task__c wot = new Work_Order_Task__c(Work_Order__c=wo1.Id, Signee_Name__c='testSignee', Signee_Relationship__c='TestRelationship', Unit_PSL_PG_number__c='testPgNo', Annex_D_Form__c='testForm1', Task__c=fslTask.Id);
wot.Status__c='Completed';
Work_Order_Task__c wot1 = new Work_Order_Task__c(Work_Order__c=wo1.Id, Signee_Name__c='testSignee', Signee_Relationship__c='TestRelationship1', Unit_PSL_PG_number__c='testPgNo1', Annex_D_Form__c='testForm2', Task__c=fslTask1.Id);
wot1.Status__c='Completed';
wotaskList1.add(wot);
wotaskList1.add(wot1);
Insert wotaskList1;


List<WorkOrder> woListToUpdate=new List<WorkOrder>();
wo1.Status='Completed';
//update wo1;
woListToUpdate.add(wo1);
//wo2.Status='Confirmed';
//woListToUpdate.add(wo2);
//update woListToUpdate;

List<Work_Order_Task__c> wotaskList= new List<Work_Order_Task__c>([SELECT Work_Order__c, Status__c, Id, Task__c FROM Work_Order_Task__c where Work_Order__c=:wo1.Id]);
// for(Work_Order_Task__c wot : wotaskList){
//     wot.Status__c='Completed';

// }
//  delete wotaskList;
List<ServiceAppointment> saList= new List<ServiceAppointment>([SELECT Id, ParentRecordId, Status FROM ServiceAppointment where ParentRecordId=:wo1.Id]);
// for(ServiceAppointment sa: saList){
//     sa.Status='Completed';
// }
delete saList;        




WOId.add(wo1.Id);
//WOId.add(wo2.Id);
//WOId.add(wo2.Id);

OppId.add(opp.Id);

Id pricebookId = Test.getStandardPricebookId();

Product2 prod = new Product2(
Name = 'Product X',
ProductCode = 'Pro-X',
isActive = true
);
insert prod;

//Create your pricebook entry
PricebookEntry pbEntry = new PricebookEntry(
Pricebook2Id = pricebookId,
Product2Id = prod.Id,
UnitPrice = 100.00,
IsActive = true
);
insert pbEntry;

//create your opportunity line item.  This assumes you already have an opportunity created, called opp
OpportunityLineItem oli = new OpportunityLineItem();
oli.OpportunityId = opp.Id;
oli.Quantity = 5;
oli.PricebookEntryId = pbEntry.Id;
oli.Product2Id=prod.id;
oli.OpportunityId=opp.Id;
// oli.TotalPrice=Quantity * pbEntry.UnitPrice;
oli.TotalPrice=oli.Quantity * pbEntry.UnitPrice;
insert oli;

List<ProductRequired> Prodlst = new List<ProductRequired>(); 

ProductRequired pr = new ProductRequired();
pr.ParentRecordId = wo1.Id;
pr.Product2Id = oli.Product2Id;
pr.Opportunity__c = oli.OpportunityId;
pr.QuantityRequired = oli.Quantity;
system.debug('pr.QuantityRequired' + pr.QuantityRequired);
pr.WO_OppLineItem_Id__c = oli.id;
Prodlst.add(pr);

Map<Id,WorkOrder> WOMap = new Map<Id,WorkOrder>();
WOMap.put(wo1.Id, wo1);

Map<Id, OpportunityLineItem> oliMap = new Map<Id, OpportunityLineItem>();
oliMap.put(oli.Id, oli);
Test.startTest();
//Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
Test.stopTest();
}*/
    public static testMethod void afterInsertTest(){
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),lastName = 'test',type = 'Prospect');
        insert acc;
        Account acc3 = new Account(lastName = 'test',type = 'Prospect');
        insert acc3;
        
        //Case
        worktype wt =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        insert wt;
        worktype wt11 =new worktype(Name='Install (Domestic) & Additional Works',EstimatedDuration=4.0,DurationType='hours');
        insert wt11;
        WorkOrder wo = new WorkOrder(RecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId(),
                                     WorkTypeId=wt.Id,AccountId=acc3.Id);
        
    }
    
   /* public static testMethod void method5(){
        
        Set<Id> WOId = new Set<Id>();
        Set<Id> OppId = new Set<Id>();
        List<worktype> wtList=new List<WorkType>();
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours',ShouldAutoCreateSvcAppt =true);
        
        wtList.add(wt1);
        worktype wt2 =new worktype(Name='Additional Works (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt2);
        worktype wt3 =new worktype(Name='Install (Domestic) & Additional Works',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt3);
        insert wtList;
        
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
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',UUID__c='1223456');
        insert cs;
        
        
        Id hcInstallWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        List<WorkOrder> woList=new List<WorkOrder>();
        WorkOrder wo1= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True,IsSFUser__c=true);
        woList.add(wo1) ;
        // WorkOrder wo2= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSFUser__c=True,Customer_Confirmation__c=True);
        //  woList.add(wo2) ;
        insert woList;
        serviceAppointment sa=[SELECT ID,SchedStartTime,SchedEndTime,ParentRecordId,ActualEndTime,Main_SA__c,Technician__c,Installer_Id_c__c FROM ServiceAppointment WHERE Main_SA__c=True and ParentRecordId=:wo1.id limit 1];
        sa.SchedStartTime=system.now();
        sa.SchedEndTime=system.now()+1;
        update sa;
        Test.startTest();
        wo1.Status='Scheduled';
        update wo1;
        wo1.Customer_Confirmation__c=true;
        update wo1;
        wo1.Customer_Confirmation__c=false;
        update wo1;
        wo1.Customer_Confirmation__c=true;
        update wo1;
        Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
        Test.stopTest();
        
    }    */
    
    public static testMethod void method6(){
        
        Set<Id> WOId = new Set<Id>();
        Set<Id> OppId = new Set<Id>();
        List<worktype> wtList=new List<WorkType>();
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt1);
        worktype wt2 =new worktype(Name='Groundworks (Commercial)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt2);
        worktype wt3 =new worktype(Name='Maintenance (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt3);
        worktype wt4 =new worktype(Name='Survey (Commercial)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt4);
        worktype wt11 =new worktype(Name='Install (Domestic) & Additional Works',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt11);
        insert wtList;
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
        insert cs;
        
        
        
        Id hcInstallWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        Id groundworksWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Groundworks').getRecordTypeId();
        Id MaintainanceWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        Id SurveyWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
        
        List<WorkOrder> woList=new List<WorkOrder>();
        WorkOrder wo1= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True,IsSFUser__c=true);
        woList.add(wo1) ;
        WorkOrder wo2= new WorkOrder(RecordtypeId = groundworksWorkOrderId,WorkTypeId=wt2.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True,IsSFUser__c=true);
        woList.add(wo2) ;
        WorkOrder wo3= new WorkOrder(RecordtypeId = MaintainanceWorkOrderId,WorkTypeId=wt3.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True,IsSFUser__c=true);
        woList.add(wo3) ;
        WorkOrder wo4= new WorkOrder(RecordtypeId = SurveyWorkOrderId,WorkTypeId=wt4.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True,IsSFUser__c=true);
        woList.add(wo4) ;
        // WorkOrder wo2= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSFUser__c=True,Customer_Confirmation__c=True);
        //  woList.add(wo2) ;
        insert woList;
        wo1.Arrival_Window_End_Time__c='11:15';
        //update wo1;
        wo2.Arrival_Window_End_Time__c='11:15';
        //update wo2;
        wo3.Arrival_Window_End_Time__c='11:15';
        //update wo3;
        wo4.Arrival_Window_End_Time__c='11:15';
        //update wo4;
        update woList;
        
    }    
    
   /* public static testmethod void test07(){
        Set<Id> WOId = new Set<Id>();
        Set<Id> OppId = new Set<Id>();
        
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        Account acc2 = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
                                   Name = 'test',type = 'Prospect');
        insert acc2;
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours',ShouldAutoCreateSvcAppt =true);
        insert wt1;

        
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
        
        Case cs = new Case(accountid=acc2.id,street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',UUID__c='1223456');
        cs.OLEV__c=true;
        insert cs;
         
        List<WorkOrder> workOrderList = new List<WorkOrder>();
        List<WorkOrder> workOrderListForUpdate = new List<WorkOrder>();
        Id hcInstallWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        WorkOrder wo1= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        workOrderList.add(wo1);
        insert workOrderList;
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
        wo1.Status='Scheduled';
      //  wo1.Customer_Confirmation__c=True;
        //wo1.IsSFUser__c=True;
        //workOrderListForUpdate.add(wo1);
        update wo1;
         Test.startTest();
      wo1.Customer_Confirmation__c=True;
      update wo1;
         Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
        Test.stopTest();
               

} */
    
    public static testmethod void test08(){
        checkRecursive.skip_install_statuscheck_whencasecreated = true;
        Set<Id> WOId = new Set<Id>();
        Set<Id> OppId = new Set<Id>();
        
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        Account acc2 = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
                                   Name = 'test',type = 'Prospect');
        insert acc2;
        List<WorkType> wtList=new List<WorkType>();
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt1) ;
        worktype wt11 =new worktype(Name='Install (Domestic) & Additional Works',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt11) ;
        worktype wt12 =new worktype(Name='Survey (Commercial)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt12) ;
        worktype wt13 =new worktype(Name='Maintenance (Commercial)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt13) ;
        insert wtList;
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
        
        Case cs = new Case(accountid=acc2.id,street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',UUID__c='1223456',Ready_to_Schedule__c = true);
        cs.OLEV__c=true;
        insert cs;
        
        List<WorkOrder> workOrderList = new List<WorkOrder>();
        List<WorkOrder> workOrderListForUpdate = new List<WorkOrder>();
        Id hcInstallWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        Id surveyWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
        //  Id commWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
        Id maintenanceWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        
        WorkOrder wo1= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,Status='Active',WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        workOrderList.add(wo1);
        WorkOrder wo2= new WorkOrder(RecordtypeId = surveyWORecordTypeId,Status='Active',WorkTypeId=wt12.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        workOrderList.add(wo2);
        WorkOrder wo3= new WorkOrder(RecordtypeId = maintenanceWORecordTypeId,Status='Active',WorkTypeId=wt13.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        workOrderList.add(wo3);
        //        WorkOrder wo4= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,Status='Active',WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        //workOrderList.add(wo4);
        insert workOrderList;

        //wo1.Arrival_Window_End_Time__c=string.valueOf(System.today());
        //update wo1;
        wo2.Arrival_Window_End_Time__c=string.valueOf(System.today());
        wo3.Arrival_Window_End_Time__c=string.valueOf(System.today());
        wo1.Arrival_Window_End_Time__c=string.valueOf(System.today());
        wo1.Status='Completed';
        if(workOrderList.size()>0){
           update workOrderList;
        }
        //update wo1;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
        Test.stopTest();
}
    
    public static testmethod void test09(){
        checkRecursive.skip_install_statuscheck_whencasecreated = true;
        Set<Id> WOId = new Set<Id>();
        Set<Id> OppId = new Set<Id>();
        
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),
                                  lastName = 'test',type = 'Prospect');
        insert acc;
        Account acc2 = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
                                   Name = 'test',type = 'Prospect');
        insert acc2;
        List<WorkType> wtList=new List<WorkType>();
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt1) ;
        worktype wt11 =new worktype(Name='Install (Domestic) & Additional Works',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt11) ;
        worktype wt12 =new worktype(Name='Survey (Commercial)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt12) ;
        worktype wt13 =new worktype(Name='Maintenance (Commercial)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt13) ;
        insert wtList;
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
        
        Case cs = new Case(accountid=acc2.id,street__c='Test',city__c='test',country_picklist__c='India',postalcode__c='735101',Opportunity__c=opp.id,
                           Install_Cost_Quote_2__c=1000,Install_Cost_Quote__c=500,Install_Hours_2__c=200,Install_Hours__c=200,
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',UUID__c='1223456',Ready_to_Schedule__c = true);
        cs.OLEV__c=true;
        insert cs;
        
        List<WorkOrder> workOrderList = new List<WorkOrder>();
        List<WorkOrder> workOrderListForUpdate = new List<WorkOrder>();
        Id hcInstallWorkOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        Id surveyWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
        //  Id commWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
        Id maintenanceWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        
        WorkOrder wo1= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,Status='Active',WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        workOrderList.add(wo1);
        WorkOrder wo2= new WorkOrder(RecordtypeId = surveyWORecordTypeId,Status='Active',WorkTypeId=wt12.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        workOrderList.add(wo2);
        WorkOrder wo22= new WorkOrder(RecordtypeId = surveyWORecordTypeId,Status='Completed',WorkTypeId=wt12.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        workOrderList.add(wo22);
        WorkOrder wo3= new WorkOrder(RecordtypeId = maintenanceWORecordTypeId,Status='Active',WorkTypeId=wt13.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        workOrderList.add(wo3);
        WorkOrder wo33= new WorkOrder(RecordtypeId = maintenanceWORecordTypeId,Status='Completed',WorkTypeId=wt13.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        workOrderList.add(wo33);
        //        WorkOrder wo4= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,Status='Active',WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSiteUser__c=True);
        //workOrderList.add(wo4);
        insert workOrderList;
        
        //wo1.Arrival_Window_End_Time__c=string.valueOf(System.today());
        //update wo1;
        wo2.Arrival_Window_End_Time__c=string.valueOf(System.today());
        wo3.Arrival_Window_End_Time__c=string.valueOf(System.today());
        wo1.Arrival_Window_End_Time__c=string.valueOf(System.today());
        wo1.Status='Completed';
        if(workOrderList.size()>0){
           update workOrderList;
        }
        
        //update wo1;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
        Test.stopTest();
}
    
    
}