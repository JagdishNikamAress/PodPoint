public class RunFieldAwareBatch 
{
    public void RunBatch()
    {
        batchJobs bj = new batchJobs();   
        Database.executeBatch(bj, 2);
        
        //Show the success message at the end.
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The sync process has been trigger, you can close this window.'));
    }
    
    public void RunAttachmentBatch()
    {
        batchJobsAttachments bj = new batchJobsAttachments();   
        Database.executeBatch(bj, 2);
        
        //Show the success message at the end.
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The sync process has been trigger, you can close this window.'));
    }
}