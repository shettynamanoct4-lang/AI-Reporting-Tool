public class SelectAllFieldQuery {
    public static Integer counter = 0;
    public static void testa(){
        //Declare object Name
        String obj = 'Account';
        //String to store whole query
        String quer = 'Select ';
        //List to store multiple objects
        List<String> listOfObj = new List<String>();
        //Add the above required object to the listOfObj list
        listOfObj.add(obj);
        //Get the fields from the 'Schema' class which retrieves the field and object, etc
        Set<String> listOfFields = schema.describeSObjects(listOfObj)[0].fields.getMap().keyset();
        System.debug('The list of fields'+listOfFields);
        //use for loop to process one by one all the fields and construct a query for above mentioned String query
        for(String str : listOfFields){
            quer = quer + str + ',';
        }
        //This query gives Select Id, Name,
        //So to remove the last comma(,) use removeEnd
        System.debug(quer);
        quer = quer.removeEnd(',');
        //This query gives Select Id, Name
        System.debug(quer);
        //To add the Object name and 'FROM' to the String query
        quer = quer + 'FROM' + obj;
        //Now our final query is done
        System.debug(quer);
        List<String> strName = new List<String>();
        List<Account> act = Database.query(quer);
        for(Account a : act){
            strName.add(a.Name);
        }
        System.debug(act);
        
                                
                                
    }
    public static void cnt(){
        
        List<Account> act = [Select Id, Name from Account where Name = 'Nesrke'];
        for(Account a : act){
            counter = counter +1;
        }
        System.debug(counter);
    }

}