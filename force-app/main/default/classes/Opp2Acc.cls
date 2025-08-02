public with sharing class Opp2Acc {
    public static void chk(List<Opportunity>op){
        Set<Id> allAccId = new Set<Id>();
        for(Opportunity o : op){
            allAccId.add(o.AccountId);
        }
        allAccId.remove(null);
        Set<Id> AccMoreThan2Opp = new Set<Id>();
        Map<Id, AggregateResult> AccIdMore = new Map<Id, AggregateResult>([Select AccountId from Opportunity where AccountId IN:allAccId GROUP BY AccountId Having Count(Id)>2]);
        AccMoreThan2Opp = AccIdMore.keySet();
        for(Opportunity o : op){
            if(AccMoreThan2Opp.contains(o.AccountId)){
                o.AccountId.addError('You can\'t have more than 2 Opp per Acc');
            }
            
        }
    }
    
}