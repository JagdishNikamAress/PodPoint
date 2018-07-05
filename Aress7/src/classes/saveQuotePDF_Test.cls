@isTest(seealldata=true)
private class saveQuotePDF_Test {

    private static testMethod void doTest() {

		Test.startTest();
        
 		Account acc = new Account(LastName='Test Account',billingstreet='Street',billingcity='City',billingpostalcode='123',personemail='test@test.com');
        acc.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where Name ='Person Account' and SobjectType ='Account' limit 1].Id;
        insert acc;
        
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
     	opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Online_Payment' and SobjectType ='Opportunity' limit 1].Id;

        insert opp;
        
        Quote q = new Quote(opportunityid=opp.id,name='TestQuote');
        
	
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());  
        saveQuotePDF.savePDF(q.id);
        
        test.StopTest();
        
        
        

    }
}