public with sharing class CnSeqAcc {
    public static void testo(List<Contact> nwCn){
        Set<Id> actId = new Set<Id>();
        for(Contact c : nwCn){
            actId.add(c.AccountId);
            
        }
        Map<Id, Account> jb = new Map<Id, Account>();
        List<Account> actjv = [Select Id, Type from Account where Id IN:actId];
        for(Account f : actjv){
            jb.put(f.Id, f);
        }
            
        Map<Id, Integer> ma = new Map<Id, Integer>();
        List<Contact> crtd = [Select Id, LastName, AccountId, size__c from Contact where AccountId IN:actId];
        for(Contact cc : crtd){
            if(crtd.size()!=null){
                //Integer i = Integer.valueof(cc.size__c);
                
                Integer i = Integer.valueOf(cc.size__c + 1);
                cc.size__c= cc.size__c + 1;
                ma.put(cc.AccountId, i);
            }
            else{
                cc.size__c = 1;
            }
        }
        for(Contact cv : nwCn){
            if(ma.containsKey(cv.AccountId)){
                cv.size__c = ma.get(cv.AccountId);
                String v = String.valueOf(cv.size__c);
                cv.Job_Name__c = jb.get(cv.AccountId).Type + v;
            }
            else{
                cv.size__c = 1;
                String v = String.valueOf(cv.size__c);
                cv.Job_Name__c = jb.get(cv.AccountId).Type + v;
            }
        }
       
    }

}