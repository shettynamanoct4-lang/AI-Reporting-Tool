public with sharing class AccFieldPlatinumStatusUpdt {
    public static void testa(List<Contact> newCon, Map<Id,Contact> oldCon){
        Set<Id> actId = new Set<Id>();
        for(Contact c : newCon){
            if(c.AccountId!=null){
                if(oldCon.get(c.Id).Contact_Type__c != c.Contact_Type__c && c.Contact_Type__c == 'Platinum'){
                    actId.add(c.AccountId);
                }
            }
        }
        List<Account> updtAc = new List<Account>();
        List<Account> act = [Select Id, Name, Platinum_Contact_Status__c from Account where Id IN: actId];
        for(Account aa : act){
            if(!act.isEmpty()){
                aa.Platinum_Contact_Status__c = 'Updated Platinum Con';
                updtAc.add(aa);
            }
            
        }
        if(updtAc.size()>0){
            update updtAc;
        }
        
    }
    
}