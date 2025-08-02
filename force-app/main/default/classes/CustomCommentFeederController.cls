public with sharing class CustomCommentFeederController {

    @AuraEnabled(cacheable=true)
    public static List<FeedItem> getFeedItemList(String status, String parentId) {
        return [
            SELECT
                Id,
                Title,
                ParentId,
                Type,
                Body,
                TYPEOF CreatedBy WHEN User THEN Id END,
                TYPEOF CreatedBy WHEN User THEN Name END,
                TYPEOF CreatedBy WHEN User THEN SmallPhotoUrl END,
                CreatedDate
            FROM FeedItem
            WHERE Title = :status
            AND ParentId = :parentId
            AND Type = 'TextPost'
            ORDER BY CreatedDate DESC
        ];
    }

    @AuraEnabled
    public static FeedItem createFeedItemRec(FeedItem feedItemRec){
        try {
            String caseStatus = [
                SELECT Status
                FROM Case
                WHERE Id = :feedItemRec.ParentId
                LIMIT 1
            ].Status;

            feedItemRec.Title = caseStatus;
            insert feedItemRec;
            return feedItemRec;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<User> searchUsers(String searchTerm) {
        searchTerm = '%' + searchTerm + '%';
        return [
            SELECT Id, Name, SmallPhotoUrl
            FROM User
            WHERE Name LIKE :searchTerm
            LIMIT 10
        ];
    }
}