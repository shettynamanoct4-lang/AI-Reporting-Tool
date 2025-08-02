public class J1EnvGeography {
    public static void main(){
        //List<J1_AllCountries_ResponseWrapper> wrapLst = new List<J1_AllCountries_ResponseWrapper>();
        // Set the endpoint URL.
        String endpoint = 'https://www.envisageglobalinsurance.com/admin/api/ApiGeographic/findAllCountries';
        endpoint = endpoint;
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endpoint);
        
        request.setBody('{"user":"SF_integration@culturalvistas.org", "key":"5a54cce28ce767e34bbef1876520d53e"}'); 
        // Set the HTTP verb to GET.
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Send the HTTP request and get the response.
        // The response is in JSON format.
        HttpResponse response = httpProtocol.send(request);
        System.debug('Status Code' + response.getBody());
        
        if(response.getStatusCode()==200){
            System.debug(response.getBody());
            /*
            JSONParser parser = JSON.createParser(response.getBody());
            parser.nextToken();
            while (parser.nextToken() != null) {
                // Start at the array of All Countires Wrapper.
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        // Advance to the start object marker to
                        //  find next country object.
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            J1Insurance_AllCountries_ResponseWrapper.response inv = (J1Insurance_AllCountries_ResponseWrapper.response)parser.readValueAs(J1Insurance_AllCountries_ResponseWrapper.response.class);
                            
                            //wrapLst.add(inv);
                            System.debug('All Countries'+inv);
                        }
                    }
                    
                }
            } 
            
        }
        //System.debug('All Countries'+wrapLst);
        //return wrapLst;
    } */
        }
    
}


}