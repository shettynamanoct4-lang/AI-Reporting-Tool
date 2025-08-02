public class ComboAcc {
    @AuraEnabled
    public static List<Account> gAc(){
        List<Account> ace = [Select Id, Name from Account];
        return ace;
    }
    //We can use Apex class as picklist for combo box for showing Profiles as :-
    //public static Map<String,String> getProfiles(){
    //    Map<String,String>profileMap = new Map<String,String>();
    //    for(Profile pr : [Select Id, Name from Profile limit 10];){
    //          profileMap.put(pr.Id, pr.Name);
    //    }
    //return profileMap;
}