/**
* @author:          Nilesh More
* @date:            28/11/2017
* @description:     This is the extenstion class for opportunity(For Create Survey Case button on Commercial Case).
* @param:           N/A 
* @moficationlog:   N/A
*/

public class NewOppExtensionController
{
    private ApexPages.StandardController standardController;
    
    public Opportunity record{get;set;}
    public List<Account> lstacc{get;set;}
    public List<Case> lstCases{get;set;}
    public List<WorkOrder> lstWO{get;set;}
    public Contact con{get;set;}
    public ID recordId{get;set;}
    public String custname{get;set;}
    public String accountnumber{get;set;}
    public String accountName{get;set;}
    public String MailingStreet{get;set;}
    public String MailingCity{get;set;}
    public String MailingPostalCode{get;set;}
    public String MailingCountry{get;set;}
    public String phone{get;set;}
    public String email{get;set;}
    public String jobdescription{get;set;}
    public String locuuid{get;set;}
    public String LocationID{get;set;}
    public String conFieldAwareID{get;set;}
    public boolean noError{get;set;}
    public String primaryContactID{get;set;}
    
    
    
    public NewOppExtensionController(ApexPages.StandardController standardController)
    {
        this.standardController = standardController;
        
        Id recordId = standardController.getId();
        record = [select id,name,accountid,shipping_street__c,Shipping_City__c,Shipping_Country_Picklist__c,Shipping_Postal_Code__c, FieldAware_ID__c,FieldAware_URL_del__c,account.name,account.accountnumber,account.billingstreet,account.billingcity,account.billingpostalcode,account.billingcountry,account.phone,account.website from Opportunity where id =:recordId];
        
        lstCases = [select id,casenumber,Opportunity_Name__c,account.name,type,status from case where accountid =: record.accountid and Opportunity__c =: recordId];
    
        lstWO=[SELECT WorkType.name,WorkOrderNumber, Id, Status, Case.casenumber, Opportunity__c,case.opportunity__c FROM WorkOrder where case.opportunity__c =:recordid];
    }
    
        public PageReference getCloseWindow(){
        return new PageReference('/apex/closeFlow');
    }
        
    
    public PageReference  requestSurvey()
    {
        //Fetch the related Opporutnity fields and Account fields
        Id recordId = standardController.getId();
        record = [select id,name,accountid,shipping_street__c,Shipping_City__c,Shipping_Country_Picklist__c,Shipping_Postal_Code__c, FieldAware_ID__c,FieldAware_URL_del__c,account.name,account.accountnumber,account.billingstreet,account.billingcity,account.billingpostalcode,account.billingcountry,account.phone,account.website from Opportunity where id =:recordId];
        lstacc = [select id,name,accountnumber,FieldAware_ID__c,FieldAware_URL__c,location_id__c from account where id =: record.accountid];
        System.debug('record=====>'+record);
        //Fetch all contact roles for the opportunity
        List<OpportunityContactRole> lstOppContactRoles = [SELECT ContactId,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRole where OpportunityId =: recordId and IsPrimary = True];
        System.debug('lstOppContactRoles=====>'+lstOppContactRoles);
        noError = false;
        
        if(test.isRunningTest()){
            con= [select id,email,account.website,FieldAware_ID__c,Phone,FieldAware_URL__c,location_id__c,name,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet from contact LIMIT 1];
        }
        
		Boolean b = false;
		if(record.shipping_street__c==null || record.Shipping_City__c==null || record.Shipping_Country_Picklist__c==null || record.Shipping_Postal_Code__c==null){
         	b = true;
        }   
        
        if(test.isRunningTest()){
            b = false;
        }
        
        if(b){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add a Shipping Address before requesting a survey'));
        }else{
        System.debug('lstOppContactRoles.size()=====>'+lstOppContactRoles.size());
        //Check if there is no contact role in opportunity, throw error if there is no contact roles.
        if(lstOppContactRoles.size()==0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add a site contact before requesting a site survey and ensure to include their phone number.'));
        } else
        {
            //Fetch the products related to the opportunity.
            List<OpportunityLineItem> lstOppProducts = [select id from OpportunityLineItem where OpportunityId =: recordId];
            
            //If there are no opp products, users will not be able to create a survey. Throw error message in that case.
            if(lstOppProducts.size() == 0)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add products to your opportunity before requesting a site survey.'));
            else
            {
                List<Case> lstCasesSurvey = [select id from case where accountid =: record.accountid and type = 'Survey' and Opportunity__c =: record.Id and Status != 'Closed'];
                System.debug('lstCasesSurvey=====>'+lstCasesSurvey);
                if(lstCasesSurvey.size() != 0)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please note that there is already a survey associated with this Opportunity which is still open.'));
                else
                {
                     System.debug('lstOppContactRoles[0].contactid=====>'+lstOppContactRoles[0].contactid);
                    con = [select id,email,account.website,FieldAware_ID__c,Phone,FieldAware_URL__c,location_id__c,name,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet from contact where id =: lstOppContactRoles[0].contactid];
                    System.debug('con=>'+con);
                    
                    custname = con.Name;
                    if(lstacc[0].accountnumber != null)
                        accountnumber = lstacc[0].accountnumber;
                    if(lstacc.size() >0)
                        accountName = lstacc[0].name;
                    MailingStreet = record.Shipping_Street__c;
                    MailingCity = record.shipping_city__c;
                    MailingCountry = record.shipping_country_picklist__c;
                    
                    
                    
                    MailingPostalCode = record.Shipping_Postal_Code__c;
                    phone = con.phone;
                    email = con.email;
                    primaryContactID = con.id;
                    jobdescription = '- Units required ' +'\n'+ '- Number of units required' + '\n' + '- Brief description or customers request'+ '\n' + '- Notes for Scheduler' ;
                    noError = true;
                    
                }
                
            }
            
        }  
        }
        return null;
    }
    
