public with sharing class createAccount {
    @AuraEnabled
    public static Account crtCon(Account ct){
        try{
            insert ct;
            return ct;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

}