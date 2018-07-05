trigger WorkOrderTrigger on WorkOrder (before insert, after insert, after update,before Update) {
    SET<Id> woIds = new SET<Id>();
    SET<Id> caseIds = new SET<Id>();
    set<id> set_caseid = new set<id>();
    boolean  b1=true;
    //Map<String,Id> WorkTypeMap;
    //List<WorkType> WorkTypeList;
    If(checkRecursive.checkk == true){
        
        /*WorkTypeList= [SELECT Id, name from WorkType];
WorkTypeMap=new Map<String,Id>();
for(WorkType wt: WorkTypeList){
WorkTypeMap.put(wt.Name, wt.Id);
}*/
        checkRecursive.callworktypemap();
    }   
    Map<Id,case> Finalcaseupdatemap = new  Map<Id,case>();
    List<WorkOrder> woListForSchedulEmail= new List<WorkOrder>();
    Set<Id> WOId = new Set<Id>();
    Set<Id> OppId = new Set<Id>();
    Set<Id> CaseIdSet = new Set<Id>();
    Set<Id> CaseIdSet2 = new Set<Id>();
    Set<Id> woIds2 = new Set<Id>();
    Set<Id> caseIds2 = new Set<Id>();
    Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
    Id AdminWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Installer Admin').getRecordTypeId();
    Id surveyWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Survey').getRecordTypeId();
    
    if(trigger.isbefore){
        if(trigger.isInsert && AvoidRecursion.WoBeforeInsert){
            SET<ID> csIdSet= new SET<ID>();
            Map<id,id> CaseWoMap = new Map<id,id>();
            for(WorkOrder wo:Trigger.new){
                csIdSet.add(wo.CaseId);
                CaseWoMap.put(wo.id,wo.CaseId);
                if(wo.Status=='Confirmed'){
                    wo.Customer_Confirmation__c= True;
                }
            }
            if(!csIdSet.isEmpty()){
                List<Case> csList = [SELECT ID,Technician_Notes__c,Install_Description__c,Maintenance_Description__c,Survey_Description__c,(SELECT Id,Survey_Description__c,Technician_Notes__c FROM WorkOrders) FROM Case WHERE ID IN:csIdSet];
                for(WorkOrder wo:Trigger.new){
                    for(case c : csList){
                        if(wo.CaseId == c.id){
                            wo.Install_Description__c=c.Install_Description__c; 
                            wo.Maintenance_Description__c=c.Maintenance_Description__c;
                            wo.Survey_Description__c = c.Survey_Description__c;
                            wo.Technician_Notes__c = c.Technician_Notes__c;
                        }
                    }
                }
            }
            
            for(WorkOrder wo:Trigger.new){
                CaseIdSet2.add(wo.CaseId);
            }
            Map<Id,Case> caseMap = new Map<Id,Case>([SELECT Id, City__c, Country_Picklist__c, PostalCode__c, Street__c FROM Case where id in :CaseIdSet2]);
            for(WorkOrder wo:Trigger.new){
                if(caseMap.containsKey(wo.CaseId)){
                    wo.Country = caseMap.get(wo.CaseId).Country_Picklist__c ;
                    wo.City = caseMap.get(wo.CaseId).City__c ; 
                    wo.Street = caseMap.get(wo.CaseId).Street__c ;
                    wo.PostalCode = caseMap.get(wo.CaseId).PostalCode__c;
                    system.debug('Value of workorder coutnry'+wo.Country);
                }
            }
            for(WorkOrder wo:Trigger.new){
                if(wo.RecordTypeId!=AdminWORecordTypeId){
                    WOId.add(wo.Id);
                    CaseIdSet.add(wo.CaseId);
                }
            }
            
            Map<Id,WorkOrder> WOMap = new Map<Id,WorkOrder>([SELECT Id,CaseId,Status,RecordTypeId  FROM WorkOrder WHERE ((CaseId in : CaseIdSet) AND (Status!='Completed' AND Status!='Incomplete' AND Status!='Rejected') AND RecordTypeId =: Trigger.new[0].RecordTypeId)]);
            if(WOMap.size()!=0){
                Trigger.new[0].addError('There is already an ongoing Work Order of this type');
            }    
            AvoidRecursion.WoBeforeInsert = false;
        }
        if(Trigger.isUpdate /*&& AvoidRecursion.WoBeforeUpdater()*/){
            for(WorkOrder wo:Trigger.new){
                if(wo.Status=='Confirmed' && wo.Status!=Trigger.oldMap.get(wo.Id).Status){
                    wo.Customer_Confirmation__c= True;
                }
            }
            
            for(WorkOrder wo:Trigger.new){
                if(wo.Status=='Completed' && wo.Status!=Trigger.oldMap.get(wo.Id).Status && wo.Missing_Comment__c==true){
                    wo.addError('Add a comment to every photo please');
                }
            }
            set<Id> woIdSet=new set<Id>();
            for(Workorder wo : Trigger.New){
                if(Trigger.oldMap.get(wo.Id).Status != wo.Status && wo.Status=='Completed')
                    woIdSet.add(wo.Id);
            }
            Set<String> aSet = new Set<String>{'Install (Domestic) Photos Task','Install (Commercial) Photos Task','Survey (Domestic) Photos Task','Survey (Commercial) Photos Task','Groundworks (Domestic) Photos Task','Groundworks (Commercial) Photos Task','Preferred Chargepoint','Unit PSL/PG Number','ENA Details','Commissioning Form','Site Handover Form','Survey Form','Maintenance Form','RAMS','Wi-Fi Status'};
                If(!woIdSet.isEmpty()){
                    Map<Id,Workorder> woLst = new Map<Id,Workorder>([select id,Status,RecordTypeId,(select id,task__r.Name,Status__c from Work_Order_Tasks__r) from Workorder where Id in : woIdSet]);
                    for(Workorder wo : Trigger.New){
                        if(woLst.containsKey(wo.Id)){
                            for(Work_Order_Task__c wot: woLst.get(wo.Id).Work_Order_Tasks__r){
                                if(aSet.contains(wot.task__r.Name) && wot.Status__c != 'Done'){
                                    wo.addError('Please complete the Important WorkOrderTask before completeing the WorkOrder');
                                }
                            }
                        }
                    }
                }
            set<Id> woIdSet2=new set<Id>();
            for(Workorder wo : Trigger.New){
                if((Trigger.oldMap.get(wo.Id).Status != wo.Status && wo.Status=='Incomplete' && wo.worktypeid != checkRecursive.WorkTypeMap.get('Install (Domestic)') && wo.worktypeid != checkRecursive.WorkTypeMap.get('Install (Domestic) & Additional Works')) || (Trigger.oldMap.get(wo.Id).Status != 'Confirmed' && wo.Status=='Incomplete' && (wo.worktypeid == checkRecursive.WorkTypeMap.get('Install (Domestic)') || wo.worktypeid == checkRecursive.WorkTypeMap.get('Install (Domestic) & Additional Works'))))
                    woIdSet2.add(wo.Id);
            }
            Set<String> aSet2 = new Set<String>{'Installation Assessment Form'};
                If(!woIdSet2.isEmpty()){   Map<Id,Workorder> woLst2 = new Map<Id,Workorder>([select id,RecordTypeId,Status,(select id,task__r.Name,Status__c from Work_Order_Tasks__r) from Workorder where Id in : woIdSet2]);
                                        for(Workorder wo : Trigger.New){
                                            if(woLst2.containsKey(wo.Id)){
                                                for(Work_Order_Task__c wot: woLst2.get(wo.Id).Work_Order_Tasks__r){
                                                    if(aSet2.contains(wot.task__r.Name) && wot.Status__c != 'Done'){
                                                        wo.addError('Complete \'Installation Assessment Form Task\' in order to Incomplete the Work Order');
                                                    }
                                                }
                                            }
                                        }
                                       }
            Set<String> aSet3 = new Set<String>{'Annex D Form'};
                If(!woIdSet.isEmpty()){   Map<Id,Workorder> woLst3 = new Map<Id,Workorder>([select id,Status,Case.OLEV__c,RecordTypeId,(select id,task__r.Name,Status__c from Work_Order_Tasks__r) from Workorder where Id in : woIdSet and Case.OLEV__c=true]);
                                       for(Workorder wo : Trigger.New){
                                           if(woLst3.containsKey(wo.Id)){
                                               for(Work_Order_Task__c wot: woLst3.get(wo.Id).Work_Order_Tasks__r){
                                                   if(aSet3.contains(wot.task__r.Name) && wot.Status__c != 'Done'){
                                                       wo.addError('Please complete the Important WorkOrderTask before completeing the WorkOrder');
                                                   }
                                               }
                                           }
                                       }
                                      }
   /*#317 homecharge email logic */         
          /*  for(WorkOrder woRec:Trigger.new){
                if(Trigger.oldMap.get(woRec.Id).Customer_Confirmation__c!=woRec.Customer_Confirmation__c && woRec.Customer_Confirmation__c==False){
                    woRec.IsSFUser__c=False;
                    woRec.IsSiteUser__c=False;
                }
            }
            
            Set<Id> WORecIdSet=new Set<Id>();
            Set<Id> WoAccountidSet = new Set<Id>();
            for(WorkOrder woRec: Trigger.new){
                if(woRec.status=='Scheduled' && woRec.RecordTypeId==hcinstallWORecordTypeId && Trigger.oldMap.get(woRec.Id).Customer_Confirmation__c!=woRec.Customer_Confirmation__c && woRec.Customer_Confirmation__c==True ){
                    WORecIdSet.add(woRec.id);
                    WoAccountidSet.add(woRec.AccountId);
                }
            }
            
            if(!WORecIdSet.isEmpty()){
                EmailTemplate template = [SELECT Id, DeveloperName, Folder.DeveloperName FROM EmailTemplate WHERE DeveloperName='Homecharge_Install_Scheduled_2'];
                OrgWideEmailAddress[] owa = [select id, DisplayName, Address from OrgWideEmailAddress WHERE DisplayName='Scheduling Pod-Point' ];
                List<Contact> conList = new List<Contact>();
                List<Account> accList = [SELECT Id,PersonEmail FROM Account where id IN : WoAccountidSet ];
                Map<Id,String> woMapNames = new Map<Id,String>();
                Map<id,WorkOrder> workOrderList = new map<id,WorkOrder>([SELECT ID,ContactId,Contact.FirstName,Contact.LastName,accountid,account.PersonEmail FROM WorkOrder where id IN : WORecIdSet]);
               
                for(WorkOrder woRec: workOrderList.values()){
                    if(woRec.Contactid!=null && woRec.AccountId!=null){
                        Contact con = new Contact();
                        con.FirstName=woRec.Contact.FirstName;
                        con.LastName=woRec.Contact.LastName;
                        con.Email=woRec.account.PersonEmail;
                        conList.add(con);
                    }
                }
                insert conList;
                
               Map<string,id> conMap = new Map<String,id>();
                for(Contact c : conList){
                    conMap.put(c.Email, c.id);
                }
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                for(WorkOrder woRec:Trigger.new){
                    if(Trigger.oldMap.get(woRec.Id).Customer_Confirmation__c!=woRec.Customer_Confirmation__c && woRec.Customer_Confirmation__c==True && woRec.IsSiteUser__c==False && worec.Confirmation_Email__c == False){
                        woRec.IsSFUser__c=true;
                    }
                    
                    if(woRec.status=='Scheduled' && woRec.RecordTypeId==hcinstallWORecordTypeId && ((checkRecursive.WorkTypeMap).containskey('Install (Domestic)') || (checkRecursive.WorkTypeMap).containskey('Install (Domestic) & Additional Works')) && Trigger.oldMap.get(woRec.Id).Customer_Confirmation__c!=woRec.Customer_Confirmation__c && woRec.Customer_Confirmation__c==True && woRec.IsSFUser__c==True  && worec.Confirmation_Email__c == False){
                        mail.setTemplateID(template.Id);
                        if(conMap.containskey(workOrderList.get(woRec.id).Account.PersonEmail))
                        mail.setTargetObjectId(conMap.get(workOrderList.get(woRec.id).Account.PersonEmail));
                        mail.setSaveAsActivity(false);
                        if ( owa.size() > 0 ) {
                        //  mail.setOrgWideEmailAddressId(owa.get(0).Id);
                        }
                        mail.setWhatId(woRec.Id);
                        allmsg.add(mail);
                        woRec.Confirmation_Email__c= True;
                        woRec.IsSiteUser__c=False;
                         woRec.Status = 'Confirmed';
                        woListForSchedulEmail.add(woRec);
                    } 
                    
                    if(woRec.status=='Scheduled' && woRec.RecordTypeId==hcinstallWORecordTypeId && ((checkRecursive.WorkTypeMap).containskey('Install (Domestic)') || (checkRecursive.WorkTypeMap).containskey('Install (Domestic) & Additional Works')) && Trigger.oldMap.get(woRec.Id).Customer_Confirmation__c!=woRec.Customer_Confirmation__c && woRec.Customer_Confirmation__c==True && woRec.IsSiteUser__c==True  && worec.Confirmation_Email__c == False){
                        mail.setTemplateID(template.Id); 
                        
                       if(conMap.containskey(woRec.Account.PersonEmail))
                        mail.setTargetObjectId(conMap.get(woRec.Account.PersonEmail));
                        mail.setSaveAsActivity(false);
                        if ( owa.size() > 0 ) {
                        }
                        mail.setWhatId(woRec.Id);
                        allmsg.add(mail);
                        woRec.Confirmation_Email__c= True;
                        woRec.IsSFUser__c=False;
                        woRec.Status = 'Confirmed';
                        woListForSchedulEmail.add(woRec);
                    }    
                }
                Messaging.sendEmail(allmsg,false);
                Delete conList;
            }*/
        }
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert && AvoidRecursion.WoAfterInsert){
            List<feedItem> feedList= new List<feedItem>();
            for(WorkOrder  wo: Trigger.new){
                if(wo.Work_Type_Text__c=='Install (Domestic)' || wo.Work_Type_Text__c=='Install (Domestic) & Additional Works'){
                    FeedItem feed = new FeedItem (ParentId = wo.Id,Body = wo.Install_Domestic_Photos_List__c);
                    feedList.add(feed);
                } else  if(wo.Work_Type_Text__c=='Install (Commercial)'){
                    FeedItem feed = new FeedItem (ParentId = wo.Id,Body = wo.Install_Commercial_Photos_List__c);
                    feedList.add(feed);
                } else  if(wo.Work_Type_Text__c=='Survey (Domestic)'){
                    FeedItem feed = new FeedItem (ParentId = wo.Id,Body = wo.Survey_Domestic_Photos_List__c);
                    feedList.add(feed);
                } else  if(wo.Work_Type_Text__c=='Survey (Commercial)'){
                    FeedItem feed = new FeedItem (ParentId = wo.Id,Body = wo.Survey_Commercial_Photos_List__c);
                    feedList.add(feed);
                } else  if(wo.Work_Type_Text__c=='Groundworks (Domestic)'){
                    FeedItem feed = new FeedItem (ParentId = wo.Id,Body = wo.Groundworks_Domestic_Photos_List__c);
                    feedList.add(feed);
                } else  if(wo.Work_Type_Text__c=='Groundworks (Commercial)'){
                    FeedItem feed = new FeedItem (ParentId = wo.Id,Body = wo.Groundworks_Commercial_Photos_List__c);
                    feedList.add(feed);
                }
            }
            if(!feedList.isEmpty()){
                insert feedList;
            }
            WorkOrderTriggerHelper.syncProdrequiredOnWoInsert(Trigger.new);
            WorkOrderTriggerHelper.afterInsertHandlerMethod(Trigger.newMap);
            WorkOrderTriggerHelper.copyAttachmentsFrommCaseWo(Trigger.new);
            AvoidRecursion.WoAfterInsert = false;  
        }
        if(trigger.isUpdate){
            Set<Id> ParentCaseId=new Set<Id>();
            Map<Id, Case> ParentCaseMap;
            list<Case> casesupdated=new list<Case>();
            for(WorkOrder wo: Trigger.new){
                if(wo.Arrival_Window_End_Time__c!=Trigger.oldMap.get(wo.Id).Arrival_Window_End_Time__c || wo.Arrival_Window_Start_Time__c!=Trigger.oldMap.get(wo.Id).Arrival_Window_Start_Time__c || wo.Scheduled_Start_Date_Time__c!=Trigger.oldMap.get(wo.Id).Scheduled_Start_Date_Time__c){
                    ParentCaseId.add(wo.CaseId);
                }
            }
            for(WorkOrder woRec: Trigger.new){
                if(Trigger.oldMap.get(woRec.Id).Customer_Confirmation__c!=woRec.Customer_Confirmation__c && woRec.Customer_Confirmation__c==True ){
                    set_caseid.add(woRec.caseid);
                }
            }
            system.debug('dfldkldfldfdldjldfjsddfj'+set_caseid);
            if(set_caseid.size()>0){
                list<case> caseworkorderlist = [select id,(select id, Customer_Confirmation__c from workorders where Customer_Confirmation__c = false), Customer_Confirmation__c from case where id IN : set_caseid ];
                for(case c : caseworkorderlist){
                    if(c.workorders.size()==0){
                        c.Customer_Confirmation__c = true;
                    }
                    Finalcaseupdatemap.put(c.id,c); 
                }
            }
            if(!ParentCaseId.isEmpty()){
                ParentCaseMap=new Map<Id, Case>([Select id,Survey_Scheduled_Start_Date_Time__c, Survey_Arrival_Window_Start_Time__c, Survey_Arrival_Window_End_Time__c,
                                                 Groundworks_Scheduled_Start_Date_Time__c,Groundworks_Arrival_Window_Start_Time__c,Groundworks_Arrival_Window_End_Time__c,
                                                 Maintenance_Scheduled_Start_Date_Time__c,Maintenance_Arrival_Window_Start_Time__c,Maintenance_Arrival_Window_End_Time__c,
                                                 Install_Scheduled_Start_Date_Time__c,Install_Arrival_Window_Start_Time__c,Install_Arrival_Window_End_Time__c,
                                                 (SELECT Id,Scheduled_Start_Date_Time__c,recordtype.name, Arrival_Window_End_Time__c, Arrival_Window_Start_Time__c, Scheduled_Start_Date__c,Status FROM WorkOrders) from case where id in : ParentCaseId]);
                for(case cs: ParentCaseMap.values()){
                    list<WorkOrder> SurveyWO=new list<WorkOrder>();
                    list<WorkOrder> InstallWO=new list<WorkOrder>();
                    list<WorkOrder> GroundworksWO=new list<WorkOrder>();
                    list<WorkOrder> MaintenanceWO=new list<WorkOrder>();
                    for(WorkOrder wo: cs.workOrders){
                        if(wo.RecordType.name.contains('Survey')){
                            SurveyWO.add(wo);
                        } else if(wo.RecordType.name.contains('Install')){
                            InstallWO.add(wo);
                        } else if(wo.RecordType.name.contains('Groundworks')){
                            GroundworksWO.add(wo);
                        } else if(wo.RecordType.name.contains('Maintenance')){
                            MaintenanceWO.add(wo);
                        }
                    }
                    if(!SurveyWO.isEmpty()){
                        if(SurveyWO.size()==1){
                            cs.Survey_Scheduled_Start_Date_Time__c=SurveyWO[0].Scheduled_Start_Date_Time__c;
                            cs.Survey_Arrival_Window_Start_Time__c=SurveyWO[0].Arrival_Window_Start_Time__c;
                            cs.Survey_Arrival_Window_End_Time__c=SurveyWO[0].Arrival_Window_End_Time__c;
                        }else{
                            for(WorkOrder wo: SurveyWO){
                                if(wo.Status!='Completed' && wo.Status!='incomplete' && wo.Status!='Rejected'){
                                    cs.Survey_Scheduled_Start_Date_Time__c=wo.Scheduled_Start_Date_Time__c;
                                    cs.Survey_Arrival_Window_Start_Time__c=wo.Arrival_Window_Start_Time__c;
                                    cs.Survey_Arrival_Window_End_Time__c=wo.Arrival_Window_End_Time__c;
                                }
                            }  
                        }    
                    }
                    
                    if(!InstallWO.isEmpty()){
                        if(InstallWO.size()==1){
                            cs.Install_Scheduled_Start_Date_Time__c=InstallWO[0].Scheduled_Start_Date_Time__c;
                            cs.Install_Arrival_Window_Start_Time__c=InstallWO[0].Arrival_Window_Start_Time__c;
                            cs.Install_Arrival_Window_End_Time__c=InstallWO[0].Arrival_Window_End_Time__c;
                        }else{
                            for(WorkOrder wo: InstallWO){
                                if(wo.Status!='Completed' && wo.Status!='incomplete' && wo.Status!='Rejected'){
                                    cs.Install_Scheduled_Start_Date_Time__c=wo.Scheduled_Start_Date_Time__c;
                                    cs.Install_Arrival_Window_Start_Time__c=wo.Arrival_Window_Start_Time__c;
                                    cs.Install_Arrival_Window_End_Time__c=wo.Arrival_Window_End_Time__c;
                                }
                            }  
                        }    
                    }
                    
                    if(!GroundworksWO.isEmpty()){
                        if(GroundworksWO.size()==1){
                            cs.Groundworks_Scheduled_Start_Date_Time__c=GroundworksWO[0].Scheduled_Start_Date_Time__c;
                            cs.Groundworks_Arrival_Window_Start_Time__c=GroundworksWO[0].Arrival_Window_Start_Time__c;
                            cs.Groundworks_Arrival_Window_End_Time__c=GroundworksWO[0].Arrival_Window_End_Time__c;
                        }else{
                            for(WorkOrder wo: GroundworksWO){
                                if(wo.Status!='Completed' && wo.Status!='incomplete' && wo.Status!='Rejected'){
                                    cs.Groundworks_Scheduled_Start_Date_Time__c=wo.Scheduled_Start_Date_Time__c;
                                    cs.Groundworks_Arrival_Window_Start_Time__c=wo.Arrival_Window_Start_Time__c;
                                    cs.Groundworks_Arrival_Window_End_Time__c=wo.Arrival_Window_End_Time__c;
                                }
                            }  
                        }    
                    }
                    
                    if(!MaintenanceWO.isEmpty()){
                        if(MaintenanceWO.size()==1){
                            cs.Maintenance_Scheduled_Start_Date_Time__c=MaintenanceWO[0].Scheduled_Start_Date_Time__c;
                            cs.Maintenance_Arrival_Window_Start_Time__c=MaintenanceWO[0].Arrival_Window_Start_Time__c;
                            cs.Maintenance_Arrival_Window_End_Time__c=MaintenanceWO[0].Arrival_Window_End_Time__c;
                        }else{
                            for(WorkOrder wo: MaintenanceWO){
                                if(wo.Status!='Completed' && wo.Status!='incomplete' && wo.Status!='Rejected'){
                                    cs.Maintenance_Scheduled_Start_Date_Time__c=wo.Scheduled_Start_Date_Time__c;
                                    cs.Maintenance_Arrival_Window_Start_Time__c=wo.Arrival_Window_Start_Time__c;
                                    cs.Maintenance_Arrival_Window_End_Time__c=wo.Arrival_Window_End_Time__c;
                                }
                            }  
                        }    
                    }
                    casesupdated.add(cs); 
                }
            }
            if(!casesupdated.isEmpty()){
                Finalcaseupdatemap.putAll(casesupdated);
                //update casesupdated;
            }
            
            
            Set<String> woIdforUploadDoc = new Set<String>();
            for(WorkOrder wo:Trigger.new){
                if (wo.status=='Completed' && (Trigger.oldMap.get(wo.Id).Status != wo.Status)){
                    woIdforUploadDoc.add(wo.Id);
                }
            }
            if(!woIdforUploadDoc.isEmpty()){
                AwsCaller.amazonS3caller(woIdforUploadDoc);
            }
            Set<Id> woIdSetForCompletedStatus= new Set<Id>();
            Set<Id> woIdSetForSchedluedStatus= new Set<Id>();
            for(workOrder wo: Trigger.new){
                if(Trigger.oldMap.get(wo.Id).Status!=wo.Status && wo.status=='Completed'){
                    woIdSetForCompletedStatus.add(wo.id);
                }
                if((Trigger.oldMap.get(wo.Id).Status!=wo.Status && wo.status=='Scheduled') || (Trigger.oldMap.get(wo.Id).Status!=wo.Status && wo.status=='Confirmed') /*|| (Trigger.oldMap.get(wo.Id).Status!=wo.Status && wo.status=='Completed')*/){
                    woIdSetForSchedluedStatus.add(wo.id);
                }
            }

                if(!woIdSetForSchedluedStatus.isEmpty()){
                List<WorkOrder> wOrderList1 = [SELECT ID,RecordTypeId,Status,UUID__c,WorkTypeId,Technician_Email__c ,
                                               (SELECT ID,SchedStartTime,ActualEndTime,Main_SA__c,Technician__c,Installer_Id_c__c FROM ServiceAppointments WHERE Main_SA__c=True) FROM WorkOrder where Id IN : woIdSetForSchedluedStatus];
                for(workOrder wo: wOrderList1){
                    if(wo.UUID__c!=null && wo.RecordTypeId==hcinstallWORecordTypeId && (wo.workTypeId==checkRecursive.WorkTypeMap.get('Install (Domestic)') ||wo.workTypeId==checkRecursive.WorkTypeMap.get('Install (Domestic) & Additional Works'))  && Trigger.oldMap.get(wo.Id).Status!=wo.Status && (wo.ServiceAppointments).size()>0){
                        String woid= String.valueOf(wo.id);
                        String wostatus=String.valueOf(wo.status);
                        DateTime wocreateddate=wo.ServiceAppointments[0].SchedStartTime;
                        String wouuid=String.valueOf(wo.UUID__c);
                        if(!test.isRunningTest())
                            OrderTool.pushDataScheduled(woid,wostatus,wocreateddate,wouuid);
                    }
                }
            }
            for(workOrder wo: Trigger.new){
                if(wo.UUID__c!=null && wo.RecordTypeId==hcinstallWORecordTypeId && (wo.workTypeId==checkRecursive.WorkTypeMap.get('Install (Domestic) & Additional Works') ||wo.workTypeId==checkRecursive.WorkTypeMap.get('Install (Domestic)')) && Trigger.oldMap.get(wo.Id).Status!=wo.Status && (wo.status=='Incomplete' || wo.status=='Rejected' || wo.status=='On Hold' )){
                    String woid= String.valueOf(wo.id);
                    String wostatus=String.valueOf(wo.status);
                    String wouuid=String.valueOf(wo.UUID__c);
                    OrderTool.pushData2(woid,wostatus,wouuid);
                }
            }
            /*for(workOrder wo: Trigger.new){
                if(wo.UUID__c!=null && wo.RecordTypeId==hcinstallWORecordTypeId && (wo.workTypeId==checkRecursive.WorkTypeMap.get('Install (Domestic) & Additional Works') ||wo.workTypeId==checkRecursive.WorkTypeMap.get('Install (Domestic)')) && Trigger.oldMap.get(wo.Id).Status!=wo.Status && wo.status=='Rejected'){
                    String woid= String.valueOf(wo.id);
                    String wostatus=String.valueOf(wo.status);
                    String wouuid=String.valueOf(wo.UUID__c);
                    OrderTool.pushData2(woid,wostatus,wouuid);
                }
            }
            for(workOrder wo: Trigger.new){
                if(wo.UUID__c!=null && wo.RecordTypeId==hcinstallWORecordTypeId && (wo.workTypeId==checkRecursive.WorkTypeMap.get('Install (Domestic) & Additional Works') ||wo.workTypeId==checkRecursive.WorkTypeMap.get('Install (Domestic)')) && Trigger.oldMap.get(wo.Id).Status!=wo.Status && wo.status=='On Hold'){
                    String woid= String.valueOf(wo.id);
                    String wostatus=String.valueOf(wo.status);
                    String wouuid=String.valueOf(wo.UUID__c);
                    OrderTool.pushData2(woid,wostatus,wouuid);
                }
            }*/
                        if(!woIdSetForCompletedStatus.isEmpty()){
            List<WorkOrder> wOrderList = [SELECT ID,RecordTypeId,Status,UUID__c,WorkTypeId,Technician_Email__c ,(SELECT ID,VRN__c,Earthing_Arrangements__c,Property_Service_Cut_Out_Rating_Amps__c,Chargepoint_Rating_Amps__c,Maximum_Demand_Amps__c ,Task__r.name,Unit_PSL_PG_number__c,Signee_Name__c,Signee_Relationship__c FROM Work_Order_Tasks__r),
                                          (SELECT ID,SchedStartTime,ActualEndTime,Main_SA__c,Technician__c,Installer_Id_c__c, Service_Report_Created_Date__c FROM ServiceAppointments) FROM WorkOrder where Id IN : woIdSetForCompletedStatus];
            
            for(workOrder wo: wOrderList){
                String serialNumber;
                String woid;
                String wostatus;
                String wouuid;
                String customerName;
                String customerRelationship;
                String installerName;
                String installerEmail;
                DateTime completedAt;
                Decimal maximumDemandAmps;
                Decimal propertyServiceCutOutRatingAmps;
                Decimal chargePointRatingAmps;
                String earthingArrangements;
                String installerId;
                String vrn;
                DateTime RecentserviceReportCreatedDate;
                if(wo.UUID__c!=null && wo.RecordTypeId==hcinstallWORecordTypeId && (wo.workTypeId==checkRecursive.WorkTypeMap.get('Install (Domestic) & Additional Works') ||wo.workTypeId==checkRecursive.WorkTypeMap.get('Install (Domestic)')) ){
                    woid= String.valueOf(wo.id);
                    wostatus=String.valueOf(wo.status);
                    wouuid=String.valueOf(wo.UUID__c);
                    installerEmail = String.valueOf(wo.Technician_Email__c);
                    for(Work_Order_Task__c wot : wo.Work_Order_Tasks__r){
                        if(wot.task__r.Name=='Unit PSL/PG Number'){
                            serialNumber=wot.Unit_PSL_PG_number__c;
                        }
                        if(wot.Task__r.Name=='Annex D Form'){
                            customerName=wot.Signee_Name__c;
                            customerRelationship=wot.Signee_Relationship__c;
                            vrn=wot.VRN__c;
                        }
                        if(wot.Task__r.Name =='ENA Details'){
                            maximumDemandAmps = wot.Maximum_Demand_Amps__c;
                            propertyServiceCutOutRatingAmps = wot.Property_Service_Cut_Out_Rating_Amps__c;
                            chargePointRatingAmps = wot.Chargepoint_Rating_Amps__c;
                            earthingArrangements = wot.Earthing_Arrangements__c;
                        }
                        if(wot.Task__r.Name =='Preferred Chargepoint'){
                            maximumDemandAmps = wot.Maximum_Demand_Amps__c;
                            chargePointRatingAmps = wot.Chargepoint_Rating_Amps__c;
                        }
                    }
                    for(serviceappointment sa :wo.serviceappointments){
                        if(sa.Main_SA__c==True){
                            installerId = sa.Installer_Id_c__c;  
                            installerName =  sa.Technician__c;      
                            completedAt = sa.ActualEndTime;
                            RecentserviceReportCreatedDate = sa.Service_Report_Created_Date__c;
                        }
                    }
                    system.debug('installerEmail'+installerEmail);
                    OrderTool.pushData3(woid,wostatus,wouuid,serialNumber,completedAt,customerName,customerRelationship,installerName,installerEmail,installerId,maximumDemandAmps,propertyServiceCutOutRatingAmps,chargePointRatingAmps,earthingArrangements,vrn,RecentserviceReportCreatedDate);
                }
            }
                        }
            List<serviceappointment> saList= new List<serviceappointment>();
            set<Id> WOIdSetForWTonSAs = new Set<Id>();
            for(workOrder wo: Trigger.new){
                if ( Trigger.oldMap.get(wo.Id).WorkTypeId!=wo.WorkTypeId)
                    WOIdSetForWTonSAs.add(wo.Id);
            }
            if(!WOIdSetForWTonSAs.isEmpty()){
            Map<Id,WorkOrder> WOIdMapForWTonSAs = new Map<Id,WorkOrder>([Select Id, Worktype.name,RecordTypeId,(Select Id, Work_Type__c from serviceappointments ) from WorkOrder where Id in: WOIdSetForWTonSAs]);
            for(workOrder woRec: WOIdMapForWTonSAs.values()){
                for (serviceappointment sa: woRec.serviceappointments){
                    sa.Work_Type__c=woRec.WorkType.name;
                    saList.add(sa);
                }
            }
            }
            Set<Id> woIdforAttachment = new Set<Id>();
            for(WorkOrder wo:Trigger.new){
                System.debug('££££££££££££££33333333333333333');
                if ((wo.status=='Completed' || wo.status=='Incomplete') && (Trigger.oldMap.get(wo.Id).Status != wo.Status)){
                    System.debug('$$$$$$$$$$$$$$$$$444444444444444444');
                    woIdforAttachment.add(wo.Id);
                }
            }
            if(!woIdforAttachment.isEmpty()){
                System.debug('$$$$$$$$$$$$$$$$$$$55555555555555555555555');
                WorkOrderTriggerHelper.syncAttachmentsFromWoToCase(woIdforAttachment); 
            }
            Id commWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
            Id maintenanceWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();
            Id GroundWorksWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Groundworks').getRecordTypeId();
            
            for(WorkOrder wo:Trigger.new){
                if((wo.RecordTypeId==surveyWORecordTypeId || wo.RecordTypeId==commWORecordTypeId || wo.RecordTypeId==hcinstallWORecordTypeId || wo.RecordTypeId==maintenanceWORecordTypeId) && wo.Status!=Trigger.oldMap.get(wo.Id).Status){
                    woIds.add(wo.Id);
                    caseIds.add(wo.CaseId);
                }
            }
            if(WorkOrderTriggerHelper.run == true){
                if(!woIds.isEmpty() && !caseIds.isEmpty()){
                    WorkOrderTriggerHelper.afterUpdateHandle(woIds,caseIds);
                }
            }
            ScheduleWorkOrderBatch.Temp = False;
            Set<Id> ParentToUpdateDurationAndTimesheet=new Set<Id>();
            Set<Id> ParentToUpdateDurationAndTimesheet2=new Set<Id>();
            Map<Id, Case> CaseToUpdateDurationAndTimesheet;
            List<Case> CaseList=new List<Case>();
            for(WorkOrder wo : Trigger.New){
                if( (wo.Planned_Duration__c!=Trigger.oldMap.get(wo.Id).Planned_Duration__c || wo.Timesheet_Duration__c!=Trigger.oldMap.get(wo.Id).Timesheet_Duration__c) && wo.recordtypeid==commWORecordTypeId){
                    ParentToUpdateDurationAndTimesheet.add(wo.CaseId);
                }
                if( (wo.Planned_Duration__c!=Trigger.oldMap.get(wo.Id).Planned_Duration__c || wo.Timesheet_Duration__c!=Trigger.oldMap.get(wo.Id).Timesheet_Duration__c) && wo.recordtypeid==GroundWorksWORecordTypeId){
                    ParentToUpdateDurationAndTimesheet2.add(wo.CaseId);
                }
            }
            if(!ParentToUpdateDurationAndTimesheet.isEmpty()){
                CaseToUpdateDurationAndTimesheet=new Map<Id,Case>([Select id,Planned_Duration__c,Timesheet_Duration__c, (Select id,Planned_Duration__c,Timesheet_Duration__c, CaseId,recordTypeId from WorkOrders where recordTypeId =:commWORecordTypeId) from Case where id in: ParentToUpdateDurationAndTimesheet]);
                
                if(!CaseToUpdateDurationAndTimesheet.isEmpty()){
                    for(Case ca: CaseToUpdateDurationAndTimesheet.values()){
                        ca.Planned_Duration__c=0;
                        ca.Timesheet_Duration__c=0;
                        for(WorkOrder wo: ca.WorkOrders){
                            if(wo.Planned_Duration__c!=null)
                                ca.Planned_Duration__c=ca.Planned_Duration__c+wo.Planned_Duration__c;
                            if(wo.Timesheet_Duration__c!=null)
                                ca.Timesheet_Duration__c=ca.Timesheet_Duration__c+wo.Timesheet_Duration__c;
                        }
                        CaseList.add(ca);
                    }
                    
                    if(!caselist.isEmpty()){
                        //  Update CaseList;
                        Finalcaseupdatemap.putAll(caselist);
                        
                    }
                }
            }
            
            Map<Id, Case> CaseToUpdateDurationAndTimesheet2;
            List<Case> CaseList2=new List<Case>();
            if(!ParentToUpdateDurationAndTimesheet2.isEmpty()){
                CaseToUpdateDurationAndTimesheet2=new Map<Id,Case>([Select id,Planned_Duration_GWs__c,Timesheet_Duration_GWs__c, (Select id,Planned_Duration__c,Timesheet_Duration__c, CaseId,recordTypeId from WorkOrders where recordTypeId =:GroundWorksWORecordTypeId) from Case where id in: ParentToUpdateDurationAndTimesheet2]);
                
                if(!CaseToUpdateDurationAndTimesheet2.isEmpty()){
                    for(Case ca: CaseToUpdateDurationAndTimesheet2.values()){
                        ca.Planned_Duration_GWs__c=0;
                        ca.Timesheet_Duration_GWs__c=0;
                        for(WorkOrder wo: ca.WorkOrders){
                            if(wo.Planned_Duration__c!=null)
                                ca.Planned_Duration_GWs__c=ca.Planned_Duration_GWs__c+wo.Planned_Duration__c;
                            if(wo.Timesheet_Duration__c!=null)
                                ca.Timesheet_Duration_GWs__c=ca.Timesheet_Duration_GWs__c+wo.Timesheet_Duration__c;
                        }
                        CaseList2.add(ca);
                    }
                    
                    if(!CaseList2.isEmpty()){
                       // Update CaseList2;
                          Finalcaseupdatemap.putAll(CaseList2);
                        
                    }
                }
            }
        } 
        
        
        AvoidRecursion.WoAfterUpdate1 = false;
    }
    system.debug('asdfdfdfdfdfdf'+Finalcaseupdatemap);   
    
    if(!Finalcaseupdatemap.isEmpty()){
        update Finalcaseupdatemap.values();
    }
}