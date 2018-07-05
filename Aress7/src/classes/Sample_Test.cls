@isTest
public class Sample_Test {
    
    @testSetup
    static void setupTestData(){
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
        
        OperatingHours oh = new OperatingHours(Name='Base Calendar',TimeZone='Europe/London');
        
        Insert oh;
        
        ServiceTerritory st = new ServiceTerritory(Name='South West',OperatingHoursId =oh.Id);
        insert st;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt1', Email='standarduser1@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standarduser111@testorg.com');
        insert u;
        
        ServiceResource sr = new ServiceResource(Name='Nilesh',ResourceType='T',RelatedRecordId=u.id,IsActive= True);
        Insert sr;
        
        //test.startTest();
        
        User user_Obj = new User(Username = 'TestUser451262017121912464811@codecoverage.com', LastName = 'LastName648', Email = 'Email22@test.com', EmailPreferencesAutoBcc = false, EmailPreferencesAutoBccStayInTouch = false, EmailPreferencesStayInTouchReminder = false, Alias = 'Alias426', CommunityNickname = 'cNickName53632', IsActive = true, TimeZoneSidKey = 'Pacific/Kiritimati', LocaleSidKey = 'sq_AL', ReceivesInfoEmails = false, ReceivesAdminInfoEmails = false, EmailEncodingKey = 'UTF-8', ProfileId = p.id, LanguageLocaleKey = 'en_US', UserPermissionsMarketingUser = false, UserPermissionsOfflineUser = false, UserPermissionsAvantgoUser = false, UserPermissionsCallCenterAutoLogin = false, UserPermissionsMobileUser = false, UserPermissionsSFContentUser = false, UserPermissionsInteractionUser = false, UserPermissionsSupportUser = false, ForecastEnabled = false, UserPreferencesActivityRemindersPopup = false, UserPreferencesEventRemindersCheckboxDefault = false, UserPreferencesTaskRemindersCheckboxDefault = false, UserPreferencesReminderSoundOff = false, UserPreferencesDisableAllFeedsEmail = false, UserPreferencesDisableFollowersEmail = false, UserPreferencesDisableProfilePostEmail = false, UserPreferencesDisableChangeCommentEmail = false, UserPreferencesDisableLaterCommentEmail = false, UserPreferencesDisProfPostCommentEmail = false, UserPreferencesContentNoEmail = false, UserPreferencesContentEmailAsAndWhen = false, UserPreferencesApexPagesDeveloperMode = false, UserPreferencesHideCSNGetChatterMobileTask = false, UserPreferencesDisableMentionsPostEmail = false, UserPreferencesDisMentionsCommentEmail = false, UserPreferencesHideCSNDesktopTask = false, UserPreferencesHideChatterOnboardingSplash = false, UserPreferencesHideSecondChatterOnboardingSplash = false, UserPreferencesDisCommentAfterLikeEmail = false, UserPreferencesDisableLikeEmail = false, UserPreferencesSortFeedByComment = false, UserPreferencesDisableMessageEmail = false, UserPreferencesDisableBookmarkEmail = false, UserPreferencesDisableSharePostEmail = false, UserPreferencesEnableAutoSubForFeeds = false, UserPreferencesDisableFileShareNotificationsForApi = false, UserPreferencesShowTitleToExternalUsers = false, UserPreferencesShowManagerToExternalUsers = false, UserPreferencesShowEmailToExternalUsers = false, UserPreferencesShowWorkPhoneToExternalUsers = false, UserPreferencesShowMobilePhoneToExternalUsers = false, UserPreferencesShowFaxToExternalUsers = false, UserPreferencesShowStreetAddressToExternalUsers = false, UserPreferencesShowCityToExternalUsers = false, UserPreferencesShowStateToExternalUsers = false, UserPreferencesShowPostalCodeToExternalUsers = false, UserPreferencesShowCountryToExternalUsers = false, UserPreferencesShowProfilePicToGuestUsers = false, UserPreferencesShowTitleToGuestUsers = false, UserPreferencesShowCityToGuestUsers = false, UserPreferencesShowStateToGuestUsers = false, UserPreferencesShowPostalCodeToGuestUsers = false, UserPreferencesShowCountryToGuestUsers = false, UserPreferencesHideS1BrowserUI = false, UserPreferencesDisableEndorsementEmail = false, UserPreferencesPathAssistantCollapsed = false, UserPreferencesCacheDiagnostics = false, UserPreferencesShowEmailToGuestUsers = false, UserPreferencesShowManagerToGuestUsers = false, UserPreferencesShowWorkPhoneToGuestUsers = false, UserPreferencesShowMobilePhoneToGuestUsers = false, UserPreferencesShowFaxToGuestUsers = false, UserPreferencesShowStreetAddressToGuestUsers = false, UserPreferencesLightningExperiencePreferred = false, UserPreferencesPreviewLightning = false, UserPreferencesHideEndUserOnboardingAssistantModal = false, UserPreferencesHideLightningMigrationModal = false, UserPreferencesHideSfxWelcomeMat = false, UserPreferencesHideBiggerPhotoCallout = false, UserPreferencesGlobalNavBarWTShown = false, UserPreferencesGlobalNavGridMenuWTShown = false, UserPreferencesCreateLEXAppsWTShown = false, UserPreferencesFavoritesWTShown = false, DigestFrequency = 'D', DefaultGroupNotificationFrequency = 'P');
        Insert user_Obj; 
        // Account acc = new Account(Name='Test Acc');
        // insert acc;
        //  WorkOrder wo = new WorkOrder(Status='New', Priority='Low',accountid=acc.id);
        //   insert wo;
        
        List<ServiceAppointment> serviceappointment_Obj = new List<ServiceAppointment>{
            new ServiceAppointment(ParentRecordId=wo.Id, EarliestStartTime=Date.Today(), DueDate=Date.Today().addDays(5), Status='Scheduled', SchedStartTime=Date.Today(), SchedEndTime=Date.Today().addDays(5))};
                
                ServiceAppointment sa = new ServiceAppointment(ParentRecordId=wo.Id, EarliestStartTime=Date.Today(), DueDate=Date.Today().addDays(5), Status='Scheduled', SchedStartTime=Date.Today(), SchedEndTime=Date.Today().addDays(5));
        serviceappointment_Obj.add(sa);
        Insert serviceappointment_Obj;
        
        ServiceResource serviceresource_Obj = new ServiceResource(Name = 'Name790', IsActive = true, IsCapacityBased = false, IsOptimizationCapable = false,RelatedRecordId = user_Obj.id);
        Insert serviceresource_Obj;
        test.startTest();
        Skill s = [SELECT id FROM Skill LIMIT 1];
        SkillRequirement sreq = new SkillRequirement(RelatedRecordId = wo.Id, SkillId = s.Id, SkillLevel = 10);
        insert sreq;
        ServiceResourceSkill srs = new ServiceResourceSkill(EffectiveEndDate=Date.Today().addDays(80), EffectiveStartDate=Date.Today().adddays(-20), SkillLevel=10, SkillId=s.id, ServiceResourceId=serviceresource_Obj.id);
        insert srs;
        
        OperatingHours operatinghours_Obj = new OperatingHours(Name = 'Name913', TimeZone = 'Pacific/Kiritimati');
        Insert operatinghours_Obj; 
        ServiceTerritory serviceterritory_Obj = new ServiceTerritory(Name = 'Name348', OperatingHoursId = operatinghours_Obj.id, IsActive = true);
        Insert serviceterritory_Obj; 
        
        ServiceTerritoryMember stm = new ServiceTerritoryMember(ServiceTerritoryid = serviceterritory_Obj.id, TerritoryType='P',EffectiveStartDate = Date.Today().addDays(-2),ServiceResourceid=serviceresource_Obj.id);
        insert stm;
        
        AssignedResource assignedresource_Obj = new AssignedResource(ServiceAppointmentId = serviceappointment_Obj[0].id, ServiceResourceId = serviceresource_Obj.id);
        Insert assignedresource_Obj; 
        //  AssignedResource assignedresource_Obj1 = new AssignedResource(ServiceAppointmentId = serviceappointment_Obj[1].id, ServiceResourceId = serviceresource_Obj.id);
        //Insert assignedresource_Obj1;
        //delete assignedresource_Obj;
        test.stopTest();
    }
    
