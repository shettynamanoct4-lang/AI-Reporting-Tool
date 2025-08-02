@isTest
public with sharing class ContactTriggerHandlerTest {
    
    @TestSetup
    public static void makeData(){
        List<Account> act = new List<Account>();
        Account a = new Account(Name= 'TestAcc1');
        Account a1 = new Account(Name= 'TestAcc2');
        act.add(a);
        act.add(a1);
        insert act;
        
        List<Contact> con =new List<Contact>();
        Contact c = new Contact(LastName= 'Cont1', AccountId= act[0].id, Active__c=True);
        Contact c1 = new Contact(LastName= 'Cont2', AccountId= act[0].id, Active__c=True);
        Contact c2 = new Contact(LastName= 'Cont3', AccountId= act[0].id);
        Contact c3 = new Contact(LastName= 'Cont4', AccountId= act[1].id);
        con.add(c);
        con.add(c1);
        con.add(c2);
        con.add(c3);
        insert con;
    }
    
    
    
    
    
    /*@isTest
    public static void afterInsertHandlerTest(){
        
        
        List<Account> tstAc = [Select Id, Num_of_Active_Contacts__c from Account];
        System.assertEquals(2, tstAc.size());
        System.assertEquals(null, tstAc[0].Num_of_Active_Contacts__c);
        System.assertEquals(null, tstAc[1].Num_of_Active_Contacts__c);
        
        List<Contact> tstCon = [Select Id from Contact];
        System.assertEquals(null, tstCon.size());
    }*/
    
    @isTest
    public static void afterInsertHandlerTest1(){
        
        
        List<Account> tstAc = [Select Id, Name, Num_of_Active_Contacts__c from Account];
        System.assertEquals(2, tstAc.size());
        for(Account ap : tstAc){
            if(ap.Name=='TestAcc1'){
                System.assertEquals(2, ap.Num_of_Active_Contacts__c);
            }
            if(ap.Name=='TestAcc2'){
                System.assertEquals(null, ap.Num_of_Active_Contacts__c);
            }
        }
        
        
        List<Contact> tstCon = [Select Id from Contact];
        System.assertEquals(null, tstCon.size());
    }
    
    @isTest
    public static void afterInsertHandlerTestBulk(){
        List<Account>tAc = [Select Id from Account where Name='TestAcc1'];
        
        
        List<Contact> con =new List<Contact>();
        for(Integer i = 0; i<1000; i++){
            Contact cc = new Contact(LastName= 'Test Cont'+ i, AccountId= tAc[0].Id, Active__c=True );
            con.add(cc);
        }
        
        insert con;
        
        List<Account> tstAc = [Select Id, Name, Num_of_Active_Contacts__c from Account];
        System.assertEquals(2, tstAc.size());
        for(Account ap : tstAc){
            if(ap.Name=='TestAcc1'){
                System.assertEquals(1002, ap.Num_of_Active_Contacts__c);
            }
            if(ap.Name=='TestAcc2'){
                System.assertEquals(null, ap.Num_of_Active_Contacts__c);
            }
        }
        
        
        List<Contact> tstCon = [Select Id from Contact];
        System.assertEquals(1004, tstCon.size());
    }
    
    @isTest
    public static void afterUpdateHandlerTest(){
        
        
        
        List<Contact> tstCon = [Select Id, LastName from Contact];
        for(Contact cd : tstCon){
            if(cd.LastName=='Cont3' || cd.LastName=='Cont4'){
                cd.Active__c= True;
            }
        }
        Test.startTest();
        update tstCon;
        Test.stopTest();
        
        List<Account> tstAc = [Select Id, Name, Num_of_Active_Contacts__c from Account];
        System.assertEquals(2, tstAc.size());
        for(Account ap : tstAc){
            if(ap.Name=='TestAcc1'){
                System.assertEquals(4, ap.Num_of_Active_Contacts__c);
            }
            if(ap.Name=='TestAcc2'){
                System.assertEquals(null, ap.Num_of_Active_Contacts__c);
            }
        }
        
        
        
        System.assertEquals(4, tstCon.size());
        
    }
    
    @isTest
    public static void afterUpdateHandlerTest2(){
        
        
        List<Account> acti = [Select Id from Account where Name = 'TestAcc2'];
        List<Contact> tstCon = [Select Id, LastName from Contact];
        for(Contact cd : tstCon){
            if(cd.LastName=='Cont3'){
                cd.Active__c= True;
                cd.AccountId=acti[0].id;
            }
        }
        Test.startTest();
        update tstCon;
        Test.stopTest();
        
        List<Account> tstAc = [Select Id, Name, Num_of_Active_Contacts__c from Account];
        System.assertEquals(2, tstAc.size());
        for(Account ap : tstAc){
            if(ap.Name=='TestAcc1'){
                System.assertEquals(2, ap.Num_of_Active_Contacts__c);
            }
            if(ap.Name=='TestAcc2'){
                System.assertEquals(1, ap.Num_of_Active_Contacts__c);
            }
        }
        
        
        
        System.assertEquals(4, tstCon.size());
        
    }
    



}