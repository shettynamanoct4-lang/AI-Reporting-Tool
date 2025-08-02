public class ContactUtilss {

    // Normal method to decide whether to use future or queueable
    public static void processOpportunities(Set<Id> contactIds) {
        // Check if this is being executed in a batch or future context
        if (System.isBatch() || System.isFuture()) {
            // If in future or batch, process using Queueable Apex
            System.enqueueJob(new ContactUtilssQueueable(contactIds));
        } else {
            // Otherwise, call the future method
            createOpportunitiesForActiveContacts(contactIds);
        }
    }

    // Future method to create Opportunities for active contacts
    @future
    public static void createOpportunitiesForActiveContacts(Set<Id> contactIds) {
        executeOpportunityCreation(contactIds);
    }

    // Shared logic for creating opportunities
    public static void executeOpportunityCreation(Set<Id> contactIds) {
        List<Contact> activeContacts = [SELECT Id, LastName, AccountId 
                                        FROM Contact 
                                        WHERE Id IN :contactIds];

        List<Opportunity> newOpportunities = new List<Opportunity>();

        for (Contact con : activeContacts) {
            Opportunity newOpp = new Opportunity(
                Name = con.LastName,
                Amount = 100,
                CloseDate = System.today().addDays(30), // Default close date
                StageName = 'Prospecting',
                AccountId = con.AccountId
            );
            newOpportunities.add(newOpp);
        }

        if (!newOpportunities.isEmpty()) {
            insert newOpportunities;
        }
    }
}