global class BatchUpdConOfAcc implements Database.Batchable<sobject>, Database.Stateful{
    global Integer totalRec = 0;
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([Select Id, Name, Phone, (Select Id, LastName, Phone from Contacts) from Account where Name = 'Batchya']);
    }
    global void execute(Database.BatchableContext bc, List<Account> act){
        List<Contact> updt = new List<Contact>();
        for(Account a : act){
            for(Contact c : a.Contacts){
                c.Phone = a.Phone;
                updt.add(c);
                totalRec = totalRec+1;
                System.debug('Count is' + totalRec);
            }
        }
        update updt;
    }
    global void finish(Database.BatchableContext bc){
        System.debug('Total Records processed are '+ totalRec);
        AsyncApexJob job = [Select Id, Status, TotalJobItems from AsyncApexJob where Id=:bc.getJobId()];
    }

}