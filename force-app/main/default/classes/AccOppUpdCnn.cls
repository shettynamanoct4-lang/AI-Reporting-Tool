public with sharing class AccOppUpdCnn {
    public static void testo(Map<Id,Contact> oldy, List<Contact> nwy){
        Set<Id> actId = new Set<Id>();
        for(Contact con : nwy){
            if(con.AccountId!=null ){
                actId.add(con.AccountId);
            }
            else if(oldy.get(con.Id).AccountId != con.AccountId){
                actId.add(oldy.get(con.Id).AccountId);
                actId.add(con.AccountId);
            }
        }
        Map<Id,Decimal> chk = new Map<Id,Decimal>();
        List<AggregateResult> agr = [Select AccountId, Sum(Amount) val from Opportunity where AccountId IN: actId group by AccountId];
        for(AggregateResult a : agr){
            chk.put((Id)a.get('AccountId'),(Decimal)a.get('val'));
        }
        List<Account> updtAc = new List<Account>();
        for(Contact cc : nwy){
            Account act = new Account();
            act.Id = cc.AccountId;
            act.Total_Opportunity__c = chk.get(cc.AccountId);
            updtAc.add(act);
        }
        
        
        
        if(updtAc.size()>0){
            update updtAc;
        }
        
    }
    
}