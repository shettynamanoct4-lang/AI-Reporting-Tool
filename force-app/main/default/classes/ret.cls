public class ret {
    public static void myMethod(String str){
        List<Account> lst = [Select Id, Name, Phone, Type From Account where Name=:str];
        for(Account ac: lst){
        System.debug('Name is:'+ ac.Name);
        }
        
    }

}