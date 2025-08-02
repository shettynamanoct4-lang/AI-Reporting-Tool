public with sharing class ClinAcCn {
    public static void testo(List<Account> actnw){
        Set<Id> actId = new Set<Id>();
        List<Contact> updcn = new List<Contact>();
        for(Account a : actnw){
            Contact cn = new Contact();
            cn.AccountId = a.Id;
            cn.LastName = a.Name;
            updcn.add(cn);
            actId.add(a.Id);
        }
        if(updcn.size()>0){
            insert updcn;
        }
        Map<Id, Account> ma = new Map<Id, Account>();
        List<Account> avn = [Select Id, Name, Client_Contact__c from Account where Id IN:actId];
        for(Account y : avn){
            ma.put(y.Id, y);
        }
        List<Account> upAc = new List<Account>();
        for(Contact up : updcn){
            if(ma.containsKey(up.AccountId)){
                Account ac = ma.get(up.AccountId);
                ac.Client_Contact__c = up.Id;
                upAc.add(ac);
            }
        }
        if(upAc.size()>0){
            update upAc;
        }
    }

}