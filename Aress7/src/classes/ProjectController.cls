public class ProjectController 
{
    private ApexPages.StandardController standardController;
    public List<Contact> lstProjectContacts{get;set;}
    public Set<id> ContactIDs{get;set;}
    
    public ProjectController(ApexPages.StandardController standardController)
    {
        this.standardController = standardController;
        
        getProjectContacts();
    }
    
    public List<Contact> getProjectContacts()
    {
        Id recordId = standardController.getId();
        
        Map<id,Phases__c> mapPhases = new Map<ID, Phases__c>([select id,name from Phases__c where Project__c =: recordId]);
        
        
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
            
            lstProjectContacts =[select id,firstname,lastname,email,account.name,phone,Region__c from contact where id IN : ContactIDs];
            
        }
        return lstProjectContacts;
    }
}