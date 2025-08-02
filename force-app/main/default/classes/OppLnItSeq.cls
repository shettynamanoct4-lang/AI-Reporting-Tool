public with sharing class OppLnItSeq {
    public static void testo(List<OpportunityLineItem> op){
        Set<Id> oppId = new Set<Id>();
        for(OpportunityLineItem o : op){
            oppId.add(o.OpportunityId);
        }
        Map<Id,String> ma = new Map<Id,String>();
        //List<OpportunityLineItem> upd = new List<OpportunityLineItem>();
        List<OpportunityLineItem> tr = [Select Id, OpportunityId, Serial_No__c from OpportunityLineItem where 
                                        OpportunityId IN: oppId];
        if(tr.size()>0){
            for(OpportunityLineItem c : tr){
                if(c.Serial_No__c !=null){
                    String lastWrd = c.Serial_No__c.right(1);
                    Integer i = Integer.valueOf(lastWrd);
                    i++;
                    c.Serial_No__c = c.Serial_No__c + ',' + (i);
                    //upd.add(c);
                    ma.put(c.OpportunityId,c.Serial_No__c);
                }
                else{
                    c.Serial_No__c = '1';
                    //upd.add(c);
                    
                }
            }
            
        }
        //update upd;
        for(OpportunityLineItem oo : op){
            if(ma.containsKey(oo.OpportunityId)){
                oo.Serial_No__c= ma.get(oo.OpportunityId);
            }
            else{
                oo.Serial_No__c='1';
            }
        }
    }

}