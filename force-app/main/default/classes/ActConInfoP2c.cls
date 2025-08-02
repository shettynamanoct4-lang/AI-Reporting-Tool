public class ActConInfoP2c {
    @AuraEnabled(cacheable=true)
    public static List<Account> actprnt(){
        List<Account> act = [Select Id, Name, Industry from Account limit 10];
        return act;
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> conOfAct(String accntId){
        List<Contact> con = [Select Id, FirstName, LastName, Phone from Contact where AccountId=:accntId];
        return con;
    }

}