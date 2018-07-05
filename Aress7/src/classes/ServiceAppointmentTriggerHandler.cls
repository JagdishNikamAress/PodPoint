public class ServiceAppointmentTriggerHandler {
    
     public static boolean run = true;
    
    //This method creates online payment oppty and Quotes
    public static void createOnlinePayOpptynQuote(SET<Id> woIdSet,SET<Id> caseIdSet){
        Opportunity oppRec;
        FeedItem post;
        Id opRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId();
        List<Opportunity> OpptyList = new List<Opportunity>();
        List<Quote> quoteList = new List<Quote>();
        List<FeedItem> feedList = new List<FeedItem>();
        Map<Id, Attachment> attchmentMap= new Map<Id, Attachment>([SELECT ParentId, Name, Id,OwnerId , Body FROM Attachment where ParentId IN : woIdSet]);
        List<Attachment> attachments = new List<Attachment>();
        List<WorkOrder> woList = [SELECT ID,Status,Incomplete_Reason__c,Case.Id,Case.AccountId FROM WorkOrder WHERE ID IN:woIdSet];
        List<Case> caseList =  [SELECT ID,Account.name,AccountId FROM Case WHERE ID IN:caseIdSet];
        For(WorkOrder woRec:woList){
            for(Case caseRec:caseList){
                oppRec = new Opportunity(Name ='HC Online Payment - '+caseRec.Account.Name,RecordTypeId=opRecordTypeId,AccountId=caseRec.AccountId,CloseDate = Date.today(),StageName = 'Unassigned');
                OpptyList.add(oppRec); 
                // quoteList.add(new Quote(Name,OpportunityId=,ExpirationDate,Notes_about_your_order__c));
            }
        }
        Insert OpptyList;
        
        System.debug('OpptyList=>'+OpptyList);
        Quote qtRec = new Quote(Name =oppRec.Name, OpportunityId= oppRec.Id,ExpirationDate =Date.today() ,Notes_about_your_order__c = 'N/A');
        quoteList.add(qtRec);
        Insert quoteList;
        for(WorkOrder wo : woList){ 
            for(Case caseRec1:caseList){
                for(Opportunity opRec:OpptyList){
                    for(Attachment file : attchmentMap.values()) {
                        Attachment newFile = file.clone();
                        newFile.ParentId = opRec.Id;
                        attachments.add(newFile);
                    }
                 }
                 post = new FeedItem(ParentId = caseRec1.Id,Body = 'Add Work Required');
                 feedList.add(post);
            }
        }    
        Insert post;
        Insert attachments;
        
        //FeedItem post = new FeedItem(ParentId = ,Body = 'Add Work Required');
        //feedList.add(post);
        //Insert post;
    }

}