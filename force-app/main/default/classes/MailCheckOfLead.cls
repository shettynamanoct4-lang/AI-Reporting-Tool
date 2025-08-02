public with sharing class MailCheckOfLead {
    public static void testa(List<Lead> newLead){
        Set<String> Emails = new Set<String>();
        List<Contact> con = [Select Id, LastName, Email from Contact];
        for(Contact c : con){
            Emails.add(c.Email);
        }
        for(Lead l : newLead){
            if(Emails.contains(l.Email)){
                l.addError('You can\'t have duplicate mail');
            }
        }
    }

}