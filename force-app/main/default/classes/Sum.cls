public class Sum {
    public static void tes(){
        Id act = [Select Id, Name from Account where Name ='Sanvio'].Id;
        
        System.debug(act);
    }

}