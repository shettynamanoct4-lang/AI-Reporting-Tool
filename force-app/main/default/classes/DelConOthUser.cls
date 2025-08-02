public with sharing class DelConOthUser {
    public static void testo(List<Contact> oldy){
        Id pId = Userinfo.getProfileId();
        Profile pname = [Select Name from Profile where Id=:pId];
        for(Contact c : oldy){
            if(pname.Name != 'System Administrator'){
                c.addError('No access for u to delete');
            }
        }
    }

}