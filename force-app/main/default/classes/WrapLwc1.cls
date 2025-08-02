public class WrapLwc1 {
    @AuraEnabled(cacheable=true)
    public static List<Wrap1> show(){
        List<Wrap1> lst = new List<Wrap1>();
        List<Account> actt = [Select Id, Name, (Select Id, LastName, Phone from Contacts) from Account LIMIT 5];
        if(!actt.isEmpty()){
            for(Account a : actt){
            Wrap1 wr = new Wrap1();
            wr.act = a;
            wr.lstCon= a.Contacts;
            wr.sizeOfCons=a.Contacts.size();
            lst.add(wr);
            }
        }
        
        return lst;
        
    }
    
    public class Wrap1{
        @AuraEnabled
        public Account act{get;set;}
        @AuraEnabled
        public List<Contact> lstCon{get;set;}
        @AuraEnabled
        public Integer sizeOfCons{get;set;}
    }
/*lst :[
       Wrap1:{ act : {Name:'Nman', Phone:'090'},
              lstCon : [{LastName:'Ki', Phone:'8786'}, {LastName:'Oi', Phone:'75786'}],
              sizeOfCons : 4 
        
       }
       Wrap1:{ act : {Name:'Qman', Phone:'56090'},
               lstCon : [{LastName:'SKi', Phone:'568786'}, {LastName:'QEOi', Phone:'45475786'}],
               sizeOfCons : 5 
        
       }
       ] */
}