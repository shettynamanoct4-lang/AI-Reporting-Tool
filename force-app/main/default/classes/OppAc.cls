public with sharing class OppAc {
    public static void CreateOpportunity(List<Account> accList)
    {
        List<Opportunity> oppList=new List<Opportunity>();
        for(Account a:accList)
        {
            Opportunity o = new Opportunity();
            o.AccountID=a.ID;
            
            o.Name=a.Name;
            o.CloseDate=System.Today().addDays(3);
            
            o.StageName='Prospecting';
            
            oppList.add(o);
        }
        
        if (oppList.size() > 0)
            Database.Insert(oppList);
    }
}