public with sharing class OppUd {
    public static void testo(List<Account> acrt){
        Set<Id> actId = new Set<Id>();
        for(Account a : acrt){
            actId.add(a.Id);
        }
        DateTime d = system.now()-30;
        List<Opportunity> op = [Select Id, AccountId , CreatedDate,CloseDate, StageName from Opportunity 
                                where ID IN: actId];
        List<Opportunity> upd = new List<Opportunity>();
        for(Opportunity o : op){
            if(o.CreatedDate< d && o.StageName != 'Closed Won'){
                o.StageName = 'Closed Lost';
                o.CloseDate = System.today();
                upd.add(o);
                
            }
        }
        update upd;
    }

}