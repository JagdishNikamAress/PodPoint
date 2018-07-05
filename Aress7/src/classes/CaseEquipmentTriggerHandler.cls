public class CaseEquipmentTriggerHandler {
    public static void handleAfterUpdate(List<Case_Equipment__c> caseEquipmentListNew){
        List<Opportunity> listOpportunity = new List<Opportunity>();
        Set<Id> caseId = new Set<Id>();
        for(Case_Equipment__c ce : caseEquipmentListNew){
           caseId.add(ce.Case__c);
        }
        
        for(Case c : [select Id,Opportunity__c,(select Total_Cost__c from Case_Equipments__r) from Case where id IN : caseId and Opportunity__c!= null]){
            Double totalcost=0.0;
            for(Case_Equipment__c ce : c.Case_Equipments__r)
            {
                if(ce.Total_Cost__c != null)
                	totalcost += ce.Total_Cost__c ;
                else
                    totalcost += 0;
            }
            Opportunity opp = new Opportunity(Id=c.Opportunity__c , Equipment_Cost__c = totalcost);
            listOpportunity.add(opp);
        }
        
        update listOpportunity;         
    }
}