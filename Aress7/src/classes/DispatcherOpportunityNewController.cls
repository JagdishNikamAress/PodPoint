public class DispatcherOpportunityNewController {

    public DispatcherOpportunityNewController(ApexPages.StandardController controller) {
        this.controller = controller;
    }

    public PageReference getRedir() {

        PageReference newPage = Page.CustomOppEditPg;

        if (ApexPages.currentPage().getParameters().get('RecordType') == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId()) {
           // newPage = Page.CustomOppEditPg;
            if(ApexPages.currentPage().getParameters().get('accid') != null){
                   newPage.getParameters().put('recordtype', Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId());
                   newPage.getParameters().put('accid', ApexPages.currentPage().getParameters().get('accid'));
                   newPage.getParameters().put('retURL', ApexPages.currentPage().getParameters().get('accid'));
                   return newPage.setRedirect(true);
            } 
            else {
                newPage.getParameters().put('recordtype', Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId());
                newPage.getParameters().put('retURL', '/006/o');
                return newPage.setRedirect(true);
            }
        
        }else if(ApexPages.currentPage().getParameters().get('RecordType') == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Bid').getRecordTypeId()){
            if(ApexPages.currentPage().getParameters().get('phaseId') != null){
                   newPage.getParameters().put('recordtype', Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Bid').getRecordTypeId());
                   newPage.getParameters().put('phaseId', ApexPages.currentPage().getParameters().get('phaseId'));
                   newPage.getParameters().put('retURL', ApexPages.currentPage().getParameters().get('phaseId'));
                   return newPage.setRedirect(true);
            } 
            else {
                newPage.getParameters().put('recordtype', Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Bid').getRecordTypeId());
                newPage.getParameters().put('retURL', '/006/o');
                return newPage.setRedirect(true);
            }
        }
        else{
            if(ApexPages.currentPage().getParameters().get('accid') != null){
                 Profile pr=[SELECT Name, Id FROM Profile where name='Homecharge Ops User'];         
                id HomechargeOpsManager=UserInfo.getProfileId();
               If(pr.id==HomechargeOpsManager){
                Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId();
                newPage.getParameters().put('accid', ApexPages.currentPage().getParameters().get('accid'));
                newPage.getParameters().put('recordtype', devRecordTypeId);
               } else{
                newPage.getParameters().put('recordtype', ApexPages.currentPage().getParameters().get('RecordType'));
                newPage.getParameters().put('accid', ApexPages.currentPage().getParameters().get('accid'));
                   newPage.getParameters().put('retURL', ApexPages.currentPage().getParameters().get('accid'));}
                return newPage.setRedirect(true);
            }
            else {
                Profile pr=[SELECT Name, Id FROM Profile where name='Homecharge Ops User'];         
                id HomechargeOpsManager=UserInfo.getProfileId();
               If(pr.id==HomechargeOpsManager){
                Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId();
                newPage.getParameters().put('recordtype', devRecordTypeId);
               } else{
                    newPage.getParameters().put('recordtype', ApexPages.currentPage().getParameters().get('RecordType'));
                }
                newPage.getParameters().put('retURL', '/006/o');
                return newPage.setRedirect(true);
            }
        } 
        
        return null;
    }

    private final ApexPages.StandardController controller;
}