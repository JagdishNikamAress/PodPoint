public class templatepageclass {
    public WorkOrder wo;
    //public String comments {get;set;}
    public string param;
    public templatepageclass(){
        //param = apexpages.currentpage().getparameters().get('rat');
    }
    
    public pagereference WoEnter(){
        param = apexpages.currentpage().getparameters().get('rat');
        wo = new WorkOrder();
        wo.id = apexpages.currentpage().getparameters().get('woid');
        wo.Customer_Confirmation__c = true;
        wo.Confirmation_Email__c=true;
        update wo;
        
        //pagereference pr = new pagereference('https://aress1-pod-point.cs88.force.com/tempChecker');
        pagereference pr = new pagereference('http://pod-point.force.com/TemChecker');
        return pr;
    }
}