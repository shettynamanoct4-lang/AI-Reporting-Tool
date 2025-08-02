public with sharing class PrtcContCrtWrap {
    @AuraEnabled
    public static Account testa(String cc){
        Wrap we = (Wrap)JSON.deserialize(cc, Wrap.class);
       // Account a = (Account)JSON.deserialize(cc, Account.class);
       // Wrap w = new Wrap();
       // we.contRec = a;
       //Account actt = (Account)JSON.deserialize(cc, Account.class);
        Account act = we.contRec;
      try{
            insert act;
            return act;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    public class Wrap{
     
        @AuraEnabled
        public Account contRec{get;set;}
    } 

}