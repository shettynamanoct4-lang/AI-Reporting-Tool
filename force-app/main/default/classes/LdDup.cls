public with sharing class LdDup {
    public static void test1(List<Lead> ld){
        Map<String, Contact> mp = new Map<String, Contact>();
        List<Contact> c = [Select Id, Email from Contact];
        for(Contact cd : c){
            mp.put(cd.Email, cd);
        }
        for(Lead l : ld){
            if(mp.containsKey(l.Email)){
                l.addError('Cant have dup mail');
            }
        }
    }
    public static void test2(List<Lead> lp, Map<Id,Lead> ml){
        Map<String, Contact> mp = new Map<String, Contact>();
        List<Contact> c = [Select Id, Email from Contact];
        for(Contact cd : c){
            mp.put(cd.Email, cd);
        }
        for(Lead li : lp){
            if(li.Email != ml.get(li.Id).Email){
                if(mp.containsKey(li.Email)){
                    li.addError('Cant have dup mail');
                }
            }
        }
        
        
        
        
    }
    
}