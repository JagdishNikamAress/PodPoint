trigger emailAttachmentReassigner on Attachment (After insert) {
    if(trigger.isAfter && trigger.isInsert){
        
        map<id,set<id>> MapEmailMessageIdAndAttachmentId = new map<id,set<id>>();
        set<id> emailids = new set<id>();
        list<attachment> attachmentlist = new list<attachment>();
        set<id> attachmentdeleteids = new set<id>();
        integer attsize;
        if(test.isRunningTest())
        {
             attsize = 10;
        }else{
             attsize = 102400;
        }
        for( Attachment attach : trigger.new ) {
           
            if(attach.BodyLength > attsize ){
                if(attach.parentid != null ){
                    String s = string.valueof( attach.parentid);
                    if( s.substring( 0, 3 ) == '02s' ){
                        attachmentdeleteids.add(attach.id);
                        if(MapEmailMessageIdAndAttachmentId.containskey(attach.parentid)){
                            set<id> tempid = MapEmailMessageIdAndAttachmentId.get(attach.parentid);
                            tempid.add(attach.id);
                            MapEmailMessageIdAndAttachmentId.put(attach.parentid,tempid);
                            emailids.add(attach.parentid);
                            attachmentlist.add(attach);
                            
                        } else{
                            set<id> ids=new set<id>();
                            ids.add(attach.id);
                            MapEmailMessageIdAndAttachmentId.put(attach.parentid,ids);
                            emailids.add(attach.parentid);
                            attachmentlist.add(attach);
                        }
                    }
                }
           }
        
        } 
        list<EmailMessage> EmailmessageidwithparentID = [select parentID from EmailMessage where id IN : emailids];
        map<id,id> MapEmailMessageIdAndCaseId = new map<id,id>();
        for(EmailMessage EM : EmailmessageidwithparentID){
            for(id ATTid : MapEmailMessageIdAndAttachmentId.get(EM.id)){
                MapEmailMessageIdAndCaseId.put(ATTid,EM.ParentId);
            }
        }
        
        Map<id,ContentVersion> ContentversionMap  = new Map<id,ContentVersion>();
        for( Attachment at : trigger.new ) {
           if(at.BodyLength > attsize ){
                ContentVersion cv = new ContentVersion();
                cv.ContentLocation = 'S';
                cv.PathOnClient = at.Name;
                cv.Origin = 'H';
                cv.OwnerId = at.OwnerId;
                cv.Title = at.Name;
                cv.VersionData = at.Body;
                ContentversionMap.put(at.id,cv);  
           }
        }
        insert ContentversionMap.values();
        set<id> insertedid = new set<id>();
        for(ContentVersion cv: ContentversionMap.values()){
            insertedid.add(cv.id);
        }
        //  for(ContentversionMap.values())
        Map<id,ContentVersion>  insertedContetnVersions= new Map<id,ContentVersion>([SELECT Id, ContentDocumentId FROM ContentVersion where id IN : insertedid]);
        Map<id,id> InsertedContentversionMap  = new Map<id,id>();
        Map<id,id> AttachmentIdAndInsertedContentversionMap  = new Map<id,id>();
        If(!insertedContetnVersions.isEmpty()){
            for(ContentVersion cv: insertedContetnVersions.values()){
                InsertedContentversionMap.put(cv.id,cv.ContentDocumentId);
                for(id attachId: ContentversionMap.keyset()){
                    if(ContentversionMap.get(attachId).id==cv.id){
                        AttachmentIdAndInsertedContentversionMap.put(attachId,cv.id);
                    }
                }
                
            }
        }
        List<ContentDocumentLink> cdlList = new  List<ContentDocumentLink>();
        for( Attachment at : trigger.new ) {
           if(at.BodyLength > attsize ){
                ContentDocumentLink cl = new ContentDocumentLink(LinkedEntityId = MapEmailMessageIdAndCaseId.get(at.id), ContentDocumentId = InsertedContentversionMap.get(AttachmentIdAndInsertedContentversionMap.get(at.Id)), ShareType = 'I');
                cdlList.add(cl);
          }
        }
        Database.SaveResult[] lsr =  Database.insert(cdlList,false);
        //Database.delete(attachmentlist,false);
        /*  list<attachment> listattachment = [select id from attachment where id IN : attachmentdeleteids];
delete listattachment;*/
    }
}