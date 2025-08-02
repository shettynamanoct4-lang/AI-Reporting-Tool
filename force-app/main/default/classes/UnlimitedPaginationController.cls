/**
    * @name:        UnlimitedPaginationController   
    * @author:      Santanu Pal   
    * @date:        22 MAR 2021
    * @description: This Apex Class is used to return the Account records and helps to search and save the records
**/
public with sharing class UnlimitedPaginationController {
    
    /**
      * @name:        getAccounts   
      * @param(s):    String prevAccRef, String nextAccRef
      * @return:      List<Account>
      * @description: to return the account records by record reference
    **/
    @AuraEnabled
    public static List<Account> getAccounts(String prevAccRef, String nextAccRef, Integer recordsLimit){
        List<Account> accountList = new List<Account>();    
        
        if(prevAccRef == NULL && nextAccRef == NULL)
            accountList = [SELECT ID, Name, Site FROM Account Order By Id ASC LIMIT :recordsLimit];
        else if(prevAccRef == NULL && nextAccRef <> NULL)
            accountList = [SELECT ID, Name,  Site FROM Account WHERE Id >: nextAccRef Order By Id ASC LIMIT :recordsLimit];
        else
            accountList = [SELECT ID, Name, Site FROM Account WHERE Id >=: prevAccRef AND Id <=: nextAccRef Order By Id];

        if(!accountList.isEmpty()){
            return accountList;
        }

        return null;

        
    }

    /**
      * @name:        searchAccounts   
      * @param(s):    String name, String prevAccRef, String nextAccRef
      * @return:      List<Account>
      * @description: to search the account records based on search key
    **/
    @AuraEnabled
    public static List<Account> searchAccounts(String name, String prevAccRef, String nextAccRef, Integer recordsLimit){
        List<Account> accountList = new List<Account>();   
        String searchKey = '%'+name.trim()+'%'; 
        
        if(prevAccRef == NULL && nextAccRef == NULL)
            accountList = [SELECT ID, Name,Site FROM Account WHERE Name LIKE: searchKey Order By Id ASC LIMIT :recordsLimit];
        else if(prevAccRef == NULL && nextAccRef <> NULL)
            accountList = [SELECT ID, Name,Site FROM Account WHERE Name LIKE: searchKey AND Id >: nextAccRef Order By Id ASC LIMIT :recordsLimit];
        else
            accountList = [SELECT ID, Name,Site FROM Account WHERE Name LIKE: searchKey AND Id >=: prevAccRef AND Id <=: nextAccRef Order By Id];

        if(!accountList.isEmpty()){
            return accountList;
        }

        return null;

        
    }

    /**
      * @name:        saveAccounts   
      * @param(s):    String selectedAccountsJSON
      * @return:      List<Account>
      * @description: to save the account records based on search key
    **/
    @AuraEnabled
    public static Boolean saveAccounts(String selectedAccountsJSON){
        System.debug('Recs from LWC : '+ selectedAccountsJSON);
        
        List<Account> accountList = new List<Account>();
        Set<Id> accountIdset = new Set<Id>();
        List<RecordLineItems> recordLineItemsList = new List<RecordLineItems>();
        Map<Id, Account> accountMap = new Map<Id, Account>();
        recordLineItemsList = (List<RecordLineItems>)JSON.deserialize(selectedAccountsJSON, List<RecordLineItems>.class);

        if(recordLineItemsList <> NULL  && !recordLineItemsList.isEmpty()){
            for(RecordLineItems rli : recordLineItemsList){
                accountIdset.add(rli.Id);
            }
        }

        if(accountIdset <> NULL  && !accountIdset.isEmpty())
            accountMap = new Map<Id, Account>([SELECT Id, Name, Site FROM Account WHERE ID in: accountIdset]);
        
        if(recordLineItemsList <> NULL  && !recordLineItemsList.isEmpty()){
            for(RecordLineItems rli : recordLineItemsList){
               if(accountMap.get(rli.Id) <> NULL){
                    accountMap.get(rli.Id).Site = rli.Site;
               }
            }
        }
        
        try {
            if(accountMap <> NULL  && !accountMap.isEmpty()){
                update accountMap.values();
                return true;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return false;
    }

    /**
      * @name:        RecordLineItems   
      * @description: this wrapper class is being used to set the template for saving records coming from LWC
    **/
    public class RecordLineItems{
        String Id;
        String Name;
        String AccountReference;
        String Site;
    }
   
}