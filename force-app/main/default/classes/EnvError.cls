public class EnvError {
    public class Wrapper{
        public Integer statusCode;	//500
	    public boolean success;
	    public List<Response> response;
    }
    public class Response {
        public String message;
 
    }

}