public with sharing class ContactTriggerHandler3 {
    public static void onAfterInsert(List<Contact> contactList) {
        Set<Id> activeContactIds = new Set<Id>();
        Set<Id> accountIdsToUpdate = new Set<Id>();

        // Collect active contact Ids and account Ids for updating No_Of_Contact__c
        for (Contact con : contactList) {
            if (con.Status__c == 'Active') {
                activeContactIds.add(con.Id);
            }
            if (con.AccountId != null) {
                accountIdsToUpdate.add(con.AccountId);
            }
        }

        // Call future method to insert opportunities for active contacts
        if (!activeContactIds.isEmpty()) {
            ContactUtilss.processOpportunities(activeContactIds);
        }

        // Update No_Of_Contact__c field for the related accounts
        if (!accountIdsToUpdate.isEmpty()) {
            updateAccountContactCount(accountIdsToUpdate);
        }
    }

    // Helper method to update the No_Of_Contact__c field for accounts
    private static void updateAccountContactCount(Set<Id> accountIds) {
        // Query accounts to update their No_Of_Contact__c field
        List<Account> accountsToUpdate = [SELECT Id, No_Of_Contact__c FROM Account WHERE Id IN :accountIds];

        for (Account acc : accountsToUpdate) {
            // Set the No_Of_Contact__c field to 2 (as per the requirement)
            acc.No_Of_Contact__c = 2;
        }

        if (!accountsToUpdate.isEmpty()) {
            AccountTriggerHandler2.skipTrigger = true; 
            update accountsToUpdate;
            AccountTriggerHandler2.skipTrigger = false;
        }
    }
}