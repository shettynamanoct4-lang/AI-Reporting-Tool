public with sharing class ContActNum {
    public static void testa(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact c : newCon){
            actId.add(c.AccountId);
        }
        Map<Id, Integer> ma = new Map<Id, Integer>();
        List<Contact> coni = [Select Id, AccountId, LastName, size__c from Contact where AccountId IN:actId];
        for(Contact cc : coni){
            if(coni.size()!=null){
                Integer a = (Integer)cc.size__c + 1;
                cc.size__c = cc.size__c + 1;
                ma.put(cc.AccountId, a);
            }
            else{
              cc.size__c = 0;  
                
            }
        }
        for(Contact co : newCon){
            if(ma.containsKey(co.AccountId)){
                co.size__c = ma.get(co.AccountId);
            }
            else{
                co.size__c = 0;
            }
        }
        
    }
    
}