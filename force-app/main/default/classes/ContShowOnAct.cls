public with sharing class ContShowOnAct {
    public static void testa(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact c : newCon){
            if(c.AccountId!=null){
                actId.add(c.AccountId);
            }
        }
        List<Account> updtd = new List<Account>();
        List<Account> act = [Select Id, Name, List_of_Contact__c, (Select Id, LastName, FirstName from Contacts) from Account where Id IN:actId];
        for(Account a : act){
            List<String> str = new List<String>();
            for(Contact cc : a.Contacts){
                str.add(cc.LastName);
            }
            String s = String.join(str, ';');
            a.List_of_Contact__c = s;
            updtd.add(a);
        }
        if(updtd.size()>0 & !updtd.isEmpty()){
            update updtd;
        }
    }

}