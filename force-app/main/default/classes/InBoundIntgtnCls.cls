@RestResource(urlMapping='/createAccountfromPostman/')
global with sharing class InBoundIntgtnCls {
    @HttpPost
    global static String createAccount() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        // Parse JSON input
        String requestBody = req.requestBody.toString();
        System.debug('Request : ' + requestBody);
        
        // Deserialize JSON to wrapper class instance
        AccountWrapper accountData = (AccountWrapper) JSON.deserialize(requestBody, AccountWrapper.class);
        
        // Extract parameters
        String accountName = accountData.Name;
        String accountPhone = accountData.Phone;
        String accountRating = accountData.Rating;
        String accountType = accountData.Type;
        
        // Create new Account
        Account acc = new Account();
        acc.Name = accountName;
        acc.Phone = accountPhone;
        acc.Rating = accountRating;
        acc.Type = accountType;
        
        try {
            insert acc;
            return 'Account with Id ' + acc.Id + ' is created. Thanks.';
        } catch (DmlException e) {
            res.statusCode = 400;
            return 'Account creation failed: ' + e.getMessage();
        }
    }
    
    public class AccountWrapper {
        public String Name;
        public String Phone;
        public String Rating;
        public String Type;
    }
    
}