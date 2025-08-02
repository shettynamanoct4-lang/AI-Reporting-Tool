public with sharing class AccConDe {
    public static void test(List<Account> act){
        Set<Id> actId = new Set<Id>(); 
        for(Account a : act){
            actId.add(a.Id);
        }
        Map<Id,List<Contact>> ma = new Map<Id,List<Contact>>();
        List<Account> ag = [Select Id, Name, (Select Id, LastName from Contacts) from Account where Id IN:actId];
        
        for(Account ad : ag){
            List<Contact> fg = ad.Contacts;
            if(fg.size()>2){
                ma.put(ad.Id, ad.Contacts);
            }
        }
        
        for(Account cf : act){
            if(ma.containsKey(cf.Id)){
                cf.addError('You cant delete it');
            }
        } 
        
    } 

}