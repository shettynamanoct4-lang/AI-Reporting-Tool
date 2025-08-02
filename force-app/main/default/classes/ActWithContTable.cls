public class ActWithContTable {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, Rating, Status__c FROM Account LIMIT 10]; // Replace with fields you want
    }

    @AuraEnabled
    public static List<Contact> getContactsByAccount(Id accountId) {
        return [SELECT Id, Name FROM Contact WHERE AccountId = :accountId];
    }
}