public with sharing class CustomerTk {
    @AuraEnabled(cacheable=true)
    public static Boolean validateCustomer(String name, String email){
        List<Account> aList = [SELECT Name, Date_Of_Birth__c,Email__c,Postal_Address__c FROM Account];
        for(Account a:aList){
            if(name.equals(a.Name) || email.equals(a.Email__c)){
                return false;
            }
        }
        return true;
    }
}