@isTest
private class SlackPublisher_Test {

    private static testMethod void doTest() {

		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
 		
        List<SlackPublisher.Oppty> opps = new List<SlackPublisher.Oppty>();        
        SlackPublisher.Oppty singleopp = new SlackPublisher.Oppty();
        singleopp.opptyName = 'opp.name';
        singleopp.stage = 'opp.stagename';
        singleopp.channel = 'Install';
        singleopp.id = 'opp.id';
      
        
        opps.add(singleopp);
        
        test.StopTest();
        
        
        SlackPublisher.postToSlack(opps);

    }
}