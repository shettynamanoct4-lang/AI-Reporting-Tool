public class ProjCnt {
    @AuraEnabled(cacheable=true)
    public static List<Contact> gtCn(Id accotId, String searchValue){
        if(searchValue!=null && searchValue!=''){
            String a = '%'+ searchValue + '%';
            List<Contact> cntu = [Select Id, Name, Phone, AccountId from Contact where AccountId=: accotId AND Name like :a];
            return cntu;
        }
        else{
            List<Contact> cnto = [Select Id, Name, Phone, AccountId from Contact where AccountId=: accotId];
            if(!(cnto).isEmpty()){
                return cnto;
            }
            return null;
        }
        
       
    }

}