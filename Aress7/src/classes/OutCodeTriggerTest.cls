@isTest
public class OutCodeTriggerTest {
   public static testmethod void test01(){
      Outcode__c testoutcode = new Outcode__c();
      testoutcode.Name ='Test';
       testoutcode.Related_Postcode__c = 'CW12ab23';
      insert testoutcode;
   }
}