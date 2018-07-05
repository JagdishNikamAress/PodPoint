public class helperJobs 
{
    public String primaryContactID{get;set;}
    public String CaseID{get;set;}
    public Static String LocationID{get;set;}
    public Static String CustomerID{get;set;}
    
    
    public void  getJobDetails(List<Case> cases)
    {
        List<Attachment> lstattach = new  List<Attachment>();
        List<Case> lstCasesUpdate = new List<Case>();
        Map<String,Installer__c> mapInstaller = new Map<String,Installer__c>();
        Installer__c Installer;
        try{ 
            for(case c : cases)
            {
                if(c.External_ID__c != null)
                {
                    String Endpoint = 'https://api.fieldaware.net/job/'+ c.External_ID__c;
                    
                    HttpResponse res = HttpRequestGETMethod(Endpoint,'GET');    
                    
                    system.debug('Repsonse :' + res.getBody());
                    
                    if(res.getStatus() == 'OK')
                    {
                        Type resultType = Type.forName('JSONJobDetails');
                        JSONJobDetails deserializeResults =       (JSONJobDetails)JSON.deserialize((String)res.getBody(), resultType);
                        System.debug('==========> deserialize() results = ' + deserializeResults);
                        
                        
                        
                        String Status = deserializeResults.State[0].substring(0,1).toUpperCase() +  deserializeResults.State[0].substring(1).toLowerCase();
                        system.debug('Installer Name :' + deserializeResults.jobLead);
                        system.debug('Status Name :' + c.status);
                        if(deserializeResults.jobLead != null)
                        {
                            if(c.Type == 'Survey')
                            {
                                system.debug('Status == ' + Status);
                                if(Status == 'Scheduled')
                                    c.status = 'Survey Scheduled';
                                else if(Status == 'Completed')
                                    c.status = 'Survey Complete';
                                else
                                    c.status = Status;
                            }
                            if(c.Type == 'Install')
                            {
                                system.debug('Status == ' + Status);
                                if(Status == 'Scheduled')
                                    c.status = 'Install Scheduled';
                                else if(Status == 'Completed')
                                    c.status = 'Install Complete';
                                else
                                    c.status = Status;
                            }
                        }
                        
                        
                        
                        
                        
                        if(deserializeResults.jobLead != null)
                        {
                            Installer = new Installer__c();
                            
                            system.debug('Installer :' + deserializeResults.jobLead.name);
                            
                            Installer.name = deserializeResults.jobLead.name + ' ' + deserializeResults.jobLead.surname;
                            Installer.Phone__c = deserializeResults.jobLead.telno;
                            Installer.Email__c = deserializeResults.jobLead.emailAddress;
                            
                            //c.Installer__c = Installer.id;
                            c.Installer__r = new Installer__c(name = Installer.name);
                            
                            if(!mapInstaller.containskey(Installer.name))
                                mapInstaller.put(Installer.name,Installer); 
                        }
                        
                        
                        if(deserializeResults.completedOn != null)
                            c.Completed_On__c = datetime.valueOf((deserializeResults.completedOn).replace('T',' ').replace('Z', '')).addHours(1);
                        if(deserializeResults.scheduledOn != null && deserializeResults.jobLead != null)
                            c.Scheduled_On__c = datetime.valueOf((deserializeResults.scheduledOn).replace('T',' ').replace('Z', '')).addHours(1);
                        if(deserializeResults.startedOn != null)
                            c.Started_On__c = datetime.valueOf((deserializeResults.startedOn).replace('T',' ').replace('Z', '')).addHours(1);
                        
                        
                        lstCasesUpdate.add(c);
                        
                        
                    }
                }
            }
            if(mapInstaller.size()>0)
                upsert mapInstaller.values() name;   
            
            Database.SaveResult[] resultsCases = Database.update(lstCasesUpdate,false);
            
            // Iterate through each returned result
            for (Database.SaveResult cs : resultsCases) {
                if (cs.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully Operation. CASE ID: ' + cs.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : cs.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Case fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
            //Database.upsert(lstattach,Attachment.name.getDescribe().getSObjectField(),false);
        }
        Catch(Exception e){system.debug('OOps there are errors ==>'+e.getMessage());}      
    }
    
    public void  getJobAttachments(List<Case> cases)
    {
        List<Attachment> lstattach = new  List<Attachment>();
        List<Case> lstCasesUpdate = new List<Case>();
        
        try{ 
            for(case c : cases)
            {
                if(c.External_ID__c != null)
                {
                    String Endpoint = 'https://api.fieldaware.net/job/'+ c.External_ID__c;
                    
                    HttpResponse res = HttpRequestGETMethod(Endpoint,'GET');    
                    
                    system.debug('Repsonse :' + res.getBody());
                    
                    if(res.getStatus() == 'OK')
                    {
                        Type resultType = Type.forName('JSONJobDetails');
                        JSONJobDetails deserializeResults =       (JSONJobDetails)JSON.deserialize((String)res.getBody(), resultType);
                        System.debug('==========> deserialize() results = ' + deserializeResults);
                        
                        lstCasesUpdate.add(c);
                        
                        for(integer j=0;j<deserializeResults.tasks.size();j++)
                        {
                            system.debug('Inside 1st Loop');
                            for(integer k=0;k<deserializeResults.tasks[j].attachments.size();k++)
                            {
                                system.debug('Inside 2nd Loop');
                                
                                String EndpointAttachment = 'https://api.fieldaware.net/job/'+ deserializeResults.uuid +'/task/' + deserializeResults.tasks[j].uuid +'/attachment/'+deserializeResults.tasks[j].attachments[k].uuid;
                                
                                HttpResponse resAttachment = HttpRequestGETMethod(EndpointAttachment,'GET');
                                
                                system.debug('Created Date:' + deserializeResults.tasks[j].attachments[k].createdDate);
                                
                                Attachment attach = new Attachment();
                                attach.contentType = deserializeResults.tasks[j].attachments[k].mimetype;
                                attach.name = deserializeResults.jobId + '_' + deserializeResults.tasks[j].attachments[k].createdDate+ ' - ' + deserializeResults.tasks[j].task.name + '_' + deserializeResults.tasks[j].attachments[k].name ;
                                // Job__c job2 = new Job__c(FieldAware_ID__c=deserializeResults.uuid); // 'a178E000000AiYt';
                                attach.Parentid = c.id;
                                attach.body = resAttachment.getBodyAsBlob();
                                
                                lstattach.add(attach);
                                
                            }
                        }
                    }
                }
            }
            Database.upsert(lstattach,Attachment.name.getDescribe().getSObjectField(),false);
        }
        Catch(Exception e){system.debug('OOps there are errors ==>'+e.getMessage());}      
    }
    
    //This funtion is called when a maintenance case is created and in case of normal contact
    public static HttpResponse updateResponseinSF(Contact con, Case C, HttpResponse res)
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
        
        
        //before the response is updated in SF; this will create a job in Fieldware. 
        helperJobs hj = new helperJobs();
        HttpResponse resJob = hj.createJob(locuuid,c.Description,c.Maintenance_Type__c);
        
        
        con.FieldAware_ID__c = uuid;
        con.FieldAware_URL__c = 'https://app.fieldaware.com/account/customers/' + uuid;
        con.location_id__c = locuuid;
        
        update con;
        
        
        return resJob;  
    }
    
    //This funtion is called when a maintenance case is created and in case of person account
    public static HttpResponse updateResponseinSF(Account acc, Case C, HttpResponse res)
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
        
        
        //before the response is updated in SF; this will create a job in Fieldware. 
        helperJobs hj = new helperJobs();
        HttpResponse resJob = hj.createJob(locuuid,c.Description,c.Maintenance_Type__c);
        
        system.debug('AccountID : '+ acc.Id);
        
        
        acc.FieldAware_ID__pc = uuid;
        acc.FieldAware_URL__pc = 'https://app.fieldaware.com/account/customers/' + uuid;
        acc.location_id__pc = locuuid;
        
        update acc;
        
        
        return resJob;  
    }
    
    //This funtion is called when a survey or install case is created
    public static HttpResponse updateResponseinSF(Contact con,Account acc, HttpResponse res,Opportunity record)
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
        
        
        //before the response is updated in SF; this will create a job in Fieldware. 
        helperJobs hj = new helperJobs();
        HttpResponse resJob = hj.createJob(acc,locuuid,'Install Job','Install');
        
        
        con.FieldAware_ID__c = uuid;
        con.FieldAware_URL__c = 'https://app.fieldaware.com/account/customers/' + uuid;
        con.location_id__c = locuuid;
        
        update con;
        
        //If job is successfully created in FieldAware, update the flag in Order.
        if(res.getStatus() == 'OK')
        {
            //    o.Install_Case_Created__c = true;
            
            //    update o;
        }
        
        return resJob;  
    }
    
    public String createOnlyCase(String OrderID)
    {
        String Street;
        String City;
        String PostalCode;
        String Country;
        String subject;
        
        Order o = [SELECT AccountId,ContractId,Id,Internal_Order__c,OpportunityId,OrderNumber FROM Order where id =: OrderID];
        Opportunity record = [select id,name,accountid,FieldAware_ID__c,FieldAware_URL_del__c,account.name,account.accountnumber,account.billingstreet,account.billingcity,account.billingpostalcode,account.billingcountry,account.phone,account.website from Opportunity where id =:o.OpportunityId];
        Account acc = [select id,name,accountnumber,FieldAware_ID__c,FieldAware_URL__c,location_id__c from account where id =: record.accountid];
        subject = 'Install Job (Contractor) - ' + acc.name;
        
        List<Case> lstCasesInstall = [select id from case where accountid =: acc.id and type = 'Install' and Opportunity_Name__c =: record.name];
        
        if(lstCasesInstall.size() == 0)//|| (lstCasesSurvey.size() == 0 && JobType =='Survey')  )
        {
            //Fetch all contact roles for the opportunity
            List<OpportunityContactRole> lstOppContactRoles = [SELECT ContactId,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRole where OpportunityId =: o.OpportunityId and IsPrimary = True];
            
            if(lstOppContactRoles.size() != 0)
            {
                Contact  con = [select id,email,account.website,account.name,account.accountnumber,Phone,name,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,accountid from contact where id =: lstOppContactRoles[0].contactid];
                //IF there is no install case on the opportunity, take the address from Quote shipping address
                //List<Quote> qt = [select id, ShippingStreet ,shippingcity,ShippingCountry ,ShippingPostalCode from quote where opportunityid =: record.id and status = 'Accepted'];
                
                //IF there is a survey case on the opportunity, take the address from survey address
                List<case> surveycase = [select id, Street__c ,City__c,Country_Picklist__c ,PostalCode__c from case where OpportunityID__c =: record.id and type = 'Survey'];
                
                
                if(surveycase.size()>0)
                {
                    Street = surveycase[0].Street__c;
                    City = surveycase[0].City__c;
                    PostalCode = surveycase[0].PostalCode__c;
                    Country = surveycase[0].Country_Picklist__c;
                    
                    createCaseInSF(o,acc.id,lstOppContactRoles[0].contactid,subject, record.id,record.name,'Install',Street,City,PostalCode,Country,[Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Contractor_Case' and SobjectType ='Case' limit 1].Id);
                    
                }
                //IF there is no quote case on the opportunity, take the address from customer address
                else
                {
                    if(con.MailingStreet == null && con.MailingCity == null && con.MailingPostalCode == null)
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is no address on customer or any address on the quote.'));
                    else
                    {
                        Street = con.MailingStreet;
                        City = con.MailingCity;
                        PostalCode = con.MailingPostalCode;
                        Country = con.MailingCountry;
                        
                        createCaseInSF(o,acc.id,lstOppContactRoles[0].contactid,subject, record.id,record.name,'Install',Street,City,PostalCode,Country,[Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Contractor_Case' and SobjectType ='Case' limit 1].Id);
                    }
                }
                
                
            }
            else
            {
                //Show the success message at the end.
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is Contact roles defined for the Opportunity, please define contact roles and try again.'));
            }
        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is already a install case open under this opportunity.'));  
        }
        
        return CaseID;
        
    }
    
    //This is function to create case in SF only for Install only cases
    public void createCaseInSF(Order o,string accountid, string contactid,String Subject, string OppID,String OppName,String Type,String Street,String City,String PostalCode,String Country,String RecordTypeID)
    {
        Case cs = new Case();
        cs.accountid = accountid;
        cs.contactid = contactid;
        cs.subject = Subject;
        cs.OpportunityID__c = OppID;
        cs.Opportunity_Name__c = OppName;
        cs.type = Type;
        cs.Street__c = Street;
        cs.City__c = City;
        cs.PostalCode__c = PostalCode;
        cs.Country_Picklist__c = Country;
        cs.RecordTypeId = RecordTypeID;
        
        
        insert cs;
        
        if(cs !=null)
        {
            o.Install_Case_Created__c = true;
            update o;
        }
        
        CaseID = cs.id;
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Install Case is successfully created.'));
    }
    
    
    //This function checks if there is a already a existing address on contact with same address details
    public String getLocationID(Contact con,String MailingStreet,String MailingCity,String MailingPostalCode,String MailingCountry)
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
    
    // This is the new method which is called on button Create Fieldware Job from Install Case record
    public String createJobafterOrder_v2(Case C,Account acc,Opportunity Opp)
    {   
        System.debug('C =>'+C);
        System.debug('acc =>'+acc);
        System.debug('Opp =>'+Opp);
        List<Case> lstCasesInstall = new List<Case>();
        
        
        //lstCasesInstall = [select id,Street__c  from case where Job_ID__c != null and id =: C.id and accountid =: acc.id and Type = 'Install' and Opportunity__c =: Opp.id];
        lstCasesInstall = [select Id,Street__c  from case where Job_ID__c != null and id =: C.id and accountid =: acc.id]; //and accountid =: acc.id and Type = 'Install' and Opportunity__c =: Opp.id];
        System.debug('lstCasesInstall => '+lstCasesInstall);
        
        if(lstCasesInstall.size() != 0)
        {
            //Show the success message at the end.
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is already a Fieldaware job for this Case.'));
            
        }
        else
        {
            //Fetch all contact roles for the opportunity
            List<OpportunityContactRole> lstOppContactRoles = [SELECT ContactId,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRole where OpportunityId =: Opp.id and IsPrimary = True];
            
            if(lstOppContactRoles.size() != 0)
            {
                Contact  con = [select id,email,account.website,account.name,account.accountnumber,FieldAware_ID__c,Phone,FieldAware_URL__c,location_id__c,name,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,accountid from contact where id =: lstOppContactRoles[0].contactid];
                System.debug('conList  ---->>> '+con);
                helperCustomer hc = new helperCustomer();
                
                //If there are no fieldaware details in the contact, means this is new customer in salesforce and hence need to created in FieldAware
                if(con.FieldAware_ID__c == null || con.FieldAware_ID__c =='')
                { 
                    
                    HttpResponse resCustomer;

                    resCustomer = hc.createCustomer(con.name,con.account.name,con.account.accountnumber,C.Street__c,C.City__c,c.PostalCode__c,C.Country_Picklist__c,con.phone,con.email);                    
                    
                    LocationID = getLocatoinIDfromJSONResponse(resCustomer);
                    
                    HttpResponse resJob;
                    
                    //createJob(acc,LocationID,'Awaiting description of works.','Install');
                    //resJob = createJob(acc,LocationID,'Awaiting description of works.','Install');
                    //updateCaseInSF(C,resJob);
                    
                    
                    //Once the data is pushed to FieldAware, the FieldAware ID and other details will be updated back in SF.
                    
                    if(resCustomer != null)
                    {
                        resJob = updateResponseinSF(con,acc,resCustomer,opp); 
                        
                        updateCaseInSF(C,resJob);
                        //Show the success message at the end.
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The data is successfully synced with FieldAware.'));
                    }
                    else
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'There is no street or city defined in the address.'));
                    
                }
                else
                {

                        LocationID = getLocationID(con,C.Street__c,C.City__c,C.PostalCode__c,C.Country_Picklist__c);
                        
                        
                        HttpResponse resCustomer;
                        HttpResponse resloc;
                        HttpResponse resJob;
                        
                        
                        //resCustomer = hc.updateCustomer(con.FieldAware_ID__c,con.name,con.account.accountnumber,C.Street__c,C.City__c,lstCasesInstall[0].PostalCode__c,lstCasesInstall[0].Country_Picklist__c,con.phone,con.email);               
                        
                        if(LocationID == '')
                        {
                            system.debug('Inside if>>');
                            resloc = hc.createLocation(con.FieldAware_ID__c,con.location_id__c,C.Street__c,C.City__c,C.PostalCode__c,C.Country_Picklist__c);
                            LocationID = getLocatoinIDfromJSONResponse(resloc);
                            
                            system.debug('Location ID>>' + LocationID);
                        }
                        else
                            resloc = hc.updateLocation(con.FieldAware_ID__c,LocationID,C.Street__c,C.City__c,C.PostalCode__c,C.Country_Picklist__c);                

                        
                        system.debug('Before Job Create>>');
                        resJob = createJob(acc,LocationID,'Awaiting description of works.','Install');
                        
                        //To be deleted later
                        //HttpResponse resCustomer = hc.updateCustomer(con.FieldAware_ID__c,con.name,con.account.accountnumber,lstCases[0].Street__c,lstCases[0].City__c,lstCases[0].PostalCode__c,lstCases[0].Country_Picklist__c,con.phone,con.email);               
                        //HttpResponse resloc = hc.updateLocation(con.FieldAware_ID__c,con.location_id__c,lstCases[0].Street__c,lstCases[0].City__c,lstCases[0].PostalCode__c,lstCases[0].Country_Picklist__c);            

                    
                    system.debug('Response : ' + resJob);
                    updateCaseInSF(C,resJob);
                    
                    //Show the success message at the end.
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The data is successfully synced with FieldAware.'));
                    
                }
            }
            else
            {
                //Show the success message at the end.
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is Contact roles defined for the Opportunity, please define contact roles and try again.'));
            }
        }
        return CaseID;       
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
    
    
    public String createJobMaintenance(Case C)
    {
        List<Case> lstCasesMaintenance = new List<Case>();
        
        caseID = c.id;
        
        lstCasesMaintenance = [select id from case where id =:c.id and Job_ID__c != null and type = 'Maintenance' and accountid =: c.accountid];
        
        
        if(lstCasesMaintenance.size() != 0)
        {
            //Show the success message at the end.
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is already a Maintenance job for this Case.'));
        }
        else
        {
            if(c.Street__c == null || c.City__c==null || c.Country_Picklist__c ==null || c.PostalCode__c ==null || c.Contact.email == null || c.Contact.phone ==null)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please fill the mandatory fields first.'));
            }           
            else
            {
                Contact  con = [select id,email,account.website,ispersonaccount,account.name,account.accountnumber,FieldAware_ID__c,Phone,FieldAware_URL__c,location_id__c,name,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,accountid from contact where id =: c.contactid];
                
                Account  acc;
                if(con.ispersonaccount)
                {
                    acc = [select id,firstname,lastname,accountnumber,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet from account where id =: con.accountid];
                }
                
                helperCustomer hc = new helperCustomer();
                
                HttpResponse resCustomer;
                HttpResponse resJob;
                HttpResponse resloc;
                
                //If there are no fieldaware details in the contact, means this is new customer in salesforce and hence need to created in FieldAware
                if(con.FieldAware_ID__c == null || con.FieldAware_ID__c =='')
                {
                    
                    if(con.IsPersonAccount==false)
                        resCustomer = hc.createCustomer(con.name,con.account.name,con.account.accountnumber,c.street__c,c.city__c,c.PostalCode__c,c.Country_Picklist__c,con.phone,con.email);
                    else
                        resCustomer = hc.createCustomer(acc.firstname+acc.lastname,acc.firstname+acc.lastname,acc.accountnumber,c.street__c,c.city__c,c.PostalCode__c,c.Country_Picklist__c,con.phone,con.email);
                    
                    if(resCustomer != null)
                    {
                        if(con.ispersonaccount == false)
                            resJob = updateResponseinSF(con,C,resCustomer); 
                        else
                        {
                            resJob = updateResponseinSF(acc,C,resCustomer);
                            updateCaseInSF(C,resJob);
                        }
                        
                        //Show the success message at the end.
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The data is successfully synced with FieldAware.'));
                    }
                    
                    
                }
                else
                {
                    resCustomer = hc.updateCustomer(con.FieldAware_ID__c,con.name,con.account.accountnumber,c.street__c,c.city__c,c.PostalCode__c,c.Country_Picklist__c,con.phone,con.email);               
                    resloc = hc.updateLocation(con.FieldAware_ID__c,con.location_id__c,c.street__c,c.city__c,c.PostalCode__c,c.Country_Picklist__c);    
                    
                    
                    
                    if(!Test.isRunningTest())
                    {
                        resJob = createJob(acc,con.location_id__c,c.Description,c.Maintenance_Type__c);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The data is successfully synced with FieldAware.'));
                    }
                    
                    system.debug('Response : ' + resJob);
                    updateCaseInSF(C,resJob);
                    
                }  
                
            }
            
        }
        return CaseID;        
    }        
    //This function will create a case in SF.This is same function with an extra parameter scopeofwork.
    public Static String  updateCaseInSF(Case C,HttpResponse resJob)
    {
        JSONParser parser = JSON.createParser(resJob.getBody());
        String uuid='';
        String url='';
        String JobId='';
        String CaseID;
        
        
        Type resultType = Type.forName('JSONJobDetails');
        JSONJobDetails deserializeResults =       (JSONJobDetails)JSON.deserialize((String)resJob.getBody(), resultType);
        System.debug('==========> deserialize() results = ' + deserializeResults);
        
        system.debug('UUID : ' + deserializeResults.uuid);
        system.debug('Response :' + resJob.getBody());
        
        if(c.type != 'Maintenance')
            c.Status = 'Awaiting Schedule';
        c.External_ID__c = deserializeResults.uuid;
        c.FieldAware_URL__c = 'https://app.fieldaware.com/account/jobs_and_quotes/jobs/'+ deserializeResults.uuid;
        c.Job_ID__c = deserializeResults.jobId;
        
        
        update c;
        
        CaseID = c.Id;

        
        return CaseID;
    }
    
    //This function will create a case in SF.This is same function with an extra parameter scopeofwork.
    public static String  createCaseInSF(Account acc,Contact con,HttpResponse resJob,String OpportunityID,String OpportunityName,String ScopeofWork1,Double InstallCostQuote1,Double InstallHours1,String ScopeofWork2,Double InstallCostQuote2,Double InstallHours2,String MailingStreet, String MailingCity, String MailingPostalCode,String MailingCountry)
    {
        JSONParser parser = JSON.createParser(resJob.getBody());
        String uuid='';
        String url='';
        String JobId='';
        String CaseID;
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
                if(fieldName == 'JobId') 
                    JobId = parser.getText();
                
            }
        }
        system.debug('UUID : ' + uuid);
        
        
        Case c = new Case();
        
        c.Subject = 'Install Job - ' + acc.Name;
        c.AccountId = acc.Id;
        c.ContactId = con.id;
        c.Status = 'Awaiting Schedule';
        c.Type = 'Install';
        c.Description = 'Install Job';
        c.External_ID__c = uuid;
        c.FieldAware_URL__c = 'https://app.fieldaware.com/account/jobs_and_quotes/jobs/'+uuid;
        c.Job_ID__c = JobId;
        c.OpportunityID__c = OpportunityID;
        c.Opportunity_Name__c = OpportunityName;
        c.Scope_of_Work__c = ScopeofWork1;
        c.Install_Cost_Quote_2__c = installcostquote1;
        c.Install_Hours__c = installhours1;
        c.Scope_of_Works_2__c = ScopeofWork2;
        c.Install_Cost_Quote__c = installcostquote2;
        c.Install_Hours_2__c = installhours2;
        c.Street__c = MailingStreet;
        c.City__c = MailingCity;
        c.Country_Picklist__c = MailingCountry;
        c.PostalCode__c = MailingPostalCode;
        c.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='FieldAware_Case' and SobjectType ='Case' limit 1].Id;
        
        
        insert c;
        
        CaseID = c.Id;
                
        return CaseID;
    }
    
    
    //This function will create a case in SF
    public static String  createCaseInSF(Account acc,HttpResponse resJob,String OpportunityID,String OpportunityName)
    {
        JSONParser parser = JSON.createParser(resJob.getBody());
        String uuid='';
        String url='';
        String JobId='';
        String CaseID;
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
                if(fieldName == 'JobId') 
                    JobId = parser.getText();
                
            }
        }
        system.debug('UUID : ' + uuid);
        
        
        Case c = new Case();
        
        c.Subject = 'Install Job - ' + acc.Name;
        c.AccountId = acc.Id;
        c.Status = 'Awaiting Schedule';
        c.Type = 'Install';
        c.Description = 'Install Job';
        c.External_ID__c = uuid;
        c.FieldAware_URL__c = 'https://app.fieldaware.com/account/jobs_and_quotes/jobs/'+uuid;
        c.Job_ID__c = JobId;
        c.OpportunityID__c = OpportunityID;
        c.Opportunity_Name__c = OpportunityName;
        c.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='FieldAware_Case' and SobjectType ='Case' limit 1].Id;
        
        insert c;
        
        CaseID = c.Id;
        
        return CaseID;
    }
    
    
    public static HttpResponse createJob_Trigger(Account acc,String locationIDs,String JobDescription,String JobType)
    {
        List<Case> lstCases = [select id from case where accountid =: acc.id and type = 'Install'];
        
        String CustomFieldCode;
        FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
        CustomFieldCode = fs.Custom_Field_Code__c;
        system.debug('CustomFieldCode :'+CustomFieldCode);     
        
        String Endpoint = 'https://api.fieldaware.net/job/';
        String Method = 'POST';
        
        if(lstcases.size() == 0)
        {
            Endpoint = 'https://api.fieldaware.net/job/';
            Method = 'POST';
            
            
            //instantiate the generator
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();   
            gen.writeStringField('scheduledOn', String.valueof(datetime.now()).replace('Z',' ').replace('T', '')); 
            gen.writeStringField('description', JobDescription);
            gen.writeFieldName('location');      
            gen.writeStartObject();   
            gen.writeObjectField('uuid', locationIDs);       
            gen.writeFieldName('customFields');      
            gen.writeStartObject();   
            if(JobType=='Survey')
                gen.writeObjectField(CustomFieldCode, '(Commercial) Survey - 60mins');       
            else
                gen.writeObjectField(CustomFieldCode, '(Commercial) Solo Install - Manual');
            gen.writeEndObject();
            
            
            String jsonString = gen.getAsString();
            system.debug('jsonJobs' + jsonString);
            
            HttpResponse res = HttpRequestPOSTMethod_Static(Endpoint,Method,jsonString);  
            return res; 
        }
        else
            return null;
    }
    
    @Future(callout=true)
    public static void updateJobDescription(String CaseID,String Description)
    {
        
        String CustomFieldCode;
        FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
        CustomFieldCode = fs.Custom_Field_Code__c;
        system.debug('CustomFieldCode :'+CustomFieldCode);     
        
        String Endpoint = 'https://api.fieldaware.net/job/' + CaseID;
        String Method = 'POST';
        
        
        //instantiate the generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('description', Description);  
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();
        system.debug('jsonJobs' + jsonString);
        
        HttpResponse res = HttpRequestPOSTMethod_Static(Endpoint,Method,jsonString);  

        
    }
    
    @Future(callout=true)
    public static void updateJobProjectManager(String CaseID,String ProjectManager)
    {
        
        String CustomFieldCode;
        FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
        CustomFieldCode = fs.Project_Manager_Custom_Code__c;
        system.debug('CustomFieldCode :'+CustomFieldCode);     
        
        String Endpoint = 'https://api.fieldaware.net/job/' + CaseID;
        String Method = 'POST';
        
        
        //instantiate the generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();   
        gen.writeFieldName('customFields');      
        gen.writeStartObject(); 
        if (Test.isRunningTest())
        {
            gen.writeObjectField('CustomFieldCode', 'Arne'); 
        }
        else
        {
            gen.writeObjectField(CustomFieldCode, ProjectManager);       
        }
        
        String jsonString = gen.getAsString();
        system.debug('jsonJobs' + jsonString);
        
        HttpResponse res = HttpRequestPOSTMethod_Static(Endpoint,Method,jsonString);  
        //return res; 
        
        
    }
    
    public Static void  getLocationID(String caseID)
    {
        
        if(caseID != null)
        {
            String Endpoint = 'https://api.fieldaware.net/job/'+ caseID;
            
            HttpResponse res = HttpRequestGETMethod_Static(Endpoint,'GET');    
            
            system.debug('Repsonse :' + res.getBody());
            
            if(res.getStatus() == 'OK')
            {
                Type resultType = Type.forName('JSONJobDetails');
                JSONJobDetails deserializeResults =       (JSONJobDetails)JSON.deserialize((String)res.getBody(), resultType);
                System.debug('==========> deserialize() results = ' + deserializeResults);
                
                
                
                LocationID =  deserializeResults.location.uuid;
                CustomerID =  deserializeResults.customer.uuid;
            }
            else
                LocationID =  null;
        }
        else 
            LocationID = null;
        
        
    }
    
    @Future(callout=true)
    public static void updateJobAddress(String CaseID,String Street, String City, String Country, String PostalCode)
    {
        
        getLocationID(CaseID);
        
        helperCustomer.updateLocation_static(CustomerID,LocationID,Street,City,Country,PostalCode);
        
        
    }
    
    public HttpResponse createJob(String locationIDs,String JobDescription,String JobType)
    {
        String CustomFieldCode;
        FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
        CustomFieldCode = fs.Maintenance_Type__c;
        system.debug('CustomFieldCode :'+CustomFieldCode);     
        
        String Endpoint = 'https://api.fieldaware.net/job/';
        String Method = 'POST';
        
        
        //instantiate the generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();   
        gen.writeStringField('scheduledOn', String.valueof(datetime.now()).replace('Z',' ').replace('T', '')); 
        if(JobDescription !=null)
            gen.writeStringField('description', JobDescription);
        gen.writeFieldName('location');      
        gen.writeStartObject();   
        gen.writeObjectField('uuid', locationIDs);       
        gen.writeEndObject();
        
        gen.writeFieldName('customFields');      
        gen.writeStartObject(); 
        if (Test.isRunningTest())
        {
            gen.writeObjectField('CustomFieldCode', '(Commercial) Survey - 60mins'); 
        }
        else
        {
            if(JobType=='Domestic')
                gen.writeObjectField(CustomFieldCode, '(Domestic)  Maintenance - 60mins');       
            if(JobType=='Commercial')
                gen.writeObjectField(CustomFieldCode, '(Commercial) Maintenance - Manual');
        }
        
        
        
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();
        system.debug('jsonJobs' + jsonString);
        
        HttpResponse res = HttpRequestPOSTMethod(Endpoint,Method,jsonString);  
        return res; 
        //}
        //else
        //    return null;
    }
    
    public HttpResponse createJob(Account acc,String locationIDs,String JobDescription,String JobType)
    {
        String CustomFieldCode;
        FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
        CustomFieldCode = fs.Custom_Field_Code__c;
        system.debug('CustomFieldCode :'+CustomFieldCode);     
        
        String Endpoint = 'https://api.fieldaware.net/job/';
        String Method = 'POST';
        
        
        //instantiate the generator
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();   
        gen.writeStringField('scheduledOn', String.valueof(datetime.now()).replace('Z',' ').replace('T', '')); 
        
        if(JobDescription !=null)
            gen.writeStringField('description', JobDescription);
        gen.writeFieldName('location');      
        gen.writeStartObject();   
        gen.writeObjectField('uuid', locationIDs);   
        gen.writeEndObject();
        
        /* Commented the  FA Tasks Automation
gen.writeFieldName('tasks');
gen.writeStartArray(); 

if(JobType == 'Survey')
{
//1st task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'f43c2ff616c248a99abe8b6d0d22c46b');       
gen.writeEndObject();    
gen.writeStringField('note', 'Fill in site survey form');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//2nd task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', '695bab4bd85a4e079d21fd91935bdd37');       
gen.writeEndObject();
gen.writeStringField('note', 'Completed customer signed Annex D');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//3rd task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'c11386b7759a4ba3a5505142a6936788');       
gen.writeEndObject();
gen.writeStringField('note', 'offstreet parking photo');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//4th task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'f2a544fcf4344da8afe020be8a58bc3a');       
gen.writeEndObject();
gen.writeStringField('note', 'Photo of mains supply service head.');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();


//5th task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'e0a2de0cbb134f69b3d961c05dac7bce');       
gen.writeEndObject();
gen.writeStringField('note', 'Distribution board photo');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//6th task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', '02d68841749048f88b166b6bacd37fa2');       
gen.writeEndObject();
gen.writeStringField('note', 'ENA form');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//7th task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'd9b7be8d1758495c84f89fbe1cde99f7');       
gen.writeEndObject();
gen.writeStringField('note', 'Install Lock');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//8th task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'd269a028a00e4a128209e371f606031f');       
gen.writeEndObject();
gen.writeStringField('note', 'Photo of serial number');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();
}
if(JobType == 'Install')
{
//1st task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'f43c2ff616c248a99abe8b6d0d22c46b');       
gen.writeEndObject();    
gen.writeStringField('note', 'Fill in site survey form');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//2nd task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', '695bab4bd85a4e079d21fd91935bdd37');       
gen.writeEndObject();
gen.writeStringField('note', 'Completed customer signed Annex D');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//3rd task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'c11386b7759a4ba3a5505142a6936788');       
gen.writeEndObject();
gen.writeStringField('note', 'offstreet parking photo');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//4th task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'f2a544fcf4344da8afe020be8a58bc3a');       
gen.writeEndObject();
gen.writeStringField('note', 'Photo of mains supply service head.');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();


//5th task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'e0a2de0cbb134f69b3d961c05dac7bce');       
gen.writeEndObject();
gen.writeStringField('note', 'Distribution board photo');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//6th task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', '02d68841749048f88b166b6bacd37fa2');       
gen.writeEndObject();
gen.writeStringField('note', 'ENA form');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//7th task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'd9b7be8d1758495c84f89fbe1cde99f7');       
gen.writeEndObject();
gen.writeStringField('note', 'Install Lock');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();

//8th task
gen.writeStartObject(); 
gen.writeFieldName('task');
gen.writeStartObject();  
gen.writeObjectField('uuid', 'd269a028a00e4a128209e371f606031f');       
gen.writeEndObject();
gen.writeStringField('note', 'Photo of serial number');
gen.writeNumberField('unitCost', 10.00);
gen.writeEndObject();
}
gen.writeEndArray();
*/
        
        gen.writeFieldName('customFields');      
        gen.writeStartObject(); 
        if (Test.isRunningTest())
        {
            gen.writeObjectField('CustomFieldCode', '(Commercial) Survey - 60mins'); 
        }
        else
        {
            if(JobType=='Survey')
                gen.writeObjectField(CustomFieldCode, '(Commercial) Survey - 60mins');       
            if(JobType=='Install')
                gen.writeObjectField(CustomFieldCode, '(Commercial) Solo Install - Manual');
            if(JobType=='Domestic')
                gen.writeObjectField(CustomFieldCode, '(Domestic)  Maintenance - 60mins');       
            if(JobType=='Commercial')
                gen.writeObjectField(CustomFieldCode, '(Commercial) Maintenance - Manual');
        }
        
        
        
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();
        system.debug('jsonJobs' + jsonString);
        
        HttpResponse res = HttpRequestPOSTMethod(Endpoint,Method,jsonString);  
        return res; 
        //}
        //else
        //    return null;
    }
    
    public static HttpResponse HttpRequestGETMethod_Static(String Endpoint, String Method)
    {
        
        String Token;
        FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
        Token = fs.Token__c;
        
        HttpRequest reqVariable = new HttpRequest();
        reqVariable.setEndpoint(Endpoint);
        reqVariable.setMethod(Method);
        reqVariable.setheader('Accept','application/json'); 
        reqVariable.setHeader('Authorization', 'Token '+Token);
        system.debug('Req body :' +reqVariable);
        
        Http httpVariable = new Http();
        HttpResponse resVariableList = httpVariable.send(reqVariable);
        
        
        //system.debug('Req body:' +(String)resVariableList.getBody());
        
        return resVariableList;
    }
    
    public HttpResponse HttpRequestGETMethod(String Endpoint, String Method)
    {
        
        String Token;
        FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
        Token = fs.Token__c;
        
        HttpRequest reqVariable = new HttpRequest();
        reqVariable.setEndpoint(Endpoint);
        reqVariable.setMethod(Method);
        reqVariable.setheader('Accept','application/json'); 
        reqVariable.setHeader('Authorization', 'Token '+Token);
        system.debug('Req body :' +reqVariable);
        
        Http httpVariable = new Http();
        HttpResponse resVariableList = httpVariable.send(reqVariable);
        
        
        //system.debug('Req body:' +(String)resVariableList.getBody());
        
        return resVariableList;
    }
    
    
    public Static HttpResponse HttpRequestPOSTMethod_Static(String Endpoint, String Method, String Body)
    {
        String Token;
        FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
        Token = fs.Token__c;
        system.debug('Token :'+Token);
        
        HttpRequest reqVariable = new HttpRequest();
        reqVariable.setEndpoint(Endpoint);
        reqVariable.setMethod(Method);
        reqVariable.setheader('Content-Type','application/raw');    
        reqVariable.setHeader('Authorization', 'Token '+ Token);
        reqVariable.setBody(Body);
        
        
        
        Http httpVariable = new Http();
        HttpResponse resVariableList = httpVariable.send(reqVariable);
        
        String strjson = '{"Contacts":' + (String)resVariableList.getBody() + '}';
        
        system.debug('Req body Contacts:' +strjson);
        
        return resVariableList;
    }
    
    public HttpResponse HttpRequestPOSTMethod(String Endpoint, String Method, String Body)
    {
        String Token;
        FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
        Token = fs.Token__c;
        
        system.debug('Token :'+Token);
        HttpRequest reqVariable = new HttpRequest();
        reqVariable.setEndpoint(Endpoint);
        reqVariable.setMethod(Method);
        reqVariable.setheader('Content-Type','application/raw');    
        reqVariable.setHeader('Authorization', 'Token ' +Token);
        reqVariable.setBody(Body);
        
        system.debug('Body : ' + Body);
        system.debug('Endpoint :' + Endpoint);
        system.debug('Method :' + Method);
        
        Http httpVariable = new Http();
        HttpResponse resVariableList = httpVariable.send(reqVariable);
        
        String strjson = '{"Contacts":' + (String)resVariableList.getBody() + '}';
        
        system.debug('Req body Contacts:' +strjson);
        
        return resVariableList;
    }
    
    
}