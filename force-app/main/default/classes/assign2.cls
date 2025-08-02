public class assign2 {
    public static void updateContacts(){
        Account a = [select id from Account where name='Burlington Textiles Corp of America'];

        List<Contact> lst = [select id, name, phone, Account.Id from contact where Account.Id=:a.Id];
        for(Contact i : lst){
            i.Phone = '9110427398';
            update i;
            System.debug(i);
            
        }
        
    }

}