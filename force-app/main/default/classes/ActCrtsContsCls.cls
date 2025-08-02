// ActCrtsContsCls.cls
public with sharing class ActCrtsContsCls {
    // Static variable to track if the trigger is already running
    public static Boolean skipTrigger = false;
    
    public static void testa(Map<Id, Account> newAccountsMap, Map<Id, Account> oldAccountsMap) {
        // Check if the trigger is already running to prevent recursion
        if(Trigger.isUpdate){
        if (!skipTrigger) {
            skipTrigger = true; // Set the flag to indicate trigger execution
            
            Set<Id> accountIdsToUpdate = new Set<Id>();
        
            // Identify accounts where the phone number has been changed
            for (Id accountId : newAccountsMap.keySet()) {
                if (newAccountsMap.get(accountId).Phone != oldAccountsMap.get(accountId).Phone) {
                    accountIdsToUpdate.add(accountId);
                }
            }
        
            // Check if there are any accounts to update
            if (!accountIdsToUpdate.isEmpty()) {
                // Query related contacts for the updated accounts
                List<Contact> contactsToUpdate = [SELECT Id, Phone, AccountId FROM Contact WHERE AccountId IN :accountIdsToUpdate];
                
                // Update contacts' phone numbers to match the updated accounts' phone numbers
                for (Contact contact : contactsToUpdate) {
                    contact.Phone = newAccountsMap.get(contact.AccountId).Phone;
                }
                
                // Update contacts
                update contactsToUpdate;
            }
            
            skipTrigger = false; // Reset the flag after processing
        } 
    }
    }
}