public class Recal {
    public static void testa(){
        Account a = new Account(Name = 'abc', Phone = '2233');
        insert a;
        Account ab = [Select Id,Name, Form__c from Account where Id='0015g00000mGTYXAA4'];
       System.debug(ab.Form__c);
        ab.Phone = '5566';
        update ab;
        Formula.recalculateFormulas(new List<Account>{ab});
        System.debug(ab.Form__c);
    }
    

}