public class AmazonS3UploaderClass extends AWS{
    Public List<ContentVersion> pCommentFileList = new List<ContentVersion>();
    Public List<ContentVersion> oCommentFileList = new List<ContentVersion>();
    Public Map<Id,String> woIdUuidMap = new Map<Id,String> ();
    public AmazonS3UploaderClass(SET<String> woIdSet){
        List<WorkOrder> woList = [SELECT Id,Case.UUID__c FROM WorkOrder WHERE ID IN:woIdSet];
        for(WorkOrder worec:woList){
            woIdUuidMap.put(worec.Id, worec.Case.UUID__c);
        }
        SET<String> pCommentSet = new SET<String>{'P','p'};
        SET<String> oCommentSet = new SET<String>{'O','o'};    
        List<FeedItem>  feedList=[SELECT Body, parentId, (SELECT RecordId, Title, Type, Value FROM FeedAttachments WHERE Type='Content') FROM FeedItem WHERE parentId IN:woIdSet];
        
        Map<Id, FeedItem> contentVersionWithFeedItem = new Map<Id,FeedItem>();
        
        Set<Id> contentVersionIdSet = new Set<Id>();
        for(FeedItem fi : feedList) {
            List<FeedAttachment> feedattachList = fi.FeedAttachments;
            for(FeedAttachment feedAttach : feedattachList) {
                contentVersionIdSet.add(feedAttach.RecordId);
                contentVersionWithFeedItem.put(feedAttach.RecordId, fi);
            }
        }
        
        List<ContentVersion> cvList= [SELECT Id, ContentDocumentId, Title, FileType, PublishStatus, VersionData, FileExtension FROM ContentVersion WHERE id in: contentVersionIdSet];   //(FileExtension='png' OR FileExtension='jpg') and id in: contentVersionIdSet];       
        SET<String> contentDocIdSet = new SET<String>();
        for(ContentVersion cv:cvList){
            contentDocIdSet.add(cv.ContentDocumentId);
        }
        System.debug('cvList=>'+cvList);
        
        String commentOnly;
        for(ContentVersion cv:cvList){
            
            FeedItem fi = contentVersionWithFeedItem.get(cv.Id);
            
            if(fi.Body!=NULL){
                commentOnly = fi.Body.replaceAll('<[^>]+>',' ').trim();
            }
            System.debug('commentOnly=>'+commentOnly);
            if(pCommentSet.contains(commentOnly) ){
                pCommentFileList.add(cv);
                System.debug('latest pCommentFileList=>'+pCommentFileList);
            }
            if(oCommentSet.contains(commentOnly) ){
                oCommentFileList.add(cv);
                System.debug('latest oCommentFileList=>'+oCommentFileList);
            }
        }
        
        init();
        
    }
     public override void init() {
         if(!woIdUuidMap.values().isEmpty()){
             for(String woId:woIdUuidMap.keySet()){
                 String woRec = woIdUuidMap.get(woId);
                 System.debug('woRec=>'+woRec);
                 for(ContentVersion cvRec:pCommentFileList){
                     system.debug('cvRec.VersionData=>'+cvRec.VersionData);
                     endpoint = new Url('https://podpoint-installs-salesforce.s3.amazonaws.com/');
                     resource = '/'+woRec+'/sf-uploads/photos/serial/'+cvRec.Title.replace(' ', '%20').replace(',', '%20').replace(':', '%20')+'.'+cvRec.FileExtension;
                     region = 'eu-west-1';
                     service = 's3';
                     accessKey = 'AKIAJECOLKBMMZZW7SYA';
                     method = HttpMethod.XPUT;
                     payload = cvRec.VersionData;
                     createSigningKey('1E5rXnyHOhykk2zcn68YLWHOZzzxHW2PWWSgiXwY');
                     getBuckets();
                 }
             }
         }
         
         if(!woIdUuidMap.values().isEmpty()){
             for(String woId1:woIdUuidMap.keySet()){
                 String woRec1 = woIdUuidMap.get(woId1);
                 System.debug('woRec1=>'+woRec1);
                 for(ContentVersion cvRec1:oCommentFileList){
                     system.debug('cvRec1.VersionData=>'+cvRec1.VersionData);
                     endpoint = new Url('https://podpoint-installs-salesforce.s3.amazonaws.com/');
                     resource = '/'+woRec1+'/sf-uploads/photos/offstreet/'+cvRec1.Title.replace(' ', '%20').replace(',', '%20').replace(':', '%20') +'.'+cvRec1.FileExtension;
                     region = 'eu-west-1';
                     service = 's3';
                     accessKey = 'AKIAJECOLKBMMZZW7SYA';
                     method = HttpMethod.XPUT;
                     payload = cvRec1.VersionData;
                     System.debug('payload=>'+payload);
                     createSigningKey('1E5rXnyHOhykk2zcn68YLWHOZzzxHW2PWWSgiXwY');
                     System.debug('before getBuckets');
                     getBuckets();
                     System.debug('after getBuckets');
                 }
             }
         }
     }
    public String[] getBuckets() {
        HttpResponse response = sendRequest();
           String[] results = new String[0];
           // Read response XML; if we get this far, no exception happened
           // This code was omitted for brevity
           return results;
    }
}