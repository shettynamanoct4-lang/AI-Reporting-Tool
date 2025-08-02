public with sharing class UsrCse {
    public static void testa(List<Case> nwCase){
        User usr = [Select Id,Name from User where Name ='Mark Wood'];
        Id OnId = usr.Id;
        for(Case cs : nwCase){
            if(cs.Origin == 'Phone'){
                cs.Status = 'New';
                cs.Status = 'High';
                cs.OwnerId = OnId;
            }
        }
        
    }

}