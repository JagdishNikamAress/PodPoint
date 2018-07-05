@isTest
public class CaseExtensionTest {
    static testMethod void testRedirect(){
        Test.StartTest();     
        WorkType wt= new WorkType(name='Install (Domestic)',DurationType='Hours',EstimatedDuration=1);
        
        insert wt;
        
        Id caseid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Homecharge Case').getRecordTypeId();
        case cs= new case(RecordTypeId=caseid,Status='Open',Survey_Status__c = 'Requested');
        
        insert cs;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cs);
        CaseExtension csExt = new CaseExtension(sc);

        PageReference pageRef = Page.SendCusomerDatafromCase; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(cs.Id));
        Test.setCurrentPage(pageRef);
        csExt.redirect(); //call all your function here
        
        Test.StopTest();
    }
    
}