public with sharing class AIReportingController {
    private static final String API_URL = 'https://api.openai.com/v1/chat/completions';
    
    @AuraEnabled(cacheable=true)
    public static List<String> getPromptSuggestions(String searchText) {
        if (String.isBlank(searchText)) {
            return new List<String>();
        }
        
        List<String> prompts = new List<String>();
        
        for (Prompt_Config__mdt  prompt : [
            SELECT Prompt_Text__c FROM Prompt_Config__mdt  
            WHERE Prompt_Text__c LIKE :('%' + searchText + '%') 
            ORDER BY Prompt_Text__c ASC 
            
        ]) {
            prompts.add(prompt.Prompt_Text__c);
        }
        
        return prompts;
    }
    
    @AuraEnabled
    public static String getAISummary(String tableData) {
        System.debug('Data for summary : ' + tableData);
        try {
            String apiKey = 'dummy'; // Store securely in Named Credentials or Custom Metadata
            
            String summaryPrompt = 
                'You are a data analyst. Analyze the following Salesforce tabular data and generate a clear and insightful summary for business stakeholders.\n\n' +
                'Please follow these formatting rules strictly:\n' +
                '- Identify patterns and trends across columns (e.g., dates, amounts, categories, statuses)\n' +
                '- Mention highest/lowest values if applicable\n' +
                '- Highlight any notable records based on volume, value, or frequency\n' +
                '- Do **not repeat** column names unless relevant\n\n' +
                'Format strictly as bullet points. Avoid any long paragraphs.\n\n' +
                '- Use bullet points (`-`) for each insight.\n' +
                '- Start each bullet with a **bolded heading**, followed by a colon and the insight. For example: `- **Highest Revenue**: Company ABC with $2M.`\n' +
                '- Only the heading should be bold. The rest of the sentence should be plain.\n' +
                '- Be concise and insightful.\n\n' +
                'Here is the data:\n' + tableData;
            
            
            
            HttpResponse response = callChatGPTForSummary(summaryPrompt, apiKey);
            
            if (response.getStatusCode() == 200) {
                return processChatGPTResponse(response.getBody());
            }
            
            return JSON.serialize(new Map<String, Object>{ 'error' => 'Error: No response from AI' });
        } catch (Exception e) {
            return JSON.serialize(new Map<String, Object>{ 'error' => e.getMessage() });
        }
    }
    
    // New method to call ChatGPT for summarization
    private static HttpResponse callChatGPTForSummary(String summaryPrompt, String apiKey) {
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
                            'content' => 'You are an AI assistant specialized in data analysis. Provide a **concise yet complete summary** of the following Salesforce data in bullet points. Ensure all key insights are included and avoid truncation.'
                            },
                                new Map<String, Object>{ 
                                    'role' => 'user', 
                                        'content' => summaryPrompt
                                        }
                },
                    'max_tokens' => 500,
                    'temperature' => 0.3
                    });
        
        request.setBody(requestBody);
        return http.send(request);
    }
    
    @AuraEnabled
    public static String getAIReport(String queryInput) {
        try {
            String apiKey = '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'; // Store securely in Named Credentials or Custom Metadata
            String schemaDetails = '';//getSchemaDetails();
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
        
        // Include picklist metadata in system prompt
        String picklistMetadata = getPicklistMetadataPrompt();
        
        String systemPrompt = 'You are a Salesforce SOQL expert. Convert user queries into valid SOQL queries. We will execute the query via Apex later.\n\n' +
                            '- If the prompt passed is any of the standard salesforce object you can use its API Name.\n' +
                            '- For Opportunity: select Opportunity Name, Amount, CloseDate, Stage, Probability and Probability_Stage__c in this order of sequence.\n' +
                            '- For Account: select Name, AccountNumber, AccountSource, AnnualRevenue, Industry in this order of sequence.\n' +
                            '- For Lead: select Full Name, Annual Revenue, Company, Email, Converted in this order of sequence.\n\n' +
                            '- If the prompt includes to order the records then, along with adding the ordering clause and other asks also make sure that the asked field value are not null by using != NULL filters in the WHERE clause.\n' +
                            '- If the prompt seems to ask for recent/latest/few records but no number is explicitly mentioned, add LIMIT 15 to the SOQL query.\n' +
                            '- If the prompt includes time filters like "this quarter" or "next quarter", use keywords like THIS_QUARTER or NEXT_QUARTER.\n' +
                            '⚠️ IMPORTANT: When the prompt includes text like "with name John" or "email as abc"....etc, assume **partial match** unless clearly specified.\n' +
                            '- Use **LIKE operator with wildcards** (e.g., Name LIKE \'%John%\') when users are likely referring to a name that contains the value.\n' +
                            '- Only use "=" for exact matches E : if the user says "exactly", "equal to", or specifies precision.\n' +
                            '- Always prefer more inclusive results to align with natural language tone.\n'+
                            '- Do NOT use CALENDAR functions on the right-hand side of the WHERE clause.\n\n'+
                            'Below is metadata for certain picklist fields in this Salesforce org:\n\n' + picklistMetadata;
        
        String requestBody = JSON.serialize(new Map<String, Object>{
            'model' => 'gpt-4o',
                'messages' => new List<Object>{
                    new Map<String, Object>{ 
                        'role' => 'system',
                            'content' => systemPrompt                            
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
    
    private static String getPicklistMetadataPrompt() {
        Map<String, List<String>> fieldValueMap = new Map<String, List<String>>();
        
        fieldValueMap.put('Account.AccountSource', getPicklistValues('Account', 'AccountSource'));
        fieldValueMap.put('Account.Industry', getPicklistValues('Account', 'Industry'));
        fieldValueMap.put('Opportunity.StageName', getPicklistValues('Opportunity', 'StageName'));
        fieldValueMap.put('Lead.Status', getPicklistValues('Lead', 'Status'));
        fieldValueMap.put('Lead.LeadSource', getPicklistValues('Lead', 'LeadSource'));
        
        List<String> lines = new List<String>();
        
        for (String field : fieldValueMap.keySet()) {
            lines.add(field + ': ' + String.join(fieldValueMap.get(field), ', '));
        }
        
        return String.join(lines, '\n');
    }

    
    private static List<String> getPicklistValues(String objectApiName, String fieldApiName) {
        List<String> values = new List<String>();
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(objectApiName);
        if (sObjType == null) return values;
        
        Schema.DescribeSObjectResult objDescribe = sObjType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        
        if (!fieldMap.containsKey(fieldApiName)) return values;
        
        Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldApiName).getDescribe();
        
        if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
            for (Schema.PicklistEntry entry : fieldDescribe.getPicklistValues()) {
                if (!entry.isActive()) continue;
                values.add(entry.getLabel());
            }
        }
        
        return values;
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
            System.debug('records: ' + records);
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
            boolean removeOpenandCloseBraces = false;
        
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
                removeOpenandCloseBraces = true;
            }
            if (soqlQuery.contains('CALENDAR_WEEK')){
                soqlQuery = soqlQuery.replace('CALENDAR_WEEK', '');
                removeOpenandCloseBraces = true;
            }
            if (soqlQuery.contains('CALENDAR_QUARTER')){
                soqlQuery = soqlQuery.replace('CALENDAR_QUARTER', '');
                removeOpenandCloseBraces = true;
            }
            if (soqlQuery.contains('CALENDAR_YEAR')){
                soqlQuery = soqlQuery.replace('CALENDAR_YEAR', '');
                removeOpenandCloseBraces = true;
            }
            System.debug('Extracted SOQL query after Calendar: ' + soqlQuery);
            if(removeOpenandCloseBraces) {
                if(soqlQuery.contains('(') && !soqlQuery.contains('SUM')) {
                    soqlQuery = soqlQuery.replace('(', '');
                }   
                if(soqlQuery.contains(')') && !soqlQuery.contains('SUM')) {
                    soqlQuery = soqlQuery.replace(')', '');
                }  
            }
            
            if(soqlQuery.contains('UserInfo.getUserId()')) {
                Id userid = UserInfo.getUserId();
                soqlQuery = soqlQuery.replace(':UserInfo.getUserId()', '\'' + userid + '\'');
            }
            
            
            return soqlQuery;
        }
        
        throw new AuraHandledException('AI response did not contain a valid SOQL query.');
    }
    
    @AuraEnabled
    public static String sendEmailWithSummary(String tableDataJson) {
        System.debug('tableDataJson: ' + tableDataJson);
        
        if (String.isBlank(tableDataJson)) {
            return 'Error: No data available to send.';
        }
        
        try {
            // Step 1: Get the summary using existing method
            String summaryResponseJson = getAISummary(tableDataJson);
            System.debug('summaryResponseJson: ' + summaryResponseJson);
            
            // Step 2: Parse the summary
            String summary = 'Summary not available';
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(summaryResponseJson);
            
            if (responseMap.containsKey('message')) {
                summary = (String) responseMap.get('message');
            } else if (responseMap.containsKey('error')) {
                return 'Error: ' + (String) responseMap.get('error');
            }
            
            // Step 3: Send the email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { UserInfo.getUserEmail() });
            mail.setSubject('AI Report Summary');
            
            String htmlSummary = summary.replaceAll('\n', '<br/>');
            
            mail.setHtmlBody('<p>Hi,</p><p>Here is your Salesforce report summary:</p>' +
                             '<div style="font-family:monospace;">' + htmlSummary + '</div><br/>' +
                             '<p>Regards,<br/>AI Assistant</p>');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            return 'Success';
            
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
    
    
    
    
    private static Blob generateExcelFromList(List<Map<String, Object>> records) {
        if (records.isEmpty()) return Blob.valueOf('No Data Found');
        
        List<String> columns = new List<String>(records[0].keySet());
        String headerRow = String.join(columns, '\t') + '\n';
        
        String data = '';
        for (Map<String, Object> row : records) {
            List<String> line = new List<String>();
            for (String col : columns) {
                line.add(String.valueOf(row.get(col)));
            }
            data += String.join(line, '\t') + '\n';
        }
        
        return Blob.valueOf(headerRow + data);
    }
    
    
    
    
    
}