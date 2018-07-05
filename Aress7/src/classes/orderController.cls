public class orderController {

    private final Order ord;
    public string orderID {get;set;}
    public string CaseID {get;set;}
    public string opportunityID {get;set;}
    public string opportunityName {get;set;}
    public string selectedAddress {get;set;}
    public string AddressID {get;set;}
    public List<Order> AllOrders {get;set;}
    public List<Order> CompletedOrders {get;set;}
    public List<Order> IncompleteOrders {get;set;}
    public List<OrderItem> ordItems {get;set;}
    public List<OrderItem> ordItems_iPro {get;set;}
    public List<OrderItem> ordItemsforExport {get;set;}
    public List<WrapperOrderItems> listWrapperOrderItems {get;set;}
    public List<WrapperAddress> lstWrapperAddress {get;set;}
    public List<SelectOption> SelectOptionsAddress{get;set;}
    public List<SelectOption> SelectOptionsStreet{get;set;}
    public boolean addressConfirmed {get;set;}
    public Map<Integer,WrapperAddress> mp {get;set;}
    public string filename{get;set;}
    public String csvContact {get;set;}
    public String csvShipto {get;set;}
    public String csvphone {get;set;}
    
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public orderController(ApexPages.StandardController stdController) {
        this.ord = (Order)stdController.getRecord();
        
        Order o = [select id,Confirm_Dispatch_Address__c,Internal_Order__c,accountid,account.name,opportunityid,opportunity.name from order where id =: this.ord.Id];
        opportunityID = o.OpportunityId;
        opportunityName = o.opportunity.name;
        
        ordItems = new List<OrderItem>();
        ordItems = [SELECT order.Confirm_Dispatch_Address__c,Date_to_Site__c,ListPrice,Actual_Dispatch_Date__c,OrderId,OrderItemNumber,Dispatched_by_iPro__c,Include_in_CSV__c,Street_del__c,order.BillingCity,order.BillingCountry,order.BillingPostalCode,PricebookEntry.name,PricebookEntry.product2.SKU__c,Quantity,Tracking_number__c,Dispatch_Date__c,Dispatch_Status__c,Dispatch_Address__c,order.Internal_Order__c FROM OrderItem where orderid =: this.ord.id];
        
        ordItems_iPro = [SELECT order.ordernumber,order.Confirm_Dispatch_Address__c,Actual_Dispatch_Date__c,ListPrice,OrderId,OrderItemNumber,Dispatched_by_iPro__c,Include_in_CSV__c,Street_del__c,order.BillingCity,order.BillingCountry,order.BillingPostalCode,PricebookEntry.product2.SKU__c,PricebookEntry.name,Quantity,Tracking_number__c,Dispatch_Date__c,Dispatch_Status__c,Dispatch_Address__c,order.Internal_Order__c FROM OrderItem where Include_in_CSV__c = true and orderid =: this.ord.id];
        
        addressConfirmed = o.Confirm_Dispatch_Address__c;
        
        if(ordItems.size() > 0)
        {
            getAddress();
            
        }
            
        //ordItemsforExport = [SELECT ListPrice,OrderId,OrderItemNumber,Include_in_CSV__c,Street_del__c,order.account.name,PricebookEntry.name,PricebookEntry.unitprice,Quantity,Tracking_number__c,Dispatch_Date__c,Dispatch_Status__c,SKU_Number__c,Dispatch_Address__c FROM OrderItem where orderid =: this.ord.id and Include_in_CSV__c = true];
        filename =  o.Internal_Order__c + ' - ' + o.Account.name ; 

    }

    public PageReference returnPage()
    {
        PageReference returnPage = new PageReference('/apex/AllOrderPage_iPro'); 
        
        return returnPage;
    }
    
    
    //This function is called when the button on Order object "Create Install Case" is clicked. This will create a job in Fieldaware and link it with a case record in SF.
    public void createInstallCase()
    {
        
        //helperJobs hj = new helperJobs();
        //CaseID = hj.createJobafterOrder(String.valueof(ord.Id));     
     }
    
    //This function creates a install case in Salesforce without any FA integration.
    public void createInstallCaseOnly()
    {
        
        CaseID = '';
        helperJobs hj = new helperJobs();
        CaseID = hj.createOnlyCase(String.valueof(ord.Id));     
        

            
    }
    
    public void getAllOrdersforiPro() 
    {
        AllOrders = [select id,Confirm_Dispatch_Address__c from order where status ='Ready for Dispatch'];
        
        CompletedOrders = [select id,Confirm_Dispatch_Address__c from order where status ='Dispatched'];
        //return ordItems;
    }
    
    public void getOrderProductsforExport() 
    {
        ordItemsforExport = [SELECT order.account.recordtype.Name,order.account.phone,order.opportunityid,City_del__c,Postal_Code_del__c,Country_del__c,ListPrice,OrderId,OrderItemNumber,Include_in_CSV__c,Street_del__c,order.account.name,PricebookEntry.name,PricebookEntry.Product2.SKU__c,PricebookEntry.Product2.Cost__c,PricebookEntry.unitprice,Quantity,Tracking_number__c,Dispatch_Date__c,Dispatch_Status__c,Dispatch_Address__c,order.Internal_Order__c FROM OrderItem where orderid =: this.ord.id and Include_in_CSV__c = true];
        
        
        //List<WrapperOrderItems> listWrapperOrderItems;
        String PrimaryContactName = '';
        String ShipToName = '';
        String ContactPhone = '';
        
        
        if(ordItemsforExport.size()>0)
        {
            //Get the primary contact name from the opportunity contact role.
            List<OpportunityContactRole> lstOppContactRoles = [SELECT contact.phone,ContactId,contact.name,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRole where OpportunityId =: ordItemsforExport[0].order.opportunityid and IsPrimary = True];
            if(lstOppContactRoles.size()>0){
                PrimaryContactName = lstOppContactRoles[0].contact.name;
            
            if(ordItemsforExport[0].order.account.recordtype.Name == 'Person Account'){
                csvContact = ordItemsforExport[0].order.account.name;
                csvphone = ordItemsforExport[0].order.account.phone;
            } else {
                csvContact = lstOppContactRoles[0].contact.name;
                csvphone = lstOppContactRoles[0].contact.phone; 
            }}
            //Get the Ship to name from the accepted quote if any.
            List<quote> lstQuotes = [SELECT id,ShippingName,status,phone FROM quote where OpportunityId =: ordItemsforExport[0].order.opportunityid and status='Accepted'];
            if(lstQuotes.size()>0)
            {
                ShipToName = lstQuotes[0].ShippingName;
                csvShipto = lstQuotes[0].ShippingName;
                ContactPhone = lstQuotes[0].phone;
                
            }
                
           
            
            listWrapperOrderItems = new List<WrapperOrderItems>(); 
            for(Orderitem oi : ordItemsforExport)
            {
                listWrapperOrderItems.add(new WrapperOrderItems(oi,PrimaryContactName,ShipToName,oi.Dispatch_Date__c,ContactPhone));
            }
            
            system.debug('Wrapper Class values' + listWrapperOrderItems);
        }
        
    }
    
    public void getAddress() 
    {
        Order ord = [SELECT id,accountid,opportunityid,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet FROM Order where id =: this.ord.id];
        //Fetch all cases linked with the Opportunity of the order with type = survey.
        List<Case> lstCases = [select id,type,Street__c,City__c,Country__c,PostalCode__c,Installer__r.Street__c,Installer__r.City__c,Installer__r.Country__c,Installer__r.Postal_Code__c from case where type ='Survey' and accountid =: ord.accountid and OpportunityId__c =: ord.OpportunityId ];
        
        //Instantiate the wrapper class.
        Integer count = 0;
        
        lstWrapperAddress = new List<WrapperAddress>(); 
        Map<Integer,WrapperAddress> mp = new Map<Integer,WrapperAddress>();
        
        
        //Add the address for the order shipping
        if(ord.ShippingStreet == null && ord.ShippingCity ==null && ord.ShippingPostalCode ==null && ord.ShippingCountry ==null)
        {        
        }
        else
        {
            lstWrapperAddress.add(new WrapperAddress(ord.ShippingStreet,ord.ShippingCity,ord.ShippingCountry,ord.ShippingPostalCode));
            
            mp.put(count, new WrapperAddress(ord.ShippingStreet,ord.ShippingCity,ord.ShippingCountry,ord.ShippingPostalCode));
            count++;
        }
        
        
        system.debug('Size Case :' + lstCases.size());  
        
        //Add those cases installer address to the wrapper class.
        for(Case c : lstCases)
        {
            if(c.Installer__r.Street__c == null && c.Installer__r.City__c ==null && c.Installer__r.Country__c ==null && c.Installer__r.Postal_Code__c ==null)
            {}
            else
            {
                system.debug('Add address 1');
                 //Add the installer address which is stored on case as a lookup of Installer
                lstWrapperAddress.add(new WrapperAddress(c.Installer__r.Street__c,c.Installer__r.City__c,c.Installer__r.Country__c,c.Installer__r.Postal_Code__c));
                mp.put(count, new WrapperAddress(c.Installer__r.Street__c,c.Installer__r.City__c,c.Installer__r.Country__c,c.Installer__r.Postal_Code__c));
                count++;
            }
            if(c.Street__c == null && c.City__c ==null && c.Country__c ==null && c.PostalCode__c ==null)
            {}
            else
            {
                system.debug('Add address 2');
                //Add the install address which is stored on case.
                //lstWrapperAddress.add(new WrapperAddress(c.Street__c,c.City__c,c.Country__c,c.PostalCode__c));
                //mp.put(count, new WrapperAddress(c.Street__c,c.City__c,c.Country__c,c.PostalCode__c));
                //count++;
            }
            
        }
        
        
       
        //Get the contact roles linked with Opp , then get the contact which is primary in the contact role to add its address in wrapper address as well
        List<OpportunityContactRole> lstOppContactRoles = [SELECT ContactId,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRole where OpportunityId =: ord.opportunityid and IsPrimary = True];
        
        Contact con;
        if(lstOppContactRoles.size()>0)
        {
            con = [select id,email,account.website,FieldAware_ID__c,Phone,FieldAware_URL__c,location_id__c,name,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,accountid from contact where id =: lstOppContactRoles[0].contactid];
        
            if(con.MailingStreet == null && con.MailingCity == null && con.MailingCountry == null && con.MailingPostalCode == null)  
            {}
            else
            {
                lstWrapperAddress.add(new WrapperAddress(con.MailingStreet,con.MailingCity,con.MailingCountry,con.MailingPostalCode));
                mp.put(count, new WrapperAddress(con.MailingStreet,con.MailingCity,con.MailingCountry,con.MailingPostalCode));
                count++;
            }
                
        }
            
        //Add the POD POINT HQ address
        lstWrapperAddress.add(new WrapperAddress('Discovery House 28 - 42 Banner Street','London','UK','EC1Y 8QE'));
        mp.put(count, new WrapperAddress('Discovery House 28 - 42 Banner Street','London','UK','EC1Y 8QE'));
        count++;
        
        
        //Add the POD POINT HQ address 2
        lstWrapperAddress.add(new WrapperAddress('FAO: Jamie Walker (01623869734), AERO Electrical, 221 Boughton Industrial Estate','Boughton Nottinghamshire','UK','NG22 9US'));
        mp.put(count, new WrapperAddress('FAO: Jamie Walker (01623869734), AERO Electrical, 221 Boughton Industrial Estate','Boughton Nottinghamshire','UK','NG22 9US'));
        count++;
        
        //Add the POD POINT HQ address 3
        lstWrapperAddress.add(new WrapperAddress('FAO: Marie Yexley (01884 235800), Sol Electrical Ltd, 22 Lower Town, Sampford Peverell','Devon','UK','EX16 7BJ'));
        mp.put(count, new WrapperAddress('FAO: Marie Yexley (01884 235800), Sol Electrical Ltd, 22 Lower Town, Sampford Peverell','Devon','UK','EX16 7BJ'));
        count++;
        
        //Add the POD POINT HQ address 4
        lstWrapperAddress.add(new WrapperAddress('FAO Gary Stirling (01506 638 600), Everwarm, 3 Inchcorse Place, Whitehill Industrial Estate','Bathgate West Lothian','UK','EH48 2EE'));
        mp.put(count, new WrapperAddress('FAO Gary Stirling (01506 638 600), Everwarm, 3 Inchcorse Place, Whitehill Industrial Estate','Bathgate West Lothian','UK','EH48 2EE'));
        count++;
        
        SelectOptionsAddress = new List<SelectOption>();
         
       
        for(integer i=0; i<mp.size(); i++)
        {           
            SelectOptionsAddress.add(new SelectOption(mp.get(i).fulladdress, mp.get(i).fulladdress));
        }
    }
    

    
    public void save() 
    {
        String fullAddress;
        List<String>  strs;
        List<OrderItem> lstOrderItem_update = new List<OrderItem>();
        for(OrderItem oi : orditems)
        {
            fullAddress = oi.Dispatch_Address__c;
            system.debug('Full Address' + fullAddress);
            strs = new List<String>();
            strs.clear();
            for(String key : fullAddress.split(','))
            {
               strs.add(key);
            }
            
            system.debug('strs : ' + strs);
            
            
            
            if(strs.size()>3)
            {
                oi.Postal_Code_del__c = strs[strs.size()-1];
                oi.Country_del__c = strs[strs.size()-2];
                oi.City_del__c   = strs[strs.size()-3];
                
                oi.Street_del__c = '';
                for(integer i=0; i<strs.size()-3;i++)
                    oi.Street_del__c = oi.Street_del__c + '' + strs[i];
            }
            
            
                
            lstOrderItem_update.add(oi);
        }
        
        
        
        update lstOrderItem_update;
    }
    
     public void saveiProChanges() 
    {
        update ordItems_iPro;
    }
    
    public PageReference exporttoexcel() 
    {
                
        return Page.OrderExportToCSV;

    }
    
    public class WrapperOrderItems  
    {
        public OrderItem ordItem {get; set;}
        public string PrimaryContactName {get; set;}
        public string ShipToName {get; set;}
        public string DispatchDate {get; set;}
        public string ContactPhoneNumber {get; set;}

        
        public WrapperOrderItems(OrderItem objorditem,String strPrimaryContactName,String strShipToName,Date dtDispatchDate,String phonenumber) 
        {
            ordItem = objorditem;
            PrimaryContactName = strPrimaryContactName;
            ShipToName = strShipToName;
            //DispatchDate = dtDispatchDate.format('DD-MM-YYYY');
            DispatchDate = DateTime.newInstance(dtDispatchDate.year(),dtDispatchDate.month(),dtDispatchDate.day()).format('dd-MM-YYYY');
            ContactPhoneNumber = phonenumber;
        }
    }
    
    public class WrapperAddress 
    {
        public string Street {get; set;}
        public string City {get; set;}
        public string Country {get; set;}
        public string PostalCode {get; set;}
        public string fulladdress {get; set;}
        
        public WrapperAddress(String strStreet,String strCity,String strCountry,String strPostalCode) 
        {
            Street = strStreet;
            City = strCity;
            Country = strCountry;
            PostalCode = strPostalCode;
            
            fulladdress = '';
            
            if(strStreet !='' && strStreet != null)
                fulladdress = strStreet;
            if(strCity !='' && strCity != null)
                fulladdress = fulladdress + ',' + strCity;
            if(strCountry !='' && strCountry != null)
                fulladdress = fulladdress + ',' + strCountry;
            if(strPostalCode !='' && strPostalCode != null)
                fulladdress = fulladdress + ',' + strPostalCode;

        }
    }
}