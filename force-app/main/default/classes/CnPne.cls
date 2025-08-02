public with sharing class CnPne {
    public static void testo(List<Account> nwAct, Map<Id,Account> maol){
        Set<Id> actId = new Set<Id>();
        for(Account aa : nwAct){
            if(aa.Phone != maol.get(aa.Id).Phone){
                actId.add(aa.Id);
            }
        }
        Map<Id, Account> maa = new Map<Id, Account>();
        List<Account> actii = [Select Id, Name, Phone from Account where Id IN: actId];
        for(Account acc : actii){
            maa.put(acc.Id, acc);
        }
        List<Contact> upd = new List<Contact>();
        List<Contact> cnt = [Select Id, AccountId ,Account.Phone, LastName from Contact where AccountId IN:actId];
        for(Contact cc : cnt){
            cc.Phone = cc.Account.Phone;
            upd.add(cc);
            
        } 
       /* for(Account d :nwAct){
            Contact ccf = new Contact();
            ccf.AccountId = d.Id;
            ccf.Phone = maa.get(d.Id).Phone;
            upd.add(ccf);
        } */
        if(upd.size()>0){
            update upd;
        }
    }

}