public with sharing class AcConNot2 {
    public static void testo(List<Contact> nwCn){
        Set<Id> actId = new Set<Id>();
        for(Contact ccn : nwCn){
            actId.add(ccn.AccountId);
        }
        Map<Id,Integer> ma = new Map<Id,Integer>();
        List<AggregateResult> agr = [Select AccountId, Count(Id) ct from Contact where AccountId IN:actId GROUP BY AccountId 
                                     HAVING Count(Id)>2 ];
        for(AggregateResult v : agr){
            ma.put((Id)v.get('AccountId'), (Integer)v.get('ct'));
        }
        for(Contact nw : nwCn){
            if(ma.containsKey(nw.AccountId)){
                nw.addError('You can\'t have more than 2 contacts');
            }
        }
    }

}