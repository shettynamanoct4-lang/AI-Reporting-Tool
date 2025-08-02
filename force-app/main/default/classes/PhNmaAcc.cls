public with sharing class PhNmaAcc {
    public static void testo(Map<Id,Account> ma, List<Account> nwAc){
        for(Account ac : nwAc){
            if(ac.Phone != ma.get(ac.Id).Phone){
                ac.Name = ac.Name + ac.Phone;
            }
        }
    }

}