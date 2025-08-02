public class dltSourceActQueuable implements Queueable {
    private final String targetAccountId;
    private final String sourceAccountId;
    private boolean hasErrors = false;

    public dltSourceActQueuable(String targetId, String sourceId) {
        this.targetAccountId = targetId;
        this.sourceAccountId = sourceId;
    }

    public void execute(QueueableContext context) {
        // Starting a transaction
        Savepoint sp = Database.setSavepoint();

        try {
            Account accountToDelete = [SELECT Id FROM Account WHERE Id = :sourceAccountId LIMIT 1];
            if (accountToDelete != null) {
                Database.DeleteResult deleteResult = Database.delete(accountToDelete, false);

                if (!deleteResult.isSuccess()) {
                    // Log or handle the delete failure
                    for (Database.Error err : deleteResult.getErrors()) {
                        System.debug('Error deleting source account: ' + err.getMessage());
                    }
                    hasErrors = true;
                    Database.rollback(sp);
                }
            }
            else{
                hasErrors = true;
                Database.rollback(sp);
                 System.debug('No Source Account');
            }
        } catch (Exception e) {
            // Log or handle the exception
            System.debug('Exception occurred in dltSourceActQueuable: ' + e.getMessage());
            hasErrors = true;
            Database.rollback(sp);
        } finally {
            // Determine the merge status based on the success of the operation
            String mergeStatus = hasErrors ? 'Error' : 'Success';
            System.debug('Status :'+ mergeStatus);
            
            // Publish platform event with merge status
            publishMergeStatusEvent(targetAccountId, mergeStatus);
        }
    }

    private static void publishMergeStatusEvent(String accountId, String status) {
        MergeStatus__e event = new MergeStatus__e(Account_Id__c = accountId, Merge_Status__c = status);
        EventBus.publish(event);
    }
}