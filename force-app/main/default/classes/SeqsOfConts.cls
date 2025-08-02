public with sharing class SeqsOfConts {
    public static void testa(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact cc : newCon){
            if(cc.AccountId!=null){
                actId.add(cc.AccountId);
            }
        }
        Map<Id,Decimal> ma = new Map<Id,Decimal>();
        List<Contact> cons = [Select Id, AccountId, size__c from Contact where AccountId IN:actId];
        if(cons.size()>0){
            for(Contact d : cons){
                Decimal i = d.size__c +1;
                d.size__c = i;
                ma.put(d.AccountId, i);
            }
            
        }
        else{
            for(Contact cc : cons){
                cc.size__c = 1;
            }
        }
        for(Contact cnt : newCon){
            if(ma.containsKey(cnt.AccountId)){
                cnt.size__c = ma.get(cnt.AccountId);
            }
            else{
                cnt.size__c = 1;
            }
        }
    }

}