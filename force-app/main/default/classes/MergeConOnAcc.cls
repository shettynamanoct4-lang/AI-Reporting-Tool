public with sharing class MergeConOnAcc {
    public static void testa(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact c : newCon){
            actId.add(c.AccountId);
        }
    List<Account> upd = new List<Account>();
    List<Account> act = [Select Id, Name, List_of_Contact__c, (Select Id, LastName from Contacts) from Account where Id IN:actId];
        for(Account a : act){
            List<String> names = new List<String>();
            for(Contact co : a.Contacts){
                names.add(co.LastName);
            }
            String newName = String.join(names, ':');
            Account acto = new Account();
            acto.Id = a.Id;
            acto.List_of_Contact__c = newName;
            acto.Name = a.Name;
            upd.add(acto);
            
            
        }
        if(upd.size()>0){
            update upd;
        }
    }

}