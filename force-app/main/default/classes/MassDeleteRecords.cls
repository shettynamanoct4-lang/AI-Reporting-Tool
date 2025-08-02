public class MassDeleteRecords {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(){
        List<Contact> con = [Select Id, firstName, lastName, Phone from Contact where firstName!=null order by createdDate desc ];
        return con;
    }
    
    @AuraEnabled
    public static void deleteSelectedContact(List<Id> ids){
        List<Contact> sel = new List<Contact>();
        sel = [Select Id from Contact where Id in:ids];
        if(sel!=null && sel.size()>0){
            delete sel;
        }
    }
        

}