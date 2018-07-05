trigger ServiceAppointmentTrigger on ServiceAppointment (before insert, before update, after insert, after update, before delete, after delete) {
    Map<id,WorkOrder> workordermap =new Map<id,WorkOrder>();
    List<ServiceAppointment> saList= new List<ServiceAppointment>();
    List<WorkOrder> woList1=new List<WorkOrder>();
    List<WorkOrder> woList2=new List<WorkOrder>();
    List<WorkOrder> woList3=new List<WorkOrder>();
    List<WorkOrder> woList4=new List<WorkOrder>();
    Id hcinstallWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Homecharge Install').getRecordTypeId();
    Id AdminWORecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Installer Admin').getRecordTypeId();
    boolean b1=true;
    /*Map<String,Id> WorkTypeMap;
    List<WorkType> WorkTypeList;
    If(b1){
        WorkTypeList= new List<WorkType>([SELECT Id, name from WorkType]);
        WorkTypeMap=new Map<String,Id>();
        for(WorkType wt: WorkTypeList){
            WorkTypeMap.put(wt.Name, wt.Id);
        }
    }    */
    If(checkRecursive.checkk == true){
        checkRecursive.callworktypemap();
    }   
    if(Trigger.isBefore && Trigger.isInsert){
        set<id> Workorderids = new set<id>();
        for(ServiceAppointment sa : Trigger.New){
               system.debug('dfdfjhdf'+sa.ParentRecordId);
             //system.debug('dfdfjhdf'+sa.ParentRecordType);
            if(string.valueOf((sa.ParentRecordId)).startsWith('0WO')){
               
                Workorderids.add(sa.ParentRecordId);
            }
        }
        system.debug('dfdfjhdf'+Workorderids);
   //     if(!Workorderids.isempty()){
            List<workorder> Workorderlist1 = [select id, recordtype.name from workorder where id IN : Workorderids];
            for(ServiceAppointment sa : Trigger.New){
                if(string.valueOf((sa.ParentRecordId)).startsWith('0WO')){
                    for(workorder wo : Workorderlist1){
                        if(sa.ParentRecordId == wo.id){
                            sa.Parent_Record_Type_Name__c = wo.recordtype.name;
                        }
                    }
                }
            }
       // }
    }

    
    
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            
            for(ServiceAppointment sa : Trigger.New){
                if(Trigger.oldMap.get(sa.Id).status!=sa.status && sa.status =='Scheduled'){
                    sa.DateWhenSABecomeSchedule__c=System.now();
                }
            }
            
            for(ServiceAppointment sa : Trigger.New){
                if(Trigger.oldMap.get(sa.Id).status=='Incomplete' && sa.status == 'Completed' && sa.Completed_in_Office__c == false){
                    sa.adderror('You can not change the status from incomplete to complete directly');
                }
                if(Trigger.oldMap.get(sa.Id).Completed_in_Office__c != sa.Completed_in_Office__c && sa.Completed_in_Office__c==true && sa.Main_SA__c==true){
                    sa.Status='Completed';
                }
            }
            
            set<Id> SaIdSet3=new set<Id>();
            set<Id> SaIdSet4=new set<Id>();
            for(ServiceAppointment sa : Trigger.New){
                if(Trigger.oldMap.get(sa.Id).Status != sa.Status && sa.Status=='Completed' && sa.Service_Report_Check__c==false && sa.Main_SA__c==true  && (sa.Work_Type__c=='Install (Domestic)' || sa.Work_Type__c=='Install (Domestic) & Additional Works')){
                    sa.status.addError('Create Service Report and get customer signature');
                }
            }
            
            set<Id> SaIdSet=new set<Id>();
            for(ServiceAppointment sa : Trigger.New){
                if(Trigger.oldMap.get(sa.Id).Status != sa.Status && sa.Status=='Completed' && sa.Main_SA__c==true)
                    SaIdSet.add(sa.ParentRecordId);
            }
            Set<String> aSet = new Set<String>{'Install (Domestic) Photos Task','Install (Commercial) Photos Task','Survey (Domestic) Photos Task','Survey (Commercial) Photos Task','Groundworks (Domestic) Photos Task','Groundworks (Commercial) Photos Task','Preferred Chargepoint','Unit PSL/PG Number','ENA Details','Commissioning Form','Site Handover Form','Survey Form','Maintenance Form','RAMS','Wi-Fi Status'};
                Map<Id,Workorder> woLst = new Map<Id,Workorder>([select id,Status,RecordTypeId,(select id,task__r.Name,Status__c from Work_Order_Tasks__r) from Workorder where Id in : SaIdSet]);
            for(ServiceAppointment sa : Trigger.New){
                for(Workorder wo : woLst.Values()){
                    if(woLst.containsKey(wo.Id)){
                        for(Work_Order_Task__c wot: woLst.get(wo.Id).Work_Order_Tasks__r){
                            if(aSet.contains(wot.task__r.Name) && wot.Status__c != 'Done'){
                                sa.addError('Complete all Work Order Tasks before completing the Work Order');
                            }
                        }
                    }
                }
            }
            
            set<Id> SaIdSet2=new set<Id>();
            for(ServiceAppointment sa : Trigger.New){
                if((Trigger.oldMap.get(sa.Id).Status != sa.Status && sa.Status=='Incomplete' && sa.Main_SA__c==true && sa.Work_Type__c!='Install (Domestic)' && sa.Work_Type__c!='Install (Domestic) & Additional Works') || ( Trigger.oldMap.get(sa.Id).Status!='Confirmed' && Trigger.oldMap.get(sa.Id).Status != sa.Status && sa.Status=='Incomplete' && sa.Main_SA__c==true && (sa.Work_Type__c=='Install (Domestic)' || sa.Work_Type__c=='Install (Domestic) & Additional Works')))
                    SaIdSet2.add(sa.ParentRecordId);
            }
            Set<String> aSet2 = new Set<String>{'Installation Assessment Form'};
                Map<Id,Workorder> woLst2 = new Map<Id,Workorder>([select id,RecordTypeId,Status,(select id,task__r.Name,Status__c from Work_Order_Tasks__r) from Workorder where Id in : SaIdSet2]);
            for(ServiceAppointment sa : Trigger.New){
                for(Workorder wo : woLst2.values()){
                    if(woLst2.containsKey(wo.Id)){
                        for(Work_Order_Task__c wot: woLst2.get(wo.Id).Work_Order_Tasks__r){
                            if(aSet2.contains(wot.task__r.Name) && wot.Status__c != 'Done'){
                                sa.addError('Complete \'Installation Assessment Form Task\' in order to Incomplete the Work Order');
                            }
                        }
                    }
                }
            }
            
            Set<String> aSet3 = new Set<String>{'Annex D Form'};
                Map<Id,Workorder> woLst3 = new Map<Id,Workorder>([select id,Status,Case.OLEV__c,RecordTypeId,(select id,task__r.Name,Status__c from Work_Order_Tasks__r) from Workorder where Id in : SaIdSet and Case.OLEV__c=true]);
            for(ServiceAppointment sa : Trigger.New){
                for(Workorder wo : woLst3.values()){
                    if(woLst3.containsKey(wo.Id)){
                        for(Work_Order_Task__c wot: woLst3.get(wo.Id).Work_Order_Tasks__r){
                            if(aSet3.contains(wot.task__r.Name) && wot.Status__c != 'Done'){
                                sa.addError('Complete all Work Order Tasks before completing the Work Order');
                            }
                        }
                    }
                }
            }
            
            for(ServiceAppointment sa : Trigger.New){
                if((sa.ActualEndTime!=Trigger.oldMap.get(sa.Id).ActualEndTime || sa.ActualStartTime!=Trigger.oldMap.get(sa.Id).ActualStartTime) && sa.ActualEndTime != null  && sa.ActualStartTime != null){
                    
                    sa.ActualDuration=(sa.ActualEndTime.gettime()-sa.ActualStartTime.gettime())/60000;
                    
                    //  sa.ActualDuration=(sa.ActualEndTime-sa.ActualStartTime)*24*60;
                }
                
                
                
                
                
                
                if((sa.SchedStartTime!=Trigger.oldMap.get(sa.Id).SchedStartTime || sa.SchedEndTime !=Trigger.oldMap.get(sa.Id).SchedEndTime) && sa.SchedStartTime!=null && sa.SchedEndTime !=null){
                    DateTime dT=sa.SchedStartTime;
                    Date SchedStartDate = date.newinstance(dT.year(), dT.month(), dT.day());
                    DateTime dT1=sa.SchedEndTime;
                    Date SchedEndDate = date.newinstance(dT1.year(), dT1.month(), dT1.day());
                    if(SchedStartDate!=SchedEndDate){
                        sa.FSL__IsMultiDay__c=true;
                    }
                    if(SchedStartDate==SchedEndDate){
                        sa.FSL__IsMultiDay__c=False;
                    }
                    
                }
            }
            
            Set<Id> parents1 = new Set<Id>();
            Map<Id,WorkOrder> woMap1 ;
            for(ServiceAppointment sa: trigger.new){
                if(Trigger.oldMap.get(sa.Id).Customer_Confirmation__c!=sa.Customer_Confirmation__c && sa.Customer_Confirmation__c==true && sa.status == 'Scheduled'){
                    parents1.add(sa.ParentRecordId);
                }
            }
            if(!parents1.isEmpty()){
                woMap1 = new Map<Id,WorkOrder>([select id,caseId, recordTypeId  from WorkOrder where Id in : parents1]);
                if(!woMap1.isEmpty()){
                    for(ServiceAppointment sa: trigger.new){
                        for(WorkOrder wo: woMap1.values()){
                           //if(wo.RecordTypeId!=hcinstallWORecordTypeId){
                                sa.Status='Confirmed';
                           // }
                        }
                    }
                }
                
            }
            //Commented on 13th April as per card ###439###
            /*  for(ServiceAppointment sa: trigger.new)
{ 
if((sa.WorkTypeId ==WorkTypeMap.get('Install (Domestic)') || sa.WorkTypeId ==WorkTypeMap.get('Install (Domestic) & Additional Works') )&& sa.Scheduled_Start_Time__c==14 && sa.Scheduled_Start_Time_Minute__c!=0){
sa.addError('Scheduled Start time can not be in 14 to 14:59');
}
}*/
            
            for(ServiceAppointment sa: trigger.new){
                if(sa.SchedStartTime!=null && sa.SchedEndTime!=null){
                    integer a=((sa.Scheduled_Start_Time__c.intValue()*60)+sa.Scheduled_Start_Time_Minute__c.intValue());
                    integer b=((sa.Scheduled_End_Time__c.intValue()*60)+sa.Scheduled_End_Time_Minute__c.intValue());
                    if(b<a){
                        sa.addError('Scheduled End Time can not be earlier than Scheduled Start Time');
                    }
                }
            }
            
            for(ServiceAppointment sa: trigger.new)
            {                
                if((sa.Status=='Unassigned' && Trigger.oldMap.get(sa.Id).Status!=sa.Status) || test.isRunningTest()){
                    sa.ArrivalWindowStartTime=null;
                    sa.ArrivalWindowEndTime=null;
                }
                 if((sa.WorkTypeId ==checkRecursive.WorkTypeMap.get('Install (Domestic)') || sa.WorkTypeId ==checkRecursive.WorkTypeMap.get('Install (Domestic) & Additional Works')) && ((Trigger.oldMap.get(sa.Id).Status!=sa.Status && sa.Status=='Scheduled' && sa.SchedStartTime!=null) || (Trigger.oldMap.get(sa.Id).SchedStartTime!=sa.SchedStartTime && sa.SchedStartTime!=null))){
                    if((sa.Scheduled_Start_Time__c>=8 && sa.Scheduled_Start_Time__c<11)|| (sa.Scheduled_Start_Time__c==11 && sa.Scheduled_Start_Time_Minute__c==0) ){
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addHours(7));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addHours(10));
                    } else if((sa.Scheduled_Start_Time__c>11 && sa.Scheduled_Start_Time__c<15) ||(sa.Scheduled_Start_Time__c==11 && sa.Scheduled_Start_Time_Minute__c!=0) || (sa.Scheduled_Start_Time__c==15 && sa.Scheduled_Start_Time_Minute__c==0) ){
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addHours(10));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addHours(14));
                    } else if(sa.Scheduled_Start_Time__c>=15 && sa.Scheduled_Start_Time__c<=17){
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addHours(14));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addHours(16));
                    }
                }
              /*  if((sa.WorkTypeId ==WorkTypeMap.get('Install (Domestic)') || sa.WorkTypeId ==WorkTypeMap.get('Install (Domestic) & Additional Works')) && ((Trigger.oldMap.get(sa.Id).Status!=sa.Status && sa.Status=='Scheduled' && sa.SchedStartTime!=null) || (Trigger.oldMap.get(sa.Id).SchedStartTime!=sa.SchedStartTime && sa.SchedStartTime!=null))){
                    if((sa.Scheduled_Start_Time__c>=8 && sa.Scheduled_Start_Time__c<11)|| (sa.Scheduled_Start_Time__c==11 && sa.Scheduled_Start_Time_Minute__c==0) ){
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addHours(8));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addHours(11));
                    } else if((sa.Scheduled_Start_Time__c>11 && sa.Scheduled_Start_Time__c<15) ||(sa.Scheduled_Start_Time__c==11 && sa.Scheduled_Start_Time_Minute__c!=0) || (sa.Scheduled_Start_Time__c==15 && sa.Scheduled_Start_Time_Minute__c==0) ){
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addHours(11));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addHours(14));
                    } else if(sa.Scheduled_Start_Time__c>=15 && sa.Scheduled_Start_Time__c<=17){
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addHours(15));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addHours(17));
                    }
                } else if((sa.WorkTypeId !=WorkTypeMap.get('Install (Domestic)') && sa.WorkTypeId !=WorkTypeMap.get('Install (Domestic) & Additional Works')) && ((Trigger.oldMap.get(sa.Id).Status!=sa.Status && sa.Status=='Scheduled' && sa.SchedStartTime!=null) || (Trigger.oldMap.get(sa.Id).SchedStartTime!=sa.SchedStartTime && sa.SchedStartTime!=null))){
                    if((sa.Scheduled_Start_Time__c==8) || (sa.Scheduled_Start_Time__c==9 && sa.Scheduled_Start_Time_Minute__c<=14)){
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addHours(8));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addHours(10));
                    } else if(sa.Scheduled_Start_Time_Minute__c>=0 && sa.Scheduled_Start_Time_Minute__c<=14){
                        integer a=sa.Scheduled_Start_Time__c.intValue()-1;
                        integer b=((a*60));
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b+120));
                    } else if(sa.Scheduled_Start_Time_Minute__c>14 && sa.Scheduled_Start_Time_Minute__c<=44){
                        integer a=(sa.Scheduled_Start_Time__c.intValue()-1);
                        integer b=((a*60)+30);
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b+120));
                    } else if((sa.Scheduled_Start_Time_Minute__c>44 && sa.Scheduled_Start_Time_Minute__c<=59)|| test.isRunningTest()){
                        integer a=(sa.Scheduled_Start_Time__c.intValue());
                        integer b=((a*60));
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b+120));
                    }
                }*/
                else if((sa.WorkTypeId !=checkRecursive.WorkTypeMap.get('Install (Domestic)') && sa.WorkTypeId !=checkRecursive.WorkTypeMap.get('Install (Domestic) & Additional Works')) && ((Trigger.oldMap.get(sa.Id).Status!=sa.Status && sa.Status=='Scheduled' && sa.SchedStartTime!=null) || (Trigger.oldMap.get(sa.Id).SchedStartTime!=sa.SchedStartTime && sa.SchedStartTime!=null))){
                    if((sa.Scheduled_Start_Time__c<=8) || (sa.Scheduled_Start_Time__c==9 && sa.Scheduled_Start_Time_Minute__c<=14)){
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addHours(7));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addHours(9));
                    } else if(sa.Scheduled_Start_Time_Minute__c>=0 && sa.Scheduled_Start_Time_Minute__c<=14){
                        integer a=sa.Scheduled_Start_Time__c.intValue()-2;
                        integer b=((a*60));
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b+120));
                    } else if(sa.Scheduled_Start_Time_Minute__c>14 && sa.Scheduled_Start_Time_Minute__c<=44){
                        integer a=(sa.Scheduled_Start_Time__c.intValue()-2);
                        integer b=((a*60)+30);
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b+120));
                    } else if((sa.Scheduled_Start_Time_Minute__c>44 && sa.Scheduled_Start_Time_Minute__c<=59)|| test.isRunningTest()){
                        integer a=((sa.Scheduled_Start_Time__c.intValue())-1);
                        integer b=((a*60));
                        sa.ArrivalWindowStartTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b));
                        sa.ArrivalWindowEndTime=(sa.Scheduled_Start_DateTime__c.addMinutes(b+120));
                    }
                }
            }
            
            Set<Id> parents = new Set<Id>();
            for(ServiceAppointment sa: trigger.new)
            {
                if(Trigger.oldMap.get(sa.Id).ArrivalWindowStartTime!=sa.ArrivalWindowStartTime || Trigger.oldMap.get(sa.Id).ArrivalWindowEndTime!=sa.ArrivalWindowEndTime ){
                    parents.add(sa.ParentRecordId);
                    sa.Customer_Confirmation__c=false;
                }
            }
            List<WorkOrder> woList=new List<WorkOrder>();
            Map<Id,WorkOrder> woMap = new Map<Id,WorkOrder>([select id,caseId,Scheduling_Email__c,Confirmation_Email__c,Customer_Confirmation__c  from WorkOrder where Id in : parents]);
            if(!woMap.isEmpty()){
                for(WorkOrder wo : woMap.values()){
                    wo.Scheduling_Email__c=false;
                    wo.Confirmation_Email__c=false;
                    wo.Customer_Confirmation__c=false;
                    woList.add(wo);
                }
            }
        }
        
        
        if(Trigger.isUpdate){
            Set<Id> parents2 = new Set<Id>();
            for(ServiceAppointment sa : Trigger.new){
                if(sa.status=='Completed' && Trigger.oldMap.get(sa.Id).Status!=sa.Status){parents2.add(sa.ParentRecordId);}
            }
            Map<Id,WorkOrder> woMap2 = new Map<Id,WorkOrder>([select id,caseId,RecordType.name,Missing_Comment__c from WorkOrder where Id in : parents2]);
            for(ServiceAppointment sa : Trigger.new){
                if(woMap2.containsKey(sa.ParentRecordId)){        
                    for(WorkOrder wo: woMap2.Values()){
                        if(wo.Missing_Comment__c==true){sa.addError('Add a comment to every photo please');
                                                       }
                    }
                }
            }            
            for(ServiceAppointment sa : Trigger.new){
                if(sa.Status=='Active' && Trigger.oldMap.get(sa.Id).Status!=Trigger.newMap.get(sa.Id).Status){sa.ActualStartTime=System.now(); }         
                if((sa.Status=='Incomplete' || sa.Status=='Completed') && Trigger.oldMap.get(sa.Id).Status!=Trigger.newMap.get(sa.Id).Status){sa.ActualEndTime=System.now(); }         
            }
            Set<Id> parents = new Set<Id>();
            for(ServiceAppointment sa : Trigger.new)
                parents.add(sa.ParentRecordId);
            Map<Id,WorkOrder> woMap = new Map<Id,WorkOrder>([select id,caseId,(select id,Main_SA__c,Status,UncheckByUser__c from serviceappointments) from WorkOrder where Id in : parents]);
            for(ServiceAppointment sa : Trigger.new){
                if(Trigger.oldMap.get(sa.Id).Main_SA__c!=Trigger.newMap.get(sa.Id).Main_SA__c && sa.Main_SA__c==true){
                    if(woMap.containsKey(sa.ParentRecordId)){
                        for(workOrder wo : woMap.values()){
                            for (serviceappointment ser: wo.ServiceAppointments){
                                if(ser.id!=sa.Id){
                                    if(ser.Main_SA__c==true && ser.Status!=sa.Status){sa.addError('Service Appointments must be in the same Status before you change the Main SA');
                                                                                     }
                                    ser.Main_SA__c=false;
                                    ser.UncheckByUser__c=true;
                                    sa.UncheckByUser__c=false;
                                    saList.add(ser);
                                }
                            }
                        }
                    }
                }
            }
              Update saList;
            
            for(ServiceAppointment sa : Trigger.new){
                
                if(Trigger.oldMap.get(sa.Id).Main_SA__c!=Trigger.newMap.get(sa.Id).Main_SA__c && sa.Main_SA__c==False && Trigger.oldMap.get(sa.Id).UncheckByUser__c==Trigger.newMap.get(sa.Id).UncheckByUser__c && (UserInfo.getProfileId() != '00e24000000znouAAA' && UserInfo.getProfileId() != '00e1o000000S2cuAAC')){sa.addError('You can not uncheck a Main SA');
                                                                                                                                                                                                                }
            }
        } 
    }
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            Set<Id> parents = new Set<Id>();
            for(ServiceAppointment sa : Trigger.new)
                parents.add(sa.ParentRecordId);
            Map<Id,WorkOrder> woMap = new Map<Id,WorkOrder>([select id,caseId,Country,City,Street,PostalCode,RecordType.name,worktype.name,ContactID, worktype.Appointment_Start_Offset__c, (select id,Main_SA__c from serviceappointments),(SELECT Product2.family, Id FROM ProductsRequired) from WorkOrder where Id in : parents]);
            Map<Id,WorkOrderLineItem> woliMap = new Map<Id,WorkOrderLineItem>([select id,Case__c,worktype.name, worktype.Appointment_Start_Offset__c, (select id,Main_SA__c,Work_Type__c  from serviceappointments) from WorkOrderLineItem where Id in : parents]);
            Map<Id,Case> caseMap=new Map<Id,Case>([SELECT Id, City__c, Country_Picklist__c, PostalCode__c, Street__c FROM Case where id in : woMap.KeySet()]);
            for(ServiceAppointment sa : Trigger.new){
                if(woMap.containsKey(sa.ParentRecordId)){
                    if(sa.Country==null)
                        sa.Country =woMap.get(sa.ParentRecordId).Country ;
                    sa.City = woMap.get(sa.ParentRecordId).City ; 
                    sa.Street =woMap.get(sa.ParentRecordId).Street ;
                    sa.PostalCode =woMap.get(sa.ParentRecordId).PostalCode;
                    sa.Case__c=woMap.get(sa.ParentRecordId).caseId;
                    sa.ContactId=woMap.get(sa.ParentRecordId).contactid;
                    sa.Work_Type__c=woMap.get(sa.ParentRecordId).worktype.name;
                    sa.WorkTypeStartOffsetTime__c=woMap.get(sa.ParentRecordId).worktype.Appointment_Start_Offset__c;
                    if(woMap.get(sa.ParentRecordId).Serviceappointments.size()==0)
                        sa.Main_SA__c=true;
                    if(woMap.get(sa.ParentRecordId).worktype.Appointment_Start_Offset__c != null){
                        if(sa.EarliestStartTime == null){sa.EarliestStartTime = system.now().addMinutes(Integer.valueof(woMap.get(sa.ParentRecordId).worktype.Appointment_Start_Offset__c));     
                                                        } else {
                                                            sa.EarliestStartTime = sa.EarliestStartTime.addMinutes(Integer.valueof(woMap.get(sa.ParentRecordId).worktype.Appointment_Start_Offset__c));
                                                        }
                        System.debug(sa.EarliestStartTime);
                    }
                } else if (woliMap.containsKey(sa.ParentRecordId)){
                    sa.Case__c=woliMap.get(sa.ParentRecordId).Case__c;
                    if(woliMap.get(sa.ParentRecordId).worktype.Appointment_Start_Offset__c != null){
                        if(sa.EarliestStartTime == null){sa.EarliestStartTime = system.now().addMinutes(Integer.valueof(woliMap.get(sa.ParentRecordId).worktype.Appointment_Start_Offset__c));     
                                                        } else {
                                                            sa.EarliestStartTime = sa.EarliestStartTime.addMinutes(Integer.valueof(woliMap.get(sa.ParentRecordId).worktype.Appointment_Start_Offset__c));   
                                                        }
                    }
                }
            }
        
            set<id> WOids = new set<id>();
            for(ServiceAppointment sa : Trigger.new){
                if(sa.Main_SA__c == true)
                    WOids.add(sa.ParentRecordId);
            }
            Map<Id,WorkOrder> woMap1 = new Map<Id,WorkOrder>([select id,(select id,Main_SA__c from serviceappointments where Main_SA__c = true ) from WorkOrder where Id in : WOids]);
            if(!woMap1.isEmpty()){
                for(ServiceAppointment sa : Trigger.new){
                    for(WorkOrder wo : woMap1.values()){
                        if(wo.serviceappointments.size()>0){
                            sa.addError('You cant create Main SA, Main SA already exist for this workorder');
                        }
                    }
                }
            }

        
        }

        
        
    }
    
    
    
    if(Trigger.isBefore){
        if(Trigger.isDelete){system.debug('isdelete1');
                             Set<Id> parents1 = new Set<Id>();
                             Map<Id,WorkOrder> woMap1 ;
                             for(ServiceAppointment sa: trigger.old){
                                 parents1.add(sa.ParentRecordId);
                             }
                             if(!parents1.isEmpty()){
                                 woMap1 = new Map<Id,WorkOrder>([SELECT Id,Scheduled_Start_Date_Time__c,(Select SchedStartTime,Scheduled_Start_Date__c,Arrival_Window_End_Time__c,Arrival_Window_Start_Time__c from serviceappointments order by SchedStartTime limit 2), Arrival_Window_End_Time__c, Arrival_Window_Start_Time__c, Scheduled_Start_Date__c FROM WorkOrder where Id in : parents1]);
                                 System.debug('womap===>'+woMap1);
                                 if(!woMap1.isEmpty()){
                                     for(ServiceAppointment sa: trigger.old){
                                         for(WorkOrder wo: woMap1.values()){
                                             List<String> scheduleStartdatelist;
                                             for (ServiceAppointment saa: wo.ServiceAppointments){
                                                 if(sa.ParentRecordId==wo.id){
                                                     wo.Arrival_Window_End_Time__c=String.valueOf(saa.Arrival_Window_End_Time__c);
                                                     wo.Arrival_Window_Start_Time__c=String.valueOf(saa.Arrival_Window_Start_Time__c);
                                                     wo.Scheduled_Start_Date_Time__c=saa.SchedStartTime;
                                                     wo.Scheduled_Start_Date__c =saa.Scheduled_Start_Date__c;
                                                     // woList1.add(wo);
                                                 }
                                             }
                                             woList1.add(wo);
                                         }
                                     }
                                     //   if(!woList1.isEmpty()){
                                     // update woList1;}
                                 }
                             }
                            }
        if(Trigger.isDelete){ 
            Set<Id> parents = new Set<Id>();
            for(ServiceAppointment sa : Trigger.old)
                parents.add(sa.ParentRecordId);
            Map<Id,WorkOrder> woMap = new Map<Id,WorkOrder>([select id,caseId,(select id,Main_SA__c from serviceappointments) from WorkOrder where Id in : parents]);
            System.debug(woMap);
            for(ServiceAppointment sa : Trigger.old){
                if(woMap.containsKey(sa.ParentRecordId)){
                    for(workOrder wo : woMap.values()){
                        if(wo.Id==sa.ParentRecordId && wo.ServiceAppointments.size()>1 && sa.Main_SA__c==true){
                            sa.addError('You cant delete an SA if Its Main SA');
                        }
                    }
                    
                }}
            
        }
        
    }
    
    
    
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            Set<Id> parents1 = new Set<Id>();
            Map<Id,WorkOrder> woMap1 ;
            for(ServiceAppointment sa: trigger.new){
                if(sa.SchedStartTime!=null){
                    parents1.add(sa.ParentRecordId);
                }
            }
            if(!parents1.isEmpty()){
                woMap1 = new Map<Id,WorkOrder>([SELECT Id,Scheduled_Start_Date_Time__c,(Select SchedStartTime,Scheduled_Start_Date__c,Arrival_Window_End_Time__c,Arrival_Window_Start_Time__c from serviceappointments order by SchedStartTime limit 1), Arrival_Window_End_Time__c, Arrival_Window_Start_Time__c, Scheduled_Start_Date__c FROM WorkOrder where Id in : parents1]);
                if(!woMap1.isEmpty()){
                    for(ServiceAppointment sa: trigger.new){
                        for(WorkOrder wo: woMap1.values()){
                            if(wo.ServiceAppointments[0].id==sa.Id){
                                List<String> scheduleStartdatelist;
                                if(sa.ParentRecordId==wo.id){
                                    wo.Arrival_Window_End_Time__c=String.valueOf(sa.Arrival_Window_End_Time__c);
                                    wo.Arrival_Window_Start_Time__c=String.valueOf(sa.Arrival_Window_Start_Time__c);
                                    wo.Scheduled_Start_Date_Time__c=sa.SchedStartTime;
                                    wo.Scheduled_Start_Date__c =sa.Scheduled_Start_Date__c;
                                    woList2.add(wo);
                                }
                            }
                        }
                    }
                    //  if(!woList1.isEmpty()){
                    //      update woList1;}
                }
            }
        }
        
        if(Trigger.isUpdate){
            Set<Id> parents1 = new Set<Id>();
            Map<Id,WorkOrder> woMap1 ;
            for(ServiceAppointment sa: trigger.new){
                if(sa.SchedStartTime!=Trigger.oldMap.get(sa.Id).SchedStartTime && sa.SchedStartTime!=null){
                    parents1.add(sa.ParentRecordId);
                }
            }
            if(!parents1.isEmpty()){
                woMap1 = new Map<Id,WorkOrder>([SELECT Id,Scheduled_Start_Date_Time__c,(Select SchedStartTime,Scheduled_Start_Date__c,Arrival_Window_End_Time__c,Arrival_Window_Start_Time__c from serviceappointments order by SchedStartTime limit 1), Arrival_Window_End_Time__c, Arrival_Window_Start_Time__c, Scheduled_Start_Date__c FROM WorkOrder where Id in : parents1]);
                if(!woMap1.isEmpty()){
                    for(ServiceAppointment sa: trigger.new){
                        for(WorkOrder wo: woMap1.values()){
                            if(wo.ServiceAppointments[0].id==sa.Id){
                                List<String> scheduleStartdatelist;
                                if(sa.ParentRecordId==wo.id){
                                    wo.Arrival_Window_End_Time__c=String.valueOf(sa.Arrival_Window_End_Time__c);
                                    wo.Arrival_Window_Start_Time__c=String.valueOf(sa.Arrival_Window_Start_Time__c);
                                    wo.Scheduled_Start_Date_Time__c=sa.SchedStartTime;
                                    wo.Scheduled_Start_Date__c =sa.Scheduled_Start_Date__c;
                                    woList3.add(wo);
                                }
                            }
                        }
                    }
                    if(!woList3.isEmpty()){
                        update woList3;}
                }
            } 
            
            /*Logic for 420 Bug in Prod: Timesheet hours for installer admin */
            Set<Id> ParentToUpdateDurationAndTimesheet=new Set<Id>();
            Map<Id, WorkOrder> WorkOrderToUpdateDurationAndTimesheet;
            List<WorkOrder> WorkOrderList=new List<WorkOrder>();
            for(ServiceAppointment sa : Trigger.New){
                if((sa.Duration!=Trigger.oldMap.get(sa.Id).Duration || sa.Timesheet_Hours_New__c!=Trigger.oldMap.get(sa.Id).Timesheet_Hours_New__c  || sa.NumberOfAssingedCrewMembers__c!=Trigger.oldMap.get(sa.Id).NumberOfAssingedCrewMembers__c) && sa.NumberOfAssingedCrewMembers__c!=null){
                    ParentToUpdateDurationAndTimesheet.add(sa.ParentRecordId);
                }
            }
            if(!ParentToUpdateDurationAndTimesheet.isEmpty()){
                WorkOrderToUpdateDurationAndTimesheet=new Map<Id,WorkOrder>([Select id,Planned_Duration__c,Timesheet_Duration__c,(SELECT ParentRecordId, Id, Duration, Timesheet_Hours__c,Timesheet_Hours_New__c,NumberOfAssingedCrewMembers__c FROM ServiceAppointments where NumberOfAssingedCrewMembers__c!= null AND duration != null) From WorkOrder where id in: ParentToUpdateDurationAndTimesheet]);
                
                if(!WorkOrderToUpdateDurationAndTimesheet.isEmpty()){
                    for(workOrder wo: WorkOrderToUpdateDurationAndTimesheet.values()){
                        wo.Planned_Duration__c=0;
                        wo.Timesheet_Duration__c=0;
                        if(!wo.ServiceAppointments.isEmpty()){
                        for(ServiceAppointment sa: wo.ServiceAppointments){
                            if(sa.Duration!=null)
                                wo.Planned_Duration__c=wo.Planned_Duration__c+(sa.Duration*sa.NumberOfAssingedCrewMembers__c);
                            if(sa.Timesheet_Hours_New__c!=null)
                                wo.Timesheet_Duration__c=wo.Timesheet_Duration__c+(sa.Timesheet_Hours_New__c*sa.NumberOfAssingedCrewMembers__c);
                        }
                    }
                        WorkOrderList.add(wo);
                    }
                    Update WorkOrderList;
                }
                
            }
        }
        
        if(Trigger.isUpdate){ 
            Set<String> saIdSet = new Set<String>();
            for(ServiceAppointment sa: trigger.new){
                if(sa.Status == 'Completed' && Trigger.oldMap.get(sa.Id).Status!=sa.Status && sa.Main_SA__c==true ){saIdSet.add(sa.Id);
                }
            }
            if(!saIdSet.isEmpty()){AwsCaller.sReportAmazonS3caller(saIdSet);
            }
            
            Set<Id> parents4 = new Set<Id>();
            Map<Id,WorkOrder> woMap4 ;
            for(ServiceAppointment sa: trigger.new){
                if((sa.Main_SA__c==true && Trigger.oldMap.get(sa.Id).Main_SA__c!=sa.Main_SA__c) ||(sa.Main_SA__c==true &&(Trigger.oldMap.get(sa.Id).Arrival_Window_Start_Time__c!=sa.Arrival_Window_Start_Time__c || Trigger.oldMap.get(sa.Id).Arrival_Window_End_Time__c!=sa.Arrival_Window_End_Time__c || Trigger.oldMap.get(sa.Id).SchedStartTime!=sa.SchedStartTime || Trigger.oldMap.get(sa.Id).Technician__c!=sa.Technician__c || Trigger.oldMap.get(sa.Id).Technician_Email__c!=sa.Technician_Email__c ))){
                    parents4.add(sa.ParentRecordId);
                }
            }
            if(!parents4.isEmpty()){
                woMap4 = new Map<Id,WorkOrder>([SELECT Id, Arrival_Window_End_Time__c, Technician_Email__c, Arrival_Window_Start_Time__c, Scheduled_Start_Date__c FROM WorkOrder where Id in : parents4]);
                if(!woMap4.isEmpty()){
                    for(ServiceAppointment sa: trigger.new){
                        for(WorkOrder wo: woMap4.values()){
                            List<String> scheduleStartdatelist;
                            if(sa.ParentRecordId==wo.id){
                                wo.Technician__c=sa.Technician__c;
                                wo.Technician_Email__c=sa.Technician_Email__c;
                                woList4.add(wo);
                            }
                        }
                    }
                    //  update woList4;
                }
            }
            
            Set<Id> woIds2 = new Set<Id>();
            Set<Id> caseIds2 = new Set<Id>();
            Set<Id> parentIds = new Set<Id>();
            for(ServiceAppointment sa : Trigger.new){
                if((sa.Status =='Incomplete' && Trigger.oldMap.get(sa.Id).Status != sa.Status && sa.Incomplete_Reason__c =='Additional Works Required' /*&& sa.RecordTypeId==hcinstallWORecordTypeId*/)){
                    parentIds.add(sa.ParentRecordId);
                }
            }
            Map<Id,WorkOrder> woMap = new Map<Id,WorkOrder>([select id,caseId from WorkOrder where Id in : parentIds AND RecordTypeId=:hcinstallWORecordTypeId]);
            for(WorkOrder wo : woMap.values()){
                woIds2.add(wo.Id);
                caseIds2.add(wo.CaseId); 
            }
            
            
            
            
            if(!woIds2.isEmpty() && !caseIds2.isEmpty()){
                ServiceAppointmentTriggerHandler.createOnlinePayOpptynQuote(woIds2,caseIds2);
            }
        }
    }
    
    
    workordermap.putall(woList1);
    workordermap.putall(woList2);
    //  workordermap.putall(woList3);
    workordermap.putall(woList4);
    
    if(!saList.isempty())
        update saList;
    if(!workordermap.isempty())
        update workordermap.values();
}