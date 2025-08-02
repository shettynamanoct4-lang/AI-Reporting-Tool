public class DmlDemo {
    public static void myMethod(){
        List<Account> con = new List<Account>();
        for(integer i=1; i<=5; i++)
        {
            Account ca = new Account(Name='Naman'+i);
            con.add(ca);
        }
        insert con;
        System.debug('Inserted Accounts'+con);   
    }

}