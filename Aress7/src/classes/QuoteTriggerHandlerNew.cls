public class QuoteTriggerHandlerNew {
public list<OpportunityContactRole> lstOppContactRoles{get;set;}
public Id woRecordTypeId;
public Opportunity record;
public List<Account> lstacc;
public List<Case> lstCases;
public Contact con;
public ID recordId;
public String primaryContactID{get;set;}
public WorkType wt1{get;set;}     

public static void createCommCase(Map<Id,Quote> QuoteIdMap){
    
    Opportunity record =[SELECT Id,Name,AccountId,shipping_street__c,Shipping_Country__c,Shipping_City__c,Shipping_Country_Picklist__c,Shipping_Postal_Code__c,
    (SELECT Id,product_family__c,ProductCode,Quantity,Unitprice, PricebookEntryId  FROM Opportunitylineitems WHERE ProductCode = 'Mngd_Inst' or ProductCode = 'Commission_Inst' or ProductCode = 'Array_Inst')
    FROM Opportunity WHERE Id IN :QuoteIdMap.keyset()];
    List<OpportunityContactRole> lstOppContactRoles = [SELECT ContactId,Id,IsPrimary,OpportunityId,Role FROM OpportunityContactRole where OpportunityId =: record.Id and IsPrimary = True];
    WorkType wt = [SELECT id, name FROM WorkType WHERE Name='Install (Commercial)' LIMIT 1];
    Id ccRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
    if(lstOppContactRoles.size()==0)
        record.addError('Please add a site contact before requesting a site survey and ensure to include their phone number.');
    else
    {
        OpportunityContactRole ocr=lstOppContactRoles[0];
        contact con =[SELECT id,email FROM contact WHERE id =: ocr.ContactId];
        list<Case> lstCases = [SELECT id,casenumber,Opportunity_Name__c,Install_Status__c,account.name,type,RecordTypeId,status FROM case WHERE accountid =: record.accountid AND Opportunity__c =: record.Id AND RecordTypeId=:ccRecordTypeId];//'0129E0000001DMH'];
         System.debug('record.Opportunitylineitems==>'+record.Opportunitylineitems);
        if(record.Opportunitylineitems.size()!=0){
        if(lstCases.isEmpty()){
            System.debug('IN lstCases.isEmpty()');
            System.debug('con.id is ==>' +con.Id);
            Id woRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
            Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Commercial Case').getRecordTypeId();
            System.debug('CaseRecordTypeId ==>' +CaseRecordTypeId+' shipping street==>'+ record.Shipping_Street__c+' shipping city==>'+ record.Shipping_City__c+' shipping postcode==>'+record.Shipping_Postal_Code__c+' shipping country==>'+record.Shipping_Country__c+' Opp Id==>'+record.Id+' ContactID==>'+con.Id);
            case cs = new case(Install_Status__c = 'Requested', AccountId=record.AccountId,RecordTypeId=CaseRecordTypeId, Type='Commercial', Street__c=record.Shipping_Street__c, City__c=record.Shipping_City__c, PostalCode__c=record.Shipping_Postal_Code__c, Country_Picklist__c=record.Shipping_Country_Picklist__c, Opportunity__c=record.Id, ContactId=con.Id);
            if(Userinfo.getName() == 'Daniel Eyers'|| Userinfo.getName() == 'Philip Hill' || Userinfo.getName() == 'Mike Jackson')cs.Project_Manager__c = 'Sam Biggs';
            if(Userinfo.getName() == 'Trishan Ponnamperuma'|| Userinfo.getName() == 'James Stevens' || Userinfo.getName() == 'Claire Barrett' || Userinfo.getName() == 'Rob Hughes' ||Userinfo.getName() == 'Matt Watkiss' ||Userinfo.getName() == 'Chris Cheetham' ||  Userinfo.getName() == 'Jonathan Horsfield'  ||Userinfo.getName() == 'Sam Deptford'  || Userinfo.getName() == 'Isabel James')cs.Project_Manager__c = 'Kostas Papadakis';         
            if(Userinfo.getName() == 'Jarred Rayns' || Userinfo.getName() == 'Rory Duncan' || Userinfo.getName() == 'Alex Potts' || Userinfo.getName() == 'Liam Callaghan' || Userinfo.getName() == 'Alex Zed')cs.Project_Manager__c = 'Bradley Turk';
            if(Userinfo.getName() == 'Oliver Dodd' || Userinfo.getName() == 'Sophie Freeman')cs.Project_Manager__c = 'Martin Miles';
            if(Userinfo.getName() == 'Natalia Silverstone')cs.Project_Manager__c = 'Sam Biggs';
            if(Userinfo.getName() == 'Charles Roberts')cs.Project_Manager__c = 'Arne Nikolaus';
            //if(Userinfo.getName() == 'Jagdish Nikam')cs.Project_Manager__c = 'Martin';
            Insert cs;
            
            System.debug('woRecordTypeId ==>'+woRecordTypeId);
            System.debug('newly created case ==>'+cs.Id);
            WorkOrder w1= new WorkOrder(ContactId=con.Id,AccountId=record.AccountId,RecordTypeId = woRecordTypeId ,Priority='Medium',WorkTypeId = wt.Id ,Status = 'Unassigned',CaseId = cs.id);
            System.debug('newly created Work Order ==>'+w1.Id);
            Insert w1;
            
            list<ServiceAppointment> lstserviceappoinment=[SELECT Id, ParentRecordId, Case__c FROM ServiceAppointment where ParentRecordId=: w1.Id];
            System.debug('lstserviceappoinment ==>'+lstserviceappoinment);
            for(ServiceAppointment sa : lstserviceappoinment ){
                sa.Case__c =w1.CaseId;
                sa.ContactId=con.Id;
            }
           
            if(lstserviceappoinment.size() > 0) {
            //update lstserviceappoinment;//this seems to just update the list. How do I actually update the custom object?
            }
            //noError = True;
            }
            else{
                system.debug('I am in else part');
                case cs1= lstCases[0];
                if(Userinfo.getName() == 'Daniel Eyers'|| Userinfo.getName() == 'Philip Hill' || Userinfo.getName() == 'Mike Jackson')cs1.Project_Manager__c = 'Sam Biggs';
                if(Userinfo.getName() == 'Trishan Ponnamperuma'|| Userinfo.getName() == 'James Stevens' || Userinfo.getName() == 'Claire Barrett' || Userinfo.getName() == 'Rob Hughes' ||Userinfo.getName() == 'Matt Watkiss' ||Userinfo.getName() == 'Chris Cheetham' ||  Userinfo.getName() == 'Jonathan Horsfield'  ||Userinfo.getName() == 'Sam Deptford'  || Userinfo.getName() == 'Isabel James')cs1.Project_Manager__c = 'Kostas Papadakis';         
                if(Userinfo.getName() == 'Jarred Rayns' || Userinfo.getName() == 'Rory Duncan' || Userinfo.getName() == 'Alex Potts' || Userinfo.getName() == 'Liam Callaghan' || Userinfo.getName() == 'Alex Zed')cs1.Project_Manager__c = 'Bradley Turk';
                if(Userinfo.getName() == 'Oliver Dodd' || Userinfo.getName() == 'Sophie Freeman')cs1.Project_Manager__c = 'Martin Miles';
                if(Userinfo.getName() == 'Natalia Silverstone')cs1.Project_Manager__c = 'Sam Biggs';
                if(Userinfo.getName() == 'Charles Roberts')cs1.Project_Manager__c = 'Arne Nikolaus';
                //if(Userinfo.getName() == 'Jagdish Nikam')cs1.Project_Manager__c = 'Martin Miles';
                cs1.Install_Status__c = 'Requested'; 
                checkRecursive.skip_install_statuscheck_whencasecreated = true;
                Update cs1;
                WorkOrder w1;
                list<WorkOrder> wolst = [select Id, Status, CaseId from WorkOrder where ((CaseId =: cs1.Id) AND (Status!='Completed' AND Status!='Incomplete' AND Status!='Rejected') AND WorkTypeId=:wt.Id)];
                Id woRecordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Commercial Install').getRecordTypeId();
                if(wolst.size()==0){
                    w1= new WorkOrder(AccountId=record.AccountId,RecordTypeId = woRecordTypeId ,Priority='Medium',WorkTypeId =wt.Id,Status = 'Unassigned',CaseId = cs1.Id);
                    Insert w1;
                    list<ServiceAppointment> lstserviceappoinment=[SELECT Id, ParentRecordId, Case__c FROM ServiceAppointment where ParentRecordId=: w1.Id];
                    System.debug('lstserviceappoinment ==>'+lstserviceappoinment);
                    for(ServiceAppointment sa : lstserviceappoinment ){
                        sa.Case__c =w1.CaseId;
                        sa.ContactId=con.Id;
                    }
                    if(lstserviceappoinment.size() > 0) {
                    //update lstserviceappoinment;
                    }
                }else{
                    System.debug('In Else=>');
                    
                    QuoteIdMap.get(record.id).addError('There is already a pending Install.');              
                }
            } 
        }
        }
    }
}