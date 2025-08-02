public with sharing class LeadValidation {
    public static void befIns(List<Lead>ld){
        Map<String,Contact> nw = new Map<String,Contact>();
        List<Contact> cn = [Select Email from Contact];
        for(Contact c : cn){
            nw.put(c.Email, c);
        }
        for(Lead lc : ld){
            if(lc.email != null){
              if(nw.containsKey(lc.Email)){
                lc.Email.addError('You cant have same email');
              }  
            }
            
        }
    }

}