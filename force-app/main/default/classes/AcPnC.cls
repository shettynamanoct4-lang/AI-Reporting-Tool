public with sharing class AcPnC {
    public static void testo(List<Contact> cont){
        Set<Id> actId = new Set<Id>();
        for(Contact ct : cont){
            actId.add(ct.AccountId);
        }
        Map<Id, Account> ma = new Map<Id, Account>();
        List<Account> ac = [Select Id, Phone from Account where Id IN:actId];
        for(Account a : ac){
            ma.put(a.Id, a);
        }
        List<Account> upd = new List<Account>();
        for(Contact cc : cont){
            Account y = ma.get(cc.AccountId);
            y.Phone = cc.Phone;
            upd.add(y);
        }
        update upd;
        
        
        
        
            
        
    } 

}