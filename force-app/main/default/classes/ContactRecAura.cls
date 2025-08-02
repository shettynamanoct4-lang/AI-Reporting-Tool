public class ContactRecAura {
    @AuraEnabled
    public static string ConRec(Contact cc){
        insert cc;
        return cc.Id;
    }

}