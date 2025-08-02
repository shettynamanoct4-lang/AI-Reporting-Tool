public with sharing class OppOpenAcc {
    public static void testo(List<Opportunity> nwOpp){
        Set<Id> actId = new Set<Id>();
      
        for(Opportunity opp : nwOpp){
            if(opp.AccountId != null){
                actId.add(opp.AccountId);
            }
        }
        List<String> cls = new List<String>();
        List<Opportunity> opro = [Select Id, AccountId, StageName from Opportunity where AccountId IN:actId];
        for(Opportunity oc : opro){
            if(oc.StageName!='Closed Won' && oc.StageName != 'Closed Lost'){
                cls.add(oc.StageName);
            }
        }
        Map<Id,Integer> countMa = new Map<Id,Integer>();
        List<AggregateResult> agr = [Select AccountId, Count(Id) cnt from Opportunity where AccountId IN:actId AND StageName IN:cls 
                                     GROUP BY AccountId];
        for(AggregateResult ag : agr){
            countMa.put((Id)ag.get('AccountId'), (Integer)ag.get('cnt'));
        }
        List<Account> actUpd = new List<Account>();
        for(Opportunity oppo : nwOpp){
            Account act = new Account();
            act.Id = oppo.AccountId;
            act.NumOfOpportunity__c = countMa.get(oppo.AccountId);
            actUpd.add(act);
        }
        if(actUpd.size()>0){
            update actUpd;
        }
        
    }

}