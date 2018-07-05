/**
	* @author: 			Prasun Banerjee
	* @date:   			28/01/2016
	* @description: 	This is the test class for the Trigger - Trigger_Quote
	* @param:			N/A 
	* @moficationlog: 	N/A
	*/
@isTest
public class OrderTrigger_Test 
{
	static testMethod void validateTrigger()
    {
        //Create a test account
        Account Acc = new Account(Name='Test Account');
        insert Acc;
        
        Contact con = new Contact(Lastname = 'Test Contact',accountid=acc.id);
        insert con;
        
        //Create a test opportunity
        Opportunity opp = new Opportunity(Name='Test Opportunity',accountid=acc.id,closedate=System.today(),StageName='Qualification');
        opp.RecordTypeId = [Select Id,SobjectType,DeveloperName From RecordType where DeveloperName ='Commercial' and SobjectType ='Opportunity' limit 1].Id;

        Insert opp;
        
        OpportunityContactRole ocr1 = new OpportunityContactRole(opportunityid=opp.id,contactid=con.id,IsPrimary=true);
        insert ocr1;
        
        Order o = new Order(accountid=acc.id,Opportunityid=opp.id,status='Draft',EffectiveDate=System.today());
        insert o;
       
        delete o;
    }
}