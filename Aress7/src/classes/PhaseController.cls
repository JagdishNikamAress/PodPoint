public class PhaseController 
{
    private ApexPages.StandardController standardController;
    public List<Contact> lstPhaseContacts{get;set;}
    public Set<id> ContactIDs{get;set;}
    
    public PhaseController(ApexPages.StandardController standardController)
    {
        this.standardController = standardController;
        
        getPhaseContacts();
    }
    
    public List<Contact> getPhaseContacts()
    {
        Id recordId = standardController.getId();
        
        Map<id,Phases__c> mapPhases = new Map<ID, Phases__c>([select id,name from Phases__c where id =: recordId]);
        
        
        if(mapPhases.size()>0)
        {
            Map<id,Opportunity> mapOpps = new Map<ID, Opportunity>([select id,name from opportunity where Phase__c IN : mapPhases.keySet()]);
            
            Map<id,OpportunityContactRole> mapOppContactRoles = new Map<id,OpportunityContactRole>([select id,contactid from OpportunityContactRole where opportunityid IN : mapOpps.keySet()]);
            
            system.debug('Map values : ' + mapOppContactRoles.keySet());
            
            ContactIDs = new Set<id>();
            for(OpportunityContactRole oppCR : mapOppContactRoles.values())
            {
                ContactIDs.add(oppCR.contactid);
            }
            
            lstPhaseContacts =[select id,firstname,lastname,email,account.name,phone,Region__c from contact where id IN : ContactIDs];
            
        }
        return lstPhaseContacts;
    }
}