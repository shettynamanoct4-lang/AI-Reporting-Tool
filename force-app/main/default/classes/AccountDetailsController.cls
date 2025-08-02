public with sharing class AccountDetailsController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getRelatedContacts(Id accountId) {
        return [SELECT Id, Name, Phone, Email FROM Contact WHERE AccountId = :accountId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Case> getRelatedCases(Id accountId) {
        return [SELECT Id, CaseNumber, Subject, Status FROM Case WHERE AccountId = :accountId];
    }
}