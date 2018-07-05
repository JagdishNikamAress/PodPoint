@isTest
public class SecondJobTest {
    
    @testSetup
    public static void setup(){
        
           Product2 prd1 = new Product2 (Name='Data & MIS (1 Year)',Description='Test Product Entry 1',productCode = 'PF-05', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Deliver - Single Solo', Description='my fee',productCode = 'PF-01',isActive=true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product', Description='my fee',productCode = 'PF-02',isActive=true);
        insert prd3;
        
        Id standardPbID = Test.getStandardPricebookId();
        
        
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook',Description='Test Pricebook', isActive=true);
        insert pbk1;
        
        //Add those products to a pricebook
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true , UseStandardPrice = false);
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPbID,UnitPrice=0.0, isActive=true,  UseStandardPrice = false);
        insert pbe3;
        
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='TestFirstName',Lastname='TestLastName',MailingCity='City',MailingStreet='Street',MailingPostalCode='12365',accountid=acc.id,FieldAware_ID__c='Test',Location_ID__c='Test Location');
        Insert con;
        
        More_FieldAware_Address__c moreaddress = new More_FieldAware_Address__c(City__c='City',Contact__c=con.Id,Country__c='Country',State__c='State',Location_ID__c='',Postal_Code__c='123');
        insert moreaddress;
        
        Opportunity opp = new Opportunity(Name='Test Opp',AccountId=acc.ID,CloseDate=Datetime.now().addDays(3).Date(),StageName='Qualification',Oportunity_Type__c='Home');
        insert opp;
    }
    
   static testmethod  void testAcount(){
        
        Opportunity opp = [select id,name from Opportunity where name='Test Opp'];
         Test.startTest();
         
        SecondJob ad = new SecondJob(opp, 'CA');
        SecondJob updater = new SecondJob(opp, 'CA');
        // startTest/stopTest block to force async processes to run
               System.enqueueJob(ad);
        ID jobID = System.enqueueJob(updater);
        Test.stopTest();       
        
    }
}