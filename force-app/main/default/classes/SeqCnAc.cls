public with sharing class SeqCnAc {
    public static void testo(List<Contact> con){
        Set<Id> actId = new Set<Id>();
        for(Contact c : con){
            actId.add(c.AccountId);
        }
        Map<Id,String>jb = new Map<Id, String>();
        List<Account> act = [Select Id, Type from Account where Id IN:actId];
        for(Account t : act){
            jb.put(t.Id,t.Type);
        }
        Map<Id,Decimal> ma = new Map<Id,Decimal>();
        List<Contact> upd = [Select Id, AccountId, size__c, Job_Name__c from Contact where AccountId IN:actId Order 
                             By CreatedDate Desc LIMIT 1];
        if(upd.size()>0){
            for(Contact cd : upd){
                if(cd.size__c != null){
                    String lastWrd = String.valueof(cd.size__c);
                    //String ls = lastWrd.right(1);
                    Integer i = Integer.valueOf(lastWrd);
                    i++;
                    cd.size__c = i;
                    ma.put(cd.AccountId, cd.size__c);
                }
                else{
                    cd.size__c = 1;
                }
            }
            
        }
        for(Contact cc : con){
            if(ma.containsKey(cc.AccountId)){
                cc.size__c = ma.get(cc.AccountId);
                String va = String.valueOf(cc.size__c);
                cc.Job_Name__c = jb.get(cc.AccountId) + va ;
            }
            else{
                cc.size__c = 1;
                cc.Job_Name__c = jb.get(cc.AccountId) + '1';
            }
        }
    }

}