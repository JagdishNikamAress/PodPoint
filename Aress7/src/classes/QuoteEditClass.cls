public class QuoteEditClass{
    public Quote qote {get;set;}
    Public Opportunity opp {get;set;}
    public Decimal subtot {get;set;}
    public Decimal Total_Inc_VAT;
    public Decimal UK_VAT {get;set;}
    public Decimal Total_Amount {get;set;}
    public QuoteEditClass(ApexPages.StandardController controller) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'All opportunity products will be added as quote line items.'));    
        
        subtot = 0.00;
        Total_Inc_VAT = 0.00;
        UK_VAT = 0.00;
        Total_Amount = 0.00;
        String primaryConId;
        Contact con;
        
        if(ApexPages.currentPage().getParameters().get('oppid') != null){
            opp = [SELECT Id,Name,Account.Name,AccountId,Account.shippingstreet,Account.shippingcity,account.shippingcountry,account.shippingpostalcode,Account.billingstreet,Account.billingcity,Account.billingcountry,Account.billingpostalcode,Billing_Street__c,Billing_City__c,Billing_Country_Picklist__c,Billing_Postal_Code__c,Shipping_Street__c,Shipping_City__c,Shipping_Country_Picklist__c,Shipping_Postal_Code__c,Amount_Excluding_VAT__c,Amount,
                   Recordtype.Name,Workplace_Grant__c,StageName,Pricebook2Id,
                   (SELECT TotalPrice,PricebookEntryId,Product2Id,ProductCode,Quantity,UnitPrice FROM OpportunityLineItems),
                   (SELECT Id,ContactId,IsPrimary FROM OpportunityContactRoles) FROM Opportunity WHERE Id = : ApexPages.currentPage().getParameters().get('oppid')];
            
            for(OpportunityContactRole ocr : opp.OpportunityContactRoles){
                if(ocr.IsPrimary){
                    primaryConId = ocr.ContactId;
                }
                break;
            }
            if(primaryConId != null){
                con = [Select id,Name,Phone,email,Fax FROM Contact WHERE id =: primaryConId];
            }
            for(OpportunityLineItem oli : opp.OpportunityLineItems){
                subtot += oli.TotalPrice;
            }
            
            Total_Inc_VAT  = (opp.Recordtype.Name =='Online Payment' ? opp.Amount_Excluding_VAT__c : (opp.Workplace_Grant__c ? subtot :opp.Amount));
            UK_VAT = (opp.Recordtype.Name =='Online Payment' ? subtot - Total_Inc_VAT : subtot/5);
            //Total_Amount = (opp.Recordtype.Name =='Online Payment' ? subtot : Total_Inc_VAT + UK_VAT);
            
            
            qote = new Quote();
            qote.name = 'Quote - '+opp.name;
            qote.ExpirationDate = date.today().addDays(30);
            qote.Notes_about_your_order__c = 'N/A';
            qote.OpportunityId = opp.id;
            if(con != null){
                qote.contactId = con.id;    
                qote.Email=con.email;
                qote.Phone = con.phone;
                qote.Fax = con.Fax;
            }
            qote.Pricebook2Id = opp.Pricebook2Id;
            
            qote.BillingName = opp.Account.Name;
            qote.ShippingName = opp.Account.Name;
            
            //if Online payment - take the address from account
            if(opp.Recordtype.Name =='Online Payment')
            {
                qote.BillingStreet = opp.account.billingstreet;
                qote.BillingCity = opp.account.billingcity;
                qote.BillingCountry = opp.account.billingcountry; 
                qote.BillingPostalCode = opp.account.billingpostalcode;
                
                qote.ShippingStreet = opp.account.shippingstreet;
                qote.ShippingCity = opp.account.shippingcity;   
                qote.ShippingCountry = opp.account.shippingcountry;
                qote.ShippingPostalCode = opp.account.shippingpostalcode;
            }
            else
            {
                qote.BillingStreet = opp.Billing_Street__c;
                qote.BillingCity =opp.Billing_City__c;
                qote.BillingCountry = opp.Billing_Country_Picklist__c; 
                qote.BillingPostalCode = opp.Billing_Postal_Code__c; 
                
                list<Case> lstCases = [select id,street__c,city__c,PostalCode__c,country_Picklist__c from case where Type = 'Survey' and status != 'Closed' and opportunityid__c =: opp.id];
                
                if(lstCases.size()>0)
                {
                    system.debug(lstCases[0].street__c);
                    qote.ShippingStreet = lstCases[0].street__c; 
                    qote.ShippingCity = lstCases[0].city__c;    
                    qote.ShippingCountry = lstCases[0].country_Picklist__c;
                    qote.ShippingPostalCode = lstCases[0].PostalCode__c;
                    
                }
                else
                {
                    qote.ShippingStreet = opp.Shipping_Street__c; 
                    qote.ShippingCity = opp.Shipping_City__c;    
                    qote.ShippingCountry = opp.Shipping_Country_Picklist__c;
                    qote.ShippingPostalCode = opp.Shipping_Postal_Code__c;
                }
                
            }
        }
    }
    
    public pagereference doSave(){
        
        insert qote;
        
        List<QuoteLineItem> qliLst = new List<QuoteLineItem>();
        for(OpportunityLineItem oli : opp.OpportunityLineItems){
            QuoteLineItem qli = new QuoteLineItem();
            qli.PricebookEntryId = oli.PricebookEntryId ;
            qli.Product2Id = oli.product2id;
            qli.Quantity = oli.quantity;
            qli.QuoteId = qote.id;
            qli.UnitPrice = oli.unitprice;
            qliLst.add(qli);
        }
        
        if(qliLst.size()>0){
            insert qliLst;
        }
        pagereference pr = new pagereference('/'+qote.id);
        return pr;
    }
}