    public testMethod static void sampleTestMethod(){
        
        List<ServiceResource> ser=new List<ServiceResource>([Select id from ServiceResource]);
        PageReference pageRef = Page.AddAbsencePagetest; // Add your VF page Name here
        Test.setCurrentPage(pageRef);      
        ApexPages.currentPage().getParameters().put('id',ser[0].Id);       
        ApexPages.standardController controller = new ApexPages.StandardController(ser[0]);
        sample se=new sample(controller);
        se.getTypes();
        se.getDurations();
        se.getSlotOptions();
        se.Type='Holiday';
        se.Duration = 'Partial day';
        Date dt=System.today(); 
        se.StartDate=dt;
        se.slotOption='Morning (7am -12pm)';
        se.customSave();
        
        
       // List<ServiceResource> ser=new List<ServiceResource>([Select id from ServiceResource]);
        PageReference pageRef2 = Page.AddAbsencePagetest; // Add your VF page Name here
        Test.setCurrentPage(pageRef2);      
        ApexPages.currentPage().getParameters().put('id',ser[0].Id);       
        ApexPages.standardController controller2 = new ApexPages.StandardController(ser[0]);
        sample se2=new sample(controller2);
        se2.Type='Extra Shift Opt Out';
        Date dt2=System.today();
        se2.StartDate=dt2;
        se2.slotOption='Morning (7am -12pm)';
        se2.customSave();
        
       
        PageReference pageRef3 = Page.AddAbsencePagetest; // Add your VF page Name here
        Test.setCurrentPage(pageRef3);      
        ApexPages.currentPage().getParameters().put('id',ser[0].Id);       
        ApexPages.standardController controller3 = new ApexPages.StandardController(ser[0]);
        sample se3=new sample(controller3);
        se3.Type='Extra Shift Opt Out';
        Date dt3=System.today();
        se3.StartDate=dt3;
        se3.slotOption='Evening (5pm - 8pm)';
        se3.customSave();
 
       PageReference pageRef4 = Page.AddAbsencePagetest; // Add your VF page Name here
        Test.setCurrentPage(pageRef4);      
        ApexPages.currentPage().getParameters().put('id',ser[0].Id);       
        ApexPages.standardController controller4 = new ApexPages.StandardController(ser[0]);
        sample se4=new sample(controller);
        se4.Type='Extra Shift Opt Out';
         se4.getSlotOptions();
        Date dt4=System.today();
        se4.StartDate=dt4;
        se4.slotOption='Afternoon (12pm - 8pm)';
        se4.customSave();
        
 /*        PageReference pageRef5 = Page.AddAbsencePagetest; // Add your VF page Name here
        Test.setCurrentPage(pageRef5);      
        ApexPages.currentPage().getParameters().put('id',ser[0].Id);       
        ApexPages.standardController controller5 = new ApexPages.StandardController(ser[0]);
        sample se5=new sample(controller);
        se5.Type='Holiday';
        se.Duration = 'Partial day';
        Date dt5=System.today();
        se5.StartDate=dt5;
        se5.slotOption='Morning (7am -12pm)';
        se5.customSave();
        */
        
        PageReference pageRef6 = Page.AddAbsencePagetest; // Add your VF page Name here
        Test.setCurrentPage(pageRef6);      
        ApexPages.currentPage().getParameters().put('id',ser[0].Id);       
        ApexPages.standardController controller6 = new ApexPages.StandardController(ser[0]);
        sample se6=new sample(controller6);
        se6.Type='Holiday';
        se6.Duration = 'Partial day';
        Date dt6=System.today(); 
        se6.StartDate=dt6;
        se6.slotOption='Afternoon (12pm - 8pm)';
        se6.customSave();
        
        
        PageReference pageRef7 = Page.AddAbsencePagetest; // Add your VF page Name here
        Test.setCurrentPage(pageRef7);      
        ApexPages.currentPage().getParameters().put('id',ser[0].Id);       
        ApexPages.standardController controller7 = new ApexPages.StandardController(ser[0]);
        sample se7=new sample(controller7);
        se7.Type='Holiday';
        se7.Duration = 'Partial day';
        Date dt7=System.today(); 
        se7.StartDate=dt7;
        se7.slotOption='Evening (5pm - 8pm)';
        se7.customSave();
        
         PageReference pageRef8 = Page.AddAbsencePagetest; // Add your VF page Name here
        Test.setCurrentPage(pageRef8);      
        ApexPages.currentPage().getParameters().put('id',ser[0].Id);       
        ApexPages.standardController controller8 = new ApexPages.StandardController(ser[0]);
        sample se8=new sample(controller8);
        se8.Type='Holiday';
         se8.getSlotOptions();
        se8.Duration = 'One Day';
        Date dt8=System.today(); 
        se8.StartDate=dt8;
        se8.slotOption='Full Day (7am - 8pm)';
        se8.customSave();
    }
}