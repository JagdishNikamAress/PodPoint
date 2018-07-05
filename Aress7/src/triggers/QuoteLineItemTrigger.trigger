trigger QuoteLineItemTrigger on QuoteLineItem (after insert, after update) {
    set<Id> qliIdSet= new set<Id>();
    set<Id> quoteIdSet= new set<Id>();
    if(trigger.isafter){
        if(trigger.isInsert || Trigger.isUpdate){
            for(QuoteLineItem qli: trigger.new){
                qliIdSet.add(qli.Id);
                quoteIdSet.add(qli.QuoteId);
            }
            List<Quote> quoteList= new List<Quote>([SELECT Id, OpportunityId, Workplace_Grant__c, Opportunity.Workplace_Grant__c,(SELECT Id, Quantity, QuoteId, TotalPrice, Total_No_of_Socket__c FROM QuoteLineItems) FROM Quote where id in: quoteIdSet And Opportunity.Workplace_Grant__c=true]);
            List<QuoteLineItem> qliList =new List<QuoteLineItem>([SELECT Id, Quantity, QuoteId, TotalPrice, Total_No_of_Socket__c FROM QuoteLineItem where QuoteId in : quoteList]);
            if(!quoteList.isEmpty()){
                for(Quote qt: quoteList){
                    //integer a= integer.valueOf(qt.Workplace_Grant__c);
                   integer a;
                    integer b=0;
                    for (QuoteLineItem qli: qliList){
                        //qt.Workplace_Grant__c=(((qli.Quantity*qli.Total_No_of_Socket__c)*(-300))+a);
                       System.debug('qli.Quantity'+qli.Quantity);
                        System.debug('qli.Total_No_of_Socket__c'+qli.Total_No_of_Socket__c);
                        System.debug('a'+a);
                        a=(integer.valueOf(qli.Total_No_of_Socket__c));
                        b=b+a;
                        System.debug('b'+b);
                    }
                    qt.Workplace_Grant__c=b*(-300);
                }
                update quoteList;
            }
        }
    }
    
    
}