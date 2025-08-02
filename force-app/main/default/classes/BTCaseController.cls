public with sharing class BTCaseController {
    @AuraEnabled
    public static String createCase(String subject, String description) {
        Case newCase = new Case(
            Subject = subject,
            Description = description,
            Origin = 'Web',
            Brand__c = 'BT Business',
            ContactId = '0035g00000XlBE3AAN'
            //RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support Case').getRecordTypeId()
        );

       
        
        // Suppress default Web-to-Case auto-response
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.EmailHeader.triggerAutoResponseEmail = false;
dmlOpts.EmailHeader.triggerUserEmail = false;

        // Important: pass dmlOpts in insert method
        Database.insert(newCase, dmlOpts);

        
        System.debug('Case : '+ newCase);
        System.debug('Case Number : '+ newCase.Id);

        // Send custom branded email
        sendBrandedEmail(newCase.Id);

        return newCase.Id;
    }

    private static void sendBrandedEmail(Id caseId) {
        // Use email template with BT Branding
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'BT_Branded_Email' LIMIT 1];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId('0035g00000XlBE3AAN');
        mail.setTemplateId(template.Id);
        mail.setSaveAsActivity(false);
        mail.setWhatId(caseId);
        System.debug('Mail success : '+ mail);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}