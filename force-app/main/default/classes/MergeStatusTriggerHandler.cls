public class MergeStatusTriggerHandler {
    public static void handleMergeStatus(List<MergeStatus__e> mergeEvents) {
        List<Account> accountsToUpdate = new List<Account>();

        for (MergeStatus__e event : mergeEvents) {
            if (event.Merge_Status__c == 'Success' || event.Merge_Status__c == 'Error') {
                accountsToUpdate.add(new Account(Id = event.Account_Id__c, Merge_Status__c = event.Merge_Status__c));
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            try {
                update accountsToUpdate;
            } catch (Exception e) {
                // Handle exception (e.g., log error message)
                System.debug('Error updating accounts: ' + e.getMessage());
            }
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getMergeStatus(String accountId) {
        Account acc = [SELECT Merge_Status__c FROM Account WHERE Id = :accountId LIMIT 1];
        return acc.Merge_Status__c;
    }
}