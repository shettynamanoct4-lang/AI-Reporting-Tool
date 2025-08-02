public with sharing class ActNameWithAccMapOnContact {
    public static Set<Id> actId = new Set<Id>();
    public static Map<Id, String> accountIdWithAccNameWithAccMap = new Map<Id, String>();
    public static String AccNameWithAccMap;
    public static void testa(List<Contact> newCont){
        for(Contact cc : newCont){
            if(cc.AccountId!=null){
                actId.add(cc.AccountId);
            }
        }
        List<Account> acts = [Select Id, Name, Acc_Map__c from Account where Id IN:actId];
        for(Account aa : acts){
            if(aa.Name !=null && aa.Acc_Map__c!=null){
                AccNameWithAccMap = String.valueOf(aa.Name) + ' , ' + String.valueOf(aa.Acc_Map__c);
            }
            else if(aa.Name !=null && aa.Acc_Map__c==null){
                AccNameWithAccMap = String.valueOf(aa.Name);
            }
            else if(aa.Name ==null && aa.Acc_Map__c!=null){
                AccNameWithAccMap = String.valueOf(aa.Acc_Map__c);
            }
            else{
                AccNameWithAccMap = '';
            }
            accountIdWithAccNameWithAccMap.put(aa.Id, AccNameWithAccMap);

        }
        for(Contact cc : newCont){
            if(accountIdWithAccNameWithAccMap.containsKey(cc.AccountId)){
                cc.Account_Name_with__c = accountIdWithAccNameWithAccMap.get(cc.AccountId);
            }
        }

    }

}