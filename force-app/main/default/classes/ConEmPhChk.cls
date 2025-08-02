public with sharing class ConEmPhChk {
    public static void testo(List<Contact> nwcn){
        Map<String,Contact> mailDup = new Map<String,Contact>();
        Map<String,Contact> phnDup = new Map<String,Contact>();
        List<Contact> cn = [Select 	Email, Phone from Contact];
        for(Contact c : cn){
            mailDup.put(c.Email, c);
            phnDup.put(c.Phone, c);
        }
        for(Contact ne : nwcn){
            if((ne.Email!=null && ne.Phone!=null) && (mailDup.containsKey(ne.Email) && phnDup.containsKey(ne.Phone))){
                   ne.addError('Duplicate');
            }
            else if((ne.Email!=null && ne.Phone!=null) &&(mailDup.containsKey(ne.Email) || phnDup.containsKey(ne.Phone))){
                    ne.addError('Duplicate');
            }
                   
               
               
        }
        
    }

}