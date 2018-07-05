@isTest
public class NewFeedItemTrigger_Test {
    static testMethod void testFeed(){
        
        
        AvoidRecursion.isFirstRun();
        AvoidRecursion.isFirstRun1();
        AvoidRecursion.isFirstRun2();
        AvoidRecursion.isFirstRun3();
        
        
        
        
        Test.StartTest();  
        list<WorkType> wtlist=new list <WorkType>();
        WorkType wt= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=1);
        wtList.add(wt);
                worktype wt3 =new worktype(Name='Install (Domestic) & Additional Works',EstimatedDuration=4.0,DurationType='hours');
        wtList.add(wt3);
        insert wtlist;
        
        Id caseid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Homecharge Case').getRecordTypeId();
        case cs= new case(RecordTypeId=caseid,Status='Open',Survey_Status__c = 'Requested');
        
        insert cs;
        
        Id workOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        WorkOrder wo=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs.id,Status='Unassigned');
        wo.Missing_Comment__c=true;
        Insert wo;
        
        FeedItem feed = new FeedItem (ParentId = wo.Id,Body = 'Hello');
        
        insert feed;
        Delete feed;
        
        update wo;
        
        Test.StopTest();
    }
}