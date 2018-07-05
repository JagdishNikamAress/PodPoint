Public class WorkOrderTriggerHelper {
    public static boolean run = true;
    public static Set<Id> WOId = new Set<Id>();
    public static Set<Id> OppId = new Set<Id>();
    //Contains Id of the WO. When WO becomes 'Incomplete' and WO Incomplete_Reason__c =='Additional Works Required'
    public static SET<Id> woIds = new SET<Id>();
    //Contains Id of the Case When related WO becomes 'Incomplete' and WO Incomplete_Reason__c =='Additional Works Required'
    public static SET<Id> caseIds = new SET<Id>();
    public static Set<Id> CaseIdSet = new Set<Id>();
  // Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
    Public WorkOrderTriggerHelper(){
    }
    
    //Only one WO for each recordtype 
    public static void oneWoForeachRecType(List<WorkOrder> woList){
        Id woRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
        for(WorkOrder wo:woList){
            WOId.add(wo.Id);
            CaseIdSet.add(wo.CaseId);
        }
        Map<Id,WorkOrder> WOMap = new Map<Id,WorkOrder>([SELECT Id,CaseId,Status  FROM WorkOrder WHERE ((CaseId in : CaseIdSet) AND (Status!='Completed' AND Status!='Incomplete' AND Status!='Rejected') AND RecordTypeId =: woList[0].RecordTypeId)]);
        if(WOMap.size()!=0){
            woList[0].addError('There is already an ongoing Work Order of this type');
        } 
    }
    
    public static void afterUpdateHandle(SET<Id> woIdSet,SET<Id> caseIdSet){
        Id surveyWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
        Id commWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
        Id maintenanceWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
        Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
        //Id woRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
        Map<Id,WorkOrder> woMap2 = new Map<Id,WorkOrder>([SELECT ID,RecordTypeId,CaseId,Technician_Notes__c,Survey_Description__c,Status FROM WorkOrder WHERE ID IN:woIdSet]);   
        Map<Id,Case> caseMap2 = new Map<Id,Case>([SELECT ID,Survey_Status__c,Technician_Notes__c,Survey_Description__c,Install_Status__c,Maintenance_Status__c FROM Case WHERE Id IN:caseIdSet]);
        
        if(!woMap2.values().isEmpty()){
            for(WorkOrder wo:woMap2.values()){
                case caseRec=caseMap2.get(wo.CaseId);
                // for(Case caseRec:caseMap2.values()){ 
                System.debug('Status change here...');
                if(wo.RecordTypeId==surveyWORecordTypeId){
                    if(wo.Status=='Unassigned')caseRec.Survey_Status__c = 'Requested';
                    if(wo.Status=='Scheduled')caseRec.Survey_Status__c = 'Scheduled';
                    if(wo.Status=='Confirmed')caseRec.Survey_Status__c = 'Confirmed';
                    if(wo.Status=='Completed')caseRec.Survey_Status__c = 'Completed';
                    if(wo.Status=='Active')caseRec.Survey_Status__c = 'Active';
                    if(wo.Status=='Incomplete')caseRec.Survey_Status__c = 'Incomplete';
                    if(wo.Status=='On Hold')caseRec.Survey_Status__c = 'On Hold';
                    if(wo.Status=='Rejected')caseRec.Survey_Status__c = 'Cancelled';
                }
                System.debug('outside if'+wo.Status);
                System.debug('outside if'+caseRec.Install_Status__c);
                if(wo.RecordTypeId==commWORecordTypeId || wo.RecordTypeId==hcinstallWORecordTypeId){
                    
                    System.debug('Status change here...commercial opptyyyyy');
                    if(wo.Status=='Unassigned')caseRec.Install_Status__c = 'Requested';
                    if(wo.Status=='Scheduled')caseRec.Install_Status__c = 'Scheduled';
                    if(wo.Status=='Confirmed')caseRec.Install_Status__c = 'Confirmed';
                    if(wo.Status=='Completed')caseRec.Install_Status__c = 'Completed';
                    if(wo.Status=='Active')caseRec.Install_Status__c = 'Active';
                    if(wo.Status=='Incomplete')caseRec.Install_Status__c = 'Incomplete';
                    if(wo.Status=='On Hold')caseRec.Install_Status__c = 'On Hold';
                    if(wo.Status=='Rejected')caseRec.Install_Status__c = 'Cancelled';
                }
                
                if(wo.RecordTypeId==maintenanceWORecordTypeId){
                    if(wo.Status=='Unassigned')caseRec.Maintenance_Status__c = 'Requested';
                    if(wo.Status=='Scheduled')caseRec.Maintenance_Status__c = 'Scheduled';
                    if(wo.Status=='Confirmed')caseRec.Maintenance_Status__c = 'Confirmed';
                    if(wo.Status=='Completed')caseRec.Maintenance_Status__c = 'Completed';
                    if(wo.Status=='Active')caseRec.Maintenance_Status__c = 'Active';
                    if(wo.Status=='Incomplete')caseRec.Maintenance_Status__c = 'Incomplete';
                    if(wo.Status=='On Hold')caseRec.Maintenance_Status__c = 'On Hold';
                    if(wo.Status=='Rejected')caseRec.Maintenance_Status__c = 'Cancelled';
                }
                //  }
            }
        }
        update caseMap2.values();
    }
    
    //This method creates online payment oppty and Quotes
    /*public static void createOnlinePayOpptynQuote(SET<Id> woIdSet,SET<Id> caseIdSet){
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
}*/
    
    //For new WO creation, add the "Work Order Tasks" based on Work Type
    public static void afterInsertHandlerMethod(Map<Id,WorkOrder> newWoMap){
        Work_Order_Task__c woTask;
        //List contains the WOT records
        List<Work_Order_Task__c> wotaskList = new List<Work_Order_Task__c>();
        
        //Map contains key as WorkTypeId and values as WorkOrder record
        SET<String> wtId = new SET<String>();
        Map<String,WorkOrder> wtIdWoMap = new Map<String,WorkOrder>();
        for(Workorder woRec1:newWoMap.values()){
            wtId.add(woRec1.WorkTypeId);
        }
        
        //FSL Task list contains the FSl tasks which worktypes are same as Workorder.
        List<FSL_Tasks__c> fslTaskList = [SELECT Id,Work_Type__c,RecordType.name FROM FSL_Tasks__c WHERE Work_Type__c IN:wtId];
        system.debug('fslTaskList===>'+fslTaskList);
        for(WorkOrder woRec:newWoMap.values()){
            for(FSL_Tasks__c fslTaskRec:fslTaskList){
                system.debug('fslTaskRec===>'+fslTaskRec);
                Id wotRecordTypeId = Schema.SObjectType.Work_Order_Task__c.getRecordTypeInfosByName().get(fslTaskRec.RecordType.name).getRecordTypeId();
                system.debug('wotRecordTypeId===>'+wotRecordTypeId);
                woTask = new Work_Order_Task__c(Work_Order__c=woRec.Id,Task__c=fslTaskRec.Id,RecordTypeId=wotRecordTypeId,Status__c='To do');
                wotaskList.add(woTask);
                system.debug('woTask===>'+woTask);
                
            }
        }
        system.debug('wotaskList===>'+wotaskList);
        Insert wotaskList;
        system.debug('wotaskList===>'+wotaskList);
    }
    
    public static void copyAttachmentsFrommCaseWo(List<WorkOrder> woList){
        Set<Id> parentCaseIdSet= new Set<Id>();
        for(WorkOrder wo: woList){
            parentCaseIdSet.add(wo.CaseId);
        }
        Map<Id,Case> CaseMap = new Map<Id,Case>([SELECT Id, CaseNumber,Status FROM Case where Id in : parentCaseIdSet]);
        Map<Id, ContentDocumentLink> contentDocLinkMap= new Map<Id, ContentDocumentLink>([ SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, ShareType, Visibility FROM ContentDocumentLink where LinkedEntityId In: parentCaseIdSet]);
        Set<Id> contentDocIdSet= new Set<Id>();
        for(ContentDocumentLink cdl: contentDocLinkMap.values()){
            contentDocIdSet.add(cdl.ContentDocumentId);
        }
        List<ContentDocumentLink> contentDocLinkList = new List<ContentDocumentLink>();
        for(WorkOrder wo:woList){
            for(ContentDocumentLink file : contentDocLinkMap.values()) {
                ContentDocumentLink newFile = new ContentDocumentLink();
                newFile.LinkedEntityId=wo.Id;
                newFile.ContentDocumentId=file.ContentDocumentId;
                newFile.ShareType='V';
                contentDocLinkList.add(newFile);                  
            }
        }
        insert contentDocLinkList;
    }
    
    public static void syncProdrequiredOnWoInsert(List<WorkOrder> woList){
          Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();

        for(WorkOrder wo:woList){
            if(wo.RecordTypeid==hcinstallWORecordTypeId){
            WOId.add(wo.Id);
            OppId.add(wo.Opportunity_Id__c);
            }
        }
        system.debug('WO Id -> '+WOId);
        system.debug('Opp Id -> '+OppId);
        System.debug('system.nowWTH'+system.now());
        Map<Id, OpportunityLineItem> oliMap = new Map<Id, OpportunityLineItem>([SELECT Id, OpportunityId, Product2Id,Quantity FROM OpportunityLineItem WHERE (OpportunityId =: OppId  and (Product_Family__c='Solo Units' OR Product_Family__c='Twin Units' OR Product_Family__c='Accessories' OR Product_Family__c='mounts'))]);
        system.debug('OLI List -> '+oliMap);
        
        Map<Id,WorkOrder> WOMap = new Map<Id,WorkOrder>([SELECT Id FROM WorkOrder WHERE Id in : WOId]);
        List<ProductRequired> Prod = new List<ProductRequired>();        
        for(WorkOrder w : WOMap.values()){
            for(OpportunityLineItem oli : oliMap.values()){
                ProductRequired pr = new ProductRequired();
                pr.ParentRecordId = w.Id;
                pr.Product2Id = oli.Product2Id;
                pr.Opportunity__c = oli.OpportunityId;
                pr.QuantityRequired = oli.Quantity;
                system.debug('pr.QuantityRequired' + pr.QuantityRequired);
                pr.WO_OppLineItem_Id__c = oli.id;
                Prod.add(pr);
            }
        }
        
        try{
            insert Prod;
            system.debug('Inserted Product Required -> '+Prod);
        }
        catch(exception e){
            system.debug('Exception -> '+e);
        }
    }
    
    // Logic to copy all attachments from WO to related case when WO status becomes COmpleeted/Incomplete
    /*    public static void syncAttachmentsFromWoToCase(Set<Id> woIdforattach){
Set<Id> CaseIdsSet = new Set<Id>();
Set<Id> OwnerIdsSet = new Set<Id>();
List<WorkOrder> woList=new List<WorkOrder>([SELECT Id,CaseId,Status,OwnerId,WorkOrder_CompletedOrIncomplete__c FROM WorkOrder where Id in: woIdforattach]);
for(WorkOrder wo:woList){
WOId.add(wo.Id);
CaseIdsSet.add(wo.CaseId);
OwnerIdsSet.add(wo.OwnerId);
}
Map<Id,WorkOrder> WOMapOld= new Map<Id,WorkOrder>([SELECT Id,CaseId,Status FROM WorkOrder where (Id in :woIdforattach and (Status='Completed' OR Status='Incomplete'))]);
Map<Id,WorkOrder> WOMap = new Map<Id,WorkOrder>([SELECT Id,CaseId,Status,WorkOrder_CompletedOrIncomplete__c FROM WorkOrder where (Id in :WOId and (Status='Completed' OR Status='Incomplete'))]);
profile pr;
if(test.isRunningTest()){
pr= [select id, name from profile where name='System Administrator'];
} else{
pr= [select id, name from profile where name='Technician'];
}
Map<Id,Case> CaseMap = new Map<Id,Case>([SELECT Id, CaseNumber,Status FROM Case where Id in :CaseIdsSet]);
Map<Id,User> OwnerMap = new Map<Id,User>([SELECT Id, ProfileId FROM User where Id in : OwnerIdsSet and ProfileId= : pr.Id]);
Map<Id, Attachment> attchmentMap= new Map<Id, Attachment>([SELECT ParentId, Name, Id,OwnerId , Body FROM Attachment where (ParentId in : WOId AND OwnerId in : OwnerMap.keySet())]);
List<Attachment> attachments = new List<Attachment>();
System.debug('WO in status complete or incomplete WOMap===>'+WOMapOld);
System.debug('WO in status complete or incomplete WOMap===>'+WOMap);
System.debug('WO in status complete or incomplete CaseMap===>'+CaseMap);
System.debug('WO in status complete or incomplete OwnerMap===>'+OwnerMap);
System.debug('WO in status complete or incomplete attchmentMap===>'+attchmentMap);
System.debug('WO in status complete or incomplete WOId===>'+WOId);

Map<Id, GoogleDoc> googleDocMap= new Map<Id, GoogleDoc>([SELECT Id, Url, ParentId, Name,OwnerId  FROM GoogleDoc where (ParentId in : WOId AND OwnerId in : OwnerMap.keySet())]);
List<GoogleDoc> googleDocs = new List<GoogleDoc>();
Map<Id, Note> noteMap= new Map<Id, Note>([ SELECT Id,ParentId, Title, Body, OwnerId FROM Note where (ParentId in : WOId AND OwnerId in : OwnerMap.keySet())]);
List<Note> notesList = new List<Note>();
Map<Id, ContentDocumentLink> contentDocLinkMap= new Map<Id, ContentDocumentLink>([ SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, ShareType, Visibility FROM ContentDocumentLink where (LinkedEntityId in : WOId)]);
Set<Id> contentDocIdSet= new Set<Id>();
for(ContentDocumentLink cdl: contentDocLinkMap.values()){
contentDocIdSet.add(cdl.ContentDocumentId);
}
Map<Id, ContentDocument> contentDocMap= new Map<Id, ContentDocument>([SELECT  OwnerId, ParentId, ContentAssetId, Id FROM ContentDocument where (Id in : contentDocIdSet AND OwnerId in : OwnerMap.keySet())]);
List<ContentDocumentLink> contentDocLinkList = new List<ContentDocumentLink>();
List<WorkOrder> worderList= new List<WorkOrder>();
for(WorkOrder wo : WOMap.values()){ 
if (wo.WorkOrder_CompletedOrIncomplete__c==false){

for(Attachment file : attchmentMap.values()) {
Attachment newFile = file.clone();
newFile.ParentId = wo.CaseId;
attachments.add(newFile);                  
}
// wo.WorkOrder_CompletedOrIncomplete__c=true;
//  worderList.add(wo);
for(GoogleDoc file : googleDocMap.values()) {
GoogleDoc newFile = file.clone();
newFile.ParentId = wo.CaseId;
googleDocs.add(newFile);                  
}
for(Note file : noteMap.values()) {
Note newFile = file.clone();
newFile.ParentId = wo.CaseId;
notesList.add(newFile);                  
}
for(ContentDocument file : contentDocMap.values()) {
ContentDocumentLink newFile = new ContentDocumentLink();
newFile.LinkedEntityId=wo.CaseId;
newFile.ContentDocumentId=file.Id;
newFile.ShareType='V';
contentDocLinkList.add(newFile);                  
}

wo.WorkOrder_CompletedOrIncomplete__c=true;
worderList.add(wo); 
}
}
update worderList;
insert attachments;
insert googleDocs;
//insert notesList;
insert contentDocLinkList;
}
*/
    
    public static void syncAttachmentsFromWoToCase(Set<Id> woIdforattach){
         System.debug('111111111111111111111111');
        id technicianid;
        id installmanagerid;
        Set<Id> CaseIdsSet = new Set<Id>();
        Set<Id> OwnerIdsSet = new Set<Id>();
        
        if(!woIdforattach.isEmpty()){
            System.debug('2222222222222222222222');
            Map<Id,WorkOrder> WOMap = new Map<Id,WorkOrder>([SELECT Id,CaseId,Status,WorkOrder_CompletedOrIncomplete__c FROM WorkOrder where (Id in : woIdforattach and (Status='Completed' OR Status='Incomplete'))]);
            profile pr;
            profile pr2;
            Set<id> prId= new Set<id>();
            if(test.isRunningTest()){
                pr= [select id, name from profile where name='System Administrator'];
                prId.add(pr.id);
            } else{
                System.debug('33333333333333333333');
                pr= [select id, name from profile where name='Technician User'];
                pr2= [select id, name from profile where name='Technician Manager'];
                technicianid = pr.id;
                installmanagerid = pr2.id;
                prId.add(pr.id);
                prId.add(pr2.id);
            }
            List<ContentDocumentLink> contentDocLinkList = new List<ContentDocumentLink>();
            if(!WOMap.isEmpty()){
                System.debug('444444444444444444');
                List<ContentDocumentLink> cdlList=new List<ContentDocumentLink>([SELECT Id, LinkedEntityId, ContentDocumentId, IsDeleted, SystemModstamp, ShareType, Visibility FROM ContentDocumentLink where (LinkedEntityId in : woIdforattach)]);
                system.debug('The value of the link'+cdlList);
                Map<id, ContentDocumentLink> contentDocLinkMap= new Map<id, ContentDocumentLink>();
                
                for(ContentDocumentLink cdl: cdlList){
                    contentDocLinkMap.put(cdl.ContentDocumentId, cdl);
                }
                Map<Id, ContentDocument> contentDocMap= new Map<Id, ContentDocument>([SELECT  OwnerId,Owner.profileId, ParentId, ContentAssetId, Id FROM ContentDocument where id in : contentDocLinkMap.keyset()]);
                
                for(ContentDocumentLink cdl: contentDocLinkMap.values()){
                    System.debug('repeat');
                    System.debug('contentDocMap'+contentDocLinkMap.values());
                      System.debug('contentDocMap'+contentDocMap.keyset());
                    
                    if(contentDocMap.containsKey(cdl.ContentDocumentId) && (contentDocMap.get(cdl.ContentDocumentId).owner.profileId == technicianid || contentDocMap.get(cdl.ContentDocumentId).owner.profileId == installmanagerid)){
                         System.debug('contentDocMap'+contentDocMap);
                        ContentDocumentLink newFile = new ContentDocumentLink();
                        newFile.LinkedEntityId=WOMap.get(cdl.LinkedEntityId).CaseId;
                        newFile.ContentDocumentId=cdl.ContentDocumentId;
                        newFile.ShareType='V';
                        contentDocLinkList.add(newFile);       
                    }
                }
                if(!contentDocLinkList.isEmpty()){
                    Try{
                        System.debug('insert555555555555555555');
                        Database.SaveResult[] lsr = Database.insert(contentDocLinkList,false);
                    } Catch(Exception e){
                        System.debug('The following exception has occurred: ' + e.getMessage());
                    }
                }
            }
            
        }
    }
    
    public static void checkforperticularWOTask(Set<Id> woIdforattach){ 
        /* 
* Logic to check fot WO task are completed before WO status becomes Completed/Incomplete
* Card #127
* 30/11/17
*/
        Map<Id,FSL_Tasks__c> FSLTaskMap=new Map<Id,FSL_Tasks__c>([select id, name from FSL_Tasks__c where name='PCB Photo' OR name='Termination Photo' OR name='Additional Materials Used Photo' OR name='Mains Supply Service Head Photo' OR name='Consumer Unit Photo(s)' OR name='Proposed Cable Run Photo' OR name='Earth Bonding Photo' OR name='Proposed Chargepoint Location Photo' OR name='Preferred Chargepoint' OR name='Installed Unit Photo' OR name='Additional Materials Used Photo' OR name='Completion Photos' OR name='Commissioning Form' OR name='Site Handover Form' OR name='Survey Form' OR name='Maintenance Form' OR name='Risk Assessment Method Statement' OR name='Wi-Fi Connected' OR name='Unit PSL/PG Number']);
        List<WorkOrder> woList=new List<WorkOrder>([SELECT Id,CaseId,Status,OwnerId,WorkOrder_CompletedOrIncomplete__c FROM WorkOrder where Id in: woIdforattach]);
        Map<Id,Work_Order_Task__c> WOTaskMap=new Map<Id,Work_Order_Task__c>([SELECT Status__c, Id, Name, Task__c, Work_Order__c FROM Work_Order_Task__c where Task__c in: FSLTaskMap.keySet() and Work_Order__c in : woIdforattach and Status__c !='Completed']);
        for (WorkOrder wo: woList)
            if(!WOTaskMap.isEmpty()){
                wo.addError('Please complete the Important WorkOrderTask before completeing the WorkOrder');
            }
        /*
* End of Logic to check fot WO task are completed before WO status becomes Completed/Incomplete
*/ 
    }
}