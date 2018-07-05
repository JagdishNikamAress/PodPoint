@isTest
public class FeedBackController_Test{
    public static Case createCase(String stat){
        Case c = new Case(Origin = 'Email',Call_Category__c='N/A',Call_Subcategory__c='N/A',Type='N/A',Status=stat,Priority='Low',recordtypeid= Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId());
        return c;
    }
    
    private static testMethod void test1(){
        Case c =  createCase('New');
        insert c;
        
        PageReference pageRef = Page.FeedBackPage;
        pageRef.getParameters().put('csId', String.valueOf(c.Id));
        pageRef.getParameters().put('rat', 'Good');
        Test.setCurrentPage(pageRef);
        FeedBackController f = new FeedBackController();
        f.goodBtn();
        f.badBtn();
        f.doSave();
           
    }
}