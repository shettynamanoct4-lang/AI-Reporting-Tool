public with sharing class AnnotatePhoneNumberAndCreateContact {
    public static void processAccounts(List<Account> accounts) {
        List<Contact> contactsToInsert = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();

        // Collect account Ids to query them as non-read-only
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }

        // Query the accounts to get a writable list
        List<Account> writableAccounts = [SELECT Id, Phone, Name FROM Account WHERE Id IN :accountIds];

        for (Account acc : writableAccounts) {
            // Check if the account's phone number is present and doesn't already start with '+91'
            if (String.isNotBlank(acc.Phone) && !acc.Phone.startsWith('+91')) {
                acc.Phone = '+91' + acc.Phone;
                accountsToUpdate.add(acc); // Add the account to the list for DML update
            }

            // Create a new contact with the same phone number as the account
            Contact newContact = new Contact(
                LastName = acc.Name,    // Assuming the Contact's LastName is the same as Account Name for simplicity
                AccountId = acc.Id,     // Link the contact to the account
                Phone = acc.Phone       // Assign the same phone number as the account
            );
            contactsToInsert.add(newContact);
        }

        // Update the modified accounts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }

        // Insert the newly created contacts
        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
}