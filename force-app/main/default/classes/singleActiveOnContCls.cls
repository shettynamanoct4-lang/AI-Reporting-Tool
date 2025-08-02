public with sharing class singleActiveOnContCls {
    public static Boolean isExecuting = false;
    public static void updateActiveforlatestContact(Map<Id,Contact> newContacts, Map<Id,Contact> oldContacts){
        System.debug('Inside active method');
        Set<Id> accountIds = new Set<Id>();
        Set<Id> contIds = new Set<Id>();
        Boolean insertTgr = oldContacts == Null ? true : false;
        System.debug('Boolean val : '+ insertTgr);
        for(Contact con : newContacts.values()){
            if(con.AccountId!=null && con.Active__c && (insertTgr || con.Active__c!=oldContacts.get(con.Id).Active__c)){
                accountIds.add(con.AccountId);
                contIds.add(con.Id);
            }
        }
        System.debug('Contact Ids : '+ contIds);
        List<Contact> updConts = new List<Contact>();
        List<Contact> activeContactsexisting = [Select Id, AccountId, Active__c from Contact where Active__c= true AND AccountId IN:accountIds AND Id NOT IN:contIds];
        System.debug('Contacts existing : '+ activeContactsexisting);
        for(Contact cont : activeContactsexisting){
            cont.Active__c = false;
            updConts.add(cont);

        }
        System.debug('Old Contacts made inactive : '+ updConts);
        if(updConts.size()>0){
            isExecuting = true;
            update updConts;
        }
    }
    
    
    
    public static void updatePhoneOfAccountForlatestContact(Map<Id,Contact> newContacts, Map<Id,Contact> oldContacts){
        System.debug('Inside phone method');
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : newContacts.values()){
            if(con.Active__c && (oldContacts == null || con.Phone != oldContacts.get(con.Id).Phone || Trigger.isInsert && con.Phone != null)){
                accountIds.add(con.AccountId);
            }
        }
        if(accountIds.size() > 0){
            List<Account> accountsToUpdate = [SELECT Id, Phone FROM Account WHERE Id IN :accountIds];
            for(Account acc : accountsToUpdate){
                // Assuming that you want to update the phone number with the most recent active contact's phone number
                List<Contact> activeContacts = [SELECT Phone FROM Contact WHERE AccountId = :acc.Id AND Active__c = true ORDER BY CreatedDate DESC LIMIT 1];
                if(!activeContacts.isEmpty()){
                    acc.Phone = activeContacts[0].Phone;
                }
            }
            update accountsToUpdate;
        }
    }

}