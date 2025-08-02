public with sharing class AcountContactService {
    public static void updateActiveContacts(Set<Id>actId){
        List<AggregateResult> cont = [Select AccountId, 
                                              Count(Id) totalContacts 
                                              from Contact 
                                              where Active__c = true 
                                              and AccountId IN: actId 
                                              Group By AccountId]; 
                List<Account> accountUpdate = new List<Account>();
                for(AggregateResult res : cont){
                    Account att = new Account();
                    att.Id= String.valueOf(res.get('AccountId')); //or use (Id)res.get('AccountId')
                    att.Num_of_Active_Contacts__c= Integer.valueOf(res.get('totalContacts'));// or (Integer)res.get('totalContacts')
                    accountUpdate.add(att);
                }
                update accountUpdate;
    }

}