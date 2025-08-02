public with sharing class OpAcCheck {
    public static void testo(List<Account> nwAct){
        Set<Id> acctIds = new Set<Id>();
        for(Account aa : nwAct){
            acctIds.add(aa.Id);
        }
        DateTime day = System.now()-30;
        List<Opportunity> updtOpp = new List<Opportunity>();
        List<Opportunity> opp = [Select Id,Name,Type,CloseDate,StageName, createdDate, AccountId from Opportunity where AccountId IN:acctIds];
        for(Opportunity opr : opp){
            if(opr.createdDate<day && opr.StageName!='Closed Won'){
                opr.StageName= 'Closed Lost';
                opr.CloseDate= System.today();
                updtOpp.add(opr);
            }
        }
        if(updtOpp.size()>0){
            update updtOpp;
        }
    }
    
    

}