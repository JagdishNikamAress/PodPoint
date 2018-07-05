public with sharing class SlackPublisher {
     
    //private static final String slackURL = 'https://hooks.slack.com/services/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';
     
    public class Oppty {
        @InvocableVariable(label='Opportunity Name')
        public String opptyName;
        @InvocableVariable(label='Stage')
        public String stage;
        @InvocableVariable(label='Channel')
        public String channel;
        @InvocableVariable(label='ID')
        public String id;
    }
     
    @InvocableMethod(label='Post to Slack')
    public static void postToSlack(List<Oppty> oppties) 
    {
        Oppty o = oppties[0]; // If bulk, only post first to avoid overloading Slack channel
        Map<String,Object> msg = new Map<String,Object>();
        msg.put('text', 'The following opportunity has changed:\n' + o.opptyName + '\nNew Stage: *' + o.stage + '*'+ '\n Click Link : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + o.id);
        msg.put('mrkdwn', true);
        String body = JSON.serialize(msg);    
        
        String slackURL;
        if(o.channel =='Install')
            slackURL = 'https://hooks.slack.com/services/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';
        else if(o.channel =='Operations')
            slackURL = 'https://hooks.slack.com/services/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';
        else if(o.channel =='Finance')
            slackURL = 'https://hooks.slack.com/services/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';
        
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