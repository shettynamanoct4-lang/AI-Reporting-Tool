public with sharing class AcooChngOmCont {
    public static void testa(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact cc : newCon){
            actId.add(cc.AccountId);
        }
        List<Account> upd = new List<Account>();
        List<Account> act = [Select Id, Name, Phone, (Select LastName, FirstName, Phone from Contacts) from Account
                            where Id IN : actId];
        for(Account aa : act){
            for(Contact co : aa.Contacts){
                aa.Phone = co.Phone;
                
            }
            upd.add(aa);
        }
        if(upd.size()>0 && !upd.isEmpty()){
            update upd; 
        }
    }

}