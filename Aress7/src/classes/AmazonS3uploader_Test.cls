@isTest
global class AmazonS3uploader_Test {
    
    global static testMethod void aswTest(){
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
                           Scope_of_Work__c='test',Scope_of_Works_2__c='test',type='Survey',UUID__c='1223456');
        insert cs;
        
        List<WorkType> wtList = new List<WorkType>();
        worktype wt1 =new worktype();
        wt1.Name='Install (Domestic)';
        wt1.EstimatedDuration=4.0;
        wt1.DurationType='hours';
        wt1.Appointment_Start_Offset__c=20;
        wtList.add(wt1);
        
        
        worktype wt2 =new worktype();
        wt2.Name='Additional Works (Domestic)';
        wt2.EstimatedDuration=4.0;
        wt2.DurationType='hours';
        wtList.add(wt2);
        worktype wt3 =new worktype();
        wt3.Name='Install (Domestic) & Additional Works';
        wt3.EstimatedDuration=4.0;
        wt3.DurationType='hours';
        wtList.add(wt3);
        insert wtList;
        
        List<WorkOrder> wList = new List<WorkOrder>();
        SET<String> woIdSet = new SET<String>();
        WorkOrder wo1= new WorkOrder();
        wo1.WorkTypeId=wt1.Id;
        wo1.AccountId=acc.Id;
        wo1.CaseId=cs.Id;
        wo1.Status='Completed';
        wList.add(wo1);
        
        //SET<String> woIdSet = new SET<String>();
        WorkOrder wo2= new WorkOrder();
        wo2.WorkTypeId=wt3.Id;
        wo2.AccountId=acc.Id;
        wo2.CaseId=cs.Id;
        wo2.Status='Completed';
        wList.add(wo2);
        Insert wList;
        woIdSet.add(wo1.Id);
        woIdSet.add(wo2.Id);
        
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
                
        /*
        ServiceAppointment sa1 = new ServiceAppointment();
        sa1.EarliestStartTime=System.today();
        sa1.DueDate=System.today()+1;
        sa1.Status='Completed';
        sa1.SchedStartTime=System.today();
        sa1.SchedEndTime=System.today()+1;
        sa1.ParentRecordId=wo1.id;
        sa1.ArrivalWindowStartTime=System.today();
        sa1.ArrivalWindowEndTime=System.today()+1;
        saList.add(sa1);*/
        
                
       
       //FeedAttachments fa = new FeedAttachments(Title='Test'); 
       /* Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=wo1.Id; 
        attach.ContentType = 'application/msword'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach; */
        
        List<ContentVersion> cvList = new List<ContentVersion>();
        ContentVersion testContentInsert =new ContentVersion(); 
        testContentInsert.ContentURL='http://www.google.com/';
        testContentInsert.Title ='Google.com'; 
        //testContentInsert.RecordTypeId = ContentRT.Id; 
        //insert testContentInsert;
        
        cvList.add(testContentInsert);
        
        ContentVersion cv=new Contentversion();
        cv.title='ABC';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        //insert cv;
        cvList.add(cv);
        
        ContentVersion contentVersion1 = new ContentVersion(Title = 'Content',PathOnClient = 'Content.html',VersionData = Blob.valueOf('Test Content'));
        cvList.add(contentVersion1);
        insert cvList;
        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion1.Id LIMIT 1];//query the contentdocumentID
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
		
        List<ContentDocumentLink> cdList  = new List<ContentDocumentLink>();
        ContentDocumentLink newcontent = new ContentDocumentLink();
        newcontent.ContentDocumentId = contentVersion_2.ContentDocumentId;
        newcontent.LinkedEntityId = wo1.Id;
        newcontent.ShareType =  'v';
		cdList.add(newcontent);
        insert cdList;
        
        List<Attachment> attachmentList = new List<Attachment>();
        Attachment attachment = new Attachment(); 
        Blob bb = Blob.valueOf('TestData');  
        attachment.ParentId = wo1.Id;  
        attachment.Name = 'Test Attachment for Parent'; 
        attachment.Body = bb;  
        attachmentList.add(attachment);
        insert attachmentList;  
        
        List<FeedItem> fiList = new List<FeedItem>();
        FeedItem feed = new FeedItem (ParentId = wo1.Id,Body = 'o');
        FeedItem feed1 = new FeedItem (ParentId = wo1.Id,Body = 'O');
        FeedItem feed2 = new FeedItem (ParentId = wo1.Id,Body = 'p');
        FeedItem feed3 = new FeedItem (ParentId = wo1.Id,Body = 'P');
        
         
        fiList.add(feed);
        fiList.add(feed1);
        fiList.add(feed2);
        fiList.add(feed3);
        insert fiList;
        
        List<FeedAttachment> fattachmentList = new List<FeedAttachment>();
        FeedAttachment feedAttachment = new FeedAttachment();
        feedAttachment.FeedEntityId = feed.Id;
        feedAttachment.RecordId = cv.id;
        feedAttachment.Title = feed.Title;
        feedAttachment.Type = 'CONTENT'; 
        fattachmentList.add(feedAttachment);
        insert fattachmentList;
        
       
        
        List<ServiceAppointment> saList = new List<ServiceAppointment>();
        SET<String> saIdSet = new SET<String>();
        ServiceAppointment sa = new ServiceAppointment();
        sa.EarliestStartTime=System.today();
        sa.DueDate=System.today()+1;
        sa.Status='Completed';
        sa.SchedStartTime=System.today();
        sa.SchedEndTime=System.today()+1;
        sa.ParentRecordId=wo1.id;
        sa.ArrivalWindowStartTime=System.today();
        sa.ArrivalWindowEndTime=System.today()+1;
        saList.add(sa);
        
        saIdSet.add(sa.Id);
        //saIdSet.add(sa1.Id);
       

        
        List<ServiceReport> saReportList = new List<ServiceReport>();
        ServiceReport sr = new ServiceReport();
        //Blob b4 = Blob.valueOf('TestData');
        sr.ParentId = sa.Id; 
        //sr.DocumentBody = b4;
        //sr.DocumentName = 'Test';
        //sr.DocumentContentType = 'PDF';
        //sr.ContentVersionDocumentId = contentVersion1.Id;
        //sr.ServiceReportNumber = '1234';
        saReportList.add(sr);
        
        
        
        
        test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new OtMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new AWSMockTest());
         insert saList;
         sa.SchedEndTime=System.today()+2;
        update sa;
        //insert saReportList;
        	AwsCaller.amazonS3caller(woIdSet);
        	//AwsCaller.sReportAmazonS3caller(saIdSet);
        test.stopTest();
		
    }
}