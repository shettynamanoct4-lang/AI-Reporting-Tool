public with sharing class ActConDelOfOpp {
    public static void testa(List<Opportunity> oldOpp){
        Set<Id> actId = new Set<Id>();
        for(Opportunity oo : oldOpp){
            if(oo.AccountId!=null){
                actId.add(oo.AccountId);
            }

        }
        List<Account> upa = new List<Account>();
        List<Contact> upc = new List<Contact>();
        List<Account> acc = [Select Id, Name from Account where Id IN:actId];
        for(Account a : acc){
            upa.add(a);
            /*
            for(Contact c : a.Contacts){
                upc.add(c);
            } */
        }
       
            if(upa.size()>0 && upa !=null){
            delete upa;
        }
        /*
        if(upc.size()>0 && upc !=null){
            delete upc;
        
        } */
        
    }

}