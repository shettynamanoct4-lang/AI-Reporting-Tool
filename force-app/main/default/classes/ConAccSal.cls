public with sharing class ConAccSal {
    public static void testo(List<Contact> nwCon){
        Set<Id> actId = new Set<Id>();
        for(Contact co : nwCon){
            actId.add(co.AccountId);
        }
        Map<Id, Account> ma = new Map<Id, Account>();
        List<Account> act = [Select Id, Name, Con_Sal__c from Account where Id IN:actId];
        for(Account a : act){
            ma.put(a.Id, a);
        }
        List<Account> upd = new List<Account>();
        for(Contact cv : nwCon){
            Account acti = ma.get(cv.AccountId);
            acti.Con_Sal__c = cv.Min_Sal__c;
            upd.add(acti);
        }
        if(upd.size()>0){
            update upd;
        }
    }

}