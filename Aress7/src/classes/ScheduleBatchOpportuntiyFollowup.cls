/**
* @author: 			Prasun Banerjee
* @date:   			25/01/2011
* @description: 	This will create an automated process which checks for any "Opportunity Close Date" 
					which is dated today and is not "won" or "Lost" or "Closed", and set an alert for that opportunity owner.
					This is the batch class to schedule.
* @param:			N/A 
* @moficationlog: 	N/A
*/

global class ScheduleBatchOpportuntiyFollowup implements Schedulable {
    global void execute(SchedulableContext sc) {
        BatchFollowupOpportunity a = new BatchFollowupOpportunity();
        database.executebatch(a,10);
    
   }
}