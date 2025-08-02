public class PostalIntegrate {
    @AuraEnabled
    public static List<Wrapper> postOfcBranchName(String branchName){
        List<Wrapper> wrapLst = new List<Wrapper>();
        // Set the endpoint URL.
        String endpoint = 'https://api.postalpincode.in/postoffice/';
        //String Branch = (String)JSON.deserialize(branchName, String.class);
        if(string.isNotBlank(branchName)){
            endpoint = endpoint + branchName;
        }
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        request.setHeader('content-type','application/json');
        // Send the HTTP request and get the response.
        // The response is in JSON format.
        HttpResponse response = httpProtocol.send(request);
        System.debug('Status Code' + response.getStatusCode());
        
        if(response.getStatusCode()==200){
            
            JSONParser parser = JSON.createParser(response.getBody());
            parser.nextToken();
            while (parser.nextToken() != null) {
                // Start at the array of PostOffice Wrapper.
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        // Advance to the start object marker to
                        //  find next invoice statement object.
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            Wrapper inv = (Wrapper)parser.readValueAs(Wrapper.class);
                            
                            wrapLst.add(inv);
                            System.debug('Postal Values'+inv);
                        }
                    }
                    
                }
            } 
            /*
            System.debug('Postal Values List'+response.getBody());
            Wrapper res = (Wrapper)JSON.deserialize(response.getBody(), Wrapper.class);
            */
            
            //System.debug('Postal Values List'+res);
           /* for(Object o : res){
                Map<String, Object> posts = (Map<String, Object>)o;
                System.debug('Maps:'+posts);
            } */
        }
        System.debug('Postal Values List'+wrapLst);
        return wrapLst;
    }
    
    public class Wrapper{
        @AuraEnabled
        public String Name{get;set;}	//New Delhi G.P.O.
        @AuraEnabled
		public String Description{get;set;}	//
        @AuraEnabled
		public String PINCode{get;set;}	//110001
        @AuraEnabled
		public String BranchType{get;set;}	//Head Post Office
        @AuraEnabled
		public String DeliveryStatus{get;set;}	//Delivery
        @AuraEnabled
		public String Circle{get;set;}	//New Delhi
        @AuraEnabled
		public String District{get;set;}	//New Delhi
        @AuraEnabled
		public String Division{get;set;}	//New Delhi GPO
        @AuraEnabled
		public String Region{get;set;}	//Delhi
        @AuraEnabled
		public String State{get;set;}	//Delhi
        @AuraEnabled
		public String Country{get;set;}
    }  
    /*
    public class Wrapper{
        @AuraEnabled
        public String Message;	//Number of Post office(s) found: 2
        @AuraEnabled
	    public String Status;	//Success
        @AuraEnabled
	    public List<PostOffice> PostOffice;
        
    }
    public class PostOffice{
        @AuraEnabled
        public String Name{get;set;}	//New Delhi G.P.O.
        @AuraEnabled
		public String Description{get;set;}	//
        @AuraEnabled
		public String PINCode{get;set;}	//110001
        @AuraEnabled
		public String BranchType{get;set;}	//Head Post Office
        @AuraEnabled
		public String DeliveryStatus{get;set;}	//Delivery
        @AuraEnabled
		public String Circle{get;set;}	//New Delhi
        @AuraEnabled
		public String District{get;set;}	//New Delhi
        @AuraEnabled
		public String Division{get;set;}	//New Delhi GPO
        @AuraEnabled
		public String Region{get;set;}	//Delhi
        @AuraEnabled
		public String State{get;set;}	//Delhi
        @AuraEnabled
		public String Country{get;set;}
    } */
}