public with sharing class SlackPublisherOrder {
     
    //private static final String slackURL = 'https://hooks.slack.com/services/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';
     
    public class ords{
        @InvocableVariable(label='Order Number')
        public String orderNumber;
        @InvocableVariable(label='Status')
        public String status;
        @InvocableVariable(label='ID')
        public String id;
        @InvocableVariable(label='Type')
        public String type;
        @InvocableVariable(label='Channel')
        public String channel;
    }
     
    
    @InvocableMethod(label='Post Order to Slack')
    public static void postToSlackCasesUpdate(List<ords> orders) {
        ords ord = orders[0]; // If bulk, only post first to avoid overloading Slack channel
        Map<String,Object> msg = new Map<String,Object>();
        if(ord.status == 'Ready for dispatch')
        	msg.put('text', 'The following order has been updated:\n' + ord.orderNumber + '\nNew Stage: *' + ord.status + '\nType: *' + ord.type + '*' + ' \n Click Link : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + ord.Id);
        else
            msg.put('text', 'The following order has been created:\n' + ord.orderNumber + '\nNew Stage: *' + ord.status + '\nType: *' + ord.type + '*' + ' \n Click Link : ' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + ord.Id);
        //msg.put('text', 'The following order has been created:\n' + ord.orderNumber + '\nNew Status: *' + ord.status + '*');
        msg.put('mrkdwn', true);
        
        String slackURL;
        if(ord.channel =='Install')
            slackURL = 'https://hooks.slack.com/services/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';
        else if(ord.channel =='Operations')
            slackURL = 'https://hooks.slack.com/services/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';
        else if(ord.channel =='Finance')
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