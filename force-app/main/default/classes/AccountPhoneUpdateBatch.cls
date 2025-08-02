public with sharing class AccountPhoneUpdateBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    // Limit for total records to be processed
    public Integer recordLimit = 100;
    
    // Start method to retrieve the query of Accounts
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query to get Accounts, limiting the result to 100 records
        String query = 'SELECT Id, Phone, Rating FROM Account WHERE Name LIKE \'Test%\' LIMIT ' + recordLimit;
        return Database.getQueryLocator(query);
    }

    // Execute method to process each batch of 10 records
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : scope) {
            acc.Phone = '99887766';
            acc.Rating = 'Hot';
            accountsToUpdate.add(acc);
        }

        // Update the batch of accounts with error handling
        if (!accountsToUpdate.isEmpty()) {
            try {
                update accountsToUpdate;
            } catch (Exception e) {
                // Log the general error details
                System.debug('Exception occurred: ' + e.getMessage());
                System.debug('Exception cause: ' + e.getCause());
            }
        }
    }

    // Finish method to log completion or send an email, if needed
    public void finish(Database.BatchableContext bc) {
        // Optional: You can add logic here for post-batch completion (e.g., sending an email notification)
        System.debug('Batch processing finished.');
    }
}