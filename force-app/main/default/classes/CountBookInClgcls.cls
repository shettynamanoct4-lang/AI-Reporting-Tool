public with sharing class CountBookInClgcls {
    public static void countBook(Map<Id,Book__c>newBooks){
        Set<Id> clgIds = new Set<Id>();
        for(Id b : newBooks.keySet()){
            if(newBooks.get(b).College__c!=null){
                clgIds.add(newBooks.get(b).College__c);
                System.debug('Colle Ids :'+ clgIds);
                System.debug('Ids of clg: '+ clgIds);
            }
        }
        CalculateCountOfBookInClg(clgIds);
        
    }
    private static void CalculateCountOfBookInClg(Set<Id> clgIds){
        Map<String, Integer> totalBookInClg = new Map<String, Integer>();
        List<College__c> clgRecToUpd = new List<College__c>();
        List<College__c> colleges = [Select Id, Total_Books__c,Name, (Select Id, City__c, College__c from Books__r) from College__c where Id IN:clgIds];
        if(colleges.size()>0 && !colleges.isEmpty()){
            for(College__c clg : colleges){
                Integer numOfBooks = clg.Books__r.size();
                totalBookInClg.put(String.valueOf(clg.Id),numOfBooks);
            }
        }
        for(College__c clg : colleges){
            if(totalBookInClg.containsKey(clg.Id)){
                System.debug('Inside first if');
                College__c clgRec = new College__c();
                clgRec.Id = clg.Id;
                clgRec.Total_Books__c = totalBookInClg.get(clg.Id);
                clgRecToUpd.add(clgRec);
            }
        }
        if(clgRecToUpd.size()>0 && !clgRecToUpd.isEmpty()){
            System.debug('Inside second if');
            update clgRecToUpd;
            System.debug('Updated Rec :'+ clgRecToUpd);
            System.debug('End');
        }
        
    }

}