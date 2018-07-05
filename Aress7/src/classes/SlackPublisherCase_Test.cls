@isTest
private class SlackPublisherCase_Test {

    private static testMethod void doTest() {

        Test.startTest();
        Case cs = new Case(Status = 'Draft');
        insert cs;
		
        List<SlackPublisherCase.Cases> css = new List<SlackPublisherCase.Cases>();        
        SlackPublisherCase.Cases singleCS = new SlackPublisherCase.Cases();
        singleCS.caseNumber = cs.CaseNumber;
        singleCS.status = cs.status;
        singleCS.id = cs.id;
        singleCS.type = cs.type;
        singleCS.action = 'Create';
        singleCS.channel = 'Install';
        
        css.add(singleCS);
     

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        SlackPublisherCase.postToSlackCasesUpdate(css);
        test.StopTest();
       

    }
}