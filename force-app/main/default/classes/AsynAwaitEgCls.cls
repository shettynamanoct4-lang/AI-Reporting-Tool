public class AsynAwaitEgCls {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getInitialContacts() {
        // Query and return initial set of contacts
        return [SELECT Id, Name, Email FROM Contact where Email!=null LIMIT 5 ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> processContacts(List<Contact> contacts) {
        // Mock processing of contacts
        for (Contact con : contacts) {
            con.Email = 'processed_' + con.Email;
        }
        return contacts;
    }



}