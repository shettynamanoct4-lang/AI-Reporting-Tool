public with sharing class CountOfOppsOnActsCls {
    public static Set<Id> actIds = new Set<Id>();
    public static Map<Id,Integer> countOfOppOnAct = new Map<Id,Integer>();
    public static List<Account> updateAct = new List<Account>();
    public static void testa(List<Opportunity> newOpps){
        for(Opportunity oop : newOpps){
            if(oop.AccountId!=null){
                actIds.add(oop.AccountId);
            }

        }
        Integer count;
        List<Account> acts = [Select Id, Name, (Select Id, AccountId, Amount, 	Name, 	CloseDate, StageName, Type from Opportunities) from Account
                              where Id IN:actIds];
        for(Account ac : acts){
            count = ac.Opportunities.size();
            countOfOppOnAct.put(ac.Id, count);
        }
        for(Opportunity oopp : newOpps){
            if(oopp.AccountId!=null){
                if(countOfOppOnAct.size() >0 && countOfOppOnAct.containsKey(oopp.AccountId)){
                    Account a = new Account();
                    a.Id = oopp.AccountId;
                    a.contactCount__c = countOfOppOnAct.get(oopp.AccountId);
                    updateAct.add(a);
                }
            }
            
        }
        if(updateAct.size()>0 && !updateAct.isEmpty()){
            update updateAct;
        }
        
    }

}