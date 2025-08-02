public with sharing class LdCrt {
    public static void testa(List<Lead> newLd){
        Set<String> com = new Set<String>();
        for(Lead l : newLd){
            com.add(l.Company);
        }
        Map<String, Id> ma = new Map<String, Id>();
        List<Account> act = [Select Id, Name from Account where Name IN:com];
        for(Account ac : act){
            ma.put(ac.Name, ac.Id);
        }
        List<Case> newCase = new List<Case>();
        for(Lead l : newLd){
            if(ma.containsKey(l.Company)){
                Case c = new Case();
                c.AccountId = ma.get(l.Company);
                c.Origin = 'Phone';
                c.Subject ='Hi there';
                c.Status = 'New';
                newCase.add(c);
            }
        }
        if(newCase.size()>0 && newCase !=null){
            insert newCase;
        }
    }

}