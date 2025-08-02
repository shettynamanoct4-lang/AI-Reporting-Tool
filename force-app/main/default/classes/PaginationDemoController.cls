public with sharing class PaginationDemoController {
    
    @AuraEnabled(cacheable=true)
    public static Integer getTotalAccountsCount() {
        return [SELECT COUNT() FROM Account];
    }
    
    @AuraEnabled
    public static List<Account> getAccounts(Integer pageSize, String lastRecordId, String sortColumnName, String sortOrder, String sortedLastFieldValue) {
        System.debug('Page Size: '+ pageSize);
        System.debug('lastRecordId: '+ lastRecordId);
        System.debug('sortColumnName: '+ sortColumnName);
        System.debug('sortOrder: '+ sortOrder);
        System.debug('sortedLastFieldValue: '+ sortedLastFieldValue);
        
        Object convertedFieldValue = convertFilterValueIntoFieldType('Account', sortColumnName, sortedLastFieldValue);
        sortColumnName = String.isNotBlank(sortColumnName) ? String.escapeSingleQuotes(sortColumnName) : sortColumnName;
        String operator = sortOrder == 'DESC' ? '<' : '>';
        String query = 'SELECT Id, Name, Type, Rating, NumberOfEmployees, CreatedDate FROM Account ';
        
        if (String.isNotBlank(lastRecordId) && String.isBlank(sortColumnName)) {
            query += 'WHERE Id ' + operator + ' :lastRecordId ';
        } else if (String.isNotBlank(lastRecordId) && String.isNotBlank(sortColumnName) && String.isNotBlank(sortedLastFieldValue)) {
            query += 'WHERE (' + sortColumnName + ' = :convertedFieldValue AND Id ' + operator + ' :lastRecordId) OR ' + sortColumnName + ' ' + operator + ' :convertedFieldValue ';
        } else if (String.isNotBlank(lastRecordId) && String.isNotBlank(sortColumnName) && String.isBlank(sortedLastFieldValue)) {
            if (sortOrder == 'ASC') {
                query += 'WHERE ((Id ' + operator + ' :lastRecordId AND ' + sortColumnName + ' = \'\') OR (' + sortColumnName + '<> \'\')) ';
            } else {
                query += 'WHERE (Id ' + operator + ' :lastRecordId AND ' + sortColumnName + ' = \'\') ';
            }
        }
        
        query += 'ORDER BY ';
        if (String.isNotBlank(sortColumnName)) {
            query += sortColumnName + ' ' + (sortOrder ?? 'ASC') + ', ';
        }
        query += 'Id ' + (sortOrder ?? 'ASC') + ' LIMIT :pageSize';
        
        System.debug('Final Query - ' + query);
        return Database.query(query);
    }
    
    @AuraEnabled
    public static List<Account> getFilteredAccounts(String filterField, String filterCriteria, String filterValue, Integer pageSize, Integer pageNumber) {
        // Calculate offset based on pagination parameters
        Integer offset = Math.max(0, (pageNumber - 1) * pageSize);
        
        String query;
        if (filterCriteria == 'notContains') {
            query = 'SELECT Id, Name, Type, Rating, NumberOfEmployees, CreatedDate FROM Account WHERE NOT (' + filterField + ' LIKE \'%' + filterValue + '%\')';
        } else {
            query = 'SELECT Id, Name, Type, Rating, NumberOfEmployees, CreatedDate FROM Account WHERE ' + filterField + ' LIKE \'%' + filterValue + '%\'';
        }
        
        // Apply pagination
        query += ' ORDER BY Name LIMIT :pageSize OFFSET :offset';
        
        // Execute the query and return the results
        return Database.query(query);
    }
    
    
    
    private static Object convertFilterValueIntoFieldType(String objectName, String fieldName, String fieldValue) {
        System.debug('fieldValue:' + fieldValue);
        Object newFieldValue = fieldValue;
        if (String.isBlank(fieldName) || String.isBlank(fieldValue)) {
            System.debug('fieldName :'+ fieldName + ' fieldValue :' + fieldValue);
            System.debug('newFieldValue (no conversion needed): ' + newFieldValue);
            return newFieldValue;
        }
        
        String fieldDataType = String.valueOf(Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType());
        System.debug('fieldDataType: ' + fieldDataType);
        switch on fieldDataType {
            when 'INTEGER' {
                newFieldValue = Integer.valueOf(fieldValue);
            }
            when 'DATETIME' {
                newFieldValue = DateTime.valueOfGMT(fieldValue.replace('T', ' '));
            }
            when 'BOOLEAN' {
                newFieldValue = Boolean.valueOf(fieldValue);
            }
            // Add more types as required
            when 'STRING' {
                newFieldValue = String.valueOf(fieldValue);               
            }
        }
        System.debug('newFieldValue 2 : ' + newFieldValue);
        return newFieldValue;
    }
    
    @AuraEnabled
    public static void deleteAccountRecords(List<Id> recordIds) {
        try {
            List<Account> accountsToDelete = [SELECT Id FROM Account WHERE Id IN :recordIds];
            delete accountsToDelete;
        } catch (DmlException ex) {
            throw new AuraHandledException('Failed to delete records: ' + ex.getMessage());
        }
    }
}