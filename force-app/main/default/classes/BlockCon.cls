public with sharing class BlockCon {
    /*public static void testo(List<Contact> con){
        Set<Id> actId = new Set<Id>();
        for(Contact c : con){
            if(c.AccountId!=null){
                actId.add(c.AccountId);
            }
        }
        Map<String,List<Contact>> ma = new Map<String,List<Contact>>();
        List<Account> ac = [Select Id, (Select Id, LastName from Contacts) from Account where Id IN:actId];
        for(Account a : ac){
            List<Contact> cc = a.Contacts;
            Integer i = cc.size();
            if(i>2){
                ma.put(a.Id, a.Contacts);
            }
        }
        for(Contact co : con){
            if(ma.containsKey(co.AccountId)){
                co.AccountId.addError('You cant have more than 2 Contact');
            }
        }
    } 
*/
    public static void testo1(List<Contact> cv){
        for(Contact c : cv){
            if(c.AccountId!=null){
                c.addError('You cant delete this');
            }
        }
    }
    
}