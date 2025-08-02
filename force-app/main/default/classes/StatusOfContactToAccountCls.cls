public with sharing class StatusOfContactToAccountCls {
    public static Set<Id> actId = new Set<Id>();
    public static Map<Id,Account> mapOfAccountRealtedToContact = new Map<Id,Account>();
    public static Map<Id,Account> updatedAccounts = new Map<Id,Account>();
    public static void testa(List<Contact> newConts, Map<Id,Contact> oldConts){
        for(Contact cc : newConts){
            if(cc.AccountId != null && String.isNotBlank(cc.AccountId) && cc.Active__c !=null && String.isNotBlank(String.valueOf(cc.Active__c))){
                actId.add(cc.AccountId);
            }
        }
        List<Account> accounts = [Select Id, Name, Status__c from Account where Id IN:actId];
        for(Account aa: accounts){
            mapOfAccountRealtedToContact.put(aa.Id, aa);
        }
        for(Contact ccc : newConts){
            if((Trigger.isInsert && mapOfAccountRealtedToContact.containsKey(ccc.AccountId)) || (Trigger.isUpdate && mapOfAccountRealtedToContact.containsKey(ccc.AccountId)
            && ccc.Active__c != oldConts.get(ccc.Id).Active__c)){
                Account a = new Account(Id = ccc.AccountId);
                
                if(ccc.Active__c == true){
                    if(updatedAccounts.containsKey(ccc.AccountId)){
                        a = updatedAccounts.get(ccc.AccountId);
                        a.Status__c = 'Active';
                        updatedAccounts.put(ccc.AccountId, a);
                    }
                    else{
                        a.Status__c = 'Active';
                        updatedAccounts.put(ccc.AccountId, a);
                    }
                }
                else if(ccc.Active__c != true){
                    if(updatedAccounts.containsKey(ccc.AccountId)){
                        a = updatedAccounts.get(ccc.AccountId);
                        a.Status__c = 'Not Active';
                        updatedAccounts.put(ccc.AccountId, a);
                    }
                    else{
                        a.Status__c = 'Not Active';
                        updatedAccounts.put(ccc.AccountId, a);
                    }
                }
            }
        }
        if(!updatedAccounts.isEmpty() && updatedAccounts.size()>0){
            update updatedAccounts.values();
        }
    }

}