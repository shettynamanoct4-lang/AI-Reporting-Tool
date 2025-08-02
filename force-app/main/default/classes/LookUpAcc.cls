public class LookUpAcc {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String actName){
        List<Account> act = new List<Account>();
        if(actName!=''){
            String ac= '%'+actName+'%';
            act = [Select Id, Name from Account where Name like:ac];
            
        }
        return act;
    }     

}