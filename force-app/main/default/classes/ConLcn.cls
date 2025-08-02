public with sharing class ConLcn {
    public static void testo(List<Account> act){
        Map<Id, Account> actId = new Map<Id, Account>();
        for(Account a : act){
            actId.put(a.Id, a);
        }
        for(Account ac : act){
            List<Contact> cn = new List<Contact>();
            for(Decimal i=0; i<actId.get(ac.Id).NumOfLoc__c; i++){
                Contact nwc = new Contact();
                nwc.AccountId = ac.Id;
                nwc.LastName = ac.Name + i;
                cn.add(nwc);
                System.debug('Contact'+cn);
            }
            if(cn.size()>0){
            insert cn;
        }
        
        }
        
    }

}