public class wrapLwcActRating {
    @AuraEnabled(cacheable = true)
    public static List<Wrap> acccountsList(String str){
        List<Wrap> wra = new List<Wrap>();
        List<Account> acc = [Select Id, Name, Phone, Rating, (Select Id, LastName, Phone from Contacts) from Account where Rating=:str
                            ORDER BY CreatedDate DESC NULLS LAST];
        for(Account a : acc){
            Wrap wa = new Wrap();
            wa.acts = a;
            wa.conts = a.Contacts;
            wra.add(wa);
        }
        return wra;
    }
    @AuraEnabled(cacheable = true)
    public static List<Account> acccountsList2(){
        List<Account> wra1 = new List<Account>();
        List<Account> acc = [Select Id, Name, Phone, Rating, (Select Id, LastName, Phone from Contacts) from Account
                            ORDER BY CreatedDate DESC NULLS LAST];
        for(Account a : acc){
            wra1.add(a);
        }
        return wra1;
    }

    
public class Wrap{
        @AuraEnabled
        public Account acts{get;set;}
        @AuraEnabled
        public List<Contact> conts{get;set;}
}
}