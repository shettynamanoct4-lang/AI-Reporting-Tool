public with sharing class ContactPhoneChange {
    public static void testa(List<Account> newAccount){
        Set<Id>actId = new Set<Id>();
        for(Account acn : newAccount){
            actId.add(acn.Id);
        }
        List<Contact> updtd = new List<Contact>();
        List<Account> act = [Select Id,Name,Phone,(Select Id,LastName,Phone from Contacts) from Account
                            where Id IN:actId];
        for(Account aa : act){
            for(Contact cc : aa.Contacts){
                cc.Phone = aa.Phone;
                updtd.add(cc);
            }
        }
        if(updtd.size()>0){
            update updtd;
        }
    }
    public static void testa1(List<Account> newAccount, Map<Id,Account>oldmap){
        Set<Id>actId = new Set<Id>();
        for(Account acn : newAccount){
            if(oldmap.get(acn.Id).Phone != acn.Phone){
                actId.add(acn.Id);
            }
            
        }
        List<Contact> updtd = new List<Contact>();
        List<Account> act = [Select Id,Name,Phone,(Select Id,LastName,Phone from Contacts) from Account
                            where Id IN:actId];
        for(Account aa : act){
            for(Contact cc : aa.Contacts){
                cc.Phone = aa.Phone;
                updtd.add(cc);
            }
        }
        if(updtd.size()>0){
            update updtd;
        }
    }

}