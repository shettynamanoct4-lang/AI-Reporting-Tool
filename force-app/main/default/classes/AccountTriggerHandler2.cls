public with sharing class AccountTriggerHandler2 {
    public static Boolean skipTrigger = false;

    // Called in before insert and before update
    public static void onBeforeInsertOrUpdate(List<Account> accountList) {
        handlePhoneNumberUpdate(accountList);
        handleRatingIndustryUpdate(accountList);
    }

    // Called in after insert and after update
    public static void onAfterInsertOrUpdate(Map<Id, Account> accountMap) {
        handleAccountUpdatesAndContactInsertion(accountMap);
        //handleIndustryContactInsertion(accountMap);
    }

    // Helper method to handle phone number updates
    private static void handlePhoneNumberUpdate(List<Account> accountList) {
        for (Account acc : accountList) {
            if (String.isNotBlank(acc.Phone) && !acc.Phone.startsWith('+91')) {
                acc.Phone = '+91' + acc.Phone;
            }
        }
    }

    // Helper method to update Industry when Rating is Hot
    private static void handleRatingIndustryUpdate(List<Account> accountList) {
        for (Account acc : accountList) {
            if (acc.Rating == 'Hot' && acc.Industry != 'Banking') {
                acc.Industry = 'Banking';
            }
        }
    }

    // Helper method to handle account updates and contact insertion
    private static void handleAccountUpdatesAndContactInsertion(Map<Id, Account> accountMap) {
        List<Account> updateAccounts = new List<Account>();
        List<Contact> newContacts = new List<Contact>();
        
        for (Account acc : accountMap.values()) {
            if (acc.Rating == 'Hot') {
                // Add to updateAccounts list to update the Type field
                Account updatedAccount = new Account(Id = acc.Id, Type = 'Prospect');
                updateAccounts.add(updatedAccount);

                // Create new contact
                Contact newContact = new Contact(
                    LastName = acc.Name,
                    AccountId = acc.Id,
                    Status__c = 'Active'
                );
                newContacts.add(newContact);
            }
        }

        // Perform DML update and insert operations
        if (!updateAccounts.isEmpty()) {
            skipTrigger = true;  // Disable the trigger to avoid recursion
            update updateAccounts;
            skipTrigger = false; // Re-enable the trigger

            if (!newContacts.isEmpty()) {
                insert newContacts;
            }
        }
    }

    // Helper method to insert contact with name 'Banking' if Industry is Banking and update Account Email
    private static void handleIndustryContactInsertion(Map<Id, Account> accountMap) {
        List<Contact> bankingContacts = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : accountMap.values()) {
            if (acc.Industry == 'Banking') {
                // Create new contact with LastName as 'Banking'
                Contact bankingContact = new Contact(
                    LastName = 'Banking',
                    AccountId = acc.Id,
                    Status__c = 'Active'
                );
                bankingContacts.add(bankingContact);
                
                // Update account email field
                Account updatedAccount = new Account(Id = acc.Id, Email__c = 'abc@gmail.com');
                accountsToUpdate.add(updatedAccount);
            }
        }

        // Insert contacts and update accounts' Email field
        if (!bankingContacts.isEmpty()) {
            insert bankingContacts;
        }
        
        if (!accountsToUpdate.isEmpty()) {
            skipTrigger = true;  // Disable the trigger to avoid recursion
            update accountsToUpdate;
            skipTrigger = false; // Re-enable the trigger
        }
    }
}