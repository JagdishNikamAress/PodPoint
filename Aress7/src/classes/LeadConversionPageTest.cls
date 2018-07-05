@isTest
public with sharing class LeadConversionPageTest
{
	static testMethod void testLeadConversion()
    {
		Account acc = new Account();
		acc.Name ='Test';
		insert acc;
	
		Lead lead=new Lead(LastName='Doe',FirstName='John',Company='Test', Account_Classification__c = 'UK', Account_Route_to_Market__c = 'Automotive', Account_Type__c = 'dealer');
		insert lead;  
        
        Account acc2 = new Account();
		acc2.Name ='Test2';
		insert acc2;
	
		Lead lead2=new Lead(LastName='Doee',FirstName='Johnn',Company='Test2');
		insert lead2;
        
        Test.startTest();
			
			ApexPages.StandardController sc = new ApexPages.StandardController(lead);
			PageReference pageRef = Page.LeadConversionPage;
			pageRef.getParameters().put('id', String.valueOf(lead.Id));
            List<LeadStatus> convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true];
			LeadConversionPageController controller=new LeadConversionPageController(sc);
			controller.getlstCompanyInfo();
			controller.getConvertedStatus();
			controller.strAccountId= acc.id;
            controller.strLeadid= convertStatus[0].id;
            controller.bolCreateOpp = true;
			controller.convertLead();
            
             
                   
        test.stopTest();
        
    }
    
}