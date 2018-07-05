trigger UpdateQuoteonEmailSent on Task (before insert) {
if(ScheduleWorkOrderBatch.Temp != TRUE || test.isRunningTest()){

    Task newTask;
    
    for(Task t :Trigger.new)
    {
        System.debug('Inside for');
          if(t.WhatId !=null && t.Subject.contains('POD Point Quote') || t.Subject.contains('POD Point quote') || t.Subject.contains('Pod Point quote') || t.Subject.contains('POD Point Quotation') || t.Subject.contains('Pod Point Quotation')|| t.Subject.contains('POD Point quotation')|| t.Subject.contains('Pod Point quotation')|| t.Subject.contains('POD Point Quotations')
            || t.Subject.contains('Pod Point Quotations')|| t.Subject.contains('POD Point quotations')|| t.Subject.contains('Pod Point quotations')|| t.Subject.contains('PP Quote') || t.Subject.contains('PP quote')|| t.Subject.contains('POD Point Quotes')|| t.Subject.contains('Pod Point Quotes')|| t.Subject.contains('PP Quotes')|| t.Subject.contains('PP quotes')
            )
          {
              Quote recQuote = [Select Id,status,QuoteNumber,contactid,accountid,Number_of_Quotes_Presented__c from Quote where Id =:t.WhatId];

                 System.debug('Status:'+recQuote.status);
                  if(recQuote.status != 'Accepted')
                  {
                      System.debug('Inside If');
                      recQuote.status = 'Presented';
                      //if(recQuote.Number_of_Quotes_Presented__c == null)
                      //    recQuote.Number_of_Quotes_Presented__c = 1;
                      //else
                      //    recQuote.Number_of_Quotes_Presented__c = recQuote.Number_of_Quotes_Presented__c + 1;
                      
                    update recQuote;
                    
                  }
                  else
                  {
                       t.addError('The opportunity is already WON, no change can be made.');
                  }

          }
                   
    }
    }
}