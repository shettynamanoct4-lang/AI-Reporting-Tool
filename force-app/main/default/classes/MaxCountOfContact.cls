public with sharing class MaxCountOfContact {
    public static void testa(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact cc : newCon){
            if(cc.AccountId != null){
                actId.add(cc.AccountId);
                
            }
        }
        List<Account> act = new List<Account>();
        Map<Id,Integer> ma = new Map<Id,Integer>();
     /*   List<AggregateResult> agr = [Select AccountId, Count(Id) cnt from Contact where AccountId IN:actId GROUP BY AccountId];
        for(AggregateResult ag : agr){
            ma.put((Id)ag.get('AccountId'), (Integer)ag.get('cnt'));
        }
        
        for(Contact cn : newCon){
            if(cn.AccountId!=null){
                if(ma.size()!=null){
                    Account a = new Account();
                    a.Id = cn.AccountId;
                    a.No_Of_Contact__c = ma.get(cn.AccountId);
                    act.add(a);
                }
            }
        } */
        List<Account> cb = [Select Id, No_Of_Contact__c, Name, (Select Id, LastName, AccountId, Salary__c from Contacts 
                            where AccountId IN:actId ORDER BY Salary__c DESC LIMIT 2 )from  Account where Id IN:actId];
        for(Account x : cb){
            Integer xv = 0;
            for(Contact cv : x.Contacts){
                xv= xv+(Integer)cv.Salary__c;
            }
            ma.put(x.Id, xv);
        }
        for(Contact cn : newCon){
            if(cn.AccountId!=null){
                if(ma.size()!=null){
                    Account a = new Account();
                    a.Id = cn.AccountId;
                    a.No_Of_Contact__c = ma.get(cn.AccountId);
                    act.add(a);
                }
            }
        }

        if(act.size()>0 && !act.isEmpty()){
            update act;
        }
        
    }

}