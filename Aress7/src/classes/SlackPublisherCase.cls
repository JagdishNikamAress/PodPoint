public with sharing class SlackPublisherCase {
     
    //private static final String slackURL = 'https://hooks.slack.com/services/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';
     
    public class Cases{
        @InvocableVariable(label='Case Number')
        public String caseNumber;
        @InvocableVariable(label='Status')
        public String status;
        @InvocableVariable(label='ID')
        public String id;
        @InvocableVariable(label='Type')
        public String type;
        @InvocableVariable(label='Action')
        public String action;
        @InvocableVariable(label='Channel')
        public String channel;
    }
     
    
    @InvocableMethod(label='Post Case Update to Slack')
    public static void postToSlackCasesUpdate(List<Cases> cases) 
    {
        Cases cs = cases[0]; // If bulk, only post first to avoid overloading Slack channel
        Map<String,Object> msg = new Map<String,Object>();
        system.debug('URL' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + cs.Id);
        
                
        if(cs.action == 'Create')
        	msg.put('text', 'The following Case has been created:\n' + cs.CaseNumber + '\nNew Stage: *' + cs.status +'\nCase Type: *' + cs.type + '*' + ' Click Link : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + cs.Id);
        else
            msg.put('text', 'The following Case has been updated:\n' + cs.CaseNumber + '\nNew Stage: *' + cs.status +'\nCase Type: *' + cs.type + '*' + ' Click Link : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + cs.Id);
        msg.put('mrkdwn', true);
        
        String slackURL;
        if(cs.channel =='Install')
            slackURL = 'https://hooks.slack.com/services/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';
        else if(cs.channel =='Operations')
            slackURL = 'https://hooks.slack.com/services/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';
        else if(cs.channel =='Finance')
            slackURL = 'https://hooks.slack.com/services/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';
       
        
        String body = JSON.serialize(msg);    
        System.enqueueJob(new QueueableSlackCall(slackURL, 'POST', body));
    }
     
    public class QueueableSlackCall implements System.Queueable, Database.AllowsCallouts {
         
        private final String url;
        private final String method;
        private final String body;
         
        public QueueableSlackCall(String url, String method, String body) {
            this.url = url;
            this.method = method;
            this.body = body;
        }
         
        public void execute(System.QueueableContext ctx) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod(method);
            req.setBody(body);
            Http http = new Http();
            HttpResponse res = http.send(req);
        }
 
    }
    
}