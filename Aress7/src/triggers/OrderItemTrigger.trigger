/**
    * @author:          Prasun Banerjee
    * @date:            20/07/2016
    * @description:     This will update the Order status to Dispatched if all order products are dispatched or as Partially dispatched if some are dispatched.
    * @param:           N/A 
    * @moficationlog:   N/A
    */

trigger OrderItemTrigger on OrderItem (after update) 
{
    List<OrderItem> lstOrderItems = new List<OrderItem>();
    List<OrderItem> lstOrderItems_update = new List<OrderItem>();
    Set<Order> lstOrder_update = new Set<Order>();
    
    for(OrderItem oi : Trigger.New)
    {
        Order o = [select id,Status from order where id =: oi.OrderId];
        Boolean contains = False;
        //Check if the order item status is changed
       if(Trigger.newMap.get(oi.id).dispatch_status__c != Trigger.oldMap.get(oi.id).dispatch_status__c && o.Status !='Dispatched') 
       {
           Boolean blAllDispatched = true;
           Boolean blPartiallyDispatched = false;
           Boolean blAllDraft = true;
           
           lstOrderItems = [select id,dispatch_status__c from OrderItem where orderid =:  o.id ];
           
           
           for(OrderItem OrderItem : lstOrderItems)
           {
               if(OrderItem.dispatch_status__c != 'Dispatched')
                   blAllDispatched = false;
               else
                   blPartiallyDispatched = true;
               
               if(OrderItem.dispatch_status__c != 'Draft' && OrderItem.dispatch_status__c != 'Awaiting iPro' )
                   blAllDraft = false;
           }
           
           system.debug('All Dispatched--' + blAllDispatched);
           system.debug('Partial Dispatched--' + blPartiallyDispatched);
           
           if(blAllDraft == false)
           {
                if(blAllDispatched == true)
                   o.Status = 'Dispatched';
               else
               {
                   if(blPartiallyDispatched==true)
                    o.Status = 'Partially Dispatched';
               }
           }
            
           for(Order ord : lstOrder_update)
           {
               if(ord == o)
                   contains = true;
           }
           
           if(contains == False)
                lstOrder_update.add(o);
           //update o;
           
           
       }
        
       //Check if the date to site is the earliest one, then udpate the date in order field
       
        if(Trigger.newMap.get(oi.id).date_to_site__c != Trigger.oldMap.get(oi.id).date_to_site__c) 
        {
            system.debug('Inside if');
            lstOrderItems = [select id,dispatch_status__c,date_to_site__c from OrderItem where orderid =:  o.id ORDER BY Date_to_Site__c ASC NULLS LAST ];
            
            system.debug('Count :' + lstOrderItems.size());
            if(lstOrderItems.size()>0)
            {
                o.Earliest_Date_to_Site__c = lstOrderItems[0].date_to_site__c;
                lstOrder_update.add(o);
            }
        }
        
       
           
    }
    List<order> alst = new List<order>(lstOrder_update);
    //update lstOrderItems_update;
    //update lstOrder_update;
    update alst;
}