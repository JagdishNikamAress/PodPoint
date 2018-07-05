public class LeadConversionPageController{

public Boolean bolCreateOpp {get;set;}
public String strAccountId {get;set;}
public String strLeadid {get;set;}
public String OppName {get;set;}
public Lead ldSource {get;set;}
Map<String, String> dict = new Map<String, String>();
Map<String, String> convertleadstatus = new Map<String, String>();
    public LeadConversionPageController(ApexPages.StandardController scMain) {
	   ldSource = [SELECT Id, FirstName, LastName, Name, OwnerId, Company, Street, City, State, PostalCOde, Country, Phone, Fax, Account_Classification__c, Account_Route_to_Market__c, Account_Type__c FROM Lead WHERE Id = :scMain.getId()];
	   bolCreateOpp = false;
       OppName=  ldSource.company;
      
         if(ldSource.Account_Classification__c == null || ldSource.Account_Route_to_Market__c == null || ldSource.Account_Type__c==null){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Add Account Classification, Route to Market and Type before converting this Lead	'));
        
       }
    }

   public List<SelectOption> getlstCompanyInfo() {
      String strCompanyWildcard = '%' + ldSource.Company + '%';
	  List<Account> lstAcct = [SELECT Id, Name, Owner.Name FROM Account WHERE Name LIKE :strCompanyWildcard];
	  List<SelectOption> lstCompanies = new List<SelectOption>();
	 
	  lstCompanies.add(new SelectOption('1','Create New Account: ' + ldSource.Company));
	  // Add found Accounts to SelectList
	  for(Account a : lstAcct) {
	     lstCompanies.add(new SelectOption(a.Id, 'Attach to Existing: ' + a.Name + ' (' + a.Owner.Name + ')'));
         dict.put(a.Id, 'Attach to Existing: ' + a.Name + ' (' + a.Owner.Name + ')');
      }
      return lstCompanies;
   }
   public List<SelectOption> getConvertedStatus(){
       List<SelectOption> ConvertedLeadStatus = new List<SelectOption>();
       List<LeadStatus> convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true];
          for(LeadStatus l : convertStatus) {
	         ConvertedLeadStatus.add(new SelectOption(l.Id,l.MasterLabel));
             convertleadstatus.put(l.id,l.MasterLabel);
	      }
      return ConvertedLeadStatus;		
    }
   public void doNothing() {  }

   public PageReference convertLead() {
	   if(ldSource.Account_Classification__c == null || ldSource.Account_Route_to_Market__c == null || ldSource.Account_Type__c==null){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Add Account Classification, Route to Market and Type before converting this Lead	'));
          return null;
       }
       Database.LeadConvert lc = new Database.LeadConvert();
	   lc.setLeadId(ldSource.Id);
	   lc.setOwnerId(ldSource.OwnerId);
       boolean teeee = lc.isDoNotCreateOpportunity();
       string temp = dict.get(strAccountId);
       string ConvertedleadstatusName = convertleadstatus.get(strLeadid);
       lc.setConvertedStatus(ConvertedleadstatusName);
       if(bolCreateOpp == true && temp == null){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must create opp when converting lead with new account'));
          return null;
       }
       if(bolCreateOpp == true && temp != null){
          lc.setDoNotCreateOpportunity(true);
         
       }
       if(bolCreateOpp == false && temp == null){
          //lc.setDoNotCreateOpportunity(true);
          lc.setOpportunityName(OppName);  
       }
       
	   if(strAccountId.length() > 1) { 
          lc.setAccountId(strAccountId);
       }
       //if(strLeadId.length() > 1) { 
          
       //}
	   Database.LeadConvertResult lcr = Database.convertLead(lc);
	   PageReference prResult;
	   if(lcr.isSuccess()) {
	      prResult = new PageReference('/' + lcr.getAccountId());
		  prResult.setRedirect(true);
		  return prResult;	
	   } else {
	        return null;
	     }
	
   }
    
}