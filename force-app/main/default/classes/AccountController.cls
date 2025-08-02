public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        List<Account> acc = [SELECT Name,Industry from Account limit 50];
        return acc;
    }
    @AuraEnabled
    public static String deleteRecords(List<String> list_deletedAccIds){
        List<Account> acDelete = [SELECT Id from Account WHERE Id IN :list_deletedAccIds];
        delete acDelete;
        return 'success';
    }

}