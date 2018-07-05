@istest
public class ContentDocumentLinkTriggerTest {

    public static testMethod void testocc(){
        Set<Id> WOId = new Set<Id>();
        Set<Id> OppId = new Set<Id>();
        List<worktype> wtList=new List<WorkType>();
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt1);
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
        WorkOrder wo1= new WorkOrder(RecordtypeId = hcInstallWorkOrderId,WorkTypeId=wt1.Id,AccountId=acc.Id,CaseId=cs.Id,IsSFUser__c=True,Customer_Confirmation__c=True);
        woList.add(wo1) ;
       
        insert woList;

      ContentVersion contentVersion = new ContentVersion(
      Title = 'SA-Penguins',
      PathOnClient = 'Penguins.jpg',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
      );
      insert contentVersion;    

      List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

     //create ContentDocumentLink  record 
     ContentDocumentLink cdl = New ContentDocumentLink();
     cdl.LinkedEntityId = cs.id;
     cdl.ContentDocumentId = documents[0].Id;
     cdl.shareType = 'V';
     insert cdl;
   }

    }