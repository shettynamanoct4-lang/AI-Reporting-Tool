public with sharing class ChatGPTController {
    private static final String API_URL = 'https://api.openai.com/v1/chat/completions';
    
    @AuraEnabled
    public static String getChatGPTResponse(String userInput) {
        try {
            String apiKey = 'dummy';
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(API_URL);
            request.setTimeout(120000); // 120 seconds timeout
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer ' + apiKey);
            request.setHeader('Content-Type', 'application/json');

            // Constructing the request body for OpenAI API
            String requestBody = JSON.serialize(new Map<String, Object>{
                'model' => 'gpt-4o',
                'messages' => new List<Object>{
                    new Map<String, Object>{
                        'role' => 'user', 'content' => userInput
                    }                 
                },
               'max_tokens' => 500
            });

            request.setBody(requestBody);
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> choices = (List<Object>) responseMap.get('choices');
                if (!choices.isEmpty()) {
                    Map<String, Object> firstChoice = (Map<String, Object>) choices[0];
                    Map<String, Object> messageContent = (Map<String, Object>) firstChoice.get('message');
                    return (String) messageContent.get('content');
                }
            }
            return 'Error: No response from ChatGPT';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}