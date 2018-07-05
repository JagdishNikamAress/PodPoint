public class ScheduleWorkOrderBatch2 implements Database.Batchable<sObject>{     // public  WorkType wt = [SELECT id, name FROM WorkType WHERE Name='Install (Domestic)'];
       public static boolean Temp = TRUE;
       public EmailTemplate template = [SELECT Id, DeveloperName, Folder.DeveloperName FROM EmailTemplate WHERE DeveloperName='Homecharge_Install_Scheduled'];
       public OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress WHERE DisplayName='Scheduling Pod-Point' ];
      // public List<Contact> conList = new List<Contact>();
      // public List<Account> accList = [SELECT Id,PersonEmail FROM Account];
       public Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
       
       
       
       public Database.QueryLocator start(Database.BatchableContext bc) {
            System.debug('Database.getQueryLocator(str)=>'+hcinstallWORecordTypeId ); 
            string statusname = 'Scheduled';
            ID myemail = '012240000002uEGAAY';
            string WorkTypeName = 'Install (Domestic)';
            string aaa = 'WorkOrder';
            string bbb = 'Homecharge Install';
           // String str= 'Select Id,AccountId,Status,Scheduling_Email__c, Account.PersonEmail,WorkType.Name,RecordTypeId From WorkOrder WHERE Status =:statusname AND Scheduling_Email__c = False AND RecordTypeId =: myemail AND WorkType.Name =:WorkTypeName AND Account.PersonEmail != null ';
            String str= 'Select Id,AccountId,Status,Scheduling_Email__c, Account.PersonEmail,WorkType.Name,RecordTypeId From WorkOrder WHERE Status =:statusname AND Confirmation_Email__c = FALSE AND RecordTypeId =: myemail AND WorkType.Name =:WorkTypeName AND Account.PersonEmail != null AND Customer_Confirmation__c=True';
            //String str='Select Id,CaseId From WorkOrder WHERE CaseId=NULL';
            System.debug('Database.getQueryLocator(str)=>'+Database.query(str));  
            return Database.getQueryLocator(str);
            
       }

       public void execute(Database.BatchableContext bc, List<WorkOrder> scope) {
                  List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                  list<Contact> NewContacts = new list<contact>();
                  set<string> Emails = new set<string>();
                  for(WorkOrder woRec:scope){
                     Emails.add(woRec.Account.PersonEmail);   
                  }

                  for(string a : Emails){
                     Contact con = new Contact();
                     con.FirstName = 'Test';
                     con.LastName = 'Contact';
                     con.Email = a;
                      if(test.isRunningTest()){
                          con.Email='abc@gmail.com';
                      }
                     NewContacts.add(con);
                  }
                  
                  Insert NewContacts;
                 
                  for(WorkOrder woRec:scope){
                    for(contact con : NewContacts){
                       if(con.Email == woRec.Account.PersonEmail){
                           Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                           msg.setTemplateID(template.Id);
                           msg.setWhatId(woRec.Id);
                           msg.setTargetObjectId(con.Id);
                           msg.setOrgWideEmailAddressId(owa.id);
                           mails.add(msg);
                           woRec.Confirmation_Email__c = TRUE;
                       }  
                    }
                  }
                
                Messaging.sendEmail(mails);
                Temp = TRUE;
                Update Scope;
                delete NewContacts;
       }
        
        /*public void execute(system.SchedulableContext sc) {
            Id batchJobId2 = Database.executeBatch(new ScheduleWorkOrderBatch2(), 200);
        }*/
        
       public void finish(Database.BatchableContext bc) {
          system.debug('JOB IS FINISHED');
       }
}