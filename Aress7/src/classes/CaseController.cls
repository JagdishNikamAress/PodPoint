public class CaseController {
    
    private final Case cs;
    public Case objCase {get;set;}
    public Account objAccount {get;set;}
    public Opportunity objOpp {get;set;}
    public String CaseID {get;set;}
    
    public CaseController(ApexPages.StandardController stdController) {
        this.cs = (Case)stdController.getRecord();
    }
    
    //This function is called when the button on Order object "Create Install Case" is clicked. This will create a job in Fieldaware and link it with a case record in SF.
    public void createInstallCase()
    {        
        
        List<Opportunity> listOpp = new List<Opportunity>();
        
        objCase = [select id,type,description,street__c,city__c,Country_Picklist__c,PostalCode__c,contact.email,contact.phone,accountid,Opportunity__c,contactid,Maintenance_Type__c from case where id =: cs.id];
        objAccount = [select id,name,accountnumber,FieldAware_ID__c,FieldAware_URL__c,location_id__c from account where id =: objCase.accountid];
        listOpp = [select id,name,accountid,FieldAware_ID__c,FieldAware_URL_del__c,account.name,account.accountnumber,account.billingstreet,account.billingcity,account.billingpostalcode,account.billingcountry,account.phone,account.website from opportunity where id =: objCase.Opportunity__c];
        
        if(listopp.size()>0)
            objOpp = listopp[0];
        
        helperJobs hj = new helperJobs();
        CaseID = hj.createJobafterOrder_v2(objCase,objAccount,objOpp);     
        
    }
    
    
    //This function is called when the button on Order object "Create Install Case" is clicked. This will create a job in Fieldaware and link it with a case record in SF.
    public void createMaintenanceCase()
    {     
        List<Opportunity> listOpp = new List<Opportunity>();
        
        objCase = [select id,type,description,street__c,city__c,Country_Picklist__c,PostalCode__c,contact.email,contact.phone,accountid,Opportunity__c,contactid,Maintenance_Type__c from case where id =: cs.id];
        objAccount = [select id,name,accountnumber,FieldAware_ID__c,FieldAware_URL__c,location_id__c from account where id =: objCase.accountid];
        listOpp = [select id,name,accountid,FieldAware_ID__c,FieldAware_URL_del__c,account.name,account.accountnumber,account.billingstreet,account.billingcity,account.billingpostalcode,account.billingcountry,account.phone,account.website from opportunity where id =: objCase.Opportunity__c];
        
        if(listopp.size()>0)
            objOpp = listopp[0];
        
        
        if(objCase.Maintenance_Type__c != null)
        {
            helperJobs hj = new helperJobs();
            CaseID = hj.createJobMaintenance(objCase);     
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter maintenance type.'));
        }
    }
}