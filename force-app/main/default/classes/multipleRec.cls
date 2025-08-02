public class multipleRec {
    @AuraEnabled
    public static List<Account> crAcc(List<Account> acc){
        insert acc;
        return acc;
    }

}