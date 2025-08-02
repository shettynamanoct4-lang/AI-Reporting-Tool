public class AccOpp {
    public static void myMethod(){
        List<Account> lst = [Select Id, Name From Account where CreatedDate = Yesterday];
        
        
        List<Opportunity> op = [Select Name, AccountId from Opportunity where AccountId IN :lst];
        for(Opportunity opp : op){
            System.debug('The Opportunites are:'+ opp.Name);
        }
        
        
    }

}