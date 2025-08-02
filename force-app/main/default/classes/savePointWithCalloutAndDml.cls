public with sharing class savePointWithCalloutAndDml {
    public String output;
    public void basicAuthDml() {
      //  Savepoint sp = Database.setSavepoint();       
        try{
            Integer dmlLimit = Limits.getLimitDmlStatements(); // Get the total DML limit
            Integer dmlUsed = Limits.getDmlStatements(); // Get the number of DML statements used
            
            
            Account a = new Account();           
            a.Name = 'CalloutAndDml-1';            
            insert a;
            System.debug('DML Limit: ' + dmlLimit);
            System.debug('DML Used: ' + dmlUsed);
            //call();
            
            // Enqueue Queueable job for HTTP callout
            System.enqueueJob(new QueueableCallout(a.Id));
            System.debug('Act :'+a);
            Integer err = 1/0; // Deliberate error to test rollback
        } catch(Exception e) {           
          //   Database.rollback(sp);
          //   Database.releaseSavepoint(sp);
            System.debug('Rollback executed. Error: ' + e.getMessage());
           // call();
        }   
    }
    public static void call(){
        // Define the endpoint URL
        String endpoint = 'https://api.collectapi.com/imdb/imdbSearchByName?query=inception';           
        // Create a new HTTP request
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');           
        // Set request headers
        request.setHeader('authorization', 'apikey 1ReGXrCBapcVZwqJd3FFIO:4sRP3KHYzG4eSWJUL4scGa');
        request.setHeader('content-type', 'application/json');          
        // Create a new HTTP object to send the request
        Http http = new Http();        
        // Send the request and get the response
        HttpResponse response = http.send(request);         
        // Check if the callout was successful (status code 200)
        if (response.getStatusCode() == 200) {
            // Parse and process the response body
            String responseBody = response.getBody();
            System.debug('Response Body: ' + responseBody);             
        } else {
            // Handle unsuccessful response
            System.debug('HTTP Callout failed with status code: ' + response.getStatusCode());
        }
    }
}