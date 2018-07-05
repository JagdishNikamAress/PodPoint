@isTest
public class ServiceCrewMemberTriggertTest {
    
    public static testmethod void test1(){
        
        OperatingHours oh = new OperatingHours(Name='Base Calendar',TimeZone='Europe/London');
        
        Insert oh;
        
       
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt1', Email='standarduser1@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standarduser111@testorg.com');
        insert u;
        
        ServiceResource sr2 = new ServiceResource(Name='Nilesh1',ResourceType='T',RelatedRecordid = u.id, IsActive= True);
        insert sr2;
         ServiceTerritory st = new ServiceTerritory(Name='South West',OperatingHoursId =oh.Id,IsActive = True);
        insert st;
        ServiceTerritoryMember Serter = new ServiceTerritoryMember(); 
        Serter.ServiceResourceId = sr2.id;
        Serter.ServiceTerritoryId = st.id;
        Serter.OperatingHoursId = oh.id;
        Serter.EffectiveStartDate = system.today().adddays(-30);
        Serter.EffectiveEndDate = system.today().adddays(30);
        Serter.TerritoryType = 'P';
        
        insert Serter;
        
        ServiceCrew sc=new ServiceCrew();
        sc.CrewSize=2;
        sc.Name='test';
        insert sc;
        
        ServiceCrewMember scmem=new ServiceCrewMember();
        scmem.StartDate=System.today();
        scmem.ServiceResourceId=sr2.id;
        scmem.ServiceCrewId=sc.Id;
        scmem.EndDate=System.today().adddays(30);
        insert scmem;
        
        
        ServiceResource sr = new ServiceResource(Name='Nilesh',ResourceType='C',ServiceCrewId = sc.id, IsActive= True);

        
       
        
        Insert sr;
        
        ServiceTerritoryMember Serter2 = new ServiceTerritoryMember(); 
        Serter2.ServiceResourceId = sr.id;
        Serter2.ServiceTerritoryId = st.id;
        Serter2.OperatingHoursId = oh.id;
        Serter2.EffectiveStartDate = system.today().adddays(31);
        Serter2.EffectiveEndDate = system.today().adddays(60);
        Serter2.TerritoryType = 'P';
       
        insert Serter2;
        
        
        //list<serviceresource> newww = [select id, (select id from ServiceTerritories) from serviceresource where id = ];
          Account acc = new Account(Name='Testing',CurrencyIsoCode='GBP',BillingCity='London',BillingCountry='United Kingdom',BillingPostalCode='123456',BillingStreet='JNStreet',Phone='123446569',ShippingCity='London',ShippingCountry='United Kingdom',ShippingPostalCode='123456',ShippingStreet='JNStreet');
        insert acc;
        
        Contact con = new Contact(FirstName='Test',LastName='Test',AccountId= acc.id,email = 'reuben1.lomas@destiny.com.au');
        insert con;
        
        Product2 prod = new Product2(Name = 'Accommodation', Family = 'Twin Units',CurrencyIsoCode='GBP');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        List<Pricebook2> Pricebook2List= new List<Pricebook2>();
        Pricebook2 customPB = new Pricebook2(Name='Podpoint - Meetings & Events', isActive=true);
        Pricebook2List.add(customPB) ;
        Pricebook2 customPB1 = new Pricebook2(Name='Podpoint - OnlinePayment', isActive=true);
        Pricebook2List.add(customPB1) ;
        insert Pricebook2List;
        
        List<PricebookEntry> PricebookEntryList= new List<PricebookEntry>();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        PricebookEntryList.add(standardPrice) ;
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB1.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        PricebookEntryList.add(customPrice1) ;
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        PricebookEntryList.add(customPrice) ;
        insert PricebookEntryList;
        
        Id bookingid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();
        Opportunity opp = new Opportunity(Name = 'Testing',AccountId = acc.Id,CurrencyIsoCode='GBP',StageName = 'New',CloseDate = date.parse('09/08/2017'),RecordtypeId= bookingid);
        insert opp;
        
        // OpportunityLineItem ol = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = customPrice1.id,Product2Id = prod.id,UnitPrice = 10,Quantity = 2);
        //  List<OpportunityLineItem> olList = new List<OpportunityLineItem>();
        //  olList.add(ol);
        //  insert olList;
        
        Id caseid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Homecharge Case').getRecordTypeId();
        case cs= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested');
        insert cs;
        case cs1= new case(RecordTypeId=caseid,Status='new',Opportunity__c=opp.Id,ContactId=con.id,Survey_Status__c = 'Requested');
        insert cs1;
        
        List<WorkType> WorkTypeList= new List<WorkType>();
        WorkType wt= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=2,ShouldAutoCreateSvcAppt=true);
        
