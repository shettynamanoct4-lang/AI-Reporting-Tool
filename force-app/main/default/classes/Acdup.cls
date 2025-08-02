public class Acdup {
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

}