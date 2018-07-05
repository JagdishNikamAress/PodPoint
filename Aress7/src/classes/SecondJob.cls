public class SecondJob implements Queueable {
    
    private Opportunity record;
    private String Idz;
    
    public SecondJob(Opportunity record,String Idz){
        this.record = record;
        this.Idz =Idz; 
    }
    
    public void updateRecord(Opportunity record,String Idz){
       record.Google_Drive_Folder_Link__c='https://drive.google.com/drive/u/0/folders/'+Idz;
       update record;
    }
    
    public void execute(QueueableContext context) { 
       
        updateRecord(record,Idz);
    }
}