        WorkTypeList.add(wt);
        WorkType wt2= new WorkType(name='Survey (Domestic)',DurationType='Hours',EstimatedDuration=2);
        WorkTypeList.add(wt2);
        WorkType wt3= new WorkType(name='Maintenance (Domestic)',DurationType='Hours',EstimatedDuration=2);
        WorkTypeList.add(wt3);
        WorkType wt4= new WorkType(name='Install (Commercial)',DurationType='Hours',EstimatedDuration=2);
        WorkTypeList.add(wt4);
        insert WorkTypeList;
        
        Id workOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        Id surveyWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
        Id commWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
        Id maintenanceWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        //Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        
        SET<Id> woIdSet = new SET<Id>();
        WorkOrder wo=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=WorkTypeList[0].id,CaseId=cs.id,Status='Unassigned');
        insert wo;
        woIdSet.add(wo.id);
        
        
        
        // ServiceAppointment sa= [SELECT Id,EarliestStartTime,DueDate,Status FROM ServiceAppointment WHERE ParentRecordId IN:woIdSet];
        //   sa.SchedEndTime=Date.today().addDays(1);
        //   sa.SchedStartTime = Date.today();
        //   update sa;
        
        serviceAppointment sa2 = new ServiceAppointment();
        sa2.EarliestStartTime=System.today();
        sa2.DueDate=System.today()+1;
        sa2.Status='Unassigned';
        sa2.SchedStartTime=System.today();
        sa2.SchedEndTime=System.today()+1;
        sa2.ParentRecordId=wo.id;
        insert sa2;
        
        //         ServiceResource serviceresource_Obj = new ServiceResource(Name = 'Name790', IsActive = true, IsCapacityBased = false, IsOptimizationCapable = false,RelatedRecordId = user_Obj.id);
        // Insert serviceresource_Obj;
        test.startTest();
        Skill s = [SELECT id FROM Skill LIMIT 1];
        SkillRequirement sreq = new SkillRequirement(RelatedRecordId = wo.Id, SkillId = s.Id, SkillLevel = 10);
        insert sreq;
        ServiceResourceSkill srs = new ServiceResourceSkill(EffectiveEndDate=Date.Today().addDays(80), EffectiveStartDate=Date.Today().adddays(-20), SkillLevel=10, SkillId=s.id, ServiceResourceId=sr.id);
        insert srs;
        
        OperatingHours operatinghours_Obj = new OperatingHours(Name = 'Name913', TimeZone = 'Pacific/Kiritimati');
        Insert operatinghours_Obj; 
        ServiceTerritory serviceterritory_Obj = new ServiceTerritory(Name = 'Name348', OperatingHoursId = operatinghours_Obj.id, IsActive = true);
        Insert serviceterritory_Obj; 
        
        /*ServiceTerritoryMember stm = new ServiceTerritoryMember(ServiceTerritoryid = serviceterritory_Obj.id, TerritoryType='P',EffectiveStartDate = Date.Today().addDays(-2),ServiceResourceid=sr.id);
        insert stm;*/
        
        AssignedResource assignedresource_Obj = new AssignedResource(ServiceAppointmentId = sa2.id, ServiceResourceId = sr2.id, ServiceCrewId = sc.id);
        try{
        Insert assignedresource_Obj; 
        }catch (DMLException e){
        }
        
        

        
        
        delete scmem;
    }
}