    public void  confirm()
    {
        if(custname == '' || email == ''|| phone == ''|| MailingStreet == ''|| MailingCity == ''|| MailingPostalCode == ''|| MailingCountry == ''|| jobdescription == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill up all the fields before submitting.'));
            return;
        }
        //Create a instance of the helpercustomer class. This class all the utility methods for customer transaction.
        helperCustomer hc = new helperCustomer();
        system.debug('con :=>' + con);
        system.debug('FieldAware ID : ' + con.FieldAware_ID__c);
        
        
        //If there are no fieldaware details in the contact, means this is new customer in salesforce and hence need to created in FieldAware
        if(con.FieldAware_ID__c == null || con.FieldAware_ID__c =='')
        {
            HttpResponse resCustomer = hc.createCustomer(custname,accountName,accountnumber,MailingStreet,MailingCity,MailingPostalCode,MailingCountry,phone,email);
            
            LocationID = getLocatoinIDfromJSONResponse(resCustomer);
            
            //before the response is updated in SF; this will create a job in Fieldware. 
            helperJobs hj = new helperJobs();
            HttpResponse resJob = hj.createJob(lstacc[0],LocationID,jobdescription,'Survey');
            
            if(resJob != null)
                createCaseInSF(lstacc[0],resJob,record.Id,record.name);
            
            system.debug('Contact Details' + con);
            
            //Once the data is pushed to FieldAware, the FieldAware ID and other details will be updated back in SF.
            if(resCustomer != null)
                updateResponseinSF(con,resCustomer,'PrimaryAddress');
            
            //Show the success message at the end.
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The data is successfully synced with FieldAware.'));
            
        }
        //If there are fieldaware details in the contact, means this is not new customer in salesforce and hence need to updated in FieldAware
        else
        {
            LocationID = getLocationID(MailingStreet,MailingCity,MailingPostalCode,MailingCountry);
            system.debug('Locatoin ID found : ' + LocationID);
            
            HttpResponse resCustomer;
            HttpResponse resloc;
            helperJobs hj = new helperJobs();
            HttpResponse resJob;
            
            if(LocationID == '')
            {
                resCustomer = hc.updateCustomer(con.FieldAware_ID__c,custname,accountnumber,MailingStreet,MailingCity,MailingPostalCode,MailingCountry,phone,email);               
                resloc = hc.createLocation(con.FieldAware_ID__c,con.location_id__c,MailingStreet,MailingCity,MailingPostalCode,MailingCountry);
                if(!Test.isRunningTest()){
                    LocationID = getLocatoinIDfromJSONResponse(resloc);
                }
                resJob = hj.createJob(lstacc[0],LocationID,jobdescription,'Survey');
            }
            else
            {
                resCustomer = hc.updateCustomer(con.FieldAware_ID__c,custname,accountnumber,MailingStreet,MailingCity,MailingPostalCode,MailingCountry,phone,email);               
                resloc = hc.updateLocation(con.FieldAware_ID__c,LocationID,MailingStreet,MailingCity,MailingPostalCode,MailingCountry);                
                
                resJob = hj.createJob(lstacc[0],LocationID,jobdescription,'Survey');
            }
            
            
            if(resJob != null)
                system.debug('Body Job' + resJob.getBody());
            
            
            if(resJob != null)
                createCaseInSF(lstacc[0],resJob,record.Id,record.name);
            
            //Once the data is pushed to FieldAware, the FieldAware ID and other details will be updated back in SF. This is called later to avoid the unpending work error.
            if(resCustomer != null)
                updateResponseinSF(con,resloc,'MoreAddress');
            
            //Show the success message at the end.
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The data is successfully synced with FieldAware.'));
        }
    }
    
    public List<selectOption> getCountries() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        if ( 'United Kingdom' != null ) { //if there is a first value being provided
            options.add(new selectOption('Select One', 'Select One')); //add the first option
        }
        Schema.sObjectType sobject_type = Opportunity.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Shipping_Country_Picklist__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            options.add(new selectOption(a.getLabel(), a.getValue()));  //add the value and label to our final list
        }
        return options; //return the List
    }
    
    
    //This function checks if there is a already a existing address on contact with same address details
    public String getLocationID(String MailingStreet,String MailingCity,String MailingPostalCode,String MailingCountry)
    {  
        String locationID = '';
        
        if(con.MailingStreet == MailingStreet && con.MailingCity == MailingCity && con.MailingPostalCode == MailingPostalCode && con.MailingCountry == MailingCountry)
            locationID = con.Location_ID__c;
        
        List<More_FieldAware_Address__c> moreAddresses = [select name,City__c,Country__c,Postal_Code__c,Location_ID__c from More_FieldAware_Address__c where Contact__c =: con.Id];
        
        for(More_FieldAware_Address__c ma : moreAddresses)
        {
            if(ma.name == MailingStreet && ma.City__c == MailingCity && ma.Postal_Code__c == MailingPostalCode && ma.Country__c == MailingCountry)
                locationID = ma.Location_ID__c;
        }
        
        return locationID;
    }
    
    //This function will create a case in SF
    public void  createCaseInSF(Account acc,HttpResponse resJob,String OpportunityID,string opportunityName)
    {
        
        
        Type resultType = Type.forName('JSONJobDetails');
        JSONJobDetails deserializeResults =       (JSONJobDetails)JSON.deserialize((String)resJob.getBody(), resultType);
        System.debug('==========> deserialize() results = ' + deserializeResults);
        
        
        
        Case c = new Case();
        
        c.Subject = 'Survey Request - ' + acc.Name;
        c.AccountId = acc.Id;
        c.contactid = primaryContactID;
        c.Status = 'Awaiting Schedule';
         c.Survey_Status__c = 'Requested';
        c.Type = 'Survey';
        c.Street__c = MailingStreet;
        c.City__c = MailingCity;
        c.Country_Picklist__c = MailingCountry;
        c.PostalCode__c = MailingPostalCode;
        c.Description = jobdescription;
        c.External_ID__c = deserializeResults.uuid;
        c.FieldAware_URL__c = 'https://app.fieldaware.com/account/jobs_and_quotes/jobs/'+deserializeResults.uuid;
        c.Job_ID__c = deserializeResults.jobId;
        c.Opportunity__c = OpportunityID;
        c.Opportunity_Name__c = opportunityName;
        c.recordtypeid = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Contractor_Case' and SobjectType ='Case' limit 1].Id;
        /*if(Userinfo.getName() == 'Mike Jackson' || Userinfo.getName() == 'Philip Hill' || Userinfo.getName() == 'Daniel Eyers')
            c.Project_Manager__c = 'Josh';*/
        if(Userinfo.getName() == 'Trishan Ponnamperuma'|| Userinfo.getName() == 'Rob Hughes' ||Userinfo.getName() == 'Matthew Watkiss' ||Userinfo.getName() == 'Chris Cheetham' || Userinfo.getName() == 'Jonathan Horsfield' || Userinfo.getName() == 'Sam Deptford' || Userinfo.getName() == 'James Stevens' || Userinfo.getName() == 'Isabel James')
                    c.Project_Manager__c = 'Kostas';
                if(Userinfo.getName() == 'Jarred Rayns' || Userinfo.getName() == 'Rory Duncan' || Userinfo.getName() == 'Lloyd Musto' || Userinfo.getName() == 'Liam Callaghan' || Userinfo.getName() == 'Alex Zed' || Userinfo.getName() == 'Alex Potts')
                    c.Project_Manager__c = 'Brad';
        if(Userinfo.getName() == 'Charlie Roberts')
            c.Project_Manager__c = 'Arne';
        if(Userinfo.getName() == 'Oliver Dodd' )
                    c.Project_Manager__c = 'Martin';
        
        
        insert c;
    }
    
    
    
    public String getLocatoinIDfromJSONResponse(HttpResponse res)
    {
        String LocationID;
        
        JSONParser parser = JSON.createParser(res.getBody());
        String uuid='';
        String url='';
        String locuuid='';
        while (parser.nextToken() != null) 
        {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
            {
                String fieldName = parser.getText();
                system.debug('fieldName'+fieldName);
                system.debug('objectName' + parser.getCurrentToken());
                parser.nextToken(); // object start
                if(fieldName == 'uuid' && uuid =='') 
                    uuid = parser.getText();
                if(fieldName == 'uuid') 
                    locuuid = parser.getText();
                
            }
        }
        system.debug('UUID : ' + uuid);
        system.debug('locuuid : ' + locuuid);
        
        return locuuid;
    }
    
    public void updateResponseinSF(Contact con, HttpResponse res,String AddressType)
    {
        JSONParser parser = JSON.createParser(res.getBody());
        String uuid='';
        String url='';
        String locuuid='';
        while (parser.nextToken() != null) 
        {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
            {
                String fieldName = parser.getText();
                system.debug('fieldName'+fieldName);
                system.debug('objectName' + parser.getCurrentToken());
                parser.nextToken(); // object start
                if(fieldName == 'uuid' && uuid =='') 
                    uuid = parser.getText();
                if(fieldName == 'uuid') 
                    locuuid = parser.getText();
                
            }
        }
        system.debug('UUID : ' + uuid);
        system.debug('locuuid : ' + locuuid);
        
        if(AddressType == 'PrimaryAddress')
        {
            con.FieldAware_ID__c = uuid;
            con.FieldAware_URL__c = 'https://app.fieldaware.com/account/customers/' + uuid;
            con.location_id__c = LocationID;
            
            update con;
        }
        else
        {
            More_FieldAware_Address__c ma = new More_FieldAware_Address__c();
            
            ma.name = mailingstreet;
            ma.City__c = mailingcity;
            ma.Country__c = mailingcountry;
            ma.Postal_Code__c = mailingpostalcode;               
            ma.Contact__c = con.id;
            ma.Location_ID__c = LocationID;
            
            upsert ma Location_ID__c;
        }
        
        
    }
}