public with sharing class ContuCountuCls {
    public static void testa(Map<Id,Account> oldAcct, Map<Id,Account> newAcct){
        Set<Id> actIds = new Set<Id>();
        for(Account act : newAcct.values()){
            if(oldAcct!=null && act.Rating != oldAcct.get(act.Id).Rating){
                actIds.add(act.Id);
            }
        }
        Integer size = 0;
        //List<Account> updAct = new List<Account>();
        Map<Id,Account> updAct = new Map<Id,Account>();
        List<Account> acts = [Select Id, Name, (Select Id, LastName from Contacts) from Account where Id IN:actIds];
        for(Account a : acts){
            for(Contact c : a.Contacts){
                size +=1;
            }
            a.contactCount__c = size;
            //updAct.add(a);
            updAct.put(a.Id, a);
        }
        for(Account act : newAcct.values()){
            if(updAct!=null && updAct.containsKey(act.Id)){
                act.contactCount__c = updAct.get(act.Id).contactCount__c;
            }
        }
        
        

    }

}