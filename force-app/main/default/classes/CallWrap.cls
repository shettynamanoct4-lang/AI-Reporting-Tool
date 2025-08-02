public class CallWrap {
    //public static String jsonStr ='{"statusCode":200,"success":true,"response":[{"CountryId":1,"Country":"Afghanistan","FIPS104":"AF","ISO2":"AF","ISO3":"AFG","ISON":"4","Internet":"AF","Capital":"Kabul","MapReference":"Asia","NationalitySingular":"Afghan","NationalityPlural":"Afghans","Currency":"Afghani","CurrencyCode":"AFA","Population":26813057,"Title":"Afghanistan","Comment":""},{"CountryId":2,"Country":"Albania","FIPS104":"AL","ISO2":"AL","ISO3":"ALB","ISON":"8","Internet":"AL","Capital":"Tirana","MapReference":"Europe","NationalitySingular":"Albanian","NationalityPlural":"Albanians","Currency":"Lek","CurrencyCode":"ALL","Population":3510484,"Title":"Albania","Comment":""}]}';
    public static void res(){
       // String jsonStr ='{"statusCode":200,"success":true,"response":[{"CountryId":1,"Country":"Afghanistan","FIPS104":"AF","ISO2":"AF","ISO3":"AFG","ISON":"4","Internet":"AF","Capital":"Kabul","MapReference":"Asia","NationalitySingular":"Afghan","NationalityPlural":"Afghans","Currency":"Afghani","CurrencyCode":"AFA","Population":26813057,"Title":"Afghanistan","Comment":""},{"CountryId":2,"Country":"Albania","FIPS104":"AL","ISO2":"AL","ISO3":"ALB","ISON":"8","Internet":"AL","Capital":"Tirana","MapReference":"Europe","NationalitySingular":"Albanian","NationalityPlural":"Albanians","Currency":"Lek","CurrencyCode":"ALL","Population":3510484,"Title":"Albania","Comment":""}]}';
      //  Env1.Wrapper wr = (Env1.Wrapper)JSON.deserialize(jsonStr, Env1.Wrapper.class);
      //  Account a = [Select Id, Name, Responses__c from Account where Id='0015g0000126xt6AAA'];
        //Env1.Wrapper wr = (Env1.Wrapper)JSON.deserialize(a.Responses__c, Env1.Wrapper.class);
       // System.debug(wr.statusCode);
     /*  List<Env1.response> wrapLst = new List<Env1.response>();
        JSONParser parser = JSON.createParser(a.Responses__c);
        parser.nextToken();
            while (parser.nextToken() != null) {
                // Start at the array of PostOffice Wrapper.
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                    while (parser.nextToken() != null) {
                        // Advance to the start object marker to
                        //  find next invoice statement object.
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            Env1.response inv = (Env1.response)parser.readValueAs(Env1.response.class);
                            
                            wrapLst.add(inv);
                            System.debug('Country Values'+inv);
                        }
                    }
                    
                }
        
       System.debug('List of Countries' + wrapLst);
                for(Env1.response ra : wrapLst){
                    System.debug(ra.CountryId);
                }
       //a.Responses__c =jsonStr;
       //update a;
       //System.debug(wr.response);
        
    } */
        Account a = [Select Id, Name, Responses__c from Account where Id='0015g00000zOTcYAAW'];
        Env5.Wrapper wr = (Env5.Wrapper)JSON.deserialize(a.Responses__c, Env5.Wrapper.class);
        List<List<Env5.response>> lst= new List<List<Env5.response>>();
        lst = wr.response;
        List<Env5.response> rep = lst[0];
        
        for(Env5.response e : rep){
            System.debug('Response' + e);
           // System.debug('Response Start Date'+ e.start_date);
        }
    } 
}