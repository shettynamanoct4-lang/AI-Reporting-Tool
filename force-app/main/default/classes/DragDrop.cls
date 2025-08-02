public class DragDrop {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAcc(){
        List<Account> acc = [Select Id, Name, Industry, Type from Account where Industry!=null];
        return acc;
    }

}