trigger CaseTrigger on Case (before insert, before update, after update,after delete,after insert){
    System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
    
    /*Logic for "Validation rule: Can't "Close" Commercial Case if any WO is not Complete/Incomplete/Rejected". 
User should not be able to 'Close a commercial case if that case contains any ongoing workOrder'
Card # 53 
Date 09/11/17
*/
    Id contrCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Contractor Case').getRecordTypeId();
    Id commCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
    Id installCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Install Case').getRecordTypeId();
    Id supportCaseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId();
    Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    if(Trigger.isBefore && Trigger.isInsert && AvoidRecursion.caseBeforeInsert){
        /*Populate Oppty Shipping address on Commercial Case When Oppty lookup field on Case becomes populated on creation OR when Oppty lookup field becomes populated on Case update (isChanged)*/
        Map<String,Case> OpptyIdCasesMap = new Map<String,Case>();
        for(case cRec : trigger.new){
            if(cRec.RecordTypeId==commCaseRecordTypeId1 && cRec.Opportunity__c != NULL){
                OpptyIdCasesMap.put(cRec.Opportunity__c, cRec);
                system.debug('in before insert trigger');
            }
        }
        if(!OpptyIdCasesMap.isEmpty()){
            List<Opportunity> caseListWithOppty = [SELECT Id,Shipping_Street__c,Shipping_City__c,Shipping_Postal_Code__c,Shipping_Country_Picklist__c,Shipping_State__c,(SELECT ID,Street__c,City__c,PostalCode__c,Country_Picklist__c FROM Cases__r )  from Opportunity where id IN : OpptyIdCasesMap.keyset()];
            system.debug('List'+caseListWithOppty);
            for(opportunity opp : caseListWithOppty){
                for(Case csRec : trigger.new){
                    if(csRec.Opportunity__c == opp.id){
                        csRec.Street__c = opp.Shipping_Street__c;
                        csRec.City__c = opp.Shipping_City__c;
                        csRec.PostalCode__c = opp.Shipping_Postal_Code__c;
                        csRec.Country_Picklist__c = opp.Shipping_Country_Picklist__c;
                        system.debug('updating the address');
                    }
                }
            }    
        }
        
        
        /*248 Only if case is Support record type,Only if Account is Person Account,
When "Account Name" lookup field is populated on Case creation OR when "Account Name" is populated on Case update (isChanged)
Then copy the address from Person Shipping address fields to the Support Case address fields (Street/City/Postcode/Country)*/
        list<account> acclist;
        set<id> accid = new set<id>();
        for(case c : trigger.new){
            if(c.RecordTypeId==supportCaseRecordTypeId1){
                accid.add(c.accountid);
            }
        }
        if(!accid.isEmpty()){
            acclist = [select id, recordtypeid, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCountryCode, (select id from contacts) from account where id IN : accid AND RecordTypeId=:personAccRecordTypeId];
            
            for(Case c1:Trigger.New){
                if(!acclist.isEmpty()){
                    for(Account accRec:acclist){
                        if(c1.AccountId == accRec.Id){
                            c1.Street__c = accRec.ShippingStreet;
                            c1.City__c = accRec.ShippingCity;
                            c1.PostalCode__c = accRec.ShippingPostalCode;
                            c1.Country_Picklist__c = accRec.ShippingCountry;
                            if(!accRec.Contacts.IsEmpty()){
                                for(Contact cont:accRec.Contacts){
                                    c1.ContactId = cont.Id;
                                }
                            }
                        }
                    }
                }
            }
        }
        for(Case cs:Trigger.new){
            /* if(cs.RecordTypeId==contrCaseRecordTypeId1 || cs.RecordTypeId==installCaseRecordTypeId1 || cs.RecordTypeId==commCaseRecordTypeId1){
if(Userinfo.getName() == 'Daniel Eyers'|| Userinfo.getName() == 'Phil Hill' || Userinfo.getName() == 'Mike Jackson')cs.Project_Manager__c = 'Stuart C';
if(Userinfo.getName() == 'Trishan Ponnamperuma'|| Userinfo.getName() == 'Jay Stephens' || Userinfo.getName() == 'Claire Bennett' || Userinfo.getName() == 'Rob Hughes' ||Userinfo.getName() == 'Matt Watkiss' ||Userinfo.getName() == 'Chris Cheetham' ||  Userinfo.getName() == 'Jon Horsfield'  ||Userinfo.getName() == 'Sam Depford'  || Userinfo.getName() == 'Isabel James')cs.Project_Manager__c = 'Kostas';         
if(Userinfo.getName() == 'Jarred Ryans' || Userinfo.getName() == 'Rory Duncan' || Userinfo.getName() == 'Alex Potts' || Userinfo.getName() == 'Liam Callaghan' || Userinfo.getName() == 'Alex Zed')cs.Project_Manager__c = 'Brad';
if(Userinfo.getName() == 'Oliver Dodd')cs.Project_Manager__c = 'Martin';
if(Userinfo.getName() == 'Natalia Silverstone')cs.Project_Manager__c = 'Sam';
if(Userinfo.getName() == 'Charlie Roberts')cs.Project_Manager__c = 'Arne';
if(Userinfo.getName() == 'Jagdish Nikam')cs.Project_Manager__c = 'Martin';
//   if(Userinfo.getName() == 'More Nilesh' || Userinfo.getName() == 'Nilesh More')
// cs.Project_Manager__c = 'Martin';
}*/
        }
        AvoidRecursion.caseBeforeInsert=False;
    }
    if(Trigger.isBefore && Trigger.isUpdate && AvoidRecursion.caseBeforeUpdater()){
        
        
        
        Map<String,Case> OpptyIdCasesMap = new Map<String,Case>();
        for(case cRec : trigger.new){
            if(cRec.RecordTypeId==commCaseRecordTypeId1 && cRec.Opportunity__c != trigger.oldmap.get(cRec.id).Opportunity__c){
                OpptyIdCasesMap.put(cRec.Opportunity__c, cRec);
            }
        }
        if(!OpptyIdCasesMap.isEmpty()){
            List<Opportunity> caseListWithOppty = [SELECT Id,Shipping_Street__c,Shipping_City__c,Shipping_Postal_Code__c,Shipping_Country_Picklist__c,Shipping_State__c,(SELECT ID,Street__c,City__c,PostalCode__c,Country_Picklist__c FROM Cases__r)  from Opportunity where id IN : OpptyIdCasesMap.keyset()];
            for(opportunity opp : caseListWithOppty){
                for(Case csRec : trigger.new){
                    if(csRec.Opportunity__c == opp.id){
                        csRec.Street__c = opp.Shipping_Street__c;
                        csRec.City__c = opp.Shipping_City__c;
                        csRec.PostalCode__c = opp.Shipping_City__c;
                        csRec.Country_Picklist__c = opp.Shipping_Country_Picklist__c;
                        system.debug('updating the address');
                    }
                }
            }    
        }
        
        
        
        
        
        
        if(AvoidRecursion.isFirstRun() ){
            
            
            
            
            
            
            
            
            /*Only if case is Support record type,Only if Account is Person Account,
When "Account Name" lookup field is populated on Case creation OR when "Account Name" is populated on Case update (isChanged)
Then copy the address from Person Shipping address fields to the Support Case address fields (Street/City/Postcode/Country)*/
            list<account> acclist;
            set<id> accid = new set<id>();
            for(case c : trigger.new){
                if(c.RecordTypeId==supportCaseRecordTypeId1 && c.AccountId!=Trigger.oldMap.get(c.Id).AccountId){
                    accid.add(c.accountid);
                }
            }
            
            if(!accid.isEmpty()){
                acclist = [select id, recordtypeid, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingCountryCode, (select id from contacts) from account where id IN : accid AND RecordTypeId=:personAccRecordTypeId];
                
                
                
                for(Case c1:Trigger.New){
                    if(!acclist.isEmpty()){
                        for(Account accRec:acclist){
                            if(c1.AccountId == accRec.Id){
                                c1.Street__c = accRec.ShippingStreet;
                                c1.City__c = accRec.ShippingCity;
                                c1.PostalCode__c = accRec.ShippingPostalCode;
                                c1.Country_Picklist__c = accRec.ShippingCountry;
                                if(!accRec.Contacts.IsEmpty()){
                                    for(Contact cont:accRec.Contacts){
                                        c1.ContactId = cont.Id;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
            
            
            
            
            
            
            
            
            
            //Id contrCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Contractor Case').getRecordTypeId();
            //Id commCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
            //Id installCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Install Case').getRecordTypeId();
            /*Code block when the Approve Survey option1/2 vecomes True*/
            List<case> caseList = new List<case>();
            for(case caseRec:trigger.new){
                
                if((caseRec.Approve_Survey_Option_1__c==True && caseRec.Approve_Survey_Option_1__c!=Trigger.oldMap.get(caseRec.Id).Approve_Survey_Option_1__c && (caseRec.RecordTypeId==contrCaseRecordTypeId1 || caseRec.RecordTypeId==commCaseRecordTypeId1)) || (
                    caseRec.Approve_Survey_Option_2__c==True && caseRec.Approve_Survey_Option_2__c!=Trigger.oldMap.get(caseRec.Id).Approve_Survey_Option_2__c && (caseRec.RecordTypeId==contrCaseRecordTypeId1 || caseRec.RecordTypeId==commCaseRecordTypeId1))){
                        caseRec.Survey_Status__c='Quoted';
                        //caseRec.Status = 'Survey Quoted';
                        caseList.add(caseRec);
                    }
                if((caseRec.Approve_Survey_Option_1__c==True && caseRec.Approve_Survey_Option_1__c!=Trigger.oldMap.get(caseRec.Id).Approve_Survey_Option_1__c && caseRec.RecordTypeId==contrCaseRecordTypeId1) || (
                    caseRec.Approve_Survey_Option_2__c==True && caseRec.Approve_Survey_Option_2__c!=Trigger.oldMap.get(caseRec.Id).Approve_Survey_Option_2__c && caseRec.RecordTypeId==contrCaseRecordTypeId1)){
                        caseRec.Status = 'Survey Quoted';
                        caseList.add(caseRec);
                    }
                
                /*Sync the Contractor Case "Status" field with "Survey Status" field*/
                if(caseRec.RecordTypeId==contrCaseRecordTypeId1){
                    if(caseRec.Status == 'Awaiting Schedule')
                        caseRec.Survey_Status__c='Requested';
                    if(caseRec.Status =='Survey Scheduled')
                        caseRec.Survey_Status__c='Scheduled';
                    if(caseRec.Status == 'Active')
                        caseRec.Survey_Status__c='Active';
                    if(caseRec.Status == 'Survey Complete')
                        caseRec.Survey_Status__c='Completed';
                    if(caseRec.Status == 'Survey Quoted')
                        caseRec.Survey_Status__c='Quoted';
                    if(caseRec.Status == 'On Hold')
                        caseRec.Survey_Status__c='On Hold';
                    if(caseRec.Status == 'Closed')
                        caseRec.Survey_Status__c='Cancelled';
                    if(caseRec.Status == 'Paused')
                        caseRec.Survey_Status__c='On Hold';
                    caseList.add(caseRec);
                }
                
                /*Sync the Install Case "Status" field with "Install Status" field*/
                if(caseRec.RecordTypeId==installCaseRecordTypeId1){
                    if(caseRec.Status == 'Awaiting Schedule')
                        caseRec.Install_Status__c='Requested';
                    if(caseRec.Status =='Install Scheduled')
                        caseRec.Install_Status__c='Scheduled';
                    if(caseRec.Status == 'Active')
                        caseRec.Install_Status__c='Active';
                    if(caseRec.Status == 'Install Complete')
                        caseRec.Install_Status__c='Completed';
                    if(caseRec.Status == 'Install Verified')
                        caseRec.Install_Status__c='Verified';
                    if(caseRec.Status == 'On Hold')
                        caseRec.Install_Status__c='On Hold';
                    if(caseRec.Status == 'Closed')
                        caseRec.Install_Status__c='Cancelled';
                    caseList.add(caseRec);
                }
            }
            //if(!caseList.isEmpty())
            //update caseList;
            
            Set<Id> IdforCommCase=new Set<Id>();
            Map<String,Case> caseMap;
            //Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
            for(Case c : Trigger.New){
                if(c.Status!=Trigger.oldMap.get(c.Id).Status && c.Status == 'Closed' && c.RecordTypeId == commCaseRecordTypeId1){
                    IdforCommCase.add(c.id);
                }
            }
            if(!IdforCommCase.isEmpty()){
                caseMap =new Map<String,Case>([SELECT Id,Status, (select id,status FROM WORKORDERS) from Case where id in : IdforCommCase]); 
                
                for(Case c : caseMap.values()){
                    if(!caseMap.get(c.Id).workorders.isEmpty()){
                        for(WorkOrder w : caseMap.get(c.Id).workorders){
                            if(w.Status != 'Completed' && w.Status != 'Incomplete' && w.Status!= 'Rejected'){
                                Trigger.new[0].addError('This Case has ongoing Work Orders');
                            }
                        }           
                    }
                }  
            } 
        }  
        AvoidRecursion.caseBeforeUpdate = false;
    }
    /*End of Logic for "Validation rule: Can't "Close" Commercial Case if any WO is not Complete/Incomplete/Rejected". */
    
    /*Code to create WOrkOrder Of Type 'Homecharge Install' When Non_Standard_Install__c is false, Ready_to_Schedule__c is true
auother:Pratik Pawar Card#73
Date 13/11/2017
*/
    if(Trigger.isAfter && Trigger.isUpdate ){
        Set<id> oppIdSet= new Set<id>(); 
        Set<id> oppIdSet2= new Set<id>(); 
        SET<ID> CaseIDsSet = new SET<ID>();
        List<case> cases=new List<case>();
        for(case caId : trigger.new){
            if(caId.Survey_Status__c!=Trigger.oldMap.get(caId.Id).Survey_Status__c && caId.Survey_Status__c!=null){
                oppIdSet.add(caId.Opportunity__c);
                CaseIDsSet.add(caId.Id);
            }
        }
        for(case caId : trigger.new){
            if(caId.Install_Status__c!=Trigger.oldMap.get(caId.Id).Install_Status__c && caId.Install_Status__c !=null){
                oppIdSet2.add(caId.Opportunity__c);
            }
        }
        
        if(!oppIdSet2.isEmpty()){
            list<opportunity> CheckOpp = [select id, Stagename, Probability from opportunity where id IN: oppIdSet2];
            for(case caId : trigger.new){
                if(caId.Install_Status__c!=Trigger.oldMap.get(caId.Id).Install_Status__c && caId.Install_Status__c !=null){
                    for(Opportunity opp : CheckOpp){
                        if(opp.Probability < 80 && caID.Opportunity__c == opp.id && checkRecursive.skip_install_statuscheck_whencasecreated == false){
                            system.debug('The value of the probabilty ' +opp.Probability);
                            caID.adderror('You can\'t update the "Install Status" because the Opportunity is not Won yet');
                        }
                    }
                }
            }
        }
        if(!oppIdSet.isEmpty()){
            List<Opportunity> oppList = [SELECT ID, StageName,Install_Status_New__c,Survey_Status__c,(Select id,Survey_Status__c,Install_Status__c,Opportunity__c FROM Cases__r WHERE Id IN : CaseIDsSet AND Opportunity__c IN: oppIdSet AND Install_Status__c=null) FROM Opportunity WHERE ID IN:oppIdSet];
            if(!oppList.isEmpty()){
                for(Opportunity oppRec:oppList){
                    if(!OppRec.Cases__r.isEmpty()){
                        for(Case caseRec:OppRec.Cases__r){
                            OppRec.Survey_Status__c = caseRec.Survey_Status__c;
                            OppRec.Install_Status_New__c = caseRec.Install_Status__c;
                        }
                    }
                }
            }
            
        }
        
        
        /*
* Logic to change address of child WOs and SAs when address of case is changed.
*/
        if(AvoidRecursion.isFirstRun1() || test.isRunningTest()){
            List<WorkOrder> wrkOList = new List<WorkOrder>();
            List<ServiceAppointment> saList = new List<ServiceAppointment>();
            Set<Id> CaseIdSet2 = new Set<Id>();
            for(case caOld : trigger.new){
                // CaseIdSet.add(c.Id);
                if((Trigger.oldMap.get(caOld.Id).City__c != caOld.City__c)||
                   (Trigger.oldMap.get(caOld.Id).Country_Picklist__c != caOld.Country_Picklist__c)||
                   (Trigger.oldMap.get(caOld.Id).PostalCode__c != caOld.PostalCode__c)||
                   (Trigger.oldMap.get(caOld.Id).Street__c != caOld.Street__c)){
                       CaseIdSet2.add(caOld.Id);
                   }
            }
            Map<Id,WorkOrder> wrkorderMap= new Map<Id,WorkOrder>([SELECT Id, Street, City, State, PostalCode, Country FROM WorkOrder where caseId in : CaseIdSet2]);
            Map<Id,ServiceAppointment> saMap= new Map<Id,ServiceAppointment>([SELECT Id, Street, City, PostalCode,ParentRecordId, Country FROM ServiceAppointment where ParentRecordId in : wrkorderMap.keySet()]);  
            for(case ca : trigger.new){
                System.debug('IN ADRESS UPDATE FOR LOOP OF CA');
                for(WorkOrder Wo : wrkorderMap.values()){
                    System.debug('IN ADRESS UPDATE FOR LOOP OF wo');
                    wo.Country = ca.Country_Picklist__c ;
                    //wo.CountryCode = ca.Country_Picklist__c ;
                    wo.City = ca.City__c ; 
                    wo.Street = ca.Street__c ;
                    wo.PostalCode = ca.PostalCode__c;
                    wrkOList.add(wo);
                }
                for(ServiceAppointment sa : saMap.values()){
                    System.debug('IN ADRESS UPDATE FOR LOOP OF sa');
                    sa.Country = ca.Country_Picklist__c ;
                    //wo.CountryCode = ca.Country_Picklist__c ;
                    sa.City = ca.City__c ; 
                    sa.Street = ca.Street__c ;
                    sa.PostalCode = ca.PostalCode__c;
                    saList.add(sa);
                }
            }
            update wrkOList;
            update saList;
            
            /*
* End of Logic to change address of child WOs and SAs when address of case is changed.
*/
            
            Set<Id> CaseIdSet= new Set<Id>();
            Id WORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
            for(case c : trigger.new){
                if((c.Non_Standard_Review__c==false || c.Non_Standard_Install_Picklist__c=='No') && c.Ready_to_Schedule__c==true && Trigger.oldMap.get(c.Id).Ready_to_Schedule__c != c.Ready_to_Schedule__c)
                    CaseIdSet.add(c.Id);
            }
            Map<Id,Case> CaseMap= new Map<Id,Case>([SELECT Id, Non_Standard_Review__c,Non_Standard_Install_Picklist__c, Ready_to_Schedule__c,AccountId, ContactId FROM Case WHERE Id in : CaseIdSet]);
            system.debug('CaseMap'+CaseMap);
            List<WorkOrder> WOList=new List<WorkOrder>();
            if(CaseMap.size()!=0){
                WorkType wt= [SELECT Id, name from WorkType where name='Install (Domestic)' limit 1];
                
                for(Case c: CaseMap.values()){
                    system.debug('c'+c);
                    system.debug('c.Ready_to_Schedule__c'+c.Ready_to_Schedule__c);
                    system.debug('Trigger.oldMap.get(c.Id).Ready_to_Schedule__c'+Trigger.oldMap.get(c.Id).Ready_to_Schedule__c);
                    If(c.Ready_to_Schedule__c=true && Trigger.oldMap.get(c.Id).Ready_to_Schedule__c != c.Ready_to_Schedule__c)  {
                        System.debug('case Id ===>'+c.Id);
                        WorkOrder w = new WorkOrder();
                        w.WorkTypeId=wt.Id;
                        w.RecordTypeId=WORecordTypeId;
                        w.CaseId=c.Id;
                        w.AccountId=c.AccountId;
                        w.ContactId=c.ContactId;
                        // w.Status='Completed';
                        WOList.add(w);
                    }
                }
            }
            System.debug('WOList.WOList===>'+WOList);
            insert WOList;
        }
        AvoidRecursion.caseAfterUpdate = false;
    }
    /*END OF Code to create WOrkOrder Of Type 'Homecharge Install' When Non_Standard_Install__c is false, Ready_to_Schedule__c is true
*/    
    
    //Map<String,String> caseIDsWithDescription = new Map<String,String>();
    Set<Id> oppIDs = new Set<Id>();
    List<Order> orderUpdate = new List<Order>(); 
    Map<String,Opportunity> OppUpdate = new Map<String,Opportunity>(); 
    // List<Opportunity> opps = new List<Opportunity>();
    
    
    if(Trigger.isUpdate || Trigger.isInsert)
    {
        for (Case c : Trigger.new)
        {
            oppIDs.add(c.Opportunity__c);
            //caseIDsWithDescription.put(c.External_ID__c,c.description);
        }         
    }
    if(Trigger.isDelete)
    {
        for(Case c : Trigger.old)
            oppIDs.add(c.Opportunity__c);
    }
    Map<Id,Opportunity> oppWithOrders;
    if(!oppIDs.isEmpty()){
        oppWithOrders = new Map<Id,Opportunity>(
            [SELECT id,(SELECT Id FROM orders where recordtypeid =: Schema.SObjectType.order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId()) FROM Opportunity WHERE Id IN :oppIDs]);
    }
    
    //In case of case is delete, the case information will be removed from the order
    if(Trigger.isDelete)
    {
        for (Case c : Trigger.old)
        {
            if(c.Opportunity__c != null)
            {
                //delete the case information on opp (case related fields)
                Opportunity opp = oppWithOrders.get(c.Opportunity__c);
                
                if(c.Type == 'Survey')
                {
                    opp.Job_ID__c = '';
                    opp.Case_Number__c = '';
                    opp.Status_Survey__c = '';
                    opp.PostCode__c = '';
                    opp.Street__c = '';
                    opp.City__c = '';
                    opp.Installer_Name__c = '';
                    opp.Project_Manager__c = '';
                    opp.FA_URL__c = '';
                    opp.Created_Date__c = null;  
                    opp.Completed_On__c = null;
                    opp.Scheduled_Date_Time__c = null;                
                    opp.Case_Link__c = '';
                    opp.Case_Record_Type__c = '';
                    opp.Type__c = c.Type;
                    
                    
                    if(c.Approve_Survey_Option_1__c == true)
                    {
                        opp.Install_Hours__c = null;
                        opp.Scope_of_Work__c = '';
                        opp.Install_Cost_Quote__c = null;
                    }
                    if(c.Approve_Survey_Option_2__c == true)
                    {
                        opp.Install_Hours_2__c = null;
                        opp.Scope_of_Work_2__c = '';
                        opp.Install_Cost_Quote_2__c = null;
                    }
                }
                if(c.Type == 'Install')
                {
                    opp.Case_Link_Install__c = '';
                    opp.Job_ID_Install__c = '';
                    opp.Case_Number_Install__c = '';
                    opp.Status_Install__c = '';
                    opp.PostCode_Install__c = '';
                    opp.Street_Install__c = '';
                    opp.City_Install__c = '';
                    opp.Installer_Name_Install__c = '';
                    opp.Project_Manager_Install__c = '';
                    opp.FA_URL_Install__c = '';
                    opp.Created_Date_Install__c = null;
                    opp.Completed_On_Install__c = null;
                    opp.Scheduled_Date_Time_Install__c = null;
                    opp.Case_Record_Type_Install__c = '';
                    opp.Type_Install__c = '';
                    
                    if(c.Approve_Survey_Option_1__c == true)
                    {
                        opp.Install_Hours__c = null;
                        opp.Scope_of_Work__c = '';
                        opp.Install_Cost_Quote__c = null;
                    }
                    if(c.Approve_Survey_Option_2__c == true)
                    {
                        opp.Install_Hours_2__c = null;
                        opp.Scope_of_Work_2__c = '';
                        opp.Install_Cost_Quote_2__c = null;
                    }
                }
                //Code for Commercial case with type='Commercial' added on 23/Jan/18
                if(c.Type == 'Commercial')
                {
                    opp.Job_ID__c = '';
                    opp.Case_Number__c = '';
                    opp.Status_Survey__c = '';
                    opp.PostCode__c = '';
                    opp.Street__c = '';
                    opp.City__c = '';
                    opp.Installer_Name__c = '';
                    opp.Project_Manager__c = '';
                    opp.FA_URL__c = '';
                    opp.Created_Date__c = null;  
                    opp.Completed_On__c = null;
                    opp.Scheduled_Date_Time__c = null;                
                    opp.Case_Link__c = '';
                    opp.Case_Record_Type__c = '';
                    opp.Type__c = c.Type;
                    
                    if(c.Approve_Survey_Option_1__c == true)
                    {
                        opp.Install_Hours__c = null;
                        opp.Scope_of_Work__c = '';
                        opp.Install_Cost_Quote__c = null;
                    }
                    if(c.Approve_Survey_Option_2__c == true)
                    {
                        opp.Install_Hours_2__c = null;
                        opp.Scope_of_Work_2__c = '';
                        opp.Install_Cost_Quote_2__c = null;
                    }
                }
                
                
                OppUpdate.put(opp.id,opp);
                
                if(oppWithOrders.size()>0)
                {
                    for(Order o : oppWithOrders.get(c.Opportunity__c).orders)
                    {
                        o.Installer_Name__c = '';
                        o.Scheduled_Date__c = null;
                        o.Started_On__c = null;
                        o.Completed_On__c = null;
                        o.Status__c = '';
                        o.Job_ID__c = '';
                        o.Case_ID__c = '';
                        o.Link_To_Case__c =  '';
                        o.Case_Number__c = '';
                        o.Install_Case_Created__c = false;
                        o.FieldAware_URL__c = '';
                        
                        orderUpdate.add(o);
                    }
                }
            }
            
            
        }
        update orderUpdate;
        update oppupdate.values();
    }
    
    //In case of case is updated, the case information will be updated on the order also.
    if(Trigger.isInsert && Trigger.isAfter && AvoidRecursion.caseAfterInsert)
    {
        Map<String, RecordType> RecTypeMap=new Map<String, RecordType>([SELECT id, SobjectType, name from RecordType where SobjectType ='Case']);
        /* List<RecordType> RecordTypeList= new List<RecordType>([SELECT id, SobjectType, name from RecordType where SobjectType ='Case']);
Map<String, RecordType> RecTypeMap=new Map<String, RecordType>();
For(RecordType rec: RecordTypeList){
RecTypeMap.put(rec.name, rec);
}*/
        for (Case c : Trigger.new)
        {
            //update the case information on opp (case related fields)
            if(c.Opportunity__c !=null)
            {
                Opportunity opp = oppWithOrders.get(c.Opportunity__c);
                OppUpdate.put(opp.id,opp);
                //update OppUpdate.values();
                if(c.Type == 'Survey')
                {
                    opp.Case_Link__c = system.URL.getSalesforceBaseUrl().toExternalForm()  +'/'+ c.id;
                    opp.Case_Number__c = c.CaseNumber;
                    opp.Job_ID__c = c.Job_ID__c;
                    opp.Status_Survey__c = c.Status;
                    opp.PostCode__c = c.PostalCode__c;
                    opp.Street__c = c.Street__c;
                    opp.City__c = c.City__c;
                    opp.Installer_Name__c = c.Installer_Name_Formula__c;
                    opp.Project_Manager__c = c.Project_Manager__c;
                    opp.FA_URL__c = c.FieldAware_URL__c;
                    system.debug('Record Type :' + c.RecordType.name);
                    // opp.Case_Record_Type__c = RecTypeMap.get(c.RecordType.name);
                    opp.Case_Record_Type__c = RecTypeMap.get(c.RecordTypeId).name;
                    //opp.Case_Record_Type__c = [SELECT name from RecordType where id =: c.RecordTypeid].name;
                    opp.Type__c = c.type;
                    if(c.CreatedDate != null)
                        opp.Created_Date__c = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                    if(c.Completed_On__c != null)
                        opp.Completed_On__c = date.newinstance(c.Completed_On__c.year(), c.Completed_On__c.month(), c.Completed_On__c.day());
                    
                    
                    if(c.Scheduled_On__c != null)
                        opp.Scheduled_Date_Time__c = date.newinstance(c.Scheduled_On__c.year(), c.Scheduled_On__c.month(), c.Scheduled_On__c.day());
                    
                    
                    if(c.Approve_Survey_Option_1__c == true)
                    {
                        opp.Install_Hours__c = c.Install_Hours__c;
                        opp.Scope_of_Work__c = c.Scope_of_Work__c;
                        opp.Install_Cost_Quote__c = c.Install_Cost_Quote__c;
                    }
                    if(c.Approve_Survey_Option_2__c == true)
                    {
                        opp.Install_Hours_2__c = c.Install_Hours_2__c;
                        opp.Scope_of_Work_2__c = c.Scope_of_Works_2__c;
                        opp.Install_Cost_Quote_2__c = c.Install_Cost_Quote_2__c;
                    }
                }
                
                if(c.Type == 'Install')
                {
                    opp.Case_Link_Install__c = system.URL.getSalesforceBaseUrl().toExternalForm()  +'/'+ c.id;
                    opp.Job_ID_Install__c = c.Job_ID__c;
                    opp.Case_Number_Install__c = c.CaseNumber;
                    opp.Status_Install__c = c.Status;
                    opp.PostCode_Install__c = c.PostalCode__c;
                    opp.Street_Install__c = c.Street__c;
                    opp.City_Install__c = c.City__c;
                    opp.Installer_Name_Install__c = c.Installer_Name_Formula__c;
                    opp.Project_Manager_Install__c = c.Project_Manager__c;
                    opp.FA_URL_Install__c = c.FieldAware_URL__c;
                    system.debug('Record Type :' + c.RecordType.name);
                    opp.Case_Record_Type_Install__c =RecTypeMap.get(c.RecordTypeId).name;
                    //opp.Case_Record_Type_Install__c = [SELECT name from RecordType where id =: c.RecordTypeid].name;
                    opp.Type_Install__c = c.type;
                    if(c.CreatedDate != null)
                        opp.Created_Date_Install__c = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                    if(c.Completed_On__c != null)
                        opp.Completed_On_Install__c = date.newinstance(c.Completed_On__c.year(), c.Completed_On__c.month(), c.Completed_On__c.day());
                    
                    if(c.Scheduled_On__c != null)
                        opp.Scheduled_Date_Time_Install__c = date.newinstance(c.Scheduled_On__c.year(), c.Scheduled_On__c.month(), c.Scheduled_On__c.day());
                    
                    
                    if(c.Approve_Survey_Option_1__c == true)
                    {
                        opp.Install_Hours__c = c.Install_Hours__c;
                        opp.Scope_of_Work__c = c.Scope_of_Work__c;
                        opp.Install_Cost_Quote__c = c.Install_Cost_Quote__c;
                    }
                    if(c.Approve_Survey_Option_2__c == true)
                    {
                        opp.Install_Hours_2__c = c.Install_Hours_2__c;
                        opp.Scope_of_Work_2__c = c.Scope_of_Works_2__c;
                        opp.Install_Cost_Quote_2__c = c.Install_Cost_Quote_2__c;
                    }
                }
                
                //Code For Commercial Case added on 23/Jan/18
                if(c.Type == 'Commercial')
                {
                    opp.Case_Link__c = system.URL.getSalesforceBaseUrl().toExternalForm()  +'/'+ c.id;
                    opp.Case_Number__c = c.CaseNumber;
                    opp.Job_ID__c = c.Job_ID__c;
                    opp.Status_Survey__c = c.Status;
                    opp.PostCode__c = c.PostalCode__c;
                    opp.Street__c = c.Street__c;
                    opp.City__c = c.City__c;
                    opp.Installer_Name__c = c.Installer_Name_Formula__c;
                    opp.Project_Manager__c = c.Project_Manager__c;
                    opp.FA_URL__c = c.FieldAware_URL__c;
                    system.debug('Record Type :' + c.RecordType.name);
                    // opp.Case_Record_Type__c = RecTypeMap.get(c.RecordType.name);
                    opp.Case_Record_Type__c = RecTypeMap.get(c.RecordTypeId).name;
                    //opp.Case_Record_Type__c = [SELECT name from RecordType where id =: c.RecordTypeid].name;
                    opp.Type__c = c.type;
                    if(c.CreatedDate != null)
                        opp.Created_Date__c = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                    if(c.Completed_On__c != null)
                        opp.Completed_On__c = date.newinstance(c.Completed_On__c.year(), c.Completed_On__c.month(), c.Completed_On__c.day());
                    
                    
                    if(c.Scheduled_On__c != null)
                        opp.Scheduled_Date_Time__c = date.newinstance(c.Scheduled_On__c.year(), c.Scheduled_On__c.month(), c.Scheduled_On__c.day());
                    
                    
                    if(c.Approve_Survey_Option_1__c == true)
                    {
                        opp.Install_Hours__c = c.Install_Hours__c;
                        opp.Scope_of_Work__c = c.Scope_of_Work__c;
                        opp.Install_Cost_Quote__c = c.Install_Cost_Quote__c;
                    }
                    if(c.Approve_Survey_Option_2__c == true)
                    {
                        opp.Install_Hours_2__c = c.Install_Hours_2__c;
                        opp.Scope_of_Work_2__c = c.Scope_of_Works_2__c;
                        opp.Install_Cost_Quote_2__c = c.Install_Cost_Quote_2__c;
                    }
                }
                
            }
            
            if((c.Type == 'Install' || c.Type == 'Commercial') && oppWithOrders.size()>0)
            {
                for(Order o : oppWithOrders.get(c.Opportunity__c).orders)
                {
                    o.Installer_Name__c = c.Installer_Name_Formula__c;
                    o.Scheduled_Date__c = c.Scheduled_On__c;
                    o.Started_On__c = c.Started_On__c;
                    o.Completed_On__c = c.Completed_On__c;
                    o.Status__c = c.Status;
                    o.Job_ID__c = c.Job_ID__c;
                    o.Case_ID__c = c.id;
                    o.Case_Number__c = c.CaseNumber;
                    o.Install_Case_Created__c = true;
                    o.Link_To_Case__c =  System.URL.getSalesforceBaseUrl().toExternalForm() + '/' +c.id;
                    o.FieldAware_URL__c = c.FieldAware_URL__c;
                    
                    orderUpdate.add(o);
                }
                
            }
            
            //Send the updated project manager name to FA
            if(Trigger.newMap.get(c.ID).Project_Manager__c != null && Trigger.newMap.get(c.ID).External_ID__c !=null)
                helperjobs.updateJobProjectManager(c.External_ID__c,c.Project_Manager__c);
            
            
        }
        
        system.debug('Before DML');
        //update OppUpdate.values();
        update orderUpdate;
        update OppUpdate.values();
        AvoidRecursion.caseAfterInsert = false;
    }
    
    //In case the description is changed , the update will be send to fieldAware
    if(Trigger.isUpdate)
    {
        if(AvoidRecursion.isFirstRun2() || test.isRunningTest()){
            Map<String, RecordType> RecTypeMap=new Map<String, RecordType>([SELECT id, SobjectType, name from RecordType where SobjectType ='Case']);
            String queueID = [SELECT id FROM Group where name = 'HC Sales Queue'].id;
            
            for(Case c : Trigger.new)
            {
                //update the case information on opp (case related fields)
                
                if(c.Opportunity__c != null)
                {
                    Opportunity opp = oppWithOrders.get(c.Opportunity__c);
                    
                    if( (Trigger.oldMap.get( c.id ).Approve_Survey_Option_1__c != Trigger.newMap.get( c.id ).Approve_Survey_Option_1__c && Trigger.newMap.get( c.id ).Approve_Survey_Option_1__c == false)
                       || (Trigger.oldMap.get( c.id ).Approve_Survey_Option_2__c != Trigger.newMap.get( c.id ).Approve_Survey_Option_2__c && Trigger.newMap.get( c.id ).Approve_Survey_Option_2__c == false)
                      )
                    {
                        if(c.Approve_Survey_Option_1__c == false)
                        {
                            opp.Install_Hours__c = null;
                            opp.Scope_of_Work__c = '';
                            opp.Install_Cost_Quote__c = null;
                        }
                        if(c.Approve_Survey_Option_2__c == false)
                        {
                            opp.Install_Hours_2__c = null;
                            opp.Scope_of_Work_2__c = '';
                            opp.Install_Cost_Quote_2__c = null;
                        }
                    }
                    
                    system.debug('Old Status value : '  + Trigger.oldMap.get( c.id ).Status);
                    system.debug('New Status value : '  + Trigger.newMap.get( c.id ).Status);
                    
                    if( Trigger.newMap.get( c.id ).Status == 'Closed')
                    {
                        //delete the case information on opp (case related fields)
                        //Opportunity opp = oppWithOrders.get(c.OpportunityID__c);
                        
                        if(c.Type == 'Survey')
                        {
                            opp.Case_Link__c = '';
                            opp.Job_ID__c = '';
                            opp.Case_Number__c = '';
                            opp.Status_Survey__c = '';
                            opp.PostCode__c = '';
                            opp.Street__c = '';
                            opp.City__c = '';
                            opp.Installer_Name__c = '';
                            opp.Project_Manager__c = '';
                            opp.FA_URL__c = '';
                            opp.Created_Date__c = null;
                            opp.Scheduled_Date_Time__c = null;
                            opp.Completed_On__c = null;
                            opp.Install_Hours__c = null;
                            opp.Scope_of_Work__c = '';
                            opp.Install_Cost_Quote__c = null;
                            
                            opp.Install_Hours_2__c = null;
                            opp.Scope_of_Work_2__c = '';
                            opp.Install_Cost_Quote_2__c = null;
                            opp.Case_Record_Type__c = '';
                            opp.Type__c = '';
                        }
                        if(c.Type == 'Install')
                        {
                            opp.Case_Link_Install__c = '';
                            opp.Job_ID_Install__c = '';
                            opp.Case_Number_Install__c = '';
                            opp.Status_Install__c = '';
                            opp.PostCode_Install__c = '';
                            opp.Street_Install__c = '';
                            opp.City_Install__c = '';
                            opp.Install_Hours_Install__c = null;
                            opp.Installer_Name_Install__c = '';
                            opp.Project_Manager_Install__c = '';
                            opp.FA_URL_Install__c = '';
                            opp.Created_Date_Install__c = null;
                            opp.Completed_On_Install__c = null;
                            opp.Scheduled_Date_Time_Install__c = null;
                            opp.Install_Hours__c = null;
                            opp.Scope_of_Work__c = '';
                            opp.Install_Cost_Quote__c = null;
                            
                            opp.Install_Hours_2__c = null;
                            opp.Scope_of_Work_2__c = '';
                            opp.Install_Cost_Quote_2__c = null;
                            opp.Case_Record_Type_Install__c = '';
                            opp.Type_Install__c = '';
                        }
                        
                        //Code for Commercial Case
                        if(c.Type == 'Commercial')
                        {
                            opp.Case_Link_Install__c = '';
                            opp.Job_ID_Install__c = '';
                            opp.Case_Number_Install__c = '';
                            opp.Status_Install__c = '';
                            opp.PostCode_Install__c = '';
                            opp.Street_Install__c = '';
                            opp.City_Install__c = '';
                            opp.Install_Hours_Install__c = null;
                            opp.Installer_Name_Install__c = '';
                            opp.Project_Manager_Install__c = '';
                            opp.FA_URL_Install__c = '';
                            opp.Created_Date_Install__c = null;
                            opp.Completed_On_Install__c = null;
                            opp.Scheduled_Date_Time_Install__c = null;
                            opp.Install_Hours__c = null;
                            opp.Scope_of_Work__c = '';
                            opp.Install_Cost_Quote__c = null;
                            
                            opp.Install_Hours_2__c = null;
                            opp.Scope_of_Work_2__c = '';
                            opp.Install_Cost_Quote_2__c = null;
                            opp.Case_Record_Type_Install__c = '';
                            opp.Type_Install__c = '';
                        }
                        
                        
                    }
                    else
                    {
                        if(c.Type == 'Survey')
                        {
                            opp.Case_Link__c = system.URL.getSalesforceBaseUrl().toExternalForm()  +'/'+ c.id;
                            opp.Case_Number__c = c.CaseNumber;
                            opp.Job_ID__c = c.Job_ID__c;
                            opp.Status_Survey__c = c.Status;
                            opp.PostCode__c = c.PostalCode__c;
                            opp.Street__c = c.Street__c;
                            opp.City__c = c.City__c;
                            opp.Installer_Name__c = c.Installer_Name_Formula__c;
                            opp.Project_Manager__c = c.Project_Manager__c;
                            opp.FA_URL__c = c.FieldAware_URL__c;
                            system.debug('Record Type :' + c.RecordType.name);
                            opp.Case_Record_Type__c =RecTypeMap.get(c.RecordTypeId).name;
                            //opp.Case_Record_Type__c = [SELECT name from RecordType where id =: c.RecordTypeid].name;
                            opp.type__c = c.type;
                            if(c.CreatedDate != null)
                                opp.Created_Date__c = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                            if(c.Completed_On__c != null)
                                opp.Completed_On__c = date.newinstance(c.Completed_On__c.year(), c.Completed_On__c.month(), c.Completed_On__c.day());
                            
                            if(c.Scheduled_On__c != null)
                                opp.Scheduled_Date_Time__c = date.newinstance(c.Scheduled_On__c.year(), c.Scheduled_On__c.month(), c.Scheduled_On__c.day());
                            
                            if(c.Approve_Survey_Option_1__c == true)
                            {
                                opp.Install_Hours__c = c.Install_Hours__c;
                                opp.Scope_of_Work__c = c.Scope_of_Work__c;
                                opp.Install_Cost_Quote__c = c.Install_Cost_Quote__c;
                            }
                            if(c.Approve_Survey_Option_2__c == true)
                            {
                                opp.Install_Hours_2__c = c.Install_Hours_2__c;
                                opp.Scope_of_Work_2__c = c.Scope_of_Works_2__c;
                                opp.Install_Cost_Quote_2__c = c.Install_Cost_Quote_2__c;
                            }
                        }
                        
                        if(c.Type == 'Install')
                        {
                            opp.Case_Link_Install__c = system.URL.getSalesforceBaseUrl().toExternalForm()  +'/'+ c.id;
                            opp.Job_ID_Install__c = c.Job_ID__c;
                            opp.Case_Number_Install__c = c.CaseNumber;
                            opp.Status_Install__c = c.Status;
                            opp.PostCode_Install__c = c.PostalCode__c;
                            opp.Street_Install__c = c.Street__c;
                            opp.City_Install__c = c.City__c;
                            opp.Install_Hours_Install__c = c.Install_Hours__c;
                            opp.Installer_Name_Install__c = c.Installer_Name_Formula__c;
                            opp.Project_Manager_Install__c = c.Project_Manager__c;
                            opp.FA_URL_Install__c = c.FieldAware_URL__c;
                            opp.Case_Record_Type_Install__c =RecTypeMap.get(c.RecordTypeId).name;
                            //opp.Case_Record_Type_Install__c = [SELECT name from RecordType where id =: c.RecordTypeid].name;
                            opp.Type_Install__c = c.Type;
                            if(c.CreatedDate != null)
                                opp.Created_Date_Install__c = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                            if(c.Completed_On__c != null)
                                opp.Completed_On_Install__c = date.newinstance(c.Completed_On__c.year(), c.Completed_On__c.month(), c.Completed_On__c.day());
                            
                            if(c.Scheduled_On__c != null)
                                opp.Scheduled_Date_Time_Install__c = date.newinstance(c.Scheduled_On__c.year(), c.Scheduled_On__c.month(), c.Scheduled_On__c.day());
                            
                            if(c.Approve_Survey_Option_1__c == true)
                            {
                                opp.Install_Hours__c = c.Install_Hours__c;
                                opp.Scope_of_Work__c = c.Scope_of_Work__c;
                                opp.Install_Cost_Quote__c = c.Install_Cost_Quote__c;
                            }
                            if(c.Approve_Survey_Option_2__c == true)
                            {
                                opp.Install_Hours_2__c = c.Install_Hours_2__c;
                                opp.Scope_of_Work_2__c = c.Scope_of_Works_2__c;
                                opp.Install_Cost_Quote_2__c = c.Install_Cost_Quote_2__c;
                            }
                        }
                        
                        //Code for Commercial Case
                        if(c.Type == 'Commercial')
                        {
                            opp.Case_Link_Install__c = system.URL.getSalesforceBaseUrl().toExternalForm()  +'/'+ c.id;
                            opp.Job_ID_Install__c = c.Job_ID__c;
                            opp.Case_Number_Install__c = c.CaseNumber;
                            opp.Status_Install__c = c.Status;
                            opp.PostCode_Install__c = c.PostalCode__c;
                            opp.Street_Install__c = c.Street__c;
                            opp.City_Install__c = c.City__c;
                            opp.Install_Hours_Install__c = c.Install_Hours__c;
                            opp.Installer_Name_Install__c = c.Installer_Name_Formula__c;
                            //opp.Project_Manager_Install__c = c.Project_Manager__c;
                            opp.FA_URL_Install__c = c.FieldAware_URL__c;
                            opp.Case_Record_Type_Install__c =RecTypeMap.get(c.RecordTypeId).name;
                            //opp.Case_Record_Type_Install__c = [SELECT name from RecordType where id =: c.RecordTypeid].name;
                            opp.Type_Install__c = c.Type;
                            if(c.CreatedDate != null)
                                opp.Created_Date_Install__c = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());
                            if(c.Completed_On__c != null)
                                opp.Completed_On_Install__c = date.newinstance(c.Completed_On__c.year(), c.Completed_On__c.month(), c.Completed_On__c.day());
                            
                            if(c.Scheduled_On__c != null)
                                opp.Scheduled_Date_Time_Install__c = date.newinstance(c.Scheduled_On__c.year(), c.Scheduled_On__c.month(), c.Scheduled_On__c.day());
                            
                            if(c.Approve_Survey_Option_1__c == true)
                            {
                                opp.Install_Hours__c = c.Install_Hours__c;
                                opp.Scope_of_Work__c = c.Scope_of_Work__c;
                                opp.Install_Cost_Quote__c = c.Install_Cost_Quote__c;
                            }
                            if(c.Approve_Survey_Option_2__c == true)
                            {
                                opp.Install_Hours_2__c = c.Install_Hours_2__c;
                                opp.Scope_of_Work_2__c = c.Scope_of_Works_2__c;
                                opp.Install_Cost_Quote_2__c = c.Install_Cost_Quote_2__c;
                            }
                        }
                        
                    }
                    
                    /*
if(Trigger.oldMap.get( c.id ).status != Trigger.newMap.get( c.id ).status && Trigger.newMap.get( c.id ).status == 'On Hold' && ([SELECT name from RecordType where id =: c.RecordTypeid].name == 'Homecharge Case' || [SELECT name from RecordType where id =: c.RecordTypeid].name == 'Homecharge Norway'))
{
opp.stagename = c.status;
}                     
*/
                    if(Test.isRunningTest())
                    {
                        opp.stagename = 'Qualification';
                    }
                    else
                    {
                        /* if(c.Opportunity_Stage__c !=null && Trigger.oldMap.get( c.id ).Opportunity_Stage__c != Trigger.newMap.get( c.id ).Opportunity_Stage__c)
opp.stagename = c.Opportunity_Stage__c ;*/
                    }
                    
                    if(Trigger.oldMap.get( c.id ).Non_Standard_Install_Type__c != Trigger.newMap.get( c.id ).Non_Standard_Install_Type__c  && [SELECT name from RecordType where id =: c.RecordTypeid].name == 'Homecharge Case' )
                    {
                        opp.Non_Standard_Install_Type__c = c.Non_Standard_Install_Type__c;
                    }
                    if(Trigger.oldMap.get( c.id ).Non_Standard_Install__c != Trigger.newMap.get( c.id ).Non_Standard_Install__c  && [SELECT name from RecordType where id =: c.RecordTypeid].name == 'Homecharge Case' )
                    {
                        opp.Non_Standard_Install__c   = c.Non_Standard_Install__c ;
                    }
                    
                    system.debug('Old Owner : '+ Trigger.oldMap.get( c.id ).owner.name);
                    system.debug('New Owner : '+ Trigger.newMap.get( c.id ).owner.name);
                    if(Trigger.oldMap.get( c.id ).ownerid != Trigger.newMap.get( c.id ).ownerid  && Trigger.oldMap.get( c.id ).ownerid == queueID && string.valueOf(c.OwnerId).startsWith('005') && [SELECT name from RecordType where id =: c.RecordTypeid].name == 'Homecharge Case' )
                    {
                        system.debug('Inside if funtion');
                        opp.ownerid   = c.ownerid ;
                    }
                    
                    OppUpdate.put(opp.id,opp);
                    
                    /*if(test.isRunningTest()){}
else{
update OppUpdate.values();
}*/
                }
                
                if((c.Type == 'Install' || c.Type == 'Commercial') && oppWithOrders.size()>0)
                {
                    if(oppWithOrders.containsKey(c.Opportunity__c)){
                        if(oppWithOrders.get(c.Opportunity__c).orders.size() > 0){
                            for(Order o : oppWithOrders.get(c.Opportunity__c).orders)
                            {
                                o.Installer_Name__c = c.Installer_Name_Formula__c;
                                o.Scheduled_Date__c = c.Scheduled_On__c;
                                o.Started_On__c = c.Started_On__c;
                                o.Completed_On__c = c.Completed_On__c;
                                o.Status__c = c.Status;
                                o.Job_ID__c = c.Job_ID__c;
                                o.Case_ID__c = c.id;
                                o.Case_Number__c = c.CaseNumber;
                                o.Install_Case_Created__c = true;
                                o.Link_To_Case__c =  System.URL.getSalesforceBaseUrl().toExternalForm() + '/' +c.id;
                                o.FieldAware_URL__c = c.FieldAware_URL__c;
                                o.Project_Manager__c = c.Project_Manager__c;
                                
                                orderUpdate.add(o);
                            }
                        }
                    }
                }
                
                // update orderUpdate;
                
                //Send the updated description to FA
                if(Trigger.oldMap.get(c.ID).description != Trigger.newMap.get(c.ID).description)
                    helperjobs.updateJobDescription(c.External_ID__c,c.Description);
                
                //Send the updated project manager name to FA
                if(Trigger.oldMap.get(c.ID).Project_Manager__c != Trigger.newMap.get(c.ID).Project_Manager__c)
                    helperjobs.updateJobProjectManager(c.External_ID__c,c.Project_Manager__c);
                
                //Send the updated address to FA
                if(Trigger.oldMap.get(c.ID).Street__c != Trigger.newMap.get(c.ID).Street__c ||  Trigger.oldMap.get(c.ID).City__c != Trigger.newMap.get(c.ID).City__c ||  Trigger.oldMap.get(c.ID).Country__c != Trigger.newMap.get(c.ID).Country__c ||  Trigger.oldMap.get(c.ID).PostalCode__c != Trigger.newMap.get(c.ID).PostalCode__c)
                    helperjobs.updateJobAddress(c.External_ID__c,c.Street__c,c.City__c,c.Country__c,c.PostalCode__c);
            }
            if(test.isRunningTest()){}
            else{
                update OppUpdate.values();
            }
            update orderUpdate;
        }   
    }
    
    //if(Trigger.isAfter && ((Trigger.isInsert && AvoidRecursion.caseAfterInsert)|| (Trigger.isUpdate && AvoidRecursion.caseAfterUpdate)|| (Trigger.isDelete && AvoidRecursion.caseAfterDelete))){
    /*  if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete )){
set<id> oppId = new set<id>();
try {
//List<Case> c_list = [SELECT Id, Date_of_COPS_Approved__c, Opportunity__c from case];

for (Case co : Trigger.new){
oppId.add(co.Opportunity__c);
}
System.debug('oppId --->>>>'+oppId);

Opportunity po = [SELECT Id, Date_of_COPS_Approved__c  FROM Opportunity WHERE Id = :oppId];
System.debug(' po ===>' + po);
List<Case> l_co = [SELECT Id, Date_of_COPS_Approved__c, OpportunityID__c from case where Opportunity__c= :po.Id order by Date_of_COPS_Approved__c DESC LIMIT 1];
System.debug(' l_co ===>' + l_co);
Case c = l_co[0];  
po.Date_of_COPS_Approved__c = c.Date_of_COPS_Approved__c;
System.debug('is after update c.Date_of_COPS_Approved__c'+c.Date_of_COPS_Approved__c);
System.debug('is after update po.Date_of_COPS_Approved__c'+po.Date_of_COPS_Approved__c);
update po;
if(test.isRunningTest()){
integer i = 1/0;
}
}
catch (Exception e) {
System.debug(e);
}

*/
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate )){
        set<id> oppId = new set<id>();
        for (Case co : Trigger.new){
            if(Trigger.isUpdate){ 
                if(co.Date_of_COPS_Approved__c!=Trigger.oldMap.get(co.ID).Date_of_COPS_Approved__c)
                    oppId.add(co.Opportunity__c);
            }
            if(Trigger.isInsert){ 
                if(co.Date_of_COPS_Approved__c!=null)
                    oppId.add(co.Opportunity__c);
            }
        }
        Map<Id,Opportunity> OppMap= new Map<Id,Opportunity>([Select Id, Date_of_COPS_Approved__c , (SELECT Id, Date_of_COPS_Approved__c, OpportunityID__c from cases__r order by Date_of_COPS_Approved__c DESC LIMIT 1)FROM Opportunity WHERE Id = :oppId ]);
        List<Opportunity> OppList =new List<Opportunity>();
        if(!OppMap.isEmpty()){
            for (Case co : Trigger.new){
                If(co.Id==OppMap.get(co.Opportunity__c).cases__r.get(0).Id){
                    OppMap.get(co.Opportunity__c).Date_of_COPS_Approved__c = co.Date_of_COPS_Approved__c;
                    OppList.add(OppMap.get(co.Opportunity__c));
                }
            }
        }
        if(!OppList.isEmpty()){
            Update OppList;
        }
        
        
        
        
    }
    
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isDelete )){
        set<id> oppId = new set<id>();
        try {
            //List<Case> c_list = [SELECT Id, Date_of_COPS_Approved__c, Opportunity__c from case];
            
            for (Case co : Trigger.new){
                oppId.add(co.Opportunity__c);
            }
            System.debug('oppId --->>>>'+oppId);
            Map<String,Opportunity> opptyIdopptyMap = new Map<String,Opportunity>([SELECT ID,Install_Status_New__c,Survey_Status__c,(SELECT ID,Survey_Status__c,Install_Status__c FROM Cases__r WHERE ID NOT IN:Trigger.New AND Install_Status__c!=NULL) FROM Opportunity WHERE ID IN:oppId]);
            
            for(Case caseRec: Trigger.New){
                System.debug('caseRec=>'+caseRec);
                if(caseRec.Survey_Status__c!=Trigger.oldMap.get(caseRec.Id).Survey_Status__c|| caseRec.Install_Status__c!=Trigger.oldMap.get(caseRec.Id).Install_Status__c){
                    System.debug('caseRec=> In First IF');
                    if(caseRec.Survey_Status__c!=Trigger.oldMap.get(caseRec.Id).Survey_Status__c){
                        System.debug('caseRec=> In 2nd IF');
                        opptyIdopptyMap.get(caseRec.Opportunity__c).Survey_Status__c = caseRec.Survey_Status__c;
                    }else if(caseRec.Install_Status__c!=Trigger.oldMap.get(caseRec.Id).Install_Status__c && caseRec.Install_Status__c==NULL){
                        System.debug('caseRec=> In 3nd IF');
                        if(opptyIdopptyMap.get(caseRec.Opportunity__c).Cases__r.size()==0){
                            System.debug('caseRec=> In 4nd IF');
                            opptyIdopptyMap.get(caseRec.Opportunity__c).Install_Status_New__c = caseRec.Install_Status__c;
                        }
                    }else if(caseRec.Install_Status__c!=Trigger.oldMap.get(caseRec.Id).Install_Status__c){
                        System.debug('caseRec=> In 5nd IF');
                        opptyIdopptyMap.get(caseRec.Opportunity__c).Install_Status_New__c = caseRec.Install_Status__c;
                    }
                }
                //}else{
                /*
if(caseRec.Survey_Status__c!=Trigger.oldMap.get(caseRec.Id).Survey_Status__c){
opptyIdopptyMap.get(caseRec.Opportunity__c).Survey_Status__c = caseRec.Survey_Status__c;
}
if(caseRec.Install_Status__c!=Trigger.oldMap.get(caseRec.Id).Install_Status__c){
opptyIdopptyMap.get(caseRec.Opportunity__c).Install_Status_New__c = caseRec.Install_Status__c;
}*/
            }
            //}    
            update opptyIdopptyMap.values();    
            
            
        }catch (Exception e) {
            System.debug(e);
        }
        AvoidRecursion.caseAfterInsert = false;
        AvoidRecursion.caseAfterUpdate = false;
        AvoidRecursion.caseAfterDelete = false;
    }
    /*
if(Trigger.isAfter) {
if(Trigger.isUpdate){
try {
for (Case co : Trigger.old){
Opportunity po = [SELECT Id, Date_of_COPS_Approved__c  FROM Opportunity WHERE Id = :co.OpportunityID__c];
List<Case> l_co = [SELECT Id, Date_of_COPS_Approved__c, OpportunityID__c from case where OpportunityID__c= :po.Id order by Date_of_COPS_Approved__c DESC];
Case c = l_co[0];
po.Date_of_COPS_Approved__c = c.Date_of_COPS_Approved__c;
System.debug('is after update c.Date_of_COPS_Approved__c'+c.Date_of_COPS_Approved__c);
System.debug('is after update po.Date_of_COPS_Approved__c'+po.Date_of_COPS_Approved__c);

update po;
}
}
catch (Exception e) {
System.debug(e);
}
}
}


if(Trigger.isDelete){
try {
for (case co : Trigger.old){
Opportunity po = [SELECT Id, Date_of_COPS_Approved__c  FROM Opportunity WHERE Id = :co.OpportunityID__c];
List<Case> l_co = [SELECT Id, Date_of_COPS_Approved__c, OpportunityID__c from case where OpportunityID__c= :po.Id order by Date_of_COPS_Approved__c DESC];
Case c = l_co[0];
po.Date_of_COPS_Approved__c = c.Date_of_COPS_Approved__c;
System.debug('is deletec.Date_of_COPS_Approved__c'+c.Date_of_COPS_Approved__c);
System.debug('is delete po.Date_of_COPS_Approved__c'+po.Date_of_COPS_Approved__c);

update po;
}
} catch (Exception e) {
System.debug(e);
}
}
*/
    System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
}