public with sharing class DntDelAccIfCon2 {
    public static void testa(List<Account> acts){
        Set<Id> actId = new Set<Id>();
        for(Account a : acts){
            actId.add(a.Id);
        }
        Map<Id, Account> ma = new Map<Id,Account>();
        List<Account> ver = [Select Id, Name, (Select Id, LastName from Contacts) from Account where Id IN:actId];
        for(Account aa : ver){
            List<Contact> con = aa.Contacts;
            if(con.size()>2){
                ma.put(aa.Id, aa);
            }
        }
        for(Account aaa : acts){
            if(ma.containsKey(aaa.Id)){
                aaa.addError('Cant delete');
            }
        }
    }

}