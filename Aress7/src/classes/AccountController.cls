public class AccountController {
	public Account Acc;
    public List<Project__c> listProjects{get;set;}
    public List<Phases__c> listPhases{get;set;}
    public List<Opportunity> listBids{get;set;}
    public String projectID {get;set;}
    public String phaseID {get;set;}
    public String routeToMarket {get;set;}
    
    public AccountController(ApexPages.StandardController controller) 
    {
        this.Acc = (Account) controller.getRecord();
        
        getProjectDetails();
        getBids();
    }
    
    public void getProjectDetails() 
    {
        system.debug(Acc);
        set<id> setprojectID = new set<id>();
        
        Account accts = [select id,Route_to_Market__c from account where id =: Acc.id];
        
        routeToMarket = accts.Route_to_Market__c;
        
        //Get all projects which are primary developer for projects.
        listProjects = [Select id,name,Start_Date__c,End_Date__c from Project__c where Property_Developer__c = : accts.id];

    }
    
    public void getPhases() {
        listPhases = [Select id, name , Stage__c,Start_Date__c,End_Date__c,Phase_Description__c from Phases__c where Project__c =:projectID ];
    }
    
    public void getBids() {
        string recordTypeId = [SELECT id from RecordType where Name ='Bid'].Id;
        listBids = [Select id, name , Stagename,account.name,amount,recordtype.name,phase__r.project__r.name,phase__r.project__r.id from Opportunity where recordtypeid =: recordTypeId  and accountid =:this.Acc.id ];
    }
}