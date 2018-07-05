trigger OutcodeTrigger on Outcode__c (before insert,before update) {
    If(Trigger.isBefore){
        for(Outcode__c otcd: Trigger.new){
            otcd.Name=otcd.RelatedOutcode__c;
        }
    }
    
}