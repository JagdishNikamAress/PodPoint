@isTest
private class generatePDFQuoteOnlinePayment_Test {

    private static testMethod void doTest() {

		Test.startTest();
        
 		Account acc = new Account(LastName='Test Account',billingstreet='Street',billingcity='City',billingpostalcode='123',personemail='test@test.com');
        acc.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where Name ='Person Account' and SobjectType ='Account' limit 1].Id;
        insert acc;
        
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
     	opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Online_Payment' and SobjectType ='Opportunity' limit 1].Id;

        insert opp;
        
        
        //ChargentSFA__Payment_Request__c pr = new ChargentSFA__Payment_Request__c(ChargentSFA__Opportunity__c = opp.id,ChargentSFA__Status__c='Created');
        //insert pr;
        
        List<generatePDFQuoteOnlinePayment.payment> prs = new List<generatePDFQuoteOnlinePayment.payment>();        
        generatePDFQuoteOnlinePayment.payment singlepr = new generatePDFQuoteOnlinePayment.payment();
        singlepr.recordID = opp.id;
        singlepr.status = 'opp.stagename';
        
        prs.add(singlepr);	
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());  
        generatePDFQuoteOnlinePayment.generatePDF(prs);
        
        test.StopTest();
        
        
        

    }
}