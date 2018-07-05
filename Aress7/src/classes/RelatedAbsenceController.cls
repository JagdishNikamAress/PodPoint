public class RelatedAbsenceController {
    public List<ResourceAbsence> absences{get;set;} 
    public ServiceResource resources {get;set;} 
    public ServiceResource resource {get;set;} 

    //Constructor 
    public RelatedAbsenceController(ApexPages.StandardController controller) { 
        resource = (ServiceResource)controller.getRecord();      
        resources = [SELECT id FROM ServiceResource WHERE id=: resource.id LIMIT 1]; 
        absences = [SELECT Duration__c,FSL__Approved__c , Slot_Options__c, End, Start, Type, ResourceId, Id, AbsenceNumber, RecordTypeId FROM ResourceAbsence WHERE ResourceId = :resources.id ORDER BY AbsenceNumber];     
    } 

    //This method is to create a new Absence while clicking on the Add Absence button 
    public pageReference newAbsence(){  
        /*pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/0Hn/e?&retURL=' + resources.id);  
        return pageRef; */
        pageReference pageRef = new pageReference('/apex/AddabsencePageTest?id='+resource.Id);
        return pageRef;
        
    } 
    //This method is to edit the existing contact record while clicking the Edit link 
    /*public pageReference editContact(){  
        String contactId = Apexpages.currentpage().getParameters().get('contactId');  
        pageReference pageRef = new pageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/' + contactId + '/e?retURL=' + accounts.id);  
        return pageRef;  
    }    */


    //This method is to delete the Absence record while clicking the Del link 
    public pageReference deleteContact(){  
        String absenceId = Apexpages.currentpage().getParameters().get('absenceId');  
        System.debug('absenceId'+absenceId);
        user Amy = [select id,FirstName, LastName,Email from user where name ='Amy Lambourne'];//Amy Lambourne
        ResourceAbsence absenceList = [SELECT Id,Duration__c,Type,Slot_Options__c FROM ResourceAbsence WHERE id = : absenceId LIMIT 1];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if(absenceList.type == 'Holiday' || absenceList.type == 'Parental' || absenceList.type == 'Medical'){
            EmailTemplate template = [SELECT Id, DeveloperName FROM EmailTemplate WHERE DeveloperName='Absence_is_Deleted'];
            
            Contact con = new Contact();
            con.FirstName = Amy.FirstName;
            con.LastName =  Amy.LastName;
            con.Email = Amy.Email;
            Insert con;
            
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setTemplateID(template.Id);
            msg.setWhatId(absenceList.Id);
            msg.setTargetObjectId(con.Id);
            msg.setSaveAsActivity(false);
            mails.add(msg);
            System.debug('mails===>'+mails);
            Messaging.sendEmail(mails);
            delete con;
        }
        
        delete absenceList; 
        
        PageReference pageRef = new PageReference('/apex/AbsenceRelatedList?id=' + +resource.id );
        pageRef.setRedirect(true); 
        //PageReference redirectPage = new PageReference('/apex/AbsenceRelatedList?id='+resource.id); 
        return pageRef;  
    }   
}