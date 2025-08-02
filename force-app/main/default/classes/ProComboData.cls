public class ProComboData {
    @AuraEnabled
    public static List<Account> goAc(){
        List<Account> ace = [Select Id, Name from Account limit 10];
        return ace;
    }
    
    @AuraEnabled
    public static List<Contact> concom(String recievedAcc){
        List<Contact> cco = [Select Name, Phone ,Id, AccountId from Contact where AccountId=:recievedAcc ];
        return cco;
    }

}