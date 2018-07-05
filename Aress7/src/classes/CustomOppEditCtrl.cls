public class CustomOppEditCtrl{
    public Opportunity opp {get;set;}
    public String recType {get;set;}
    public OpportunityContactRole ocr {get;set;}
    public boolean b {get;set;}
    public transient Map<String, Decimal> probabilityStageNameMap;
    public String accId;

    public CustomOppEditCtrl(ApexPages.StandardController controller) {
        opp = new Opportunity(StageName='New');
        if(ApexPages.currentPage().getParameters().get('RecordType') != null){
            Recordtype rt = [Select id,Name FROM Recordtype WHERE Id = : ApexPages.currentPage().getParameters().get('RecordType')];
            recType = rt.name;
        }
        if(recType == 'Online Payment'){
            opp.closedate = date.today();
        }
        
        if(recType == 'Commercial'){
            opp.closedate = date.today().adddays(30);
        }
        
        opp.recordtypeid = ApexPages.currentPage().getParameters().get('RecordType');
        opp.StageName = 'Qualification';    
        ocr = new OpportunityContactRole(Role = 'Decision Maker'); 
        b = false;
        
        accId = ApexPages.currentPage().getParameters().get('accid');
        if(accId != null){
            opp.AccountId = accId;
            populateAddress();
        }
        String phsId = ApexPages.currentPage().getParameters().get('phaseId');
        if(phsId != null && recType == 'Bid'){
            opp.Phase__c = phsId; 
        }
    }
    
    public pagereference doSave(){
      
        insert opp;
        //system.debug('================='+opp.ChargentSFA__Billing_Email__c);
        if((recType == 'Commercial' || recType == 'Online Payment' || recType == 'Bid') && b){
            ocr.OpportunityId = opp.id;
            ocr.IsPrimary = true;
            insert ocr;
        }
        if(recType == 'Bid')
        {
         opp.stagename = 'Consultancy - Bid';   
        }
        if(recType == 'Home Charge' || recType == 'Home Charge Norway')
        {
          opp.stagename = 'New';  
        }
        if(recType == 'Online Payment' && b){
            String emailid = [Select email FROM Contact WHERE id =: ocr.contactid].email;
            System.debug(ocr.contactid+'---------------'+emailid);
            //opp.ChargentSFA__Billing_Email__c = emailid;
            //system.debug(opp.ChargentSFA__Billing_Email__c);
            //opp.ChargentSFA__Order_Information__c = 'Online Payment';
            opp.stagename = 'New';  
        }
        if(recType == 'Online Payment'){
            opp.stagename = 'New';  
        }
        update opp;
        pagereference pr = new pagereference('/oppitm/choosepricebook.jsp?id='+opp.id+'&retURL='+opp.id+'&saveURL=/p/opp/SelectSearch?addTo='+opp.id);//'&retURL=%2Fp%2Fopp%2FSelectSearch%3FaddTo%3D0069E000002zxF5%26retURL%3D%252F006%252Fe
        return pr;
    }
    
    public void populateAddress(){
        Account acc = [SELECT (SELECT id,Name,Email FROM Contacts),Name,Recordtype.name,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingStreet,BillingCity,BillingCountry,BillingPostalCode,BillingStreet FROM Account WHERE Id = : opp.Accountid];
        opp.Billing_Street__c = acc.BillingStreet;
        opp.Billing_City__c = acc.BillingCity;
        opp.Billing_Country_Picklist__c= acc.BillingCountry; 
        opp.Billing_Postal_Code__c = acc.BillingPostalCode; 
        opp.Shipping_Street__c = acc.ShippingStreet; 
        opp.Shipping_City__c = acc.ShippingCity;    
        
        opp.Shipping_Country_Picklist__c= acc.ShippingCountry;
        opp.Shipping_Postal_Code__c = acc.ShippingPostalCode;
        if(acc.Recordtype.name == 'Business Account'){
             b = true;
        } else {
            b = false;
        }
        system.debug(b);
        
        if(recType == 'Online Payment'){
            opp.Name = 'HC Online Payment - '+acc.Name;
        }
    }
    
    public void changeStageName() {
    
       if (probabilityStageNameMap == null) {
         probabilityStageNameMap = new Map<String, Decimal>();
         for (OpportunityStage oppStage : [Select MasterLabel, DefaultProbability
                                           From OpportunityStage]) {
           probabilityStageNameMap.put(oppStage.MasterLabel, oppStage.DefaultProbability);
         }
       }
      
       if (probabilityStageNameMap.containsKey(opp.StageName)) {
         opp.Probability = probabilityStageNameMap.get(opp.StageName);
       }
    }
        
}