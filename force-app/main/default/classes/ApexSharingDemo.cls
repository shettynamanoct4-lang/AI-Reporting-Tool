public class ApexSharingDemo {
    public static void share(){
        AccountShare a = new AccountShare();
        Account actShare = [Select Id, Name from Account where Name = 'Chatrapati'];
        Id toBeShared = actShare.Id;
        a.AccountId = toBeShared;
        System.debug(toBeShared);
        User who = [Select Id from User where firstName = 'Mark'];
        a.UserOrGroupId = who.Id;
        a.AccountAccessLevel = 'Edit';
        a.CaseAccessLevel = 'Edit';
        a.OpportunityAccessLevel = 'Edit';
        Database.insert(a, false);
    }
    public static void dc(){
        List<Account> act = [Select Id, Name from Account where Name='Nesrke' FOR UPDATE];
    }

}