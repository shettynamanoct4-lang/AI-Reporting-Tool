public with sharing class AccountSearchController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String globalSearchKey, String searchKey, String phoneFilter, String ratingFilter, String statusFilter, Integer limitSize, String lastRecordName, String lastRecordId) {
        String query = 'SELECT Id, Name, Phone, Rating, Status__c FROM Account WHERE ';

        // Global search across all fields
        if (!String.isBlank(globalSearchKey)) {
            query += '(Name LIKE \'%' + String.escapeSingleQuotes(globalSearchKey) + '%\' ' +
                     'OR Phone LIKE \'%' + String.escapeSingleQuotes(globalSearchKey) + '%\' ' +
                     'OR Rating LIKE \'%' + String.escapeSingleQuotes(globalSearchKey) + '%\' ' +
                     'OR Status__c LIKE \'%' + String.escapeSingleQuotes(globalSearchKey) + '%\')';
        } else {
            query += 'Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';

            // Apply filters if provided
            if (!String.isBlank(phoneFilter)) {
                query += ' AND Phone LIKE \'%' + String.escapeSingleQuotes(phoneFilter) + '%\'';
            }
            if (!String.isBlank(ratingFilter)) {
                query += ' AND Rating = \'' + String.escapeSingleQuotes(ratingFilter) + '\'';
            }
            if (!String.isBlank(statusFilter)) {
                query += ' AND Status__c = \'' + String.escapeSingleQuotes(statusFilter) + '\'';
            }
        }

        // Handle infinite scrolling: load more records after the last loaded record
        if (!String.isBlank(lastRecordName) && !String.isBlank(lastRecordId)) {
            query += ' AND (Name > :lastRecordName OR (Name = :lastRecordName AND Id > :lastRecordId))';
        }

        query += ' ORDER BY Name, Id LIMIT :limitSize';

        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static Integer countOfAccounts() {
        // Get the total number of records for pagination or other use cases
        Integer totalAccounts = [SELECT COUNT() FROM Account];
        return totalAccounts;
    }
}