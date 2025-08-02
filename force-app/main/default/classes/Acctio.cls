public with sharing class Acctio {
    public static void test(List<Contact> cn){
        Set<Id> acctId = new Set<Id>();
        for(Contact c : cn){
            if(c.AccountId!=null){
                acctId.add(c.AccountId);
            }
        }
        Map<Id,Integer> na = new Map<Id,Integer>();
        List<AggregateResult> af = [Select AccountId, Count(Id)cn from Contact where AccountId IN:acctId GROUP BY AccountId];
        for(AggregateResult b : af){
            na.put((Id)b.get('AccountId'),(Integer)b.get('cn'));
        }
        List<Account> nw = new List<Account>();
        for(Contact s : cn){
            Account a = new Account();
            a.Id = s.AccountId;
            a.contactCount__c = na.get(s.AccountId);
            nw.add(a);
        }
        update nw;
    }
    public static void test1(List<Contact> cn, Map<Id,Contact> om){
        Set<Id> acctId = new Set<Id>();
        for(Contact c : cn){
            if((c.AccountId != null) &&  (om.get(c.Id).AccountId != c.AccountId)){
                acctId.add(om.get(c.Id).AccountId);
                acctId.add(c.AccountId);
                
            }
        }
        Map<Id,Integer> na = new Map<Id,Integer>();
        List<AggregateResult> af = [Select AccountId, Count(Id)cn from Contact where AccountId IN:acctId GROUP BY AccountId];
        for(AggregateResult b : af){
            na.put((Id)b.get('AccountId'),(Integer)b.get('cn'));
        }
        List<Account> nw = new List<Account>();
        for(Contact s : cn){
            Account a = new Account();
            a.Id = s.AccountId;
            a.contactCount__c = na.get(s.AccountId);
            nw.add(a);
        }
        update nw;
        
    }

}