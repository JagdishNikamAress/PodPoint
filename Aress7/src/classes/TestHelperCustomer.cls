@isTest(seealldata=true)
Private class TestHelperCustomer{
 @isTest Static void  TestcreateCustomer()
 {
     test.StartTest();
     Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
     helperCustomer hc = new helperCustomer();
     hc.createCustomer('name','1111','1111', 'billingStreet','billingCity','billingPostalCode','billingcountry','12345', 'email.email.com');
     test.StopTest();
 }
   
    
 @isTest Static void  TestupdateCustomer()
 {
     test.StartTest();
     Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
     helperCustomer hc = new helperCustomer();
     hc.updateCustomer('Fieldawareid','name','1111', 'billingStreet','billingCity','billingPostalCode','billingcountry','12345', 'email.email.com');
     test.StopTest();
 }
    
    @isTest Static void  TestupdateLocation()
    {
        test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        helperCustomer hc = new helperCustomer();
        hc.updateLocation('Fieldawareid','LocationID', 'billingStreet','billingCity','billingPostalCode','billingcountry');
        test.StopTest();
    }   
     @isTest Static void  TestHttpRequestGETMethod()
     {
         test.StartTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         helperCustomer hc = new helperCustomer();
         HttpResponse res = hc.HttpRequestGETMethod('EndPoint','Method');         
         test.StopTest();
     }
    @isTest Static void  TestHttpRequestPOSTMethod()
     {
         test.StartTest();
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         helperCustomer hc = new helperCustomer();
         HttpResponse res = hc.HttpRequestPOSTMethod('EndPoint','Method','TestBody');         
         test.StopTest();
     }
		
}