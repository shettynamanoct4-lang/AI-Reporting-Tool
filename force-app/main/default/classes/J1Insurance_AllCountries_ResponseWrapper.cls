public class J1Insurance_AllCountries_ResponseWrapper {
    public Integer statusCode;	    
    public boolean success;
    public List<response> response;
    
    
    public class response{
        public Integer CountryId;	    
        public String Country;	    
        public String FIPS104;	    
        public String ISO2;	    
        public String ISO3;	    
        public String ISON;	    
        public String Internet;	    
        public String Capital;	    
        public String MapReference;	    
        public String NationalitySingular;	    
        public String NationalityPlural;	    
        public String Currrency;	    
        public String CurrencyCode;	    
        public Integer Population;	    
        public String Title;	   
        public String Comment;
    }

}