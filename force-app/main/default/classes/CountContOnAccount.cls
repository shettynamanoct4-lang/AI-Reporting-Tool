public with sharing class CountContOnAccount {
    public static void testo(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact c : newCon){
            if(c.AccountId!=null){
                actId.add(c.AccountId);
            }
        }
        System.debug(actId);
        Map<Id,Integer> ma = new Map<Id,Integer>();
        List<AggregateResult> agr = [Select AccountId, Count(Id)cont from Contact where AccountId IN:actId GROUP BY AccountId];
        for(AggregateResult ag : agr){
            ma.put((Id)ag.get('AccountId'), (Integer)ag.get('cont'));
        }
        List<Account> updAc = new List<Account>();
        for(Contact cc : newCon){
            Account ac = new Account();
            ac.Id = cc.AccountId;
            ac.No_Of_Contact__c = ma.get(cc.AccountId);
            System.debug(ac.No_Of_Contact__c);
            updAc.add(ac);
        }
        if(updAc.size()>0){
            update updAc;
            System.debug(updAc);
        }
    }
}