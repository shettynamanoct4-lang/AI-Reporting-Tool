public with sharing class contactTriggerHandler2 {
    public static void test1(List<Contact> con){
        
        Set<Id> actId = new Set<Id>();
        
        for(contact co: con){
            if(co.AccountId != null){
                actId.add(co.AccountId);
            }
        }
        List<Account> a =[Select id,type,contactCount__c from account where id IN :actId]; 
        List<Account> updatedacn = new List<Account>();
        for(Contact c : con){
            for(Account ac : a){
                c.Job_Name__c=ac.type+(ac.contactCount__c+1);
                ac.contactCount__c=ac.contactCount__c+1;
                updatedacn.add(ac);
                
            }
            update updatedacn;
        }
        
    } 
}