public with sharing class CltAc {
    public static void test(List<Account> ac){
        Set<Id> acctId = new Set<Id>();
        List<Contact> cv = new List<Contact>();
        for(Account a : ac){
            Contact c = new Contact();
            c.AccountId = a.Id;
            c.LastName = a.Name;
            cv.add(c);
            acctId.add(c.AccountId);
        }
        insert cv;
        Map<Id, Account> ma = new Map<Id, Account>();
        List<Account> upd = new List<Account>();
        List<Account> ad = [Select Id ,Client_Contact__c from Account where Id IN: acctId];
        for(Account fc : ad){
            ma.put(fc.Id, fc);
        }
        for(Contact v : cv){
            Account e = ma.get(v.AccountId);
            e.Client_Contact__c = v.Id;
            upd.add(e);
        }
        update upd;
        
    }

}