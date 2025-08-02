public with sharing class cntOfConOnActtClss {
    public static Set<Id> actIds = new Set<Id>();
    public static Map<Id,Integer> mapOfActIdWidConCounts = new Map<Id,Integer>();
    public static List<Account> accounts = new List<Account>();
    public static void testa(Map<Id,Contact> newCont){
        /*
        for(Contact c : newCont.values()){
            if(c.AccountId!=null){
                 actIds.add(c.AccountId);
            }
        }
        */
        for(Id ids : newCont.Keyset()){
            if(newCont.get(ids).AccountId!=null && String.isNotBlank(String.valueOf(newCont.get(ids).AccountId))){
                 actIds.add(newCont.get(ids).AccountId);
            }
        }
        List<AggregateResult> agr = [Select Count(Id)conCount,AccountId  from Contact where AccountId IN:actIds GROUP BY AccountId];
        for(AggregateResult ag : agr){
            mapOfActIdWidConCounts.put(String.valueOf(ag.get('AccountId')), Integer.valueOf(ag.get('conCount')));
        }
        for(Id ids : newCont.Keyset()){
            if(mapOfActIdWidConCounts.containsKey(newCont.get(ids).AccountId)){
                Account a = new Account();
                a.Id = newCont.get(ids).AccountId;
                a.contactCount__c = mapOfActIdWidConCounts.get(newCont.get(ids).AccountId);
                accounts.add(a);
            }
        }
        if(accounts.size()>0 && !accounts.isEmpty()){
            update accounts;
        }
    }

}