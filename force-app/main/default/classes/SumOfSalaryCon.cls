public with sharing class SumOfSalaryCon {
    public static void testa(List<Contact> con){
        Set<Id> actId = new Set<Id>();
        for(Contact c : con){
            actId.add(c.AccountId);
        }
        List<Account> upd = new List<Account>();
        Map<Id, Decimal> ma = new Map<Id, Decimal>();
        List<AggregateResult> agr = [Select AccountId, Sum(Budget__c) cal from Contact 
                                     where AccountId IN: actId GROUP BY AccountId];
        for(AggregateResult a: agr){
            ma.put((Id)a.get('AccountId'), (Decimal)a.get('cal'));
        }
        for(Contact cc : con){
            Account ua = new Account();
            ua.Id = cc.AccountId;
            ua.No_Of_Contact__c = ma.get(cc.AccountId);
            upd.add(ua);
            
            
        }
        if(upd.size()>0){
            update upd;
        }
        
    }

}