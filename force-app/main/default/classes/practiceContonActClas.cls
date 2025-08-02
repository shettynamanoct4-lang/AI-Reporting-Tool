public class practiceContonActClas {
    public static void testa(List<Contact> newConts, Map<Id,Contact>oldConts){
        Set<Id>actIds = new Set<Id>();
        for(Contact cc : newConts){
            if(cc.AccountId!=null){
                actIds.add(cc.AccountId);
            }
            if(oldConts!=null){
                if(oldConts.get(cc.Id).AccountId != null || oldConts.get(cc.Id).AccountId != cc.AccountId){
                    actIds.add(oldConts.get(cc.Id).AccountId);
                  //  actIds.add(cc.AccountId); //chk for update scenario of old act being change to new act
                }
            }
        }
        if(actIds.size()>0 && !actIds.isEmpty()){
            calcRollUp(actIds);
        }
    }
    
    public static void calcRollUp(Set<Id> actIds){
        List<Account> updAct = new List<Account>();
        List<Account> accts = [Select Id,No_Of_Contact__c,Name from Account where Id IN:actIds];
        Map<Id,Integer> numberOfContactsOnActs = new Map<Id,Integer>();
        List<AggregateResult> contsOnActs = [Select AccountId, Count(Id) contCount from Contact where AccountId IN:actIds GROUP BY AccountId];
        if(!contsOnActs.isEmpty()){
            for(AggregateResult ar : contsOnActs){
                numberOfContactsOnActs.put( String.valueOf(ar.get('AccountId')),(Integer)(ar.get('contCount')));
                System.debug(numberOfContactsOnActs);
            }
        }
        for(Account accc : accts){
            if(!accts.isEmpty() && numberOfContactsOnActs.containsKey(accc.Id)){
                accc.No_Of_Contact__c = numberOfContactsOnActs.get(accc.Id);
                updAct.add(accc);
            }
            
        }
        if(updAct.size()>0){
            update updAct;
        }
        
    }
}