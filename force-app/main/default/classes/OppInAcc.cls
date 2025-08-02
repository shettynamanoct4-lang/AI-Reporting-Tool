public with sharing class OppInAcc {
    public static void calcOpp(List<Opportunity> op){
        Set<Id> accId = new Set<Id>();
        for(Opportunity o : op){
            accId.add(o.AccountId);
        }
        List<Account> cnt = new List<Account>();
        List<Account> ac = [Select Id, (Select Id, Name FROM Opportunities) FROM Account WHERE Id IN:accId];
        for(Account a : ac){
            List<Opportunity> oo = a.Opportunities;
            a.NumOfOpportunity__c = oo.size();
            cnt.add(a);
        }
        update cnt;
    }
    public static void calUpCon(List<Opportunity> newop, Map<Id,Opportunity> oldop){
        Set<Id> actId = new Set<Id>();
        for(Opportunity o : newop){
            if(o.AccountId!=null && o.AccountId!= oldop.get(o.Id).AccountId){
                actId.add(o.AccountId);
                actId.add(oldop.get(o.Id).AccountId);
            }
        }
        List<AggregateResult> cnt = [Select AccountId, Count(Id) ct from Opportunity where AccountId IN: actId GROUP BY AccountId];
        List<Account> actu = new List<Account>();
        for(AggregateResult a : cnt){
            Account ac = new Account();
            ac.Id = (String)a.get('AccountId');
            ac.NumOfOpportunity__c = (Integer)a.get('ct');
            actu.add(ac);
        }
        update actu;
    }
    /*
    public static void calUpCon(List<Opportunity> opr, Map<Id,Opportunity> mp){
        Set<Id> acId = new Set<Id>();
        for(Opportunity oo : opr){
            if(String.isNotBlank(oo.AccountId) && mp.get(oo.Id).AccountId != oo.AccountId){
                acId.add(mp.get(oo.Id).AccountId);
                acId.add(oo.AccountId);
            }
        }
        List<Account> cont = new List<Account>();
        List<Account> ac = [Select Id, (Select Id, Name FROM Opportunities) FROM Account WHERE Id IN:acId];
        for(Account a : ac){
            List<Opportunity> ooo = a.Opportunities;
            a.NumOfOpportunity__c = ooo.size();
            cont.add(a);
        }
        update cont;
        
    }
   */
    public static void delOpp(List<Opportunity> op){
        Set<Id> accId = new Set<Id>();
        for(Opportunity o : op){
            accId.add(o.AccountId);
        }
        List<Account> cnt = new List<Account>();
        List<Account> ac = [Select Id, (Select Id, Name FROM Opportunities) FROM Account WHERE Id IN:accId];
        for(Account a : ac){
            List<Opportunity> oo = a.Opportunities;
            a.NumOfOpportunity__c = oo.size();
            cnt.add(a);
        }
        update cnt;
    }
    public static void undelOpp(List<Opportunity> op){
        Set<Id> accId = new Set<Id>();
        for(Opportunity o : op){
            accId.add(o.AccountId);
        }
        List<Account> cnt = new List<Account>();
        List<Account> ac = [Select Id, (Select Id, Name FROM Opportunities) FROM Account WHERE Id IN:accId];
        for(Account a : ac){
            List<Opportunity> oo = a.Opportunities;
            a.NumOfOpportunity__c = oo.size();
            //Even we don't make list it will work.
            cnt.add(a);
        }
        update cnt;
    }
    
    
    
    
    
}