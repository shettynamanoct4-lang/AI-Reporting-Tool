public with sharing class CantDltActOpp {
    public static void testa(List<Account> oldAct){
        Set<Id> actId = new Set<Id>();
        for(Account ac : oldAct){
            actId.add(ac.Id);
        }
        Map<Id,Account> verify = new Map<Id,Account>();
        List<Account> old = [Select Id, Name, (Select Id, Name, Amount, CloseDate, Type, StageName from Opportunities where StageName = 'Closed Won') 
                             from Account where ID IN:actId];
     /*   for(Account aa : old){
            for(Opportunity o : aa.Opportunities){
                if(o.StageName == 'Closed Won'){
                    verify.put(aa.Id, aa);
                }
            }
        } */
        for(Account aa : old){
            verify.put(aa.Id, aa);
        }
        for(Account aco : oldAct){
            if(verify.containsKey(aco.Id)){
                aco.addError('You can\'t delete');
            }
        }
        
        
    }

}