/**
	* @author: 			Prasun Banerjee
	* @date:   			28/01/2016
	* @description: 	This is the test class for the Trigger - Trigger_Quote//Last Modified by Nilesh More(27/12/2017)
	* @param:			N/A 
	* @moficationlog: 	N/A
	*/
	
@isTest
public class Trigger_Quote_Test 
{
	static testMethod void validateTrigger()
    {
        //Create a test account
        Account Acc = new Account(Name='Test Account');
        insert Acc;
        
        Contact con = new Contact(Lastname = 'Test Contact',accountid=acc.id);
        insert con;
        
        //Create a test opportunity
        List<String> OpptyIds = new List<String>();
        Opportunity opp = new Opportunity(Name='Test Opportunity',accountid=acc.id,closedate=System.today(),StageName='Qualification');
        opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;

        Insert opp;
        
        OpptyIds.add(opp.Id);
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        //Create a test quote
        Quote qt = new Quote(name='Test Quote',opportunityid=opp.id,shippingstreet='test street',billingstreet='test street',shippingcity = 'City',billingcity = 'City',shippingpostalcode = '123',billingpostalcode = '123' ,Notes_about_your_order__c='test note');
        Insert qt;
        
        String bodyStr='Test Body';
        
        Attachment att=new Attachment();
        att.Body=Blob.valueOf(bodyStr);
        att.Name='Note_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.txt';
        att.parentId=qt.id;
        insert att;
         
        opp.SyncedQuoteId =qt.id;
        update opp;       
        //Change the status to accepted. It will custom error written in the trigger as there will be no attachment.
        qt.Status = 'Accepted';
        //qt.IsSyncing='True';
         
        //update qt;
        //QuoteTriggerHandlerNew.createCommCase(OpptyIds);
        
    }
}