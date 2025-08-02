public with sharing class NatDlt {
    public static void testo(List<Account> act){
        Set<Id> actId = new Set<Id>();
        for(Account a : act){
            actId.add(a.Id);
        }
        Map<Id, Integer> ma = new Map<Id, Integer>();
        List<AggregateResult> agr = [Select AccountId, COUNT(Id) cnt from Contact  where AccountId IN:actId GROUP BY AccountId HAVING COUNT(Id)>2];
        for(AggregateResult av : agr){
            ma.put((Id)av.get('AccountId'), (Integer)av.get('cnt'));
        }
        for(Account anw : act){
            if(ma.containsKey(anw.id)){
                anw.addError('You can\'t delete');
            }
        }
    }

}