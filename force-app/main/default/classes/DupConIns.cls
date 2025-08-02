public with sharing class DupConIns {
    private static boolean cond = true;
    public static boolean runOnce(){
        if(cond){
            cond = false;
            return true;
        }
        else{
            return false;
        }
    }
    public static void testo(List<Contact> cn){
        List<Contact> upd = new List<Contact>();
        for(Contact c : cn){
            Contact g = new Contact();
            g = c.Clone();
            upd.add(g);
           
        }
        insert upd;
    }

}