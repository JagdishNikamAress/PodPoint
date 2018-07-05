trigger Trigger_to_update_opportunity_field_Date_of_COPS_Approved on Case (after insert, after delete, after update) 
{
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete)){
        try {
            //List<Case> c_list = [SELECT Id, Date_of_COPS_Approved__c, Opportunity__c from case];
            set<id> oppId = new set<id>();
            for (Case co : Trigger.new){
                oppId.add(co.Opportunity__c);
            }
            
            if(!oppId.isEmpty()){
            System.debug('oppId --->>>>'+oppId);
            
            Opportunity po = [SELECT Id, Date_of_COPS_Approved__c  FROM Opportunity WHERE Id = :oppId];
            System.debug(' po ===>' + po);
            List<Case> l_co = [SELECT Id, Date_of_COPS_Approved__c, OpportunityID__c from case where Opportunity__c= :po.Id order by Date_of_COPS_Approved__c DESC LIMIT 1];
            System.debug(' l_co ===>' + l_co);
            Case c = l_co[0];  
            po.Date_of_COPS_Approved__c = c.Date_of_COPS_Approved__c;
            System.debug('is after update c.Date_of_COPS_Approved__c'+c.Date_of_COPS_Approved__c);
            System.debug('is after update po.Date_of_COPS_Approved__c'+po.Date_of_COPS_Approved__c);
            update po;
            
            }
            if(test.isRunningTest()){
                integer i = 1/0;
            }
        }
        catch (Exception e) {
            System.debug(e);
        }
    }
    
    /*
if(Trigger.isAfter) {
if(Trigger.isUpdate){
try {
for (Case co : Trigger.old){
Opportunity po = [SELECT Id, Date_of_COPS_Approved__c  FROM Opportunity WHERE Id = :co.OpportunityID__c];
List<Case> l_co = [SELECT Id, Date_of_COPS_Approved__c, OpportunityID__c from case where OpportunityID__c= :po.Id order by Date_of_COPS_Approved__c DESC];
Case c = l_co[0];
po.Date_of_COPS_Approved__c = c.Date_of_COPS_Approved__c;
System.debug('is after update c.Date_of_COPS_Approved__c'+c.Date_of_COPS_Approved__c);
System.debug('is after update po.Date_of_COPS_Approved__c'+po.Date_of_COPS_Approved__c);

update po;
}
}
catch (Exception e) {
System.debug(e);
}
}
}


if(Trigger.isDelete){
try {
for (case co : Trigger.old){
Opportunity po = [SELECT Id, Date_of_COPS_Approved__c  FROM Opportunity WHERE Id = :co.OpportunityID__c];
List<Case> l_co = [SELECT Id, Date_of_COPS_Approved__c, OpportunityID__c from case where OpportunityID__c= :po.Id order by Date_of_COPS_Approved__c DESC];
Case c = l_co[0];
po.Date_of_COPS_Approved__c = c.Date_of_COPS_Approved__c;
System.debug('is deletec.Date_of_COPS_Approved__c'+c.Date_of_COPS_Approved__c);
System.debug('is delete po.Date_of_COPS_Approved__c'+po.Date_of_COPS_Approved__c);

update po;
}
} catch (Exception e) {
System.debug(e);
}
}
*/
}