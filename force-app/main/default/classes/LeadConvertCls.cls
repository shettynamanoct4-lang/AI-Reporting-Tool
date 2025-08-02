public with sharing class LeadConvertCls {
    public static void ldTst(Id leadId, Id opportunityId){
        // Retrieve the existing opportunity record
        Opportunity existingOpportunity = [SELECT Id, AccountId, ContactId, OrderNumber__c FROM Opportunity WHERE Id = :opportunityId];

        // Query lead fields before conversion
        Lead leadBeforeConversion = [SELECT Id, SICCode__c FROM Lead WHERE Id = :leadId];

        // Convert the Lead programmatically
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadId);
        lc.setAccountId(existingOpportunity.AccountId); // Set the AccountId if required
        lc.setOpportunityId(existingOpportunity.Id);
        lc.setConvertedStatus('Closed - Converted');

        // Optionally, copy the value from the Lead's field to the custom field in the existing Opportunity
        existingOpportunity.OrderNumber__c = leadBeforeConversion.SICCode__c;

        Database.LeadConvertResult lcr = Database.convertLead(lc);

        // Check if lead conversion was successful
        if (lcr.isSuccess()) {
            // Update the existing opportunity record with lead details
            update existingOpportunity;
            System.debug('Opportunity updated successfully with Lead field value.');

            // Get the converted opportunity ID
            Id convertedOppId = lcr.getOpportunityId();
            Id accountId = lcr.getAccountId();
            Id contactId = lcr.getContactId();
            System.debug('Act Id:'+ accountId + ','+ 'Con Id:'+ contactId+ ',' +  'Opp Id:'+ convertedOppId);
        } else {
            // Handle lead conversion failure
            System.debug('Lead conversion failed: ' + lcr.getErrors());
        }
    }
}