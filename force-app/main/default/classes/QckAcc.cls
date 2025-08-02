public class QckAcc {
    @AuraEnabled
    public static void createAcc(String name, String phone, String parentRecordId){
        Account acc = new Account(Name=name, Phone=phone, ParentId=parentRecordId);
        insert acc;    
    }

}