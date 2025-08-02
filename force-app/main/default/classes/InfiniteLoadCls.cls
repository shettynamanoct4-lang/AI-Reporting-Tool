public class InfiniteLoadCls {
    @AuraEnabled
    public static List < Account > fetchAccounts( Integer intOffSet ) {
        
        List < Account > listAccounts = new List < Account >();
        System.debug( 
            'intOffSet is ' + intOffSet
        );
        
        if ( intOffSet != null ) {
            
            listAccounts = [ 
                SELECT Id, Name, Industry, AccountNumber 
                FROM Account 
                LIMIT 20 OFFSET : Integer.valueOf( intOffSet ) 
            ];
            
        }
        
        System.debug(
            'listAccounts is ' + 
            listAccounts
        );
        
        return listAccounts;
        
    }

}