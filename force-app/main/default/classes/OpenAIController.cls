public with sharing class OpenAIController {
    private static final String API_URL = 'https://api.openai.com/v1/chat/completions';
    
    @AuraEnabled(cacheable=true)
    public static List<String> getPromptSuggestions(String searchText) {
        if (String.isBlank(searchText)) {
            return new List<String>();
        }
        
        List<String> prompts = new List<String>();
        
        for (Prompt_Config__mdt prompt : [
            SELECT Prompt_Text__c FROM Prompt_Config__mdt 
            WHERE Prompt_Text__c LIKE :('%' + searchText + '%') 
            ORDER BY Prompt_Text__c ASC 
            
        ]) {
            prompts.add(prompt.Prompt_Text__c);
        }
        
        return prompts;
    }

    @AuraEnabled
    public static String getAIReport(String queryInput) {
        try {

            String apiKey = 'dummy';
            String schemaDetails = getSchemaDetails();
            HttpResponse response = callChatGPT(queryInput, apiKey, schemaDetails);
            System.debug('Response code : ' + response.getStatusCode());
            if (response.getStatusCode() == 200) {
                System.debug('Callout response : '+ processChatGPTResponse(response.getBody()));
                return processChatGPTResponse(response.getBody());
            }
            System.debug('Error: No response from AI');
            return JSON.serialize(new Map<String, Object>{ 'error' => 'Error: No response from AI' });
        } catch (Exception e) {
            System.debug('Error: '+ e.getMessage());
            return JSON.serialize(new Map<String, Object>{ 'error' => e.getMessage() });
        }
    }

    // Method to call ChatGPT API
    private static HttpResponse callChatGPT(String queryInput, String apiKey, String schemaDetails) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(API_URL);
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + apiKey);
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(120000);

        String requestBody = JSON.serialize(new Map<String, Object>{
            'model' => 'gpt-4o',
            'messages' => new List<Object>{
                new Map<String, Object>{ 
                    'role' => 'system',
                    'content' => 'You are a Salesforce SOQL expert. Convert user queries into valid SOQL queries. If the prompt passed is any of the standard salesforce object you can use its API Name. If it is an opportunity object display the opportunity name, amount, closedate, stage and probability in this order of sequence. If its an account object display the Account Name, Account Number, Account Source, AnnualRevenue, Industry in this order of sequence. If its Lead object display the  Full Name, Annual Revenue, Company, Email, Converted. If its custom object name then Here are the Salesforce custom object and field details: ' + schemaDetails
                },
                new Map<String, Object>{ 
                    'role' => 'user', 
                    'content' => 'Convert this into SOQL Query: ' + queryInput
                }
            },
            'max_tokens' => 150,
            'temperature' => 0.3
        });

        request.setBody(requestBody);
 
        return http.send(request);
    }
    
    private static String getSchemaDetails() {
        Map<String, Schema.SObjectType> allObjects = Schema.getGlobalDescribe();
        List<String> schemaInfo = new List<String>();
        // Loop over all custom objects
        for (String objName : allObjects.keySet()) {
            if (objName.endsWith('__c')) { // Custom objects
                Schema.DescribeSObjectResult describeResult = allObjects.get(objName).getDescribe();
                List<String> fieldNames = new List<String>();
                Map<String, Schema.SObjectField> fields = describeResult.fields.getMap();
                for (String fldName : fields.keySet()) {
                    fieldNames.add(fldName);
                }
                schemaInfo.add('Object: ' + objName + ', Fields: [' + String.join(fieldNames, ',') + ']');
            }
        }
        System.debug('Schema info : '+ schemaInfo);
        return String.join(schemaInfo, '; ');
    }

    // Process AI Response
    private static String processChatGPTResponse(String responseBody) {
        System.debug('Request Body : '+ responseBody);
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        List<Object> choices = (List<Object>) responseMap.get('choices');

        if (!choices.isEmpty()) {
            Map<String, Object> firstChoice = (Map<String, Object>) choices[0];
            Map<String, Object> messageContent = (Map<String, Object>) firstChoice.get('message');
            String aiResponse = (String) messageContent.get('content');

            if (aiResponse.toLowerCase().contains('select') && aiResponse.toLowerCase().contains('from')) {
                String soqlQuery = cleanAIResponse(aiResponse);
                return executeSOQL(soqlQuery);
            } else {
                System.debug('Request else body : '+ JSON.serialize(new Map<String, Object>{ 'message' => aiResponse }));
                return JSON.serialize(new Map<String, Object>{ 'message' => aiResponse });
            }
        }
        System.debug('Error: No valid response from AI');
        return JSON.serialize(new Map<String, Object>{ 'error' => 'Error: No valid response from AI' });
    }

    private static String executeSOQL(String soqlQuery) {
        System.debug('Query before security enforcement: ' + soqlQuery);
        try {
            
            List<sObject> records = Database.query(soqlQuery);
            if (records.isEmpty()) {
                return JSON.serialize(new List<Map<String, Object>>());
            }
            
            List<Map<String, Object>> results = new List<Map<String, Object>>();
            for (sObject rec : records) {
                system.debug('Object Records:' +rec);
                results.add((Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(rec)));
                System.debug('results : '+ results);
            }
            
            return JSON.serializePretty(results);
        } catch (Exception e) {
            System.debug('Invalid query: ' + e.getMessage());
            return JSON.serialize(new Map<String, Object>{ 'error' => 'Invalid query: ' + e.getMessage() });
        }
    }
    

    // Clean AI Response
    private static String cleanAIResponse(String aiResponse) {
        List<string> CALENDAR_TYPES = new List<string>{'CALENDAR_MONTH','CALENDAR_WEEK', 'CALENDAR_QUARTER', 'CALENDAR_YEAR'};
        
        System.debug('Original AI Response: ' + aiResponse);
        
        // Regex pattern to reliably capture full SOQL query
        Pattern fullQueryPattern = Pattern.compile('(?is)(SELECT.+?FROM.+?)(?=```|$)');
        Matcher fullQueryMatcher = fullQueryPattern.matcher(aiResponse);
        
        if (fullQueryMatcher.find()) {
            String soqlQuery = fullQueryMatcher.group(1).trim();
            // Clean markdown if exists
            soqlQuery = soqlQuery.replaceAll('```sql', '').replaceAll('```', '').trim();
            System.debug('Extracted SOQL query: ' + soqlQuery);
            if (soqlQuery.contains('CALENDAR_MONTH')){
    			soqlQuery = soqlQuery.replace('CALENDAR_MONTH', '');
			}
			else if (soqlQuery.contains('CALENDAR_WEEK')){
    			soqlQuery = soqlQuery.replace('CALENDAR_WEEK', '');
			}
            else if (soqlQuery.contains('CALENDAR_QUARTER')){
    			soqlQuery = soqlQuery.replace('CALENDAR_QUARTER', '');
			}
			else if (soqlQuery.contains('CALENDAR_YEAR')){
    			soqlQuery = soqlQuery.replace('CALENDAR_YEAR', '');
			}
            System.debug('Extracted SOQL query after Calendar: ' + soqlQuery);
            if(soqlQuery.contains('(')) {
                soqlQuery = soqlQuery.replace('(', '');
            }
            
            if(soqlQuery.contains('UserInfo.getUserId()')) {
                Id userid = UserInfo.getUserId();
                soqlQuery = soqlQuery.replace(':UserInfo.getUserId()', 'userid');
            }
            
            System.debug('Extracted SOQL query Open Brasis: ' + soqlQuery);
            if(soqlQuery.contains(')')) {
                soqlQuery = soqlQuery.replace(')', '');
            }
            System.debug('Extracted SOQL query Close Brasis: ' + soqlQuery);          
            return soqlQuery;
        }
        
        throw new AuraHandledException('AI response did not contain a valid SOQL query.');
    }
    
}