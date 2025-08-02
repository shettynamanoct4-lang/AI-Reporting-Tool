@RestResource(urlMapping='/createActfromPostman/')
global with sharing class createActPstMan {
    
    
    @HttpPost
    global static String createAccount() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        // Extract parameters from the request
        String accountName = req.params.get('ActName');
        String accountPhone = req.params.get('Phone');
        String accountRating = req.params.get('Rating');
        String accountType = req.params.get('Type');
        
        System.debug('Name : ' + accountName);
        System.debug('Phone : ' + accountPhone);
        System.debug('Rating : ' + accountRating);
        System.debug('Type : ' + accountType);
        
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



}