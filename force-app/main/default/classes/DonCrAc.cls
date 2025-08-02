public with sharing class DonCrAc {
    public static void testo(List<Account> actnw){
        Set<String>actId = new Set<String>();
        for(Account qr : actnw){
            actId.add(qr.Name);
        }
        Map<String,Account> ma = new Map<String,Account>();
        List<Account> act = [Select Id, Name from Account where Name IN:actId];
        for(Account a : act){
            ma.put(a.Name, a);
        }
        for(Account aa : actnw){
            if(ma.containsKey(aa.Name)){
                aa.addError('Cant Dup');
            }
        }
    }

}