public with sharing class ContactController {
     @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String searchKey,Integer rowsPerPage) {
        String searchQuery = 'SELECT Id, Name, Email, Phone FROM Contact';
        list<Contact> list_contact = new list<Contact>();
        if (!String.isEmpty(searchKey)) {
            String escapedSearchKey = String.escapeSingleQuotes(searchKey);
            searchQuery += ' WHERE Name LIKE \'%' + escapedSearchKey + '%\' OR Email LIKE \'%' + escapedSearchKey + '%\' OR Phone LIKE \'%' + escapedSearchKey + '%\' OR Account.Name LIKE \'%' + escapedSearchKey + '%\' LIMIT :rowsPerPage ';
            list_contact = Database.query(searchQuery);
        }else{
            list_contact = Database.query(searchQuery);
        }
        return list_contact;
    }
}