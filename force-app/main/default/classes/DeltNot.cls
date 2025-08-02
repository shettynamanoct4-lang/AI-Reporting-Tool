public with sharing class DeltNot {
    public static void testo(List<Account> actOld){
        Set<Id> actId = new Set<Id>();
        for(Account a : actOld ){
            actId.add(a.Id);
        }
        Map<Id, Contact> ma = new Map<Id, Contact>();
        List<Account> ant = [Select Id, Name, (Select LastName, FirstName from Contacts) from Account where Id IN:actId];
        for(Account aa : ant){
            List<Contact> cct = aa.Contacts;
            if(cct.size()>2){
                for(Contact coni : cct){
                    ma.put(coni.AccountId, coni);
                 }
            }
            
        }
        for(Account vr : actOld){
            if(ma.containsKey(vr.Id)){
                vr.addError('Cant have more than 2');
            }
        }
        
    }

}