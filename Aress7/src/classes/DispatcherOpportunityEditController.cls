public class DispatcherOpportunityEditController {

    public DispatcherOpportunityEditController(ApexPages.StandardController controller) {
        this.controller = controller;
    }

    public PageReference getRedir() {

        Opportunity o = [Select id, recordtypeid From Opportunity Where Id = :ApexPages.currentPage().getParameters().get('id')];

        PageReference newPage;

        if (o.recordtypeid == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId()
           || o.recordtypeid == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId()
           || o.recordtypeid == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Bid').getRecordTypeId()) {
            newPage = Page.CustomOppOverrideEditPage;
            newPage.getParameters().put('id', o.id);
        } else {
            newPage = new PageReference('/' + o.id + '/e?retURL='+o.id);
            newPage.getParameters().put('nooverride', '1');
        }

        
        return newPage.setRedirect(true);
    }

    private final ApexPages.StandardController controller;
}