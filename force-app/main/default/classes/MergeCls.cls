public class MergeCls {
    
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account];
    }
    
    @AuraEnabled
    public static void mergeFields(String targetId, String sourceId) {
        // Starting a transaction
        Savepoint sp = Database.setSavepoint();
        String mergeStatus = 'Error'; // Default to error

        try {
            Account target = [SELECT Id, Phone, Rating, Description FROM Account WHERE Id = :targetId];
            Account source = [SELECT Id, Phone, Rating, Description FROM Account WHERE Id = :sourceId];
            
            // Store original values before making changes
           storeOriginalValues(targetId, target.Phone, target.Rating, target.Description);
            
            // Updating the target account with source account data
            target.Phone = source.Phone;
            target.Rating = source.Rating;
            target.Description += (target.Description != null ? ' ' : '') + source.Description;
            
            // Use Database.update for better error handling
            Database.SaveResult updateResult = Database.update(target, false);
            
            if (updateResult.isSuccess()) {
                mergeStatus = 'Success'; // Update status to success if update is successful
                // Enqueue the deletion of the source account
                System.enqueueJob(new dltSourceActQueuable(targetId, sourceId));
            } else {
                // Handle the update failure
                for (Database.Error err : updateResult.getErrors()) {
                    System.debug('Error updating target account: ' + err.getMessage());
                }
                // Rollback transaction as update failed
                Database.rollback(sp);
            }
        } catch (Exception e) {
            // Rollback the transaction in case of any exception
            System.debug('Error merging accounts: ' + e.getMessage());
            Database.rollback(sp);
        } finally {
            // Publish platform event with merge status
             
            publishMergeStatusEvent(targetId, mergeStatus);
            System.debug('Status :'+ mergeStatus);
        }
    }
    
    
    @AuraEnabled
    public static void reverseUpdate(String targetId) {
        System.debug('Target Id :'+ targetId);
        MergeSettings__c settings = MergeSettings__c.getOrgDefaults();
        if (settings != null) {
            Account target = [SELECT Id, Phone, Rating, Description FROM Account WHERE Id = :targetId];
            Savepoint sp = Database.setSavepoint();
            try {
                // Reset to original values
                target.Phone = settings.Original_Phone__c;
                target.Rating = settings.Original_Rating__c;
                target.Description = settings.Original_Description__c;
                
                update target;
                System.debug('Restored original values for account: ' + targetId);
            } catch (Exception e) {
                System.debug('Error during reverse update: ' + e.getMessage());
                Database.rollback(sp);
            }
        } else {
            System.debug('No original values stored for account: ' + targetId);
        }
        
    }
    
    private static void storeOriginalValues(String targetId, String phone, String rating, String description) {
        MergeSettings__c settings = MergeSettings__c.getOrgDefaults();
        
        settings.Original_Phone__c = phone;
        settings.Original_Rating__c = rating;
        settings.Original_Description__c = description;
        update settings;
    }
    

    private static void publishMergeStatusEvent(String accountId, String status) {
        MergeStatus__e event = new MergeStatus__e(Account_Id__c = accountId, Merge_Status__c = status);
        EventBus.publish(event);
    }
}