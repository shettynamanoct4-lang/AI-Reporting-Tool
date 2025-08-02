public with sharing class CantHveMreThn2ConOnAcc {
    public static void testa(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact cc : newCon){
            actId.add(cc.AccountId);
        }
        Map<Id, Integer> ma = new Map<Id, Integer>();
        List<AggregateResult> agr = [Select Count(Id) cnt, AccountId from Contact where AccountId IN: actId GROUP BY AccountId ];
        for(AggregateResult aa : agr){
            if((Integer)aa.get('cnt') >2){
                ma.put((Id)aa.get('AccountId'), (Integer)aa.get('cnt'));
            }
        }
        for(Contact cn : newCon){
            if(ma.containsKey(cn.AccountId)){
                cn.AccountId.addError('You cant have more than 2 Contacts here');
            }
        }
        
    }

}