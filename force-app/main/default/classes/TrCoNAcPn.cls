public with sharing class TrCoNAcPn {
    public static void testa(List<Contact> nwCn){
        Set<Id> actId = new Set<Id>();
        for(Contact c : nwCn){
            actId.add(c.AccountId);
        }
        Map<Id,Account> ma = new Map<Id,Account>();
        List<Account> ac = [Select Id, Name, Phone from Account where Id IN:actId];
        for(Account aa : ac){
            ma.put(aa.Id, aa);
        }
        for(Contact cn : nwCn){
            if(ma.containsKey(cn.AccountId)!=null){
                cn.Phone = ma.get(cn.AccountId).Phone;
            }
        }
    }

}