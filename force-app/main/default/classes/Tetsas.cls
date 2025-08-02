public class Tetsas {
    public static Id tes(){
        Account a = [Select Id, Name from Account order By CreatedDate DESC LIMIT 1];
        Id act = a.Id;
        return act;
    }

}