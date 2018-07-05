trigger TaskRayProjectTrigger on TASKRAY__Project__c (after Insert) {
    /*if(Trigger.isBefore && Trigger.isInsert){
Set<Id> opptyId = new Set<Id>();
for(TASKRAY__Project__c tr : trigger.new){
system.debug('tr.TASKRAY__trOpportunity__c'+tr.TASKRAY__trOpportunity__c);
opptyId.add(tr.TASKRAY__trOpportunity__c);
}
if(!opptyId.isEmpty()){
list<order> Myorders = [select id,opportunityID from order where opportunityID IN :opptyId ];
system.debug('Myorders'+Myorders);
if(!Myorders.isEmpty()){
Map <id,order> MyordersMaP=NEW  Map <id,order> ();
for(Order ord: Myorders){
MyordersMaP.put(ord.opportunityID, ord);
}
for(TASKRAY__Project__c tr : trigger.new){
if(MyordersMaP.containsKey(tr.TASKRAY__trOpportunity__c) )
tr.project__c = MyordersMaP.get(tr.TASKRAY__trOpportunity__c).id;
}
}
}


}*/
    if(trigger.isAfter && trigger.IsInsert){
        set<id> Taskrayprojectids = new set<id>();
        List<TASKRAY__Project_Task__c> TaskrayprojectTasks = new List<TASKRAY__Project_Task__c>();
        List<TASKRAY__trChecklistItem__c> ChecklistToInsert=new List<TASKRAY__trChecklistItem__c>();
        Map<String,List<TASKRAY__trChecklistItem__c>> TRProjectTaskMap = new Map<String,List<TASKRAY__trChecklistItem__c>>();
        for(TASKRAY__Project__c TR : trigger.new){
            Taskrayprojectids.add(TR.TASKRAY__trTemplateSource__c);
        }
        if(Taskrayprojectids.size()>0){
            list<TASKRAY__Project_Task__c> TaskrayProjectTasklist = [select CreatedById, CreatedDate, CurrencyIsoCode, Id, 
                                                                     IsDeleted, LastActivityDate, LastModifiedById, 
                                                                     LastModifiedDate, LastReferencedDate, LastViewedDate, 
                                                                     Name, Open_Checklist_items__c, Order__c, OwnerId, 
                                                                     SystemModstamp, TASKRAY__Archived__c, TASKRAY__Blocked__c, 
                                                                     TASKRAY__Deadline__c, TASKRAY__Dependent_On__c, 
                                                                     TASKRAY__Dependent_Update_Pending__c, TASKRAY__Description__c, 
                                                                     TASKRAY__List__c, TASKRAY__Priority__c, TASKRAY__Project__c, 
                                                                     TASKRAY__RepeatCreated__c, TASKRAY__Repeat_End_Date__c, 
                                                                     TASKRAY__Repeat_Every__c, TASKRAY__Repeat_Interval_Type__c, 
                                                                     TASKRAY__Repeat_Week_Days__c, TASKRAY__SortOrder__c, 
                                                                     TASKRAY__Status__c, TASKRAY__trAccount__c, 
                                                                     TASKRAY__trBusinessDuration__c, TASKRAY__trBusinessHrsOverride__c, 
                                                                     TASKRAY__trCompleted__c, TASKRAY__trDepOffset__c, 
                                                                     TASKRAY__trDuration__c, TASKRAY__trEstimatedHours__c, 
                                                                     TASKRAY__trHidden__c, TASKRAY__trHideUntilOffset__c, 
                                                                     TASKRAY__trHideUntil__c, TASKRAY__trIsMilestone__c, 
                                                                     TASKRAY__trLockDates__c, TASKRAY__trOpportunity__c, 
                                                                     TASKRAY__trProjectBusinessHoursId__c, 
                                                                     TASKRAY__trProjectSortOrder__c, TASKRAY__trStartDate__c, 
                                                                     TASKRAY__trTaskGroup__c, TASKRAY__trTemplateSource__c, 
                                                                     TASKRAY__trTime_Entry_Count__c, TASKRAY__trTotalTimeOnTask__c ,
                                                                     (select TASKRAY__trOwner__c,
                                                                      TASKRAY__trLongName__c,
                                                                      TASKRAY__Completed__c,
                                                                      TASKRAY__SortOrder__c,
                                                                      TASKRAY__trChecklistGroup__c,
                                                                      TASKRAY__Project_Task__c from TASKRAY__TaskRay_Checklist_Items__r) from TASKRAY__Project_Task__c where TASKRAY__Project__c IN : Taskrayprojectids ];
            for(TASKRAY__Project__c TR : trigger.new){
                for(TASKRAY__Project_Task__c TRTask : TaskrayProjectTasklist ){
                    TASKRAY__Project_Task__c TRTask1= TRTask.clone(false, true, false, true);
                    TRTask1.TASKRAY__Project__c =TR.Id ;
                    TRTask1.Name = TRTask.name;
                    TRTask1.TASKRAY__Priority__c = TRTask.TASKRAY__Priority__c;
                    TRTask1.TASKRAY__List__c = TRTask.TASKRAY__List__c;
                    TaskrayprojectTasks.add(TRTask1);
                    List<TASKRAY__trChecklistItem__c> Checklist=new List<TASKRAY__trChecklistItem__c>();
                    Checklist.addall(TRTask.TASKRAY__TaskRay_Checklist_Items__r);
                    TRProjectTaskMap.put(TRTask.name,Checklist);
                }
            }
            insert TaskrayprojectTasks;
            if(!TaskrayprojectTasks.isEmpty()){
                for(TASKRAY__Project_Task__c TRTask1:  TaskrayprojectTasks){
                    if(TRProjectTaskMap.Containskey(TRTask1.Name)){
                        if(!TRProjectTaskMap.get(TRTask1.Name).isEmpty()){
                            for(TASKRAY__trChecklistItem__c checklist : TRProjectTaskMap.get(TRTask1.Name)){
                                TASKRAY__trChecklistItem__c checklist1= checklist.clone(false, true, false, true);
                                checklist1.TASKRAY__Project_Task__c=TRTask1.Id;
                                ChecklistToInsert.add(checklist1);
                            }
                        }
                    }
                }
                insert ChecklistToInsert;
            }
        }
    }
}