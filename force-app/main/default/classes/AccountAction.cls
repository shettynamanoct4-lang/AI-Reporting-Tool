public class AccountAction {
    public static void insertOpportunity(List<Account> accountList, map< Id, Account> oldAccMap){
        
        //list to store Opportunity record
        List<Opportunity> listOfOpportunities = new List<Opportunity>();
        
        //when account is created 
        for(Account acc: accountList){
            
            if(oldAccMap==Null){
            
        // If 'Industry' field on Account has the values as 'Agriculture', add new Opportunity in the list 'listOfOpportunities'
            if(acc.Industry == 'Agriculture') {
                listOfOpportunities.add(new Opportunity(Name = acc.Name+' Opp',
                                                        AccountId = acc.Id,
                                                        StageName = 'Prospecting', 
                                                        Amount = 0, 
                                                        CloseDate = System.today() + 90));
            }
            }
            else
            {
             // Check if the new updated value is different from old in Industry field and is 'Agriculture'
            if(acc.Industry != oldAccMap.get(acc.Id).Industry && acc.Industry == 'Agriculture') {
                listOfOpportunities.add(new Opportunity(Name = acc.Name+' Opp',
                                                        AccountId = acc.Id,
                                                        StageName = 'Prospecting', 
                                                        Amount = 0, 
                                                        CloseDate = System.today() + 90));
            }
        }
        }
             if(!listOfOpportunities.isEmpty()) {
             insert listOfOpportunities;
             }
        
        
    
    }

}