public class EmailToCaseTgr {
    public static void validateLogic(List<EmailMessage> newEmailmsg){
        // List to update cases
        List<Case> casesToUpdate = new List<Case>();
        
        // Loop through the EmailMessage records
        for (EmailMessage email : newEmailmsg) {
            System.debug('Entered in Email Msg Tgr');
            // Ensure the EmailMessage is linked to a Case
            if (email.ParentId != null && String.valueOf(email.ParentId).startsWith('500')) {
                // Query the associated Case
                Case linkedCase = [SELECT Id, ContactId, AccountId FROM Case WHERE Id = :email.ParentId LIMIT 1];
                
                // Check if a Contact exists for the email's FromAddress
                Contact associatedContact = [SELECT Id, AccountId FROM Contact WHERE Email = :email.FromAddress LIMIT 1];
                
                if (associatedContact != null) {
                    // Associate the Contact and Account with the Case
                    linkedCase.ContactId = associatedContact.Id;
                    linkedCase.AccountId = associatedContact.AccountId;
                } else {
                    // Create a test Contact if none exists
                    Contact testContact = new Contact(
                        FirstName = 'Test',
                        LastName = 'Contact',
                        Email = email.FromAddress
                    );
                    insert testContact;
                    
                    // Associate the test Contact with the Case
                    linkedCase.ContactId = testContact.Id;
                }
                
                // Check the email body for a specific keyword to populate the Case Type
                if (email.TextBody != null && email.TextBody.contains('Type - Electrical')) {
                    linkedCase.Type = 'Electrical';
                }
                
                // Add the case to the list for updates
                casesToUpdate.add(linkedCase);
            }
        }
        
        // Update the cases with the new associations
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
    
}