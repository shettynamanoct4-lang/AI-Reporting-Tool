public with sharing class wrapperTable {
    public wrapperTable() {
        
    }
    @AuraEnabled(cacheable=true)
    public static String getAccounts(){
        Integer rowIndex = 0;
        List<accountWrap> accWrapList = new List<accountWrap>();
        try {
            List<Account> accList = [SELECT Id, Name, Phone FROM Account Order By CreatedDate Desc limit 10];
            if(!accList.isEmpty()){
                for(Account a : accList){
                    accWrapList.add(new accountWrap(a.Id,a.Name,a.Phone,rowIndex));
                    rowIndex++;
                } 
            }
            
            return JSON.serialize(accWrapList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled()
    public static void changeRating(String accRecords){
        List<Account> act = new List<Account>();
        try{
            List<accountWrap> accLst = (List<accountWrap>)JSON.deserialize(accRecords, List<accountWrap>.class);
        
        for(accountWrap ac : accLst){
            if(ac.isSelected == true){
                Account aaa = new Account();
                aaa.Id = ac.Id;
                aaa.Rating ='Hot';
                act.add(aaa);
                System.debug(aaa);
            }

        }
            if(act.size()>0){
                update act;
            }
        
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    public class accountWrap{
        public String Id;
        public String AccountName;
        public String Phone;
        public Boolean isSelected;
        public Integer index;
        public accountWrap(String Id, String AccountName, String Phone, Integer index){
            this.Id = Id;
            this.AccountName = AccountName;
            this.Phone = Phone;
            this.isSelected = false;
            this.index = index;
        }
        
    }
}