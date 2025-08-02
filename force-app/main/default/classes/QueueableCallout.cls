public class QueueableCallout implements Queueable, Database.AllowsCallouts {
    private Id accountId;

    public QueueableCallout(Id accountId) {
        this.accountId = accountId;
    }

    public void execute(QueueableContext context) {
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
        
        // Process the response
        if (response.getStatusCode() == 200) {
            String responseBody = response.getBody();
            System.debug('Response Body: ' + responseBody);
        } else {
            System.debug('HTTP Callout failed with status code: ' + response.getStatusCode());
        }
    }
}