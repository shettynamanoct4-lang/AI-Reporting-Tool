public with sharing class AccTk {
    @AuraEnabled(cacheable=true)
    public static String getAcctId(String accName){
        Account acc = [select Id, Name from Account where Name=:accName limit 1];
        Id accId = acc.Id;
        return accId;
    }
}