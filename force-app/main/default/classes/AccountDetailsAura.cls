public with sharing class AccountDetailsAura {
    @AuraEnabled
    public static List<Account> getAllAccounts(){
        return [Select Id, Name ,AccountNumber, AnnualRevenue from Account LIMIT 50];
    }
    @AuraEnabled
    public static List<Account> searchByName(String key){
        String name = '%'+key+'%';
        return [Select Id, Name, AccountNumber, AnnualRevenue from Account where Name like:name LIMIT 50];
    }
    @AuraEnabled
    public static Account searchById(String AccountId){
        return [Select Id, Name from Account where Id=:AccountId ];
    }

}