public class FeedBackController{
    public Case cs;
    public String comments {get;set;}
    public String btnClrGd {get;set;}
    public String btnClrBd {get;set;}
    public string param;
    public FeedBackController(){
        param = apexpages.currentpage().getparameters().get('rat');
        changeButton();
    }
    
    public pagereference doSave(){
        cs = new Case();
        cs.id = apexpages.currentpage().getparameters().get('csid');
        cs.SAT_Rating__c = param;
        cs.SAT_Comment__c = comments;
        
        update cs;
        
        pagereference pr = new pagereference('https://pod-point.com/');
        return pr;
    }
    
    public void goodBtn(){
        param ='Good';
        changeButton();
    }
    
    public void badBtn(){
        param = 'Bad';
        changeButton();
    }
    
    public void changeButton(){
        if(param  == 'Good'){
            btnClrGd = '#91BF43;font-weight: bold';
            btnClrBd = '#D9D9D9';
        } else {
            btnClrGd = '#D9D9D9';
            btnClrBd = '#91BF43;font-weight: bold';
        }
    }
}