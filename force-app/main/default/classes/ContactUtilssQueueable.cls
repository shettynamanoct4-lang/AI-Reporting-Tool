public class ContactUtilssQueueable implements Queueable {
    Set<Id> contactIds;

    // Constructor to pass the active contact IDs
    public ContactUtilssQueueable(Set<Id> contactIds) {
        this.contactIds = contactIds;
    }

    // Execute method for queueable
    public void execute(QueueableContext context) {
        ContactUtilss.executeOpportunityCreation(contactIds);
    }
}