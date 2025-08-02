public with sharing class UpdChldFrmParCls {
    public static void testa(Map<Id,Account> oldActs, List<Account>newActs){
        Set<Id> actIds = new Set<Id>();
        for(Account a : newActs){
            if(oldActs.get(a.Id).Phone != a.Phone){
                actIds.add(a.Id);
            }
        }
        List<Contact> contactToBeUpdated = new List<Contact>();
        List<Account> accountss = [Select Id, Name, Phone,(Select Id, LastName, Phone from Contacts) from Account where Id IN:actIds];
        for(Account aa : accountss){
            if(aa.Contacts !=null && !aa.Contacts.isEmpty() && aa.Contacts.size()>0){
                for(Contact c : aa.Contacts){
                    c.Phone = aa.Phone;
                    contactToBeUpdated.add(c);
                }
            }
        }
        if(contactToBeUpdated.size()>0 && !contactToBeUpdated.isEmpty() && contactToBeUpdated !=null){
            update contactToBeUpdated;
        }
        
    }

}