@isTest
public class CreateNewOpportunitytest {
    @istest static void newaccinsertnewopportunity(){
        //creating new account
          
        account newacc = new account(name = 'Sample Account');
        insert newacc;
        
        // we are checking whether the inserted account created the opportunity
        
        list<opportunity> queriedopp = [select id from opportunity where accountid =:newacc.id];
        
        // checking whether the query returned one result which confirms that inserting account inserts opportunity.
        // 
        system.assertEquals(1, queriedopp.size());
    }
}