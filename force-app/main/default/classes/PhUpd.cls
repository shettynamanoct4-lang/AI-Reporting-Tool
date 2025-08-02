public with sharing class PhUpd {
    public static void testo(Map<Id,Account> oldMa, List<Account> nwAc){
        Set<Id> actId = new Set<Id>();
        for(Account ac : nwAc){
            if(oldMa.get(ac.Id).Phone != ac.Phone){
                actId.add(ac.Id);
            }
        }
        List<Contact> updCon = new List<Contact>();
        List<Account> actnw = [Select Id, Name,Phone, (Select Id, LastName, Phone from Contacts) from Account where Id IN:actId];
        for(Account aa : actnw){
            if(oldMa.get(aa.Id).Phone != aa.Phone){
                List<Contact> retCn = aa.Contacts;
                for(Contact vc : retCn){
                    vc.Phone = aa.Phone;
                    updCon.add(vc);
                }
            }
            
        }
        if(updCon.size()>0){
            update updCon;
        }
    }

}