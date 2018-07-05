@isTest 
private class AllOrderPageController_Test {
    static testMethod void AllOrderPageController() 
    {
       Account acc = new Account(Name='Test Account');
       insert acc;
       
       Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id);
       Insert con;
       
       Case c = new Case(accountid=acc.id,Street__c = 'Street', City__c = 'City', Country__c ='Country',PostalCode__c ='1235645');
       Insert c;
        
       Opportunity opp = new Opportunity(Name='Test Opp',StageName='Negotiation',closedate=datetime.now().date(),accountid=acc.id);
       insert opp;
        
       Order ord1 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Ready for Dispatch',effectivedate=datetime.now().date());
       insert ord1;
        
       Order ord2 = new Order(Accountid = acc.id, OpportunityId = opp.id,status='Dispatched',effectivedate=datetime.now().date());
       insert ord2;
        
        //ApexPages.StandardController sc = new ApexPages.standardController(ord1);
        AllOrderPageController e = new AllOrderPageController();
        
       	e.getAllOrdersforiPro();
 

        
        
        //System.assertEquals(e.acct, a);
    }
}