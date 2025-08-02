public with sharing class FileHandler {
    public static void afterInsertHandler(List<ContentDocumentLink> fileList){
        //To hold the AccountId where file is attached and the file Id is not empty which is linked to Account only
        Set<Id> acctIdSet = new Set<Id>();
        Map<Id, Account> actMap = new Map<Id, Account>();
        //For the new inserted file on Account check if it's attached to that Account 
        for(ContentDocumentLink cd : fileList){
            //LinkedEntityId is like attached File's Account Id and startsWithIgnoreCase('001') tells that it's attached to Account
            if(cd.LinkedEntityId !=null && String.valueOf(cd.LinkedEntityId).startsWithIgnoreCase('001')){
                acctIdSet.add(cd.LinkedEntityId);
            } 
        }
        if(acctIdSet.size()>0){
            for(AggregateResult ag : [Select count(Id) fileNum, LinkedEntityId actId from ContentDocumentLink
                                      where LinkedEntityId in:acctIdSet group by LinkedEntityId]){
                                          Account newAcc = new Account(Id= (Id)ag.get('actId'),	Total_No_Of_Files__c=(decimal)ag.get('fileNum'));
                                          actMap.put(newAcc.Id, newAcc);
                                      }
        }
        if(actMap!=null && actMap.size()>0){
            update actMap.values();
        }
    }

}