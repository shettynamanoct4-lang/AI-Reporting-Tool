public with sharing class SumOfCon {
    public static void testa(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact con : newCon){
            actId.add(con.AccountId);
        }
        List<Account> actUpd = new List<Account>();
        List<Account> act = [Select Id, Name, Contact_Salary__c, (Select Id, LastName, Salary__c from Contacts) from Account
                            where Id IN:actId];
        for(Account a : act){
            Decimal sum = 0;
            for(Contact c : a.Contacts){
                sum = sum + c.Salary__c;
            }
            Account acti = new Account();
              acti.Id = a.Id;
              acti.Name = a.Name;
              acti.Contact_Salary__c = sum;
              actUpd.add(acti);
          /*  a.Contact_Salary__c= sum;
            actUpd.add(a); */
        }
        if(actUpd.size()>0){
            update actUpd;
        }
        
    }

}