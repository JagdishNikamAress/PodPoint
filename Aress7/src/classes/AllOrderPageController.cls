public class AllOrderPageController {

    private final Order ord;
    public string orderID {get;set;}
    public List<Order> AllOrders {get;set;}
    public List<Order> CompletedOrders {get;set;}
    public List<Order> IncompleteOrders {get;set;}

    
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    public AllOrderPageController() {
       
        	getAllOrdersforiPro();
      
    }

   
    public void getAllOrdersforiPro() 
    {
        AllOrders = [select id,account.name,ordernumber,status,Internal_Order__c,description,Order_Send_Date__c  from order where Order_Send_Date__c != null and (status ='Cancelled' or status ='Ready for Dispatch' or status ='Partially Dispatched')];
        
        CompletedOrders = [select id,account.name,ordernumber,status,Internal_Order__c,description,Order_Send_Date__c,CreatedDate  from order where status ='Dispatched' and CreatedDate = LAST_N_DAYS:30];
        //return ordItems;
    }
    
	
}