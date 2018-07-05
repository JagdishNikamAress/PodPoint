/**
* @author:          Nilesh More
* @date:            28/11/2017
* @description:     This is the extenstion class for Case(For Create Survey Case button on Commercial Case).
* @param:           N/A 
* @moficationlog:   N/A
*/
public class CaseExtension {
    string caseId;
    public CaseExtension(ApexPages.StandardController standardController){
        //this.standardController = standardController;
        caseId = standardController.getId();
        System.debug('caseId=>'+caseId);
    } 
        
    public PageReference redirect(){
        Case record = [select Id,Opportunity__c From Case where id =:caseId];
        //Write your logic here and redirect
        PageReference retURL = new PageReference('/apex/SendCusomerDatafromCase?id='+record.Opportunity__c);
        retURL.setRedirect(true);
        return retURL;
    
     }
}