/**
* @author:          Prasun Banerjee
* @date:            12/07/2016
* @description:     This will delete order related values from opp on order deletion.
* @param:           N/A 
* @moficationlog:   N/A
*/

trigger OrderTrigger on Order (after delete) 
{
    
    if(Trigger.isDelete)
    {
        List<Opportunity> listOpportunities = new List<Opportunity>();
        List<Opportunity> listOpportunitiesToUpdate = new List<Opportunity>();
        Set<Id> OrderOppsIDs = new Set<Id>();
        
        for(Order o : Trigger.Old)
        {
            OrderOppsIDs.add(o.opportunityid);
        }
        
        listOpportunities = [select id from opportunity where id IN :OrderOppsIDs];
        
        for(Opportunity opp : listOpportunities)
        {
            opp.Order_Number__c = '';
            opp.Order_Status__c = '';
            opp.Order_Type__c = '';
            opp.Confirm_Date_Dispatch_Address__c = false;
            
            listOpportunitiesToUpdate.add(opp);
        }
        
        update listOpportunitiesToUpdate;
    }
    
}