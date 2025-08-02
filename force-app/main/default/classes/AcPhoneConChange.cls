public with sharing class AcPhoneConChange {
    public static void testo(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact c : newCon){
            actId.add(c.AccountId);
        }
        List<Account> acti = new List<Account>();
        Map<Id,Account> ma = new Map<Id,Account>();
        List<Account> act = [Select Id, Phone, (Select Id, LastName, Phone from Contacts) from Account where Id IN:actId];
        for(Account aa : act){
            ma.put(aa.Id,aa);
        }
        for(Contact c : newCon){
            if(ma.containsKey(c.AccountId)){
                Account acc = ma.get(c.AccountId);
                acc.Phone = c.Phone;
                acti.add(acc);
            }
        }
    /*    for(Account aa : act){
            for(Contact cc : aa.Contacts){
                aa.Phone = cc.Phone;
                acti.add(aa);
            }
        } */
        if(acti.size()>0){
            update acti;
        }
        
    }

}