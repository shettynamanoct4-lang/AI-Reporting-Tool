public with sharing class OppCnIn {
    public static void testo(List<Contact> nwCn){
        Set<Id> actId = new Set<Id>();
        for(Contact c : nwCn){
            if(c.AccountId!=null){
                actId.add(c.AccountId);
            }
        }
        List<Contact> conc = [Select Id, LastName, AccountId from Contact where AccountId IN:actId];
        List<Opportunity> oppi = new List<Opportunity>();
        for(Contact cc : conc){
            Opportunity op = new Opportunity();
            op.AccountId = cc.AccountId;
            op.Name = 'Trigger done';
            op.Type = 'Existing Customer - Upgrade';
            op.Amount = 566;
            op.CloseDate = System.today();
            op.StageName = 'Closed Won';
            oppi.add(op);
            
        }
        if(oppi.size()>0){
            insert oppi;
        }
    }

}