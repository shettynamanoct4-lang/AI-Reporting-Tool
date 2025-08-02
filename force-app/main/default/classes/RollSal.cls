public with sharing class RollSal {
    public static void testo(List<Contact> con){
        Set<Id> actId = new Set<Id>();
        for(Contact co : con){
            actId.add(co.AccountId);
        }
        Map<String,Decimal> ma = new Map<String,Decimal>();
        List<AggregateResult> agr = [Select AccountId ,MIN(Min_Sal__c) mi from Contact  where AccountId IN:actId Group By AccountId];
        for(AggregateResult ag : agr){
            ma.put((String)ag.get('AccountId'),(Decimal)ag.get('mi') );
        }
        List<Account> upd = new List<Account>();
        for(Contact cf : con){
            if(ma.containsKey(cf.AccountId)){
                Account act = new Account();
                act.Id = cf.AccountId;
                act.Con_Sal__c = ma.get(cf.AccountId);
                upd.add(act);
            }
        }
        if(upd.size()>0){
            update upd;
        }
    }

}