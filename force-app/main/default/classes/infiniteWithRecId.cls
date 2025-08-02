public class infiniteWithRecId {
    @AuraEnabled(cacheable=true)
    public static List<Account> loadDataById(){
        List<Account> first50Records = [Select Id, Name, Industry, AccountNumber from Account Order By Name,Id LIMIT 500];
        return first50Records;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Account> loadMoreData(String lastName, String lastId){
        List<Account> after50Records = [Select Id, Name, Industry, AccountNumber from Account where (Name>:lastName) OR (Name=:lastName AND Id>:lastId) 
                                        Order By Name,Id LIMIT 500];
        return after50Records;
    }
    
    @AuraEnabled(cacheable=true)
    public static Integer countOfAccounts(){
        AggregateResult totalAccounts = [Select Count(Id) recordsCount from Account];
        Integer countOfActs = (Integer)totalAccounts.get('recordsCount');
        return countOfActs;
    }

}