public with sharing class CrteTaskFrmAct {
    public static void testo(Map<Id,Account> mapi , List<Account> nwAct){
        Set<Id>actId = new Set<Id>();
        for(Account ac : nwAct){
            if(mapi.get(ac.Id).Industry=='Banking' && ac.Industry == 'Education'){
                actId.add(ac.Id);
            }
        }
       // Map<Id, Account> nwma = new Map<Id, Account>();
        List<Task> upd = new List<Task>();
        List<Account> act = [Select Id, OwnerId, Name from Account where Id IN:actId];
      //  for(Account f : act){
       //     nwma.put(f.Id, f);
     //   }
        for(Account aa : act){
            Task t = new Task();
            t.OwnerId = aa.OwnerId;
            t.WhatId = aa.Id;
            t.Subject  = 'Trigger success';
            upd.add(t);
        }
        if(upd.size()>0){
            insert upd;
        }
    }

}