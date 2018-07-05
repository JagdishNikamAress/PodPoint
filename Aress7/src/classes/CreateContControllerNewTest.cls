@isTest
public class CreateContControllerNewTest {
    public static testMethod void testSubmit(){
        Account acc = new Account(Name = 'Test Account');
        Insert acc;
        Contact con = new Contact(FirstName='Test',Lastname='Name',email='test@test.com',accountid=acc.id);
        Insert con;
        
        CreateContactControllerNew.ContactWrapper wrap = new CreateContactControllerNew.ContactWrapper();
        wrap.firstName = 'test';
        wrap.lastname = 'Name';
        wrap.email = 'test@test.com';
        CreateContactControllerNew.ContactWrapper wrap1 = new CreateContactControllerNew.ContactWrapper();
        wrap1.firstName = 'test';
        wrap1.lastname = 'Name';
        wrap1.email = 'test1@test.com';
        List<CreateContactControllerNew.ContactWrapper> wrapl = new List<CreateContactControllerNew.ContactWrapper>();
        wrapl.add(wrap);
        wrapl.add(wrap1);
        
        PageReference pageRef = Page.CreateContactPageNew;
        pageRef.getParameters().put('rowIndex', '1');
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(con);
        CreateContactControllerNew obj = new CreateContactControllerNew(sc);
        obj.cont = con;
        obj.acct = acc;
        obj.conWrapList = wrapl;
        obj.addRow();
        obj.submit();
        obj.deleteRow();
    }
}