public with sharing class AcCnPne {
    public static void testo(List<Account> nwact , Map<Id,Account> oldma){
        Set<Id> actId = new Set<Id>();
        for(Account a : nwact){
            if(a.Phone != oldma.get(a.Id).Phone ){
                actId.add(a.Id);
            }
        }
        Map<Id, Account> mo = new Map<Id,Account>();
        List<Contact> updc = new List<Contact>();
        List<Account> nwAc = [Select Id, Phone, (Select Id, LastName, Phone from Contacts) from Account where Id IN:actId];
        for(Account v : nwAc){
            mo.put(v.Id, v);
        }
        for(Account d : nwact){
            if(d.Phone != oldma.get(d.Id).Phone  ){
                if(mo.containsKey(d.Id)){
                    Account au = mo.get(d.Id);
                    List<Contact> cnn = au.Contacts;
                    for(Contact ct : cnn){
                        ct.Phone = d.Phone;
                        updc.add(ct);
                        System.debug('Updated'+ updc);
                    }
                }
            }
        }
        update updc;
        
        
        
    }

}