public without sharing class generatePDFQuoteOnlinePayment{
        
        
        public class payment {
            @InvocableVariable(label='RecordID')
            public String recordID;
            @InvocableVariable(label='Status')
            public String status;
        }
        
        @InvocableMethod(label='Generate PDF')
        public static void generatePDF(List<payment> payments) 
        {
            payment pr = payments[0];
            
            String QuoteID;
            
            Opportunity opp = [select id,Pricebook2Id,owner.email,name,account.name,accountid,account.personcontactid,account.billingstreet,account.PersonEmail,account.billingcity,account.billingstate,account.billingpostalcode from opportunity where id =: pr.recordID];        
            List<Opportunitylineitem> lstOpplineItems = [SELECT Id,ListPrice,Name,OpportunityId,PricebookEntryId,Product2Id,ProductCode,Product_Family__c,Product_Name__c,Quantity,TotalPrice,UnitPrice FROM OpportunityLineItem where OpportunityId =: opp.id];        
            List<OpportunityContactRole> lstOppContactRoles = [SELECT ContactId,contact.email,Contact.mailingstreet,Contact.mailingcity,Contact.mailingstate,Contact.mailingpostalcode,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRole where OpportunityId =: opp.id and IsPrimary = True];
            
            system.debug('Status' + pr.status);
            
            //Create the quote once the payment request is sent to the customer
            if(pr.status == 'Created' || pr.status == 'Manually Sent' || pr.status == 'Auto Sent')
            {
                String MailingStreet = '';
                String MailingCity = '';
                String MailingState = '';
                String MailingPostalCode = '';
                
                
                //List<contact> listContacts = [select id,email,name,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,accountid from contact where id =: lstOppContactRoles[0].contactid];
                
                //Take the address from the contact linked with the opp
                if(lstOppContactRoles.size() == 0)
                {
                    MailingStreet = opp.account.billingstreet;
                    MailingCity = opp.account.billingcity;
                    MailingState = opp.account.billingstate;
                    MailingPostalCode = opp.account.billingpostalcode;
                    
                }
                else
                {
                    MailingStreet = lstOppContactRoles[0].Contact.mailingstreet;
                    MailingCity = lstOppContactRoles[0].Contact.mailingcity;
                    MailingState = lstOppContactRoles[0].Contact.mailingstate;
                    MailingPostalCode = lstOppContactRoles[0].Contact.mailingpostalcode;
                }
                
                //Create the quote here
                Quote q = new Quote();
                q.OpportunityId = opp.id;
                q.name = 'Quote : Online Payment - ' + Opp.Name;
                q.Notes_about_your_order__c = 'N/A';
                
                
                q.Status = 'Draft';
                q.BillingName = opp.account.name;
                q.BillingStreet =MailingStreet;
                q.BillingCity =MailingCity;
                q.BillingState =MailingState;
                q.BillingPostalCode =MailingPostalCode;
                
                q.ShippingName = opp.account.name;
                q.ShippingStreet =MailingStreet;
                q.ShippingCity =MailingCity;
                q.ShippingState =MailingState;
                q.ShippingPostalCode =MailingPostalCode;
                q.Pricebook2Id = opp.Pricebook2Id;
                
                insert q;
                
                //Create quote line items based on opp line items
                
                List<QuoteLineItem> listQuoteLineItem = new List<QuoteLineItem>();
                for(Opportunitylineitem OppLineItem : lstOpplineItems)
                {
                    QuoteLineItem qlt = new QuoteLineItem();
                    
                    
                    qlt.PricebookEntryId  = OppLineItem.PricebookEntryId ;
                    qlt.Product2Id   = OppLineItem.Product2Id  ;
                    qlt.Quantity   = OppLineItem.Quantity ;
                    qlt.UnitPrice   = OppLineItem.UnitPrice  ;
                    qlt.QuoteId   = q.id ;
                    
                    listQuoteLineItem.add(qlt);
                }
                
                insert listQuoteLineItem;
                
                
                saveQuotePDF.savePDF(q.id);
                
                
            }
            else //The payment request is now paid, hence a quote PDF will be created and sent to the customer
            {
                List<Quote> quotestoUpdate = new List<Quote>();
                List<Quote> quotes = [select id from quote where opportunityid =: pr.recordID];    
                
                QuoteDocument qDoc;
                if(!Test.isRunningTest())
                	qDoc = [SELECT Document,Id,QuoteId FROM QuoteDocument WHERE quoteid =: quotes[0].id]; 
                
               
                
                EmailTemplate templateId = [Select id from EmailTemplate where name = 'Customer VAT Receipt'];
                
                /// Send the email to the customer
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                // Create the email attachment with the quote PDF created above
                email.setTemplateID(templateId.Id);
                
                if(lstOppContactRoles.size() == 0)
                    email.setTargetObjectId(opp.account.personcontactid);
                else
                    email.setTargetObjectId(lstOppContactRoles[0].contactid);
                
                email.setSaveAsActivity(false);
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName('attachment.pdf');
                
                if(!Test.isRunningTest())
                	efa.setBody(qDoc.Document);
                else
               		efa.setBody(Blob.valueOf('Unit Test Attachment Body'));
                
                String[] toAddresses;
                if(lstOppContactRoles.size() == 0)
                    toAddresses = new String[] {opp.account.PersonEmail};
                        else
                        toAddresses = new String[] {lstOppContactRoles[0].contact.email};
                            
                            //String[] toAddresses = new String[] {opp.account.PersonEmail};
                            String[] ccAddresses = new String[] {opp.owner.email};
                                
                                email.setToAddresses( toAddresses );
                email.setCcAddresses( ccAddresses );
                //email.setPlainTextBody( 'This is a simple email body' );
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                
                Messaging.SendEmailResult [] r =
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
                
                
                //Once the email is sent to the customer with Quote and PDF attached, the quote status will be changed to accepted.
                if(quotes.size()>0)
                {
                    quotes[0].status = 'Accepted';
                    quotestoUpdate.add(quotes[0]);
                }
                
                if(quotestoUpdate.size()>0)
                	update quotestoUpdate;
                
                //Finally the Opp stage will be changed to Invoiced.
                opp.StageName = 'Invoiced';
                
                update opp;
            }
        }
        
        
}