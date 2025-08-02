public class rollBackDeemo {
    public static void testa(){
        Savepoint sp = Database.setSavepoint();
        try{
            Account a = new Account();
            a.Name = 'Roll-2';
            insert a;
            System.debug('Account :'+a);
            //Integer err = 1/0; 
            Contact c = new Contact();
            c.FirstName = 'Roll-Cnt0-2';
          //error-  c.LastName = 'Lst';
            insert c;
            System.debug('Contact :'+c);
        }catch(Exception e){
            System.debug('Exception :'+ e);
            Database.rollback(sp);
            Database.releaseSavepoint(sp);
        }
        //created irrespective of success or fail
        College__c clgRec = new College__c();
        clgRec.Name = 'Rv3';
        insert clgRec;
        System.debug('Rv3');
        
        
    }

}