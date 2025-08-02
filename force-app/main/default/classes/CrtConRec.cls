public with sharing class CrtConRec {
    @AuraEnabled(cacheable = true)
    public static List<Contact> ct(String recId){
        List<Contact> con = [Select LastName, Id, LeadSource from Contact where Id =:recId];
        return con;
        
        
           
    }
    public static void tes(){
        Map<Id,Contact> ma = new Map<Id,Contact>();
        List<Contact> con = [Select Id, LastName, FirstName, Phone from Contact LIMIT 10];
        for(Contact c : con){
            ma.put(c.Id,c);
        }
        System.debug(ma);
    }

}