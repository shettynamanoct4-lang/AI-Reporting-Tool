public class ActWithFilter {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountRecords() {
        return [SELECT Id, Name, Phone, Rating FROM Account LIMIT 500];
    }
    
    @AuraEnabled
    public static void deleteAccountRecords(List<Id> accountIds) {
        System.debug('Starting deleteAccountRecords method');
        System.debug('Account IDs to delete: ' + accountIds);

        try {
            List<Account> accountsToDelete = [SELECT Id FROM Account WHERE Id IN :accountIds];
            System.debug('Accounts to delete: ' + accountsToDelete);
            
            delete accountsToDelete;
            System.debug('Successfully deleted accounts');
        } catch (Exception e) {
            System.debug('Error occurred: ' + e.getMessage());
            throw new AuraHandledException('Error deleting records: ' + e.getMessage());
        }
    }

}