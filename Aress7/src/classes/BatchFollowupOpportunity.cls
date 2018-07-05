/**
* @author: 			Prasun Banerjee
* @date:   			25/01/2011
* @description: 	This will create an automated process which checks for any "Opportunity Close Date" 
					which is dated today and is not "won" or "Lost" or "Closed", and set an alert for that opportunity owner.
* @param:			N/A 
* @moficationlog: 	N/A
*/

global class BatchFollowupOpportunity implements Database.Batchable<sObject>, Database.AllowsCallouts
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        // Get all opportunity
        //String query =  'SELECT Id,Last_Stage_Change_Date__c,StageName,Name,ownerid FROM Opportunity WHERE (StageName = \'Qualification\' AND (Last_Stage_Change_Date__c != LAST_N_DAYS:7)) OR (StageName = \'Developing Proposal\' AND (Last_Stage_Change_Date__c != LAST_N_DAYS:14)) OR (StageName = \'Negotiation\' AND (Last_Stage_Change_Date__c != LAST_N_DAYS:21)) OR (StageName = \'Awaiting Sign Off\' AND (Last_Stage_Change_Date__c != LAST_N_DAYS:35))';
        String query =  'SELECT Id,Last_Stage_Change_Date__c,StageName,Name,ownerid,CloseDate FROM Opportunity WHERE StageName != \'Won\' AND StageName != \'Lost\'  AND StageName != \'Closed\' AND CloseDate <= Today';
        system.debug('query...'+query);
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Opportunity> scope)
    {
        try
        {
         System.debug('Count:'+scope.size());
         List<Task> tasks = new List<Task>();
         Task t;
            
         //Fetch all tasks which are already open, this will be used to compare if there is already a open task for the opportunity.
         List<Task> openTasks = [Select ID,status,whatid,subject from Task where status='Open'];
            
            
         //Loop through all opportunity and create a task for all opportunity.
         for(Opportunity op : scope)
         {
             //If already a similar task exists, the system will not create another one.
             if(!checkifTaskExists(op,openTasks))
             {
                 
                 //creating the new task here.
                 t = new Task();
             
                 t.Subject = 'Opportunity Followup : ' + op.Name;
                 t.Description = 'Below opportunity is still open and the close date has passed and needs your attention. \n\nOpportunity Name :'+ op.Name +' \nStatus :'+ op.StageName +' \nLast Stage Date :'+ op.CloseDate +' \n\nThanks,';
                 system.debug('Description : ' + t.Description);
                 t.Priority = 'Normal';
                 t.WhatId = op.Id;
                 t.ActivityDate = Datetime.now().addDays(3).Date();
                 t.ReminderDateTime = Datetime.now().addDays(1);
                 t.OwnerId = op.OwnerId;
                 t.IsReminderSet = true;
                 
                 tasks.add(t);
             }
              
         }
        insert tasks;
        }
        catch(Exception e)
        {
            System.debug('Exception : '+e);
        }
        
    }   
    
    
    //This functions returns boolean if there is any task already for the same opportunity which is open with same subject.
    public boolean checkifTaskExists(Opportunity op,List<Task> openTasks)
    {
        boolean exists=false;
        String taskSubject = 'Opportunity Followup : ' + op.Name;
        
        for(Task t :openTasks)
        {
            if(t.WhatId == op.Id && t.Status == 'Open' && t.Subject == taskSubject)
                exists = true;
        }
        system.debug('exists:'+exists);
       return exists; 
    }
    
    global void finish(Database.BatchableContext BC)
    {
    }
}