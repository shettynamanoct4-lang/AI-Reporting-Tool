public class assignment {
    public static void createAccOpp(String accName, String oppName, String stage, Date cd){
        Account acc = new Account();
        acc.Name = accName;
        insert acc;
        ID accID = acc.Id;
        Opportunity opp = new Opportunity();
        opp.AccountId = accID;
        opp.Name = oppName;
        opp.StageName = stage;
        opp.CloseDate = cd;
        insert opp;
    }
}