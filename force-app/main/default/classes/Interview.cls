//Helper class for the logic of the trigger
public with sharing class Interview {
    public static void testo(List<OpportunityLineItem> oPrdt){
        Set<Id> opId = new Set<Id>();
        for(OpportunityLineItem op: oPrdt){
            opId.add(op.OpportunityId);
        }
       List<Opportunity> oppUpdate= new List<Opportunity>();
        for(Opportunity opp: [Select id, Name, List_of_Products__c,(Select Id, Name from OpportunityLineItems) from Opportunity 
                              where Id IN:opId]) {
        Opportunity oppObj = new Opportunity();
        oppObj.Id = opp.Id;
        String[] productNames = new String[0];
        for(OpportunityLineItem item: opp.OpportunityLineItems) {
            productNames.add(item.Name);
        }
        oppObj.List_of_Products__c = String.join(productNames,',');
        oppObj.Name = opp.Name;
        oppUpdate.add(oppObj);
    }
    Update oppUpdate;
} 
   /*     List<Opportunity> updAc = new List<Opportunity>();
        Map<Id,Opportunity> opMap = new Map<Id,Opportunity>();
        List<Opportunity> opp = [Select Id,List_of_Products__c from Opportunity where Id IN: opId];
        for(Opportunity c : opp){
            opMap.put(c.Id, c);
        }
        Map<Id,String> nm = new Map<Id,String>();
        List<String> oNm = new List<String>();
        for(OpportunityLineItem oo: oPrdt){
            oNm.add(oo.Name);
            
        }
        String s = String.join(oNm, '/');
            
        
      for(OpportunityLineItem oo: oPrdt){
            Opportunity na = opMap.get(oo.OpportunityId);
            if(na!=null){
                
                na.List_of_Products__c = s;
                updAc.add(na);
            }
        }
        if(updAc!=null){
            update updAc;
        }
    } */
  /*      for(Integer i=0;i<oPrdt.size();i++){
           Opportunity na = opMap.get(oPrdt[i].OpportunityId);
           //String b += oPrdt[i].Name;
           na.List_of_Products__c = b;
        } */
  /*  
    public static void testo1(List<OpportunityLineItem> oPrdt, Map<Id,OpportunityLineItem>oldy){
        Set<Id> opId = new Set<Id>();
        for(OpportunityLineItem op: oPrdt){
            if(op.Name!=oldy.get(op.Id).Name){
                opId.add(op.OpportunityId);
            }
            
        }
        List<Opportunity> updAc = new List<Opportunity>();
        Map<Id,Opportunity> opMap = new Map<Id,Opportunity>();
        List<Opportunity> opp = [Select Id,List_of_Products__c from Opportunity where Id IN: opId];
        for(Opportunity c : opp){
            opMap.put(c.Id, c);
        }
        for(OpportunityLineItem oo: oPrdt){
            Opportunity na = opMap.get(oo.OpportunityId);
            if(na!=null){
                na.List_of_Products__c = oo.Name;
                updAc.add(na);
            }
        }
        if(updAc!=null){
            update updAc;
        }
    }
    public static void testo2(List<OpportunityLineItem> oPrdt){
        Set<Id> opId = new Set<Id>();
        for(OpportunityLineItem op: oPrdt){
            opId.add(op.OpportunityId);
        }
        List<Opportunity> updAc = new List<Opportunity>();
        Map<Id,Opportunity> opMap = new Map<Id,Opportunity>();
        List<Opportunity> opp = [Select Id,List_of_Products__c from Opportunity where Id IN: opId];
        for(Opportunity c : opp){
            opMap.put(c.Id, c);
        }
        for(OpportunityLineItem oo: oPrdt){
            Opportunity na = opMap.get(oo.OpportunityId);
            if(na!=null){
                na.List_of_Products__c = oo.Name;
                updAc.add(na);
            }
        }
        if(updAc!=null){
            update updAc;
        }
    } */

}