public class wireEg {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAcco(){
        List<Account> act = [Select Name, Id, AccountNumber from Account limit 50];
        return act;
    }

}