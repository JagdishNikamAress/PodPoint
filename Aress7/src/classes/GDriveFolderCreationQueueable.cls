public  class GDriveFolderCreationQueueable implements Queueable, Database.AllowsCallouts {
    private  Opportunity opy;
    private List<Account> acc;
    Private string OpptyCaseNumber;
    
    public void execute(QueueableContext context) {
        system.debug('<<<<--- Inside Execute---->>>'+opy+'-->'+acc);
        calloutGDRIVE(opy,acc);
    }

    public GDriveFolderCreationQueueable(Opportunity opy1,List<Account> acc1, string CaseNumber ){
        system.debug('<<<<--- Inside Constructor ---->>>'+opy1+'-->'+acc1);
        opy = opy1;
        acc = acc1;
        OpptyCaseNumber = CaseNumber;
        
    }
    

    public void calloutGDRIVE(Opportunity record,List<Account> lstacc){
                system.debug('<<<<--- Inside calloutGDRIVE ---->>>');

        String IdForURL;
        
        //Access token Generation
        string accesstoken;
        if(test.isRunningTest()){
            accesstoken='ya29.c.ElnYBehL132CTBgK_Y_Q7QLIwO0IahNfahq8VFYCTSRcVK0GzTphOfTt9TTlDbOg6QhowErBXAXracbU1tFQEq3ZqyBH9-8ItihDCteeMab7s3RSTpxiuXcGmQ';
        } else{
            accesstoken = GDriveForSalesforceCtrl.accessToken;
        }
        
        system.debug('The value of the access token'+accesstoken);
        
        //Get the list of all folders present in the Teamdrive
        Http http2 = new Http();
        HttpRequest req2 = new HttpRequest();
        req2.setEndpoint('https://www.googleapis.com/drive/v3/files?corpora=teamDrive&includeTeamDriveItems=true&q=mimeType+%3D+%22application%2Fvnd.google-apps.folder%22&supportsTeamDrives=true&teamDriveId=0AO1E6HSb1uccUk9PVA&fields=files(id%2Cname)&key=AIzaSyCUWLx_j1JK8hjCwCdYJ9Y0QMhmQ3eAJNg');
        req2.setHeader('Authorization', 'Bearer ' + accessToken);
        req2.setHeader('Content-Type', 'application/json');
        req2.setMethod('GET');
        HttpResponse resp2 = http2.send(req2);
        system.debug('The value of the response'+resp2.getbody());
        string JSONValue = resp2.getBody();
        
        //Convert the json into Map
        Map<string,string> temp = parseJSONToMap(JSONValue);
        System.debug('temp'+temp);
        
        //Create folders in google drive as per the criteria
        String filename= record.name +' '+ '-'+' ' +OpptyCaseNumber;
        String foldername= lstacc[0].name;
        String Body;
          if(temp.containskey(foldername)){
            body = '{ "kind": "drive#file", "mimeType": "application/vnd.google-apps.folder", "name":"'+filename+'","parents": ["'+temp.get(foldername)+'"]}';
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&key=AIzaSyCUWLx_j1JK8hjCwCdYJ9Y0QMhmQ3eAJNg');
            system.debug('accessToken>>'+accessToken);
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setHeader('Content-Type', 'application/json');
            system.debug('body.length()'+body.length());
            system.debug('body>>'+body);
            req.setBody(body);
            req.setMethod('POST');
            HttpResponse resp = http.send(req);
            AllActions objAction = (AllActions) System.JSON.deserialize(resp.getBody(), AllActions.class); 
            system.debug('id===>' + objAction.id);
            IdForURL=objAction.id;
            system.debug('The valueo of the gdrive link'+IdForURL);
            system.debug('resp'+resp);
        } else if(!temp.containskey(foldername)){
            body = '{ "kind": "drive#file", "mimeType": "application/vnd.google-apps.folder", "name":"'+foldername+'","parents": ["'+'0AO1E6HSb1uccUk9PVA'+'"]}';
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&key=AIzaSyCUWLx_j1JK8hjCwCdYJ9Y0QMhmQ3eAJNg');
            system.debug('accessToken>>'+accessToken);
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setHeader('Content-Type', 'application/json');
            system.debug('body.length()'+body.length());
            system.debug('body>>'+body);
            req.setBody(body);
            req.setMethod('POST');
            HttpResponse resp = http.send(req);
            system.debug('resp'+resp.getBody());
            string respbody = resp.getBody();
            AllActions objAction = (AllActions) System.JSON.deserialize(resp.getBody(), AllActions.class); 
            system.debug('id===>' + objAction.id);
            IdForURL=objAction.id;
             
            string temp2 = objAction.id;
            system.debug('Value of the temp'+temp2);
            //string folderid =  respbody.mid(respbody.indexOf('id')+6,respbody.indexOf('id')+6+28);  
            // system.debug(folderid);
            body = '{ "kind": "drive#file", "mimeType": "application/vnd.google-apps.folder", "name":"'+filename+'","parents": ["'+temp2+'"]}';
            Http http4 = new Http();
            HttpRequest req4 = new HttpRequest();
            req4.setEndpoint('https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&key=AIzaSyCUWLx_j1JK8hjCwCdYJ9Y0QMhmQ3eAJNg');
            system.debug('accessToken>>'+accessToken);
            req4.setHeader('Authorization', 'Bearer ' + accessToken);
            req4.setHeader('Content-Type', 'application/json');
            system.debug('body.length()'+body.length());
            system.debug('body>>'+body);
            req4.setBody(body);
            req4.setMethod('POST');
            HttpResponse resp4 = http4.send(req4);
            system.debug('resp4'+resp4);
            AllActions2 objAction2 = (AllActions2) System.JSON.deserialize(resp.getBody(), AllActions2.class); 
            system.debug('id===>' + objAction.id);
            IdForURL=objAction2.id;
            
        }
                   SecondJob sj = new SecondJob(record,IdForURL); 

                   System.enqueueJob(sj);

    }
    
     Map<string,string> parseJSONToMap(string JSONValue){
        JSONParser parser = JSON.createParser(JSONValue);
        list<string> jsonMap = new list<string>();
        Map<string,string> jsonMap1 = new Map<string,string>();
        boolean bb=true;
        while (parser.nextToken() != null) {
            if(bb){
                parser.nextToken();
                bb=false;
            }
            parser.nextToken();
            parser.nextToken();
            parser.nextvalue();
            String id2 = parser.getText();
            parser.nextToken();
            parser.nextvalue();
            String name = parser.getText();
            jsonMap1.put(name, id2);
            jsonMap.add(name);
        }
        return jsonMap1;
    }
    
    
    public class AllActions{
        public String id   {get;set;}
        
    }
    public class AllActions2{
        public String id   {get;set;}
        
    }
    
    
    
}