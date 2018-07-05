public class CreateContactControllerNew {
    
    public list<ContactWrapper> conWrapList {get;set;}
    public Account acct {get;set;}
    public contact cont{get;set;}
    public Integer rowIndex {get;set;}
    
    public CreateContactControllerNew(ApexPages.StandardController controller){
        
        cont = new Contact();
        conWrapList = new list<ContactWrapper>();
        
        for(Integer i=0;i<10;i++){
            conWrapList.add(new ContactWrapper());
            System.debug('conWrapList=>'+conWrapList);
        }
    }
    
    public void deleteRow() {
        rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        conWrapList.remove(rowIndex-1);
    }
    
    public void addRow() {
        for(Integer i=0;i<10;i++){
            conWrapList.add(new ContactWrapper());
        }
    }
    
    public PageReference submit() {
        Set<String> newContactEmails = new Set<String>();
        for(ContactWrapper conWrap : ConWrapList){
            if(conWrap.Email != '' && conWrap.lastName != ''){
                newContactEmails.add(conWrap.Email);
            }
        }
        system.debug('newContactEmails:>>'+newContactEmails);
        
        Set<String> existingConEmails = new Set<String>();
        List<Contact> newConList = [SELECT Id, Email FROM Contact WHERE Email IN:newContactEmails];
        System.debug('newConList=>'+newConList);
        
        for(Contact con : newConList){
            existingConEmails.add(con.Email);
        }
        system.debug('existingConEmails:>>'+existingConEmails);
        
        
        list<ContactWrapper> validContactList = new list<ContactWrapper>();
        list<Contact> validContacts = new list<Contact>();
        for(ContactWrapper conWrap : ConWrapList){
            if(!existingConEmails.contains(conWrap.Email)){
                if(conWrap.lastName != null && conWrap.lastName != ''){	 // As last Name is mandatory on Contact, create COntact only when Last Name is not empty
                    Contact con = new Contact();
                    con.firstName = conWrap.firstName;
                    con.lastName = conWrap.lastName;
                    con.Email = conWrap.email;
                    con.AccountId = cont.AccountId;
                    //newConEmails.add(conWrap.email);
                    validContacts.add(con);
                }
                else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Required field Missing.');
                    ApexPages.addMessage(myMsg); 
                }
            }
         }			
    
        system.debug('validContacts:>>'+validContacts);
        if(!validContacts.isEmpty()){
            insert validContacts;
        }
        
        
        List<Contact> newConList2 = [SELECT Id, Email FROM Contact WHERE Email IN:newContactEmails];
       // System.debug('newConList2=>'+newConList2[0]+newConList2[1]);
        List<Account> accList = [SELECT ID,Name FROM Account WHERE Id=:cont.AccountId];
        
        
        //Insert Event For Account
        Event E = new Event();
        E.Type = 'CPD';
        E.Subject = 'CPD - '+accList[0].Name;
        E.WhatId = cont.accountId;
        datetime dtstart = System.now();//Datetime.newInstance(2017, 20 , 12, 00, 00, 00); 
        datetime dtend = System.now().addHours(2);//Datetime.newInstance(2017, 20 , 12, 01, 00, 00);
        E.EndDateTime = dtend;
        E.StartDateTime = dtstart; 
        E.ActivityDateTime = dtstart; 
        //E.DurationInMinutes = 60;
        insert E;
        System.debug('E=>'+E);
        
        // newConList.addAll(validContacts);
        List<EventRelation> erList = new List<EventRelation>();
        for(Contact con: newConList2){
            EventRelation er  = new EventRelation();
            er.EventId = E.Id;
            er.RelationId = con.Id;
            er.IsInvitee = true;
            erList.add(er);
        }
        
       
        
        insert erList;
        system.debug('erList=>'+erList);
        
        // Redirect user to Account detail page
        PageReference pageRef = new PageReference('/'+cont.AccountId);
        return pageRef;    
    }
    
    public class ContactWrapper{
        public string firstName{get;set;}
        public string lastName{get;set;}
        public string email{get;set;}
        
        public ContactWrapper(){
            firstName = '';
            lastName = '';
            email = '';
        }
    }
}