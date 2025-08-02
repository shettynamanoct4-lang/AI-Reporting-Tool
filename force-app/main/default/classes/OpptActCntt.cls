public with sharing class OpptActCntt {
    public static void testa(List<Opportunity> newOpp){
        Set<Id> actId = new Set<Id>();
        for(Opportunity op : newOpp){
            if(op.AccountId!=null){
                actId.add(op.AccountId);
            }
        }
        Map<Id, Integer> ma = new Map<Id, Integer>(); 
        List<AggregateResult> agr = [Select AccountId, COUNT(Id) cnt from Opportunity where AccountId IN:actId GROUP BY AccountId];
        for(AggregateResult a : agr){
            ma.put((Id)a.get('AccountId'), (Integer)a.get('cnt'));
        }
        List<Account> acUp = new List<Account>();
        if(ma.size()!=null){
            for(Opportunity oo : newOpp){
                if(oo.AccountId!=null && ma.containsKey(oo.AccountId)){
                    Account actt = new Account();
                    actt.Id = oo.AccountId;
                    actt.NumOfOpportunity__c = ma.get(oo.AccountId);
                    acUp.add(actt);
                }
            }
        }
        if(acUp.size()>0 && !acUp.isEmpty()){
            update acUp;
        }
    }

}