@RestResource(urlMapping='/slack')
global class Slack {
 //TODO: Add unit tests
 @HttpPost
 global static void processOutgoingSlackWebhook(){
 	RestRequest req = RestContext.request; 
   	String body =  req.params.get('text');
    String token = req.params.get('token');
    String channelName = req.params.get('channel_name');
    String userName = req.params.get('user_name');
     
  	if (token.equals(Slack_Settings__c.getInstance().token__c)){
    	Slack_Message__c msg = new Slack_Message__c(source__c='Slack',body__c=body,
                                                   channel__c=channelName, user_name__c=userName);     
        insert msg;
    }                                              
 }
    private static void processInboundSlackWebhook(Message msg ){
      
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Slack_Settings__c.getInstance().endpoint__c);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(msg));
        HttpResponse res = h.send(req);
    }
    
     @future(callout=true)
     public static void sendMessageAsync(String msgId) {
           Message msg = new Message(msgId);
         processInboundSlackWebhook(msg);
     }
     public static void sendMessage(String msgId){
           Message msg = new Message(msgId);
     	 processInboundSlackWebhook(msg);
 	 }
    
    public static void sendMessage(Message msg){
     	 processInboundSlackWebhook(msg);
 	 }
    
    public class Message {
        public string text {get;set;}
        public string channel {get;set;}
        public string icon_emoji {get;set;}
        public string username {get;set;}
        public string icon_url {get;set;}
        public Message() {
            
        }
        public Message (Id msgid) {
            Slack_Message__c msg = [select id, name, body__c, channel__c, user_name__c
                                   	from slack_message__c where id =:msgId limit 1];
            text = msg.body__c;
            username = msg.User_Name__c;
            channel = msg.Channel__c;
        }
    }
}