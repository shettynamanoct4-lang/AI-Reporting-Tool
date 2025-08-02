public with sharing class LdMail {
    public static void testo(List<Lead> ldnw){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate et = [Select Id, Subject, Description, HtmlValue, DeveloperName, Body from EmailTemplate where
                           Name = 'Pdf for Lead'];
        for(Lead l : ldnw){
            if(l.Email !=null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(l.Id);
                mail.setSenderDisplayName('System Administrator');
                mail.setUseSignature(false);
                mail.setBccSender(false) ;
                mail.setSaveAsActivity(false);
                mail.setTemplateId(et.Id);
                List<String> s = new List<String>();
                s.add(l.Email);
                mail.toaddresses = s;
                emailList.add(mail);
            }
        }
        /*if(emailList.size()>0){
            List<Messaging.SendEmailResult> res = new List<Messaging.SendEmailResult>();
            if(res[0].success){
                System.debug('Email sent successfully');
            }
            else{
                System.debug('Email fail');
            }
        } */
    }

}