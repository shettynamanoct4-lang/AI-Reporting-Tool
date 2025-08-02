public with sharing class ConAccDlt {
    public static void testo(List<Contact> ct){
        Set<Id> actId = new Set<Id>();
        for(Contact c : ct){
            if(c.AccountId != null){
                actId.add(c.AccountId);
            }
        }
        Map<Id,Account> ma = new Map<Id,Account>();
        List<Account> cc = [select Id, Name from Account where Id IN:actId];
        for(Account cv : cc){
            ma.put(cv.Id, cv);
        }
        List<Account> upda = new List<Account>();
        for(Contact od : ct){
            if(ma.containsKey(od.AccountId)){
                Account acti = ma.get(od.AccountId);
                upda.add(acti);
                System.debug('Updated' + upda);
            }
        }
        if(upda.size()>0){
            delete upda;
        }
    }

}