@isTest
public class TemplatePageController_Test {
    static testMethod void testWoEnter(){
        Test.StartTest();     
        WorkType wt= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=1);
        
        insert wt;
        
        Id caseid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Homecharge Case').getRecordTypeId();
        case cs= new case(RecordTypeId=caseid,Status='Open',Survey_Status__c = 'Requested');
        
        insert cs;
        
        Id workOrderId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        WorkOrder wo=new WorkOrder(RecordTypeId=workOrderId,WorkTypeId=wt.id,CaseId=cs.id,Status='Unassigned');
        wo.Customer_Confirmation__c=True;
        Insert wo;
        
        //wo.Customer_Confirmation__c=True; 
        //update wo;
        
        PageReference pageRef = Page.TemplateVfPage; // Add your VF page Name here
        pageRef.getParameters().put('woid', String.valueOf(wo.Id));
        Test.setCurrentPage(pageRef);
        
        templatepageclass tempPageTest = new templatepageclass();
        tempPageTest.WoEnter(); //call all your function here
        
        Test.StopTest();
    }
}