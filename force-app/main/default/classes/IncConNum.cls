public with sharing class IncConNum {
    public static void testo(List<Contact> cc){
    Set<Id> actId = new Set<Id>();
    for(Contact c : cc){
        actId.add(c.AccountId);
    }
    Map<Id,Decimal> upd = new Map<Id,Decimal>();
    List<Contact> cont = [Select Id, AccountId, size__c from Contact where AccountId IN:actId ORDER BY CreatedDate DESC];
    for(Contact qc : cont){
        if(cont.size()>0){
            Decimal a = qc.size__c+1;
            qc.size__c = qc.size__c+1;
            upd.put(qc.AccountId, a);
        }
        else{
            qc.size__c = 1;
        }
          
    }
    for(Contact cf : cc){
        if(upd.containsKey(cf.AccountId)){
            cf.size__c = upd.get(cf.AccountId);
        }
        else{
            cf.size__c = 1;
        }
    }
        
    }
}