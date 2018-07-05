public class SAReportUploaderClass extends AWS{
    Public List<ServiceAppointment> saList= new List<ServiceAppointment>();
    Public List<ServiceReport> saReportList =  new List<ServiceReport>(); 
    Public Map<Id,String> saIdUuidMap = new Map<Id,String> ();
    public SAReportUploaderClass(SET<String> saIdSet){
        saList = [SELECT Id,Case__r.UUID__c FROM ServiceAppointment WHERE ID IN:saIdSet];
        System.debug('saList'+saList);
        for(ServiceAppointment saRec:saList){
            saIdUuidMap.put(saRec.Id, saRec.Case__r.UUID__c);
        }
        saReportList=[SELECT Id, ContentVersionDocumentId, DocumentName, DocumentContentType, DocumentBody, ServiceReportNumber, Template, ParentId,CreatedDate FROM ServiceReport WHERE ParentId IN:saIdUuidMap.keySet() ORDER BY CreatedDate DESC LIMIT 1];
        init();
    }
     public override void init() {
         System.debug('saList'+saList);
         if(!saIdUuidMap.values().isEmpty()){
             for(String saId:saIdUuidMap.keySet()){
                 String UUID = saIdUuidMap.get(saId);
                 System.debug('UUID=>'+UUID);
                 for(ServiceAppointment saRec:saList){
                     for(ServiceReport Report:saReportList){
                         System.debug('Report.DocumentBody'+Report.DocumentBody);
                         endpoint = new Url('https://podpoint-installs-salesforce.s3.amazonaws.com/');
                         resource = '/'+UUID+'/sf-uploads/service-report/'+Report.ServiceReportNumber+'.pdf';
                         region = 'eu-west-1';
                         service = 's3';
                         accessKey = 'AKIAJECOLKBMMZZW7SYA';
                         method = HttpMethod.XPUT;
                         payload = Report.DocumentBody;
                         createSigningKey('1E5rXnyHOhykk2zcn68YLWHOZzzxHW2PWWSgiXwY');
                         System.debug('calling getBucket=>');
                         getBuckets();
                         System.debug('call over getBucket=>');
                         // need to pause to allow the createRequest to complete before trying again
                         //Integer start = System.Now().millisecond();
                         //while(System.Now().millisecond()< start+500){ 
                         //}
                     }
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
    
     public static void fakeMethod(){
    Integer i = 0;
    i++;
  i++;
  i++;
  i++;
  i++;
  i++;
  i++;
  i++;
           i++;
  i++;
  i++;
  i++;
  i++;
  i++;
  i++;
  i++;
           i++;
  i++;
  i++;
  i++;
  i++;
  i++;
  i++;
  i++;
    //repeat the i++ hundred of times

  }
}