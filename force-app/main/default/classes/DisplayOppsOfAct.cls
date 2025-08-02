public with sharing class DisplayOppsOfAct {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOppList(Id lwcActRecId){
        system.debug('Act Id :'+lwcActRecId);
        
        List<Opportunity> oppList = [Select id,Name,Amount,AccountId,CloseDate From Opportunity Where AccountId =: lwcActRecId ];
        //Null check
        if(!oppList.isEmpty()){
            return oppList;
        }
        return null;
        
        
    }
    
}