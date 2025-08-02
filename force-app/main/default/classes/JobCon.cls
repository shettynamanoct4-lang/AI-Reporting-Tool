public with sharing class JobCon {
    public static void tets(List<Contact> newCon){
        Set<Id> actId = new Set<Id>();
        for(Contact c : newCon){
            actId.add(c.AccountId);
        }
        List<Contact> ac = [Select Id, Account.Id, Account.Name, LastName, 	Job_Name__c from Contact where Account.Id IN: actId ];
        List<Contact> cnt = new List<Contact>();
        for(Contact cc : ac){
            cc.Job_Name__c = cc.Account.Name;
        }
    }

}