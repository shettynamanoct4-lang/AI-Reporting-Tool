public with sharing class SumOppAcc {
    public static void test(List<Account> ac){
        Set<Id> actId = new Set<Id>();
        for(Account a : ac){
            actId.add(a.Id);
        }
        Map<Id, Double> mp = new Map<Id, Double>();
        List<AggregateResult> ag = [Select AccountId, Sum(Amount) sa from Opportunity where AccountId IN:actId Group By  AccountId];
        for(AggregateResult v : ag){
            mp.put((Id)v.get('AccountId'), (Double)v.get('sa'));
        }
        for(Account dv : ac){
            dv.Total_Opportunity__c = mp.get(dv.Id);
        }
    }

}