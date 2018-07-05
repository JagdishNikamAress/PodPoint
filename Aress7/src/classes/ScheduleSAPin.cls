public class ScheduleSAPin implements Database.Batchable<SObject>,Schedulable{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        string SAStatus1 = 'Scheduled';
        string SAStatus2 = 'Confirmed';
        String str= 'Select Id, FSL__Pinned__c From ServiceAppointment WHERE (Status = :SAStatus1 OR Status = :SAStatus2) AND SchedStartTime <= today';
        System.debug('Database.getQueryLocator(str)=>'+Database.query(str));  
        return Database.getQueryLocator(str);
    }
    
    public void execute(Database.BatchableContext bc, List<ServiceAppointment> scope) {
        for(ServiceAppointment SA : scope){
            if(!SA.FSL__Pinned__c)
            SA.FSL__Pinned__c = true;
        }
        Update Scope;
    }
    
    public void execute(system.SchedulableContext sc) {
        Id batchJobId2 = Database.executeBatch(new ScheduleSAPin(), 200);
        
    }
    
    public void finish(Database.BatchableContext bc) {
    }
}