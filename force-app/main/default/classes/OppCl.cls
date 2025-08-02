public with sharing class OppCl {
    public static void testo(Map<Id, Opportunity> oldma, List<Opportunity> nwop){
        Set<Id> AcId = new Set<Id>();
        for(Opportunity opi : nwop){
            if(opi.Client_Contac__c != null && opi.Client_Contac__c != oldma.get(opi.Id).Client_Contac__c){
                AcId.add(opi.AccountId);
            }
        }
        Map<Id,Account> mc = new Map<Id,Account>();
        List<Account> aact = [Select Id, Client_Contact__c from Account where Id IN:AcId ];
        for(Account af : aact){
            mc.put(af.Id, af);
        }
        List<Account> upda = new List<Account>();
        for(Opportunity oo : nwop){
            if(mc.containsKey(oo.AccountId)){
                Account avi = mc.get(oo.AccountId);
                avi.Client_Contact__c = oo.Client_Contac__c;
                upda.add(avi);
            }
        }
        if(upda.size()>0){
            update upda;
        }
        
    }

}