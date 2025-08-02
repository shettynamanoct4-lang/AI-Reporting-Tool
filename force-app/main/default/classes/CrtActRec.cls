public with sharing class CrtActRec {
      @AuraEnabled(cacheable = true)
      public static List<Account> at(String recId){
        List<Account> acc = [Select Name, Id, Phone, BillingAddress, AccountSource from Account where Id =:recId];
        return acc;
           
    }



}