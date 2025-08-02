public with sharing class UpdActPhone {
    public static void testo(List<Contact> nwCn, Map<Id,Contact> oldma){
        Set<Id> actId = new Set<Id>();
        for(Contact c : nwCn){
            if(oldma.get(c.Id).Phone != c.Phone){
                actId.add(c.AccountId);
            }
            
        }
        Map<Id,Account> ma = new Map<Id,Account>();
        List<Account> act = [Select Id,Name, Phone from Account where Id IN:actId];
        for(Account aa : act){
            ma.put(aa.Id, aa);
        }
        List<Account> actUpd = new List<Account>();
        for(Contact nc : nwCn){
            if(oldma.get(nc.Id).Phone != nc.Phone){
                if(ma.containsKey(nc.AccountId)){
                    Account acti = ma.get(nc.AccountId);
                    acti.Phone = nc.Phone;
                    actUpd.add(acti);
                }
            }
        }
        if(actUpd.size()>0){
            update actUpd;
        }
    }

}