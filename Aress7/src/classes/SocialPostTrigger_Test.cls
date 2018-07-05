@isTest
public class SocialPostTrigger_Test {
    public testMethod static void postTest(){
        List<Account> accList = new List<Account>();
        Account acc = new Account(recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
                                  Name = 'test',type = 'Prospect');
        accList.add(acc);
        insert accList;
        
        worktype wt1 =new worktype(Name='Install (Domestic)',EstimatedDuration=4.0,DurationType='hours');
        insert wt1;
        Id SupportCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId();
        List<Case> csList = new List<Case>();
        List<SocialPost> spList = new List<SocialPost>();
        Case cs = new Case(AccountId=acc.Id,Status = 'New',Origin = 'Phone',Call_Category__c='Support Issue',Call_Subcategory__c = 'Home Unit',Type = 'Issue',RecordTypeId=SupportCaseRecordTypeId);
        csList.add(cs);
        Case cs1 = new Case(AccountId=acc.Id,Status = 'New',Origin = 'Phone',Call_Category__c='Support Issue',Call_Subcategory__c = 'Home Unit',Type = 'Issue',RecordTypeId=SupportCaseRecordTypeId);
        csList.add(cs1);
        insert csList;
        
        SocialPost sp = new SocialPost(ParentId=cs.Id,Status='SENT',MessageType='Tweet',Name='testPost',Handle='StagingPP');
        spList.add(sp);
        SocialPost sp2 = new SocialPost(ParentId=cs.Id,Status='SENT',MessageType='Reply',Name='TestPost1',Handle='StagingPP');
        spList.add(sp2);
        SocialPost sp3 = new SocialPost(ParentId=cs.Id,Status='SENT',MessageType='Direct',Name='testPost',Handle='StagingPP');
        spList.add(sp3);
        
        SocialPost sp4 = new SocialPost(ParentId=cs1.Id,Status='SENT',MessageType='Tweet',Name='testPost');
        spList.add(sp4);
        SocialPost sp5 = new SocialPost(ParentId=cs1.Id,Status='SENT',MessageType='Reply',Name='TestPost1');
        spList.add(sp5);
        SocialPost sp6 = new SocialPost(ParentId=cs1.Id,Status='SENT',MessageType='Direct',Name='testPost');
        spList.add(sp6);
        
        insert spList;
        
        sp4.Handle = 'StagingPP';
        update sp4;
    }
}