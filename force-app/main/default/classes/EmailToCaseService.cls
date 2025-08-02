global class EmailToCaseService implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                            Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        try {
            System.debug('Inside email service');
            // Parse the email body to extract the reason
            String emailBody = email.plainTextBody;
            String caseReason = extractCaseReason(emailBody); // Extract the reason from email body
            
            // Create a Case
            Case newCase = new Case(
                Subject = email.subject != null ? email.subject : 'No Subject Provided',
                Description = emailBody,
                Status = 'New', // Default status
                Reason = caseReason // Set Case Reason
            );
            
            insert newCase;
            
            // Create a Case Comment
            CaseComment caseComment = new CaseComment(
                ParentId = newCase.Id,
                CommentBody = 'This case was created from an email.',
                IsPublished = true
            );
            
            insert caseComment;
            
            result.success = true;
        } catch (Exception e) {
            result.success = false;
            result.message = 'Error processing email: ' + e.getMessage();
        }
        
        return result;
    }
    
    // Utility method to extract Case Reason from email body
    private String extractCaseReason(String emailBody) {
        if (emailBody == null) return null;
        
        // Look for "Reason - <Value>" in the email body
        Pattern pattern = Pattern.compile('(?i)Reason\\s*[-:]\\s*(\\w+)'); // Regex for "Reason - Feedback"
        Matcher matcher = pattern.matcher(emailBody);
        
        if (matcher.find()) {
            return matcher.group(1); // Return the extracted value
        }
        
        return null; // Default to null if no reason found
    }
}