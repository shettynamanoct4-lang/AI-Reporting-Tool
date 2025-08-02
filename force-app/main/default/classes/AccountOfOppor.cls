public class AccountOfOppor {
    public static void myMethod(){
        List<Account> lst = [Select Id, Name From Account where CreatedDate = THIS_WEEK];
        List<Id> actId = new List<Id>();
        for(Account a : lst){
            actId.add(a.Id);
        }
        List<Opportunity> op = [Select Name, AccountId from Opportunity where AccountId IN :actId];
        for(Opportunity opp : op){
            System.debug('The Opportunites are:'+ opp.Name);
        }
        
    }
}