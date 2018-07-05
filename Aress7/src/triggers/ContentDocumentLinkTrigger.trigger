trigger ContentDocumentLinkTrigger on ContentDocumentLink (After insert) {
    if(trigger.isafter && trigger.isinsert){
        set<id> Caseids = new set<id>();
        list<contentDocumentLink> addContentdoclist = new  list<contentDocumentLink>();
        for(ContentDocumentLink cod: Trigger.new){
            if(string.valueof(cod.LinkedEntityId).contains('500') ){
               Caseids.add(cod.LinkedEntityId);
            }
        }
        if(caseids.size()>0){
            list<workorder> Workorderlist = [select id, caseid from workorder where caseid IN : Caseids ];
            for(ContentDocumentLink cod: Trigger.new){
                for(workorder w : Workorderlist){
                    if(cod.LinkedEntityId == w.caseid){
                        ContentDocumentLink cd=new ContentDocumentLink();
                        cd.ContentDocumentId=cod.ContentDocumentId;
                        cd.LinkedEntityId= w.id;
                        cd.ShareType = 'V';
                        addContentdoclist.add(cd);
                    }
                }
                
            }
            if(addContentdoclist.size()>0){
                try{
                   insert addContentdoclist;
                }catch(Exception e){
                    system.debug('Error');
                } 
            }
        }
    }
}