trigger OrderDispatchEmailTrigger on EmailMessage (after insert) {
    for(EmailMessage message : trigger.new)
    {
      if(message.TextBody != null)
      {
          if(message.TextBody.contains('Ref. Order #'))
          {
              String OrderID = message.TextBody.right(message.TextBody.length() - message.TextBody.indexof('Ref. Order #') - 12);
              
              system.debug('Order Number : ' + OrderID);
              
              List<OrderItem> ordItemsforExport = [SELECT ListPrice,OrderId,OrderItemNumber,Include_in_CSV__c,Street_del__c,order.account.name,PricebookEntry.name,PricebookEntry.unitprice,Quantity,Tracking_number__c,Dispatch_Date__c,Dispatch_Status__c,SKU_Number__c,Dispatch_Address__c FROM OrderItem where order.id =: OrderID.trim() and Include_in_CSV__c = true];
            
              
              Order ord;
              if(ordItemsforExport.size()>0)
              {
                  ord = [SELECT id,Order_Send_Date__c,recordtype.name from order where id =: ordItemsforExport[0].orderid];
              
                  List<OrderItem> OrderItemToUpdate = new List<OrderItem>();
                
                  for(OrderItem oi : ordItemsforExport)
                  {
                      oi.Dispatch_Status__c = 'Awaiting iPro';
                      
                      OrderItemToUpdate.add(oi);
                  }
                  
                  if(ord !=null)
                    ord.Order_Send_Date__c = datetime.now().date();	
                  
                  //if(ord.recordtype.name == 'Non Managed Installation')
                  ord.Status = 'Ready for Dispatch';

				                     
                  update OrderItemToUpdate;
                  update ord;
              }
                  
          }
      }
        
      
    }
}