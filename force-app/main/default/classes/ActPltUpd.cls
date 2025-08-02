public with sharing class ActPltUpd {
    @AuraEnabled
    public static void updateAccountRating(Id accountId, String newRating) {
        try {
            Account accountToUpdate = [SELECT Id, Rating FROM Account WHERE Id = :accountId LIMIT 1];
            accountToUpdate.Rating = newRating;
            update accountToUpdate;
        } catch (Exception e) {
            // Handle the exception and throw it to the LWC
            throw new AuraHandledException('Failed to update account rating: ' + e.getMessage());
        }
    }

}