public with sharing class DataTableForMoreThan50k {
    
    @AuraEnabled(cacheable=true)
    public static PaginationResult loadInitialData(Integer pageSize){
        List<Account> records = [SELECT Id, Name, Industry, AccountNumber FROM Account ORDER BY Id ASC LIMIT :pageSize];
        Boolean hasPrevious = false;
        Boolean hasNext = records.size() < pageSize; // Check if there are more records after the current set
        System.debug('Has Next :' + hasNext);
        return new PaginationResult(records, hasPrevious, hasNext);
    }
    
    @AuraEnabled(cacheable=true)
    public static PaginationResult loadMoreData(String lastId, Integer pageSize){
        // Fetch records excluding the lastId
        List<Account> records = [SELECT Id, Name, Industry, AccountNumber FROM Account WHERE Id > :lastId ORDER BY Id ASC LIMIT :pageSize];
        
        Boolean hasPrevious = true; // There are always previous records available
        Boolean hasNext = records.size() >= pageSize; // Check if there are more records after the current set
        
        // Remove the extra record fetched
        if (records.size() > 0) {
            records.remove(0);
        }
        
        return new PaginationResult(records, hasPrevious, hasNext);
    }
    
    
    
    public class PaginationResult {
        @AuraEnabled
        public List<Account> records { get; set; }
        @AuraEnabled
        public Boolean hasPrevious { get; set; }
        @AuraEnabled
        public Boolean hasNext { get; set; }
        
        public PaginationResult(List<Account> records, Boolean hasPrevious, Boolean hasNext){
            this.records = records;
            this.hasPrevious = hasPrevious;
            this.hasNext = hasNext;
        }
    }
}