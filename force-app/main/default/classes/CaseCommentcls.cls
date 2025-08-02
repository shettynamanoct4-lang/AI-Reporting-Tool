public class CaseCommentcls {
    
    public static void validate(List<Case> newCases){
        List<CaseComment> caseComments = new List<CaseComment>();
        
        for (Case c : newCases) {
            System.debug('Entered in Case Tgr');
            // Create a CaseComment for each newly inserted Case
            CaseComment comment = new CaseComment(
                ParentId = c.Id, // Associate the comment with the Case
                CommentBody = 'This is an auto-generated case comment.',
                IsPublished = true // Set to true if you want the comment to be visible to the customer
            );
            caseComments.add(comment);
        }
        
        if (!caseComments.isEmpty()) {
            insert caseComments; // Insert the CaseComments
        }
    }
     
}