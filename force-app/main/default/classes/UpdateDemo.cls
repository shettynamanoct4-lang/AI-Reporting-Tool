public class UpdateDemo {
    public static void myMethod(){
        
        List<Opportunity> opr = [Select Name, Amount, CloseDate from Opportunity where CreatedDate = LAST_90_DAYS];
        Date d = Date.today();
        for(Opportunity op : opr){
            op.CloseDate=d+90;
            System.debug('Changed date:'+ op.CloseDate);
        }
        update opr;
        
    }

}