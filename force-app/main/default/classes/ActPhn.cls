public with sharing class ActPhn {
    public static void testo(List<Contact>cn){
        Set<Id> actId = new Set<Id>();
        for(Contact c : cn){
            if(c.AccountId!=null && c.Phone!=null){
                actId.add(c.AccountId);
            }
        }
        List<Account> act = [Select Id, Phone, (Select Id, Phone from Contacts) from Account where Id In:actId];
        //List<Contact> cop = [Select Id, Phone , AccountId, Account.Phone from Contact where AccountId IN:actId];
        List<Account> b = new List<Account>();
        for(Account t : act){
            for(Contact cv : t.Contacts){
                t.Phone = cv.Phone;
                b.add(t);
            }
        }
        update b;
    }

}