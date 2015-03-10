trigger SlackMessageProcessing on Slack_Message__c (after insert) {
    for (Slack_Message__c msg : Trigger.New) {
        if(msg.Source__c.equals('Salesforce')) {
            Slack.sendMessageAsync(msg.id);
        }
    }
}