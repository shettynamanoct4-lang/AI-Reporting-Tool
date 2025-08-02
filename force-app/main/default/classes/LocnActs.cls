public with sharing class LocnActs {
    public static void testo(List<Account> nwAct){
        Set<Id>actId = new Set<Id>();
        for(Account ac : nwAct){
            if(ac.NumOfLoc__c!=null){
                actId.add(ac.Id);
            }
        }
        Map<Id,Integer> ma = new Map<Id,Integer>();
        List<Account> actu = [Select Id, Name, NumOfLoc__c from Account where Id IN:actId];
        for(Account a : actu){
            ma.put(a.Id,(Integer)a.NumOfLoc__c);
        }
        List<Contact> newCon = new List<Contact>();
        for(Account aa : nwAct){
            for(Integer i = 0; i<ma.get(aa.Id); i++){
                Contact c = new Contact();
                c.LastName = 'Test' + i;
                c.AccountId = aa.Id;
                newCon.add(c);
            }
        }
        if(newCon.size()>0){
            insert newCon;
        }
    }
 
}