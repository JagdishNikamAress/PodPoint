public class DispatcherOpportunityViewController {

    public DispatcherOpportunityViewController(ApexPages.StandardController controller) {
        this.controller = controller;
    }

    public PageReference getRedir() {

        system.debug('Parameter : ' +ApexPages.currentPage().getParameters().get('id'));
        Opportunity o = [Select id, recordtypeid From Opportunity Where Id = :ApexPages.currentPage().getParameters().get('id')];

        PageReference newPage;

        if (o.recordtypeid == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId()
           || o.recordtypeid == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Online Payment').getRecordTypeId()
           || o.recordtypeid == Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Bid').getRecordTypeId()) {
            newPage = Page.CustomOppDtail;
            newPage.getParameters().put('id', o.id);
        } else {
            newPage = new PageReference('/' + o.id);
            newPage.getParameters().put('nooverride', '1');
        }

        
        return newPage.setRedirect(true);

    }

    private final ApexPages.StandardController controller;

}