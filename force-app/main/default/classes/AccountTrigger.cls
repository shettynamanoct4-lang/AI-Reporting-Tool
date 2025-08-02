public class AccountTrigger {
    public static void onAfterInsert(List<Account> accountList)
    {
        //calling afterInsert method from AccountAction class
   
      AccountAction.insertOpportunity(accountList,null);  
    
    }


}