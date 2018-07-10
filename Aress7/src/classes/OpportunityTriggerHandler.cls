public class OpportunityTriggerHandler { 
    public static boolean run = true;
    
    @InvocableMethod
    public static void afterinsertOpp(List<Id> oppIds){
        List<Opportunity> oppNew = [select id,name,recordtypeid,amount,accountid,closedate,(select id from Transactions_20170807101244828__r) from Opportunity where id IN : oppIds];
        list<bt_stripe__Transaction__c> trans = new list<bt_stripe__Transaction__c>();
        set<String> accIds = new set<String>();
        for(Opportunity o : oppNew){
            accIds.add(o.accountid);
        }
        system.debug('accids'+accIds);
        Map<String,Account> accMap = new Map<String,Account>([select recordtype.name,id from Account where id in : accids]);
        Map<String,String> oppConMap = new Map<String,String>();
        for(OpportunityContactRole orl : [select id,contactid,opportunityid from OpportunityContactRole where isprimary = True and opportunityid IN : oppNew]){
            oppConMap.put(orl.opportunityid,orl.contactid);
        } 
        for(Opportunity o : oppNew){
            if(o.RecordTypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId()){
                system.debug('inside insert method');
                bt_stripe__Transaction__c tran= new bt_stripe__Transaction__c();
                tran.bt_stripe__Amount__c = o.amount;
                if(accMap.get(o.accountid).recordtype.name == 'Person Account'){
                    tran.bt_stripe__Related_Account__c = o.accountid;
                } else {
                    tran.bt_stripe__Related_Contact__c = oppConMap.get(o.id);
                    tran.bt_stripe__Related_Account__c = o.accountid;
                }
                tran.Opportunity__c = o.id;
                tran.bt_stripe__Description__c = 'Online Payment';
                tran.bt_stripe__Due_Date__c = o.CloseDate;
                tran.bt_stripe__Currency_ISO__c = 'GBP';
                if(o.Transactions_20170807101244828__r.size()>0){
                    tran.id = o.Transactions_20170807101244828__r[0].id;
                }
                trans.add(tran);
            }
        }
        
        if(trans.size() > 0){
            upsert trans;
            List<bt_stripe__Transaction__c> trlst = [select id,opportunity__c,bt_stripe__PayLink__c from bt_stripe__Transaction__c where id in : trans];
            for(bt_stripe__Transaction__c t : trlst){
                Opportunity op = new Opportunity(id=t.opportunity__c,paylink__c = t.bt_stripe__PayLink__c);
                update op;
            }
        }
    }
    public static Case createInstallCase(String AccountID,String OppID,String OppName,List<Case> lstSurveyCases,List<Quote> lstQuote){
        Case cs = new Case();
        if(lstSurveyCases != null)
        {
            if(lstSurveyCases.size()>0)
            {
                cs.Street__c = lstSurveyCases[0].street__c;
                cs.City__c = lstSurveyCases[0].city__c;
                cs.PostalCode__c = lstSurveyCases[0].postalcode__c;
                cs.Country_Picklist__c = lstSurveyCases[0].Country_picklist__c;
                cs.Install_Cost_Quote_2__c  = lstSurveyCases[0].Install_Cost_Quote_2__c;
                cs.Install_Cost_Quote__c = lstSurveyCases[0].Install_Cost_Quote__c;
                cs.Install_Hours_2__c = lstSurveyCases[0].Install_Hours_2__c;
                cs.Install_Hours__c = lstSurveyCases[0].Install_Hours__c;
                cs.Scope_of_Work__c = lstSurveyCases[0].Scope_of_Work__c;
                cs.Scope_of_Works_2__c = lstSurveyCases[0].Scope_of_Works_2__c;
            } 
            else
            {
                if(lstQuote.size()>0)
                {
                    cs.Street__c = lstQuote[0].shippingstreet;
                    cs.City__c = lstQuote[0].shippingcity;
                    cs.PostalCode__c = lstQuote[0].shippingpostalcode;
                    cs.Country_Picklist__c = lstQuote[0].shippingCountry;
                }
            }
        }        
        else
        {
            if(lstQuote.size()>0)
            {
                cs.Street__c = lstQuote[0].shippingstreet;
                cs.City__c = lstQuote[0].shippingcity;
                cs.PostalCode__c = lstQuote[0].shippingpostalcode;
                cs.Country_Picklist__c = lstQuote[0].shippingCountry;
            }
        }
        
        cs.subject = 'Install Job - ' + OppName;
        cs.AccountId = AccountID;
        cs.Call_Category__c = 'Homecharge';
        cs.Opportunity__c = OppID;
        cs.Project_Manager__c = 'Martin';
        cs.Type = 'Install';
        cs.RecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('Install Case').getRecordTypeId();
        if(!test.isRunningTest()){
            if(oppMap.get(OppID).opportunitycontactroles.size()>0){
                cs.contactid = oppMap.get(OppID).opportunitycontactroles[0].contactid;
            }
        }
        return cs;
    }
    
    public static Order createOrder(Opportunity Opp,String RecordTypeID,String Status,List<Case> lstSurveyCases,List<Quote> lstQuote, list<case> Caselist){
        Order ord = new Order();

        //In case of online and Home Charge opp, the address will be copied from account
        if(opp.recordtype.name == 'Online Payment' || opp.recordtype.name == 'Home Charge')
        {
            ord.BillingStreet = opp.account.billingstreet;
            ord.BillingCity = opp.account.billingcity;
            ord.BillingPostalCode = opp.account.billingpostalcode;
            ord.BillingCountry = opp.account.billingCountry;
            
            ord.shippingstreet = opp.account.shippingstreet;
            ord.ShippingCity = opp.account.shippingcity;
            ord.ShippingPostalCode = opp.account.shippingpostalcode;
            ord.ShippingCountry = opp.account.shippingcountry;
            
        }
        else
        {
            if(lstSurveyCases != null)
            {
                if(lstSurveyCases.size()>0)
                {
                    ord.shippingstreet = lstSurveyCases[0].street__c;
                    ord.ShippingCity = lstSurveyCases[0].city__c;
                    ord.ShippingPostalCode = lstSurveyCases[0].postalcode__c;
                    ord.ShippingCountry = lstSurveyCases[0].Country_picklist__c;
                } 
                else
                {
                    if(lstQuote.size()>0)
                    {
                        ord.shippingstreet = lstQuote[0].shippingstreet;
                        ord.ShippingCity = lstQuote[0].shippingcity;
                        ord.ShippingPostalCode = lstQuote[0].shippingpostalcode;
                        ord.ShippingCountry = lstQuote[0].shippingCountry;
                    }
                }
            }        
            else
            {
                if(lstQuote.size()>0)
                {
                    ord.shippingStreet = lstQuote[0].shippingstreet;
                    ord.shippingCity = lstQuote[0].shippingcity;
                    ord.shippingPostalCode = lstQuote[0].shippingpostalcode;
                    ord.shippingCountry = lstQuote[0].shippingCountry;
                }
            }
            
            //Billing will always be from quote billing address
            if(lstQuote.size()>0)
            {
                ord.BillingStreet = lstQuote[0].billingstreet;
                ord.BillingCity = lstQuote[0].billingcity;
                ord.BillingPostalCode = lstQuote[0].billingpostalcode;
                ord.BillingCountry = lstQuote[0].billingCountry;  
            }
        }
        
        
        
        ord.AccountId = Opp.AccountId;
        ord.OpportunityId = opp.id;
        ord.Pricebook2Id = opp.Pricebook2Id;
        ord.RecordTypeId = RecordTypeID;
        ord.EffectiveDate = date.today();
        ord.Status = Status;
         if(!caselist.isEmpty()){	
       
             system.debug('ddfdfdfndf'+lstSurveyCases);   
             system.debug('caselist[0].Id'+caselist);	
             ord.Case__c = caselist[0].Id;			
        }
        
        return ord;
    }
    public static Map<id,Opportunity> oppMap;
    public static void handleAfterUpdate(List<String> oppListNew, List<case> caselist){ 
        /*
        //When 'Home charge' Opportunity stage becomes "Qualified" then change the owner of all Home charge cases.
        
        //List is fetchig the Queue.
        List<Group> qList = [select Id from Group where  Type = 'Queue' AND NAME = 'HC Docs Request Queue' LIMIT 1]; 
        //Check the condition if List is not empty
        if(!qList.isEmpty()){
            //List is fetching All 'Home charge 'opportunities and related 'Home Charge Cases'
            List<Opportunity> opportunities = [SELECT Id,Name,RecordType.Name,StageName,(SELECT ID, RecordType.Name FROM Cases__r WHERE RecordType.Name='Homecharge Case') FROM Opportunity WHERE RecordType.Name ='Home Charge' AND ID IN:oppListNew];
            
            List<case> cases = new List<case>();
            //Loop contains the logic to update all related case owners to the Queue
            for(Opportunity oppty:opportunities){
                if(oppty.StageName=='Qualified'){
                    for(Case c:oppty.Cases__r){
                        c.OwnerId = qList[0].Id;
                        cases.add(c);
                    }  
                }
            }
            update cases;
        }
        */
        run = False;
        Map<Integer,Case> mapCaseToCreate = new Map<Integer,Case>();
        Map<Integer,Order> mapOrders = new Map<Integer,Order>();
        Map<Integer,List<OrderItem>> mapOrderProducts = new Map<Integer,List<OrderItem>>();
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        boolean hasManagedInstallProduct = false;
        boolean hasHardwareProduct = false;
        boolean hasMISProduct = false;
        boolean hasDataProduct = false;
        boolean hasLockProduct = false;
        Integer i = 0;
        system.debug('Inside function');
        
        
        oppMap = new Map<id,Opportunity>([select Id,Name,recordtype.name,StageName,accountid,account.type, Pricebook2Id,  
                                          account.shippingstreet,account.shippingcity,account.shippingcountry,account.shippingpostalcode,
                                          account.billingstreet,account.billingcity,account.billingcountry,account.billingpostalcode,
                                          (SELECT Id,product_family__c,productcode,quantity,unitprice, PricebookEntryId  FROM opportunitylineitems),
                                          (SELECT Id FROM orders),
                                          (select contactid from opportunitycontactroles where IsPrimary = true),
                                          (SELECT Id,shippingstreet,shippingcity,shippingpostalcode,shippingcountry,billingstreet,billingcity,billingpostalcode,billingcountry FROM quotes where status = 'Accepted')
                                          from Opportunity where id IN : oppListNew]);
        System.debug('oppMap'+oppMap);
        //Create a map with Opportunity id and list of surveys
        Map<String,List<Case>> oppCaseMap = new Map<String,List<Case>>();
        for(Case c : [select id,casenumber,street__c,city__c,country_picklist__c,postalcode__c,Opportunity__c,
                      Install_Cost_Quote_2__c,Install_Cost_Quote__c,Install_Hours_2__c,Install_Hours__c,
                      Scope_of_Work__c,Scope_of_Works_2__c from case where Type = 'Survey' AND status != 'Closed' AND Opportunity__c IN : oppListNew]){
                          if(oppCaseMap.keySet().contains(c.Opportunity__c)){
                              oppCaseMap.get(c.Opportunity__c).add(c);
                          } else {
                              List<Case> cl = new List<case>();
                              cl.add(c);
                              oppCaseMap.put(c.Opportunity__c, cl);
                          }
                      }
        
        system.debug('Size of Map : ' + oppCaseMap.size());
        
        for(String s : oppListNew)
        {
            if(oppMap.get(s).orders.size() == 0)
            {
                Opportunity opp;
                if(oppMap.keyset().contains(s)){
                    opp = oppMap.get(s);
                }
                String RecordTypeID;
                String CaseID;
                String OrderStatus = 'Draft';
                
                
                ////////////////////////////////////////////////////////////////////////////////
                //This is the logic where flags are set based on Opp Products based on record types
                ////////////////////////////////////////////////////////////////////////////////
                
                if(opp.recordtype.name == 'Commercial' || opp.recordtype.name == 'Bid' || opp.recordtype.name == 'Online Payment'){
                    //Find out if the opp has any managed product
                    for(OpportunityLineItem oppLineItem : opp.opportunitylineitems){
                        if(oppLineItem.ProductCode == 'Mngd_Inst'  || oppLineItem.ProductCode == 'Commission_Inst' || oppLineItem.ProductCode == 'Array_Inst')
                            hasManagedInstallProduct = true;
                        
                        if(oppLineItem.ProductCode != 'LOCK' && (oppLineItem.Product_Family__c == 'Solo Units' || oppLineItem.Product_Family__c == 'Twin Units' ||  oppLineItem.Product_Family__c == 'Rapid Chargers' || oppLineItem.Product_Family__c == 'Accessories' || oppLineItem.Product_Family__c == 'Mounts' || oppLineItem.Product_Family__c == 'Signs' || oppLineItem.Product_Family__c == 'Parts' || oppLineItem.Product_Family__c == 'Charging Cables'))
                            hasHardwareProduct = true;
                        
                        if(oppLineItem.Product_Family__c == 'MIS')
                            hasMISProduct = true;
                        
                        if(oppLineItem.Product_Family__c == 'Data' || oppLineItem.Product_Family__c == 'Shipping' ||  oppLineItem.Product_Family__c == 'Warranty' || oppLineItem.Product_Family__c == 'Adjustments' || (oppLineItem.Product_Family__c == 'Installs' && oppLineItem.ProductCode != 'Mngd_Inst'))
                            hasDataProduct = true;
                        
                        if(oppLineItem.ProductCode == 'LOCK')
                            hasLockProduct = true;
                    }
                }
                
                if(opp.recordtype.name == 'Home Charge'){
                    //Find out if the opp has any managed product
                    for(OpportunityLineItem oppLineItem : opp.opportunitylineitems)
                    { 
                        if(oppLineItem.Product_Family__c == 'Charging Cables' || oppLineItem.Product_Family__c == 'Mounts' ){
                            hasHardwareProduct = true;
                                            system.debug('Come in hasHardwareProduct');

                        }
                        if(oppLineItem.ProductCode == 'Mngd_Inst'){
                            hasManagedInstallProduct = true;
                        system.debug('Come in hasManagedInstallProduct');
                    }
                    }
                }
                
                ////////////////////////////////////////////////////////////////////////////////
                //This is the logic where orders and install cases are created based on record types
                ////////////////////////////////////////////////////////////////////////////////
                
                if(opp.RecordType.name == 'Home Charge')
                {
                    system.debug('hasManagedInstallProduct:>>'+hasManagedInstallProduct);
                    if(hasManagedInstallProduct){
                        RecordTypeID = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId();
                        system.debug('Manageinsta');}
                    else
                    {
                        RecordTypeID = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Non Managed Installation').getRecordTypeId();
                        OrderStatus = 'Ready for Helen';
                    system.debug('NON Manageinsta');
                    }
                    
                    system.debug('hasHardwareProduct:>>'+hasHardwareProduct);
                    //if(hasHardwareProduct)
                    if(hasHardwareProduct && opp.StageName=='Install Requested')
                        mapOrders.put(i,createOrder(opp,Schema.SObjectType.Order.getRecordTypeInfosByName().get('Non Managed Installation').getRecordTypeId(),OrderStatus,oppCaseMap.get(opp.id),opp.quotes,caselist));   
                        System.debug('mapOrders=>'+mapOrders);
                }
                
                
                if((opp.recordtype.name == 'Commercial' || opp.recordtype.name == 'Online Payment' || opp.recordtype.name == 'Bid') && (opp.account.type == 'Customer' || (opp.account.type != 'Customer' && opp.quotes.size()>0)))
                {
                    if(hasManagedInstallProduct){
                        //mapCaseToCreate.put(i,createInstallCase(opp.AccountId,opp.id,opp.Name,oppCaseMap.get(opp.id),opp.quotes));
                        RecordTypeID = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Managed Installation').getRecordTypeId();
                    }
                    else
                    {
                        RecordTypeID = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Non Managed Installation').getRecordTypeId();
                        OrderStatus = 'Ready for Helen';
                    }
                    

                    if(((opp.recordtype.name == 'Commercial' || opp.recordtype.name == 'Bid') && hasHardwareProduct) ||(opp.recordtype.name == 'Online Payment' && hasHardwareProduct ))
                        mapOrders.put(i,createOrder(opp,RecordTypeID,OrderStatus,oppCaseMap.get(opp.id),opp.quotes,caselist));     
                        System.debug('mapOrders=>'+mapOrders);
                        
                    if((hasMISProduct && !hasManagedInstallProduct && !hasHardwareProduct) || (hasDataProduct && !hasManagedInstallProduct && !hasHardwareProduct && opp.recordtype.name == 'Commercial'))
                    {
                        opp.Ready_to_Invoice__c = true;
                        oppToUpdate.add(opp);
                    }
                    
                }    
                
                
                ///Add products to the order
                List<OrderItem> orderItemsList = new List<OrderItem>();
                for(Opportunitylineitem oppLineItem : oppMap.get(s).opportunitylineitems)
                {
                    if(opp.recordtype.name == 'Home Charge')
                    {
                        if(oppLineItem.Product_Family__c == 'Charging Cables' ||oppLineItem.Product_Family__c == 'Mounts' )
                        {
                            OrderItem ordItem = new OrderItem();
                            ordItem.PricebookEntryId = opplineitem.PricebookEntryId;
                            ordItem.Quantity = opplineItem.quantity;
                            ordItem.UnitPrice = oppLineItem.UnitPrice;
                            
                            orderItemsList.add(ordItem);
                        }
                    }
                    else if(opp.recordtype.name == 'Online Payment')
                    { 
                        if(oppLineItem.ProductCode != 'LOCK')
                        {
                            if(oppLineItem.Product_Family__c == 'Solo Units' || oppLineItem.Product_Family__c == 'Twin Units' ||  oppLineItem.Product_Family__c == 'Rapid Chargers' || oppLineItem.Product_Family__c == 'Accessories' || oppLineItem.Product_Family__c == 'Mounts' || oppLineItem.Product_Family__c == 'Signs' || oppLineItem.Product_Family__c == 'Parts' || oppLineItem.Product_Family__c == 'Charging Cables')
                            {
                                OrderItem ordItem = new OrderItem();
                                ordItem.PricebookEntryId = opplineitem.PricebookEntryId;
                                ordItem.Quantity = opplineItem.quantity;
                                ordItem.UnitPrice = oppLineItem.UnitPrice;
                                
                                orderItemsList.add(ordItem);
                            }
                        }
                    }
                    else
                    { 
                        if(oppLineItem.Product_Family__c == 'Solo Units' || oppLineItem.Product_Family__c == 'Twin Units' ||  oppLineItem.Product_Family__c == 'Rapid Chargers' || oppLineItem.Product_Family__c == 'Accessories' || oppLineItem.Product_Family__c == 'Mounts' || oppLineItem.Product_Family__c == 'Signs' || oppLineItem.Product_Family__c == 'Parts' || oppLineItem.Product_Family__c == 'Charging Cables')
                        {
                            OrderItem ordItem = new OrderItem();
                            ordItem.PricebookEntryId = opplineitem.PricebookEntryId;
                            ordItem.Quantity = opplineItem.quantity;
                            ordItem.UnitPrice = oppLineItem.UnitPrice;
                            
                            orderItemsList.add(ordItem);
                        }
                    }
                }
                mapOrderProducts.put(i,orderItemsList);
                
                i++;  
            }
            
        }
        
        system.debug('Before DML');
        //create the installcase
        
        system.debug('Size :  ' + mapCaseToCreate.size());
        insert mapCaseToCreate.values();
        
        for(Integer i1 : mapOrders.keySet()){
            if(mapCaseToCreate.keySet().contains(i1)){
                mapOrders.get(i1).Case__c = mapCaseToCreate.get(i1).id;
                mapOrders.get(i1).Status__c = mapCaseToCreate.get(i1).Status;
                mapOrders.get(i1).Case_Number__c = mapCaseToCreate.get(i1).CaseNumber;
                mapOrders.get(i1).Install_Case_Created__c = true;
                mapOrders.get(i1).Link_To_Case__c = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + mapCaseToCreate.get(i1).id;
                mapOrders.get(i1).Project_Manager__c = mapCaseToCreate.get(i1).Project_Manager__c;
            }
        }
        
        insert mapOrders.values();
        
        if(mapOrderProducts.size()>0)
        {
            List<OrderItem> orderItemsListToUpdate = new List<OrderItem>();
            for(Integer i1 : mapOrders.keySet()){
                if(mapOrders.keySet().contains(i1)){
                    for(OrderItem ordItem : mapOrderProducts.get(i1)){
                        ordItem.OrderId = mapOrders.get(i1).id;
                        orderItemsListToUpdate.add(ordItem);
                    }
                    //mapOrderProducts.get(i1).orderid = mapOrders.get(i1).id;
                }
            }  
            
            insert orderItemsListToUpdate;
            
        }
        
        //Update Opp to update the ready to invoice flag
        if(oppToUpdate.size()>0)
            update oppToUpdate;
    }
    
    //Method contains the logic for:Sync "Survey Status" & "Install Status" on Opp to Opp Stage after update
    public static void syncSurveyInstallStatToStage(List<String> oppIdList){
        System.debug('oppIdList=>'+oppIdList);
        
        List<Opportunity> newOpptyList = new List<Opportunity>();
        List<Opportunity> opptyList = [SELECT ID,Survey_Status__c,Install_Status_New__c,StageName,(Select id,Survey_Status__c,Install_Status__c,Opportunity__c FROM Cases__r WHERE Opportunity__c IN: oppIdList AND Install_Status__c=null) FROM Opportunity WHERE ID IN:oppIdList];
        if(!opptyList.isEmpty()){
            for(Opportunity opptyRec:opptyList){
                if(!opptyRec.Cases__r.isEmpty()){
                    for(Case caseRec:opptyRec.Cases__r){
                        if(opptyRec.Install_Status_New__c==NUll){
                            if(opptyRec.Survey_Status__c=='Requested')
                                opptyRec.StageName = 'Survey Requested';
                            if(opptyRec.Survey_Status__c=='Scheduled')
                                opptyRec.StageName = 'Survey Scheduled';
                            if(opptyRec.Survey_Status__c=='Completed')
                                opptyRec.StageName = 'Survey Completed';
                            if(opptyRec.Survey_Status__c=='Incomplete')
                                opptyRec.StageName = 'Survey Incomplete';
                            if(opptyRec.Survey_Status__c=='On Hold')
                                opptyRec.StageName = 'Survey On Hold';
                            if(opptyRec.Survey_Status__c=='Rejected')
                                opptyRec.StageName = 'Survey Cancelled';
                            if(opptyRec.Survey_Status__c=='Quoted')
                                opptyRec.StageName = 'Survey Quoted';
                        }  
                        
                        if(opptyRec.StageName!='Invoiced'){
                            if(opptyRec.Survey_Status__c=='Requested')
                                opptyRec.StageName = 'Survey Requested';
                            if(opptyRec.Survey_Status__c=='Scheduled')
                                opptyRec.StageName = 'Survey Scheduled';
                            if(opptyRec.Survey_Status__c=='Completed')
                                opptyRec.StageName = 'Survey Completed';
                            if(opptyRec.Survey_Status__c=='Incomplete')
                                opptyRec.StageName = 'Survey Incomplete';
                            if(opptyRec.Survey_Status__c=='On Hold')
                                opptyRec.StageName = 'Survey On Hold';
                            if(opptyRec.Survey_Status__c=='Rejected')
                                opptyRec.StageName = 'Survey Cancelled';
                            if(opptyRec.Survey_Status__c=='Quoted')
                                opptyRec.StageName = 'Survey Quoted';
                            
                            if(opptyRec.Install_Status_New__c=='Requested')
                                opptyRec.StageName = 'Install Requested';
                            if(opptyRec.Install_Status_New__c=='Scheduled')
                                opptyRec.StageName = 'Install Scheduled';
                            if(opptyRec.Install_Status_New__c=='Completed')
                                opptyRec.StageName = 'Install Completed';
                            if(opptyRec.Install_Status_New__c=='Incomplete')
                                opptyRec.StageName = 'Install Incomplete';
                            if(opptyRec.Install_Status_New__c=='On Hold')
                                opptyRec.StageName = 'Install On Hold';
                            if(opptyRec.Install_Status_New__c=='Rejected')
                                opptyRec.StageName = 'Install Cancelled';
                            if(opptyRec.Install_Status_New__c=='Verified')
                                opptyRec.StageName = 'Install Verified';
                        }  
                    }
                }
                newOpptyList.add(opptyRec);
            }
        }
         update newOpptyList;
    }
    
    //Method contains the logic for Create/Clone WO when Online Payment is "Won"
    /*public static void createOnlineOppty(List<String> opptyIdforOp){
        //WorkOrder wo;
        List<WorkOrder> woList = new List<WorkOrder>();
        Id hcWoRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        WorkType wt = [SELECT id, name FROM WorkType WHERE Name='Install (Domestic)'];
        //List<case> caseList = [SELECT ID,RecordType.Name FROM Case WHERE RecordType.Name='Homecharge Case' ORDER BY LastModifiedDate DESC LIMIT 1 ];
        List<Opportunity> OpptyWithInstallProd = [SELECT ID,AccountId,(SELECT ID,RecordType.Name,ContactId,AccountId FROM Cases__r WHERE RecordType.Name='Homecharge Case' ORDER BY LastModifiedDate DESC LIMIT 1),(SELECT ID, Product_Family__c FROM OpportunityLineItems WHERE Product_Family__c = 'Installs') FROM Opportunity WHERE ID IN:opptyIdforOp];
        for(Opportunity oppRec:OpptyWithInstallProd){
            for(Case caseRec:oppRec.Cases__r){
                woList.add(new WorkOrder(ContactId=caseRec.ContactId,AccountId=caseRec.AccountId,RecordTypeId = hcWoRecordTypeId ,Priority='Medium',WorkTypeId = wt.Id ,Status = 'Unassigned',CaseId = caseRec.id));
            }
        }
        insert woList;
    }*/
    
    public static void createCloneOnlineOppty(List<String> opptyIdforOp){
        System.debug('opptyIdforOp=>'+opptyIdforOp);
        List<WorkOrder> woList = new List<WorkOrder>();
        Id hcWoRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        //WorkType wt = [SELECT Id, Name FROM WorkType WHERE Name='Install (Domestic)'];
        WorkType wt1 = [SELECT Id, Name FROM WorkType WHERE Name='Install (Domestic) & Additional Works'];
               //List<OpportunityLineItem> oliMap = new List<OpportunityLineItem>([SELECT OpportunityId, Id, Product_Family__c FROM OpportunityLineItem WHERE Product_Family__c = 'Installs' AND OpportunityId IN:opptyIdforOp]);
        List<Opportunity> OpptyWithInstall = [SELECT ID,AccountId,(SELECT ID,RecordType.Name,ContactId,AccountId FROM Cases__r WHERE RecordType.Name='Homecharge Case' ORDER BY LastModifiedDate DESC LIMIT 1) FROM Opportunity WHERE ID IN:opptyIdforOp];

        List<OpportunityLineItem> OpptyWithInstallProd = new List<OpportunityLineItem>([SELECT OpportunityId, Id, Product_Family__c FROM OpportunityLineItem WHERE Product_Family__c = 'Installs' AND OpportunityId IN:opptyIdforOp]);
       
        System.debug('OpptyWithInstallProd=>'+OpptyWithInstallProd);
        //List<case> caseList = [SELECT ID,RecordType.Name,AccountId,ContactId,(SELECT ID,Status,Incomplete_Reason__c,ContactId,AccountId FROM WorkOrders WHERE Status='Incomplete' AND Incomplete_Reason__c='Additional Works Required') FROM Case WHERE RecordType.Name='Homecharge Case' AND AccountId=:OpptyWithInstall[0].AccountId ORDER BY LastModifiedDate DESC LIMIT 1 ];
        List<case> caseList = [SELECT ID,RecordType.Name,AccountId,ContactId,(SELECT ID,case__c FROM Service_Appointments__r),(SELECT ID,Status,Incomplete_Reason__c,ContactId,AccountId FROM WorkOrders WHERE Status='Incomplete' AND Incomplete_Reason__c='Additional Works Required') FROM Case WHERE RecordType.Name='Homecharge Case' AND AccountId=:OpptyWithInstall[0].AccountId ORDER BY LastModifiedDate DESC LIMIT 1 ];
        System.debug('caseList=>'+caseList);
            
        for(Opportunity oppRec:OpptyWithInstall){
           if(!OpptyWithInstallProd.isEmpty()){
               if(!caseList.isEmpty()){
                   for(Case caseRec:caseList){
                       //if(!caseRec.WorkOrders.isEmpty())
                       
                       if(!caseRec.Service_Appointments__r.isEmpty())
                       {
                            woList.add(new WorkOrder(ParentWorkOrderId=caseRec.WorkOrders[0].Id,Status='Unassigned',Incomplete_Reason__c=caseRec.WorkOrders[0].Incomplete_Reason__c,ContactId=caseRec.WorkOrders[0].ContactId,AccountId=oppRec.AccountId,RecordTypeId = hcWoRecordTypeId ,Priority='Medium',WorkTypeId =wt1.Id ,CaseId = caseRec.id));    
                       }else
                       woList.add(new WorkOrder(Status = 'Unassigned',AccountId=oppRec.AccountId,ContactId=caseRec.ContactId,RecordTypeId = hcWoRecordTypeId ,Priority='Medium',WorkTypeId = wt1.Id ,CaseId = caseRec.id));
                   }
               }
           }
        }     
         Insert woList; 
    }           
}