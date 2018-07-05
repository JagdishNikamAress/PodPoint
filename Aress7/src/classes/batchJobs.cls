global class batchJobs implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful
{

        global batchJobs()
        {
           // Batch Constructor
        }
       
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC)
        {
         //String query = 'select id,name,accountid,FieldAware_ID__c,FieldAware_URL_del__c,account.name,account.billingstreet,account.billingcity,account.billingpostalcode,account.billingcountry,account.phone,account.website from Opportunity';
         String query = 'select id,Job_ID__c,External_ID__c,status,type from case where status IN(\'New\',\'Scheduled\',\'Install Scheduled\',\'Active\',\'Paused\',\'Awaiting Schedule\')';
         return Database.getQueryLocator(query);
        }
      
      // Execute Logic
       global void execute(Database.BatchableContext BC, List<Case> scope)
       {
           
                helperJobs hc = new helperJobs();
                
                hc.getJobDetails(scope);
     
       }
     
       global void finish(Database.BatchableContext BC)
       {
            // Logic to be Executed at finish
       }
}