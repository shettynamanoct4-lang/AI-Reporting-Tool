public with sharing class UpdLstNme {
    public static void testa(List<Contact>con){
        Set<Id> actId = new Set<Id>();
        for(Contact c : con){
            actId.add(c.AccountId);
        }
        Map<Id,Account> ma = new Map<Id, Account>();
        List<Contact> upd = new List<Contact>();
        List<Account> act = [Select Id, Name, (Select Id,FirstName, LastName from Contacts) from Account where Id IN:actId];
        for(Account ad : act){
            ma.put(ad.Id, ad);
        }
        for(Contact aa : con){
           aa.Job_Name__c = ma.get(aa.AccountId).Name;
        }
            
    }

}