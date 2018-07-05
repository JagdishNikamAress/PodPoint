public with sharing class AddAttendees {
    
    //public list < Contact > AssociatedContacts {get;set;}
    public list <AttendeeWrap> AssociatedContacts {get;set;}
    public Event Evt;
    //public boolean IsSelected {get;set;}
    public String RelatedToAccountid{get;set;}
    public boolean isRender{get;set;}
    
    public AddAttendees(ApexPages.StandardController controller) {
        this.Evt = (event) controller.getRecord();
        RelatedToAccountid = ApexPages.currentPage().getParameters().get('RelatedToAccountid');
        System.debug('======= >Passed accountid is '+RelatedToAccountid);
        Evt.Ownerid = Userinfo.getUserid();
        evt.whatid = RelatedToAccountid;
        isRender = false;
        getAccountDetails();
    }
    
    public PageReference getAccountDetails() {
        //AssociatedContacts = [Select FirstName, LastName from Contact where Accountid = : Evt.whatid];
        AssociatedContacts = new List<AttendeeWrap>();
        for(Contact c : [Select FirstName, LastName,Name,Email from Contact where Accountid = : Evt.whatid]){
            AssociatedContacts.add(new AttendeeWrap(c));
        }
        return Null;
    }
    
    public void Customsave() {
        evt.Subject = evt.Subject;
        evt.Ownerid = Userinfo.getUserid();
        evt.whatid = RelatedToAccountid;
        evt.Location = evt.Location;
        evt.StartDateTime = evt.StartDateTime;
        evt.EndDateTime = evt.EndDateTime;
        evt.type = evt.type;
        evt.description = evt.description;
        evt.IsAllDayEvent = evt.IsAllDayEvent;
        evt.IsReminderSet = evt.IsReminderSet;
        evt.ReminderDateTime = evt.ReminderDateTime;
        
        try {
            insert Evt;
            isRender = true;
            
            
        } catch (DMLException e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL, +e.getmessage()));
            
        }
        
    }
    public pagereference AddAttendees(){
         list<EventRelation> AttendeesToInsert = new list<EventRelation>();
         if(AssociatedContacts!=Null && !AssociatedContacts.isEmpty()){
             
             For(AttendeeWrap aw:AssociatedContacts){
                EventRelation Attendees = new EventRelation();
                if(aw.isSelected == True){
                    Attendees.RelationId = aw.con.id;
                    Attendees.Status = 'New';
                    Attendees.EventId = evt.id;
                    AttendeesToInsert.add(Attendees);
                }
              }
              System.debug('Attendees list values=========>'+AttendeesToInsert);
            }
            pagereference pr;
            if(AttendeesToInsert!=Null && !AttendeesToInsert.isEmpty()){
                
                    insert AttendeesToInsert;
                    pr = backtoAccountDetail();
                
            }
        return pr;
    }
    public pagereference backtoAccountDetail(){
        String RecordURL = URL.getSalesforceBaseUrl().toExternalForm() +'/' + RelatedToAccountid;
        pagereference pr = new pagereference(RecordURL);
        pr.setRedirect(true);
        return pr;
    }
    
    public class AttendeeWrap{
        public Contact con {get;set;}
        public Boolean isSelected {get;set;}
        public String msg {get;set;}
        public AttendeeWrap(Contact c){
            con = c;
            isSelected = FALSE;
            msg = c.Email != null ?'':'Invitee will not receive invitation for not having valid email addresses';
        }
    }
                   
    
}