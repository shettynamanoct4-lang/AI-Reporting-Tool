public with sharing class ContactPhoneAccountSame {
    public static void testa(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact c : newCon){
            if(c.AccountId !=null){
                actId.add(c.AccountId);
            }
        }
        Map<Id,Account> ma = new Map<Id,Account>();
        List<Account> act = [Select Id, Name, Phone, (Select Id, LastName, Phone from Contacts) from Account where Id IN:actId];
        Account t = [Select Id, Name from Account where Name = 'Sanvio'];
        System.debug(t);
        for(Account a : act){
            ma.put(a.Id, a);
        }
        for(Contact cc : newCon){
            //for(Contact cc : ac.Contacts){
                cc.Phone = ma.get(cc.AccountId).Phone;
            
        }
        
    }

}