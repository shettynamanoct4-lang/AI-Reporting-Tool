public with sharing class AccountFieldSetController {
    
    // Method to retrieve field set details and JSON response
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getFieldSetData() {
        // Get Field Set information dynamically
        List<Schema.FieldSetMember> fieldSetMembers = SObjectType.Account.FieldSets.CustomFieldSet.getFields();
        List<Map<String, String>> fields = new List<Map<String, String>>();
        
        for (Schema.FieldSetMember fsm : fieldSetMembers) {
            Map<String, String> fieldData = new Map<String, String>();
            fieldData.put('label', fsm.getLabel());
            fieldData.put('apiName', fsm.getFieldPath());
            fields.add(fieldData);
        }

        // Simulate 3rd party JSON response for demonstration
        String jsonResponse = '[{"Full Name":"LE ROUX BYRON","Phone Number":"6608170167088","Contact Salary":"33","SalesRep":"DIRECTOR","contactCount":"19600106"},' + 
        '{"Full Name":"KLOPPER JOHAN LOUIS","Phone Number":"2711188605083","SalesRep":"DIRECTOR","contactCount":"19560712"},' + 
        '{"Full Name":"LE ROUX DUDLEY","Phone Number":"5901095885087","Contact Salary":"67.00","SalesRep":"DIRECTOR","contactCount":"19380723"},' + 
        '{"Full Name":"SALKOW GARRY WILLIAM","Phone Number":"6208195860088","SalesRep":"DIRECTOR","contactCount":"19570808"}]';

        // Deserialize the JSON string
        List<Object> jsonDataList = (List<Object>) JSON.deserializeUntyped(jsonResponse);

        // Convert List<Object> to List<Map<String, Object>>
        List<Map<String, Object>> jsonData = new List<Map<String, Object>>();
        for (Object obj : jsonDataList) {
            jsonData.add((Map<String, Object>) obj);
        }

        // Create result map to send both field set details and JSON data to LWC
        Map<String, Object> result = new Map<String, Object>();
        result.put('fields', fields);
        result.put('data', jsonData);

        System.debug('Results : '+ result.get('fields'));
        return result;
    }
}