trigger ProductRequiredTrigger on ProductRequired (after insert,after delete) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        Set<Id> parents = new Set<Id>();
        for(ProductRequired pr: trigger.new)
            parents.add(pr.ParentRecordId);
        Map<Id,WorkOrder> woMap = new Map<Id,WorkOrder>([select id,caseId,RecordType.name,worktype.name, worktype.Appointment_Start_Offset__c, (select id,Main_SA__c,Products_Summary__c from serviceappointments),(SELECT Product2.family,Product2.ProductCode,  Id FROM ProductsRequired) from WorkOrder where Id in : parents]);
        Map<Id,serviceappointment> saMap=new Map<Id,serviceappointment>();
        for(WorkOrder wo: woMap.values()){
            for (serviceappointment sa : wo.serviceappointments){
                sa.Products_Summary__c='';
                integer i=0;
                for(ProductRequired prodReq : wo.ProductsRequired){
                    if(i==0){
                        sa.Products_Summary__c=prodReq.Product2.ProductCode;
                    }else{
                        sa.Products_Summary__c=sa.Products_Summary__c+' + '+prodReq.Product2.ProductCode;
                    }
                    i++;
                }
                saMap.put(sa.Id,sa);
            }
        }
        if(!saMap.isEmpty()){
            update saMap.values();
        }
        /*   for(ProductRequired prodReq: trigger.new){
if(woMap.containsKey(prodReq.ParentRecordId)){
integer soloUnit=0;
integer chargingCable=0;
integer commUnit=0;
String solounitproductcode;
for(workorder woRec : woMap.values()){
// System.debug('woRec.RecordType.name @@@@@@@@@@@@@@@@@@'+woRec.RecordType.name);
if(woRec.RecordType.name=='Commercial Install'){
commUnit=1;
}

if(woRec.RecordType.name=='Homecharge Install'){
//  System.debug('woRec.ProductsRequired @@@@@@@@@'+woRec.ProductsRequired);                            
for(ProductRequired pr: woRec.ProductsRequired){
//  System.debug('pr.Product2.family @@@@@@@@@@@@@@@'+pr.Product2.family);
if(pr.Product2.family=='Solo Units'){
soloUnit=soloUnit+1;
solounitproductcode=pr.Product2.ProductCode;
}
if(pr.Product2.family=='Charging Cables' || pr.Product2.family=='Mounts' || pr.Product2.family=='Installs')
chargingCable=chargingCable+1;
// System.debug('soloUnit @@@@@@@@@'+soloUnit);
//  System.debug('chargingCable @@@@@@@@@@@@@'+chargingCable);
}
}
//    System.debug('FINAL soloUnit+++++chargingCable @@@@@@@@@@@@@@@'+soloUnit+'-----'+chargingCable);

for (serviceappointment sa : woRec.serviceappointments){
if(commUnit==1)
sa.Products_Summary__c='Commercial Units';
if(soloUnit==1 && chargingCable==0)
sa.Products_Summary__c=solounitproductcode;
if(soloUnit==0 && chargingCable>0)
sa.Products_Summary__c='+ Extras';
if(soloUnit==1 && chargingCable>0)
sa.Products_Summary__c=solounitproductcode+'+ Extras';
if(soloUnit>1 && chargingCable==0)
sa.Products_Summary__c='Multiple Products';
if(soloUnit>1 && chargingCable>0)
sa.Products_Summary__c='Multiple Products+ Extras';
saMap.put(sa.Id,sa);
}
}
}
}		
if(!saMap.isEmpty()){
update saMap.values();
}  */
    }
    
    if(Trigger.isAfter && Trigger.isDelete){
        Set<Id> parents = new Set<Id>();
        for(ProductRequired pr: trigger.old)
            parents.add(pr.ParentRecordId);
        Map<Id,WorkOrder> woMap = new Map<Id,WorkOrder>([select id,caseId,RecordType.name,worktype.name, worktype.Appointment_Start_Offset__c, (select id,Main_SA__c,Products_Summary__c from serviceappointments),(SELECT Product2.family, Product2.ProductCode, Id FROM ProductsRequired) from WorkOrder where Id in : parents]);
        Map<Id,serviceappointment> saMap=new Map<Id,serviceappointment>();
        for(WorkOrder wo: woMap.values()){
            for (serviceappointment sa : wo.serviceappointments){
                sa.Products_Summary__c='';
                integer i=0;
                if(!wo.ProductsRequired.isEmpty()){
                for(ProductRequired prodReq : wo.ProductsRequired){
                    if(i==0){
                        sa.Products_Summary__c=prodReq.Product2.ProductCode;
                    }else{
                        sa.Products_Summary__c=sa.Products_Summary__c+' + '+prodReq.Product2.ProductCode;
                    }
                    i++;
                }
            }
                saMap.put(sa.Id,sa);
            }
        }
        if(!saMap.isEmpty()){
            update saMap.values();
        }
        /*  for(ProductRequired prodReq: trigger.old){
if(woMap.containsKey(prodReq.ParentRecordId)){
integer soloUnit=0;
integer chargingCable=0;
integer commUnit=0;
for(workorder woRec : woMap.values()){
// System.debug('woRec.RecordType.name @@@@@@@@@@@@@@@@@@'+woRec.RecordType.name);
if(woRec.RecordType.name=='Commercial Install'){
commUnit=1;
}

if(woRec.RecordType.name=='Homecharge Install'){
//  System.debug('woRec.ProductsRequired @@@@@@@@@'+woRec.ProductsRequired);                            
for(ProductRequired pr: woRec.ProductsRequired){
//  System.debug('pr.Product2.family @@@@@@@@@@@@@@@'+pr.Product2.family);
if(pr.Product2.family=='Solo Units')
soloUnit=soloUnit+1;
if(pr.Product2.family=='Charging Cables' || pr.Product2.family=='Mounts')
chargingCable=chargingCable+1;
// System.debug('soloUnit @@@@@@@@@'+soloUnit);
//  System.debug('chargingCable @@@@@@@@@@@@@'+chargingCable);
}
}
//    System.debug('FINAL soloUnit+++++chargingCable @@@@@@@@@@@@@@@'+soloUnit+'-----'+chargingCable);

for (serviceappointment sa : woRec.serviceappointments){
if(commUnit==1)
sa.Products_Summary__c='Commercial Units';
if(soloUnit==1 && chargingCable==0)
sa.Products_Summary__c='S7-UC';
if(soloUnit==0 && chargingCable>0)
sa.Products_Summary__c='+ Extras';
if(soloUnit==1 && chargingCable>0)
sa.Products_Summary__c='S7-UC+ Extras';
if(soloUnit>1 && chargingCable==0)
sa.Products_Summary__c='Multiple Products';
if(soloUnit>1 && chargingCable>0)
sa.Products_Summary__c='Multiple Products+ Extras';
if((soloUnit==1 && chargingCable==0) || commUnit==0)
sa.Products_Summary__c=' ';
saMap.put(sa.Id,sa);

}
}
}
}
if(!saMap.isEmpty()){
update saMap.values();
}	*/
    }
    
}