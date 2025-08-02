public class ErrorCallWrapper {
    public static void res(){
        Account a = [Select Id, Name, Responses__c from Account where Id='0015g0000127g2lAAA'];
        EnvError.Wrapper wr = (EnvError.Wrapper)JSON.deserialize(a.Responses__c, EnvError.Wrapper.class);
        System.debug(wr);
        List<EnvError.response> lst= new List<EnvError.response>();
        lst = wr.response;
        for(EnvError.Response e : lst){
            System.debug(e);
        }

    }

}