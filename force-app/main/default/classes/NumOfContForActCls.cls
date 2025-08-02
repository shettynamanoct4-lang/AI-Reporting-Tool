public with sharing class NumOfContForActCls {
    public static Set<Id> actId = new Set<Id>();
    public static Map<Id,Integer> mapOfActWidNumOfCon = new Map<Id,Integer>();
    public static List<Contact> consToBeInserted = new List<Contact>();
    public static void testa(List<Account> newActs){
        for(Account a : newActs){
            if(a.No_Of_Contact__c!=null){
               actId.add(a.Id);
            }
        }
        List<Account> acts = [Select Id, Name, No_Of_Contact__c from Account where Id IN:actId];
        for(Account ac : acts){
            mapOfActWidNumOfCon.put(ac.Id, Integer.valueOf(ac.No_Of_Contact__c));
        }
        for(Account aca : newActs){
            if(mapOfActWidNumOfCon.containsKey(aca.Id) && !mapOfActWidNumOfCon.isEmpty()){
                for(Integer i=0; i<mapOfActWidNumOfCon.get(aca.Id); i++){
                    Contact c = new Contact();
                    c.AccountId = aca.Id;
                    c.LastName = 'Contact' + i;
                    consToBeInserted.add(c);
                }
            }
        }
        if(consToBeInserted.size()>0 && !consToBeInserted.isEmpty()){
            insert consToBeInserted;
        }

        
    }

}