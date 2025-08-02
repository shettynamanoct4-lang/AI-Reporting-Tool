public class Env1 {
    public class Wrapper{
        public Integer statusCode;	    //200
	    public boolean success;
	    public List<response> response;
    }
        
        public class response{
            public Integer CountryId;	    //1
            public String Country;	    //Afghanistan
            public String FIPS104;	    //AF
            public String ISO2;	    //AF
            public String ISO3;	    //AFG
            public String ISON;	    //4
            public String Internet;	    //AF
            public String Capital;	    //Kabul
            public String MapReference;	    //Asia
            public String NationalitySingular;	    //Afghan
            public String NationalityPlural;	    //Afghans
            public String Currrency;	    //Afghani
            public String CurrencyCode;	    //AFA
            public Integer Population;	    //26813057
            public String Title;	    //Afghanistan
            public String Comment;
        }
    /*
    public static String jsonStr ='{"statusCode":200,"success":true,"response":[{"CountryId":1,"Country":"Afghanistan","FIPS104":"AF","ISO2":"AF","ISO3":"AFG","ISON":"4","Internet":"AF","Capital":"Kabul","MapReference":"Asia","NationalitySingular":"Afghan","NationalityPlural":"Afghans","Currency":"Afghani","CurrencyCode":"AFA","Population":26813057,"Title":"Afghanistan","Comment":""},{"CountryId":2,"Country":"Albania","FIPS104":"AL","ISO2":"AL","ISO3":"ALB","ISON":"8","Internet":"AL","Capital":"Tirana","MapReference":"Europe","NationalitySingular":"Albanian","NationalityPlural":"Albanians","Currency":"Lek","CurrencyCode":"ALL","Population":3510484,"Title":"Albania","Comment":""}]}';
    public static void res(){
        //String jsonStr ='{"statusCode":200,"success":true,"response":[{"CountryId":1,"Country":"Afghanistan","FIPS104":"AF","ISO2":"AF","ISO3":"AFG","ISON":"4","Internet":"AF","Capital":"Kabul","MapReference":"Asia","NationalitySingular":"Afghan","NationalityPlural":"Afghans","Currency":"Afghani","CurrencyCode":"AFA","Population":26813057,"Title":"Afghanistan","Comment":""},{"CountryId":2,"Country":"Albania","FIPS104":"AL","ISO2":"AL","ISO3":"ALB","ISON":"8","Internet":"AL","Capital":"Tirana","MapReference":"Europe","NationalitySingular":"Albanian","NationalityPlural":"Albanians","Currency":"Lek","CurrencyCode":"ALL","Population":3510484,"Title":"Albania","Comment":""}]}';
        Wrapper wr = (Wrapper)JSON.deserialize(jsonStr, Wrapper.class);
        Account a = [Select Id, Name, 	Responses__c from Account where Id='0015g0000126xt6AAA'];
       
        a.Responses__c = wr;
        update a;
    } */
    

}