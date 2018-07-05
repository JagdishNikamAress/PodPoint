@isTest
private class SlackPublisherOrder_Test {

    private static testMethod void doTest() {

        Test.startTest();
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Order' and isActive=true and name='Managed Installation'];

        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        //Order cs = new Order(Status = 'Draft',recordtypeid=rtypes[0].id,accountid = acc.id,effectivedate=Datetime.now().Date());
        //insert cs;
		
        List<SlackPublisherOrder.ords> css = new List<SlackPublisherOrder.ords>();        
        SlackPublisherOrder.ords singleCS = new SlackPublisherOrder.ords();
        singleCS.orderNumber = '123'; //cs.ordernumber;
        singleCS.status = 'Draft'; //cs.status;
        singleCS.id = '123'; //cs.id;
        singleCS.type = 'Managed Installation'; //rtypes[0].name;
        singleCS.channel = 'Install';
        
        css.add(singleCS);
     

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        SlackPublisherOrder.postToSlackCasesUpdate(css);
        test.StopTest();
       

    }
}