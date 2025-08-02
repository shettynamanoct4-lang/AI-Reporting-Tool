public class CallWrpr {
    public static void res(){
        Account a = [Select Id, Name, Responses__c from Account where Id='0015g00000zOTcYAAW'];
        Env6.Wrapper wr = (Env6.Wrapper)JSON.deserialize(a.Responses__c, Env6.Wrapper.class);
        List<Env6.response> lst= new List<Env6.response>();
        lst = wr.response;
        for(Env6.Response e : lst){
            System.debug(e);
        }

    }

}