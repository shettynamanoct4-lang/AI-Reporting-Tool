public with sharing class BdayOnIdenConCls {
    public static void testa(List<Identification__c> newIden){
        Set<Id> ConId = new Set<Id>();
        for(Identification__c i : newIden){
            if(i.Contact__c !=null && i.Type_of_Doc__c == 'Aadhar' && i.DateOfBirth__c!=null){
                ConId.add(i.Contact__c);
            }
        }
        List<Contact> updatedCon = new List<Contact>();
        List<Contact> con = [Select Id, LastName, Birthdate, (Select Id, Contact__c,DateOfBirth__c, Type_of_Doc__c from Identifications__r)
                             from Contact where Id IN:ConId];
        for(Contact c : con){
            for(Identification__c ii : c.Identifications__r){
                if(ii.Contact__c !=null && ii.Type_of_Doc__c == 'Aadhar' && ii.DateOfBirth__c!=null){
                    c.Birthdate = ii.DateOfBirth__c;
                    updatedCon.add(c);
                }
            }
        }
        if(updatedCon.size()>0 && !updatedCon.isEmpty()){
            update updatedCon;
        }
        
    }
    /*
    
    public static void testa2(Map<Id,Identification__c> oldIden,List<Identification__c> newIdent){
        
        Set<Id> ConIdd = new Set<Id>();
        for(Identification__c i : newIdent){
            if(i.Contact__c !=null && i.DateOfBirth__c!=null && oldIden.get(i.Id).Type_of_Doc__c != 'Aadhar' && i.Type_of_Doc__c == 'Aadhar'){
                
                ConIdd.add(i.Contact__c);
            }
        }
       List<Contact> updatedCon1 = new List<Contact>();
        List<Contact> cons = [Select Id, LastName, Birthdate, (Select Id, Contact__c,DateOfBirth__c, Type_of_Doc__c from Identifications__r)
                              from Contact where Id IN:ConIdd];
        for(Contact c : cons){
            for(Identification__c ii : c.Identifications__r){
                if(ii.Contact__c !=null && ii.Type_of_Doc__c == 'Aadhar' && ii.DateOfBirth__c!=null){
                    c.Birthdate = ii.DateOfBirth__c;
                  updatedCon1.add(c);
                }
            }
        }
        try{
            if(updatedCon1.size()>0 && !updatedCon1.isEmpty()){
                update updatedCon1;
            }
        }
        catch(Exception e ){
            System.debug(e);
        } 
        
    } */
    
    
    
    
}