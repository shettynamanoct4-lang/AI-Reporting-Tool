public with sharing class ContactTriggerHandler {
    public static void afterInsertHandler(List<Contact> newContacts){
        Set<Id> actId = new Set<Id>();
            for(Contact con : newContacts){
                if(!String.isBlank(con.AccountId)){
                    actId.add(con.AccountId);
                }
                AcountContactService.updateActiveContacts(actId);
            }
    }
    public static void accConNot2(List<Contact> co){
        Set<Id> actId = new Set<Id>();
        for(Contact c : co){
            if(c.AccountId != null){
                actId.add(c.AccountId);
            }
        }
        Map<Id,List<Contact>> ma = new Map<Id,List<Contact>>();
        List<AggregateResult> mtc = [Select AccountId from Contact where AccountId IN:actId Group By AccountId Having Count(Id) > 2];
        for(AggregateResult a : mtc){
            ma.put((String)a.get('AccountId'),(List<Contact>)a.get('List<Contact>'));
        }
        for(Contact cn : co){
            if(ma.containsKey(cn.AccountId)){
                cn.AccountId.addError('You cant have more than 2 Contact in Account');
            }
        }
        
    }
    /*public static void accConNot2(List<Contact> ctc){
        Set<Id> accId = new Set<Id>();
        for(Contact rec : ctc){
            if(!String.isBlank(rec.AccountId)){
            accId.add(rec.AccountId);
        }
        }
        accId.remove(null);
        Set<Id> moreThan2Con = new Set<Id>();
        Map<Id, AggregateResult> ma = new Map<Id, AggregateResult>([Select AccountId from Contact where AccountId=:accId GROUP BY AccountId HAVING COUNT(Id)>2]);
        moreThan2Con = ma.keySet();
        for(Contact ca : ctc){
            if(moreThan2Con.contains(ca.AccountId)){
                ca.AccountId.addError('You can\'t have more than 2 contact per account');
            }
        }
        
    }
    */
    
    public static void afterUpdateHandler(List<Contact> newContacts, Map<Id,Contact> oldContactsMap){
        Set<Id> actId = new Set<Id>();
            for(Contact con : newContacts){
                if(!String.isBlank(con.AccountId) && oldContactsMap.get(con.Id).Active__c!=con.Active__c){  
                    actId.add(con.AccountId);
                }
                if(oldContactsMap.get(con.Id).AccountId!=con.AccountId){
                    actId.add(con.AccountId);
                    actId.add(oldContactsMap.get(con.Id).AccountId);
                }
                AcountContactService.updateActiveContacts(actId);
            }
    }
    //logic to prevent user to insert primary contact if there's any existing primary contact under Account
    public static void beforeInsertHandler(List<Contact> newCon){
        
        ////to add those accounId to this set where the contact is primary and the contact has an Account associated
        Set<Id> accIdSet = new Set<Id>();
        
        //map to hold existing primary contact where it holds AccountId as key and Contact as value
        Map<Id,Contact> accIdNewMap= new Map<Id,Contact>();
        
        for(Contact cn : newCon){
            if(cn.isPrimary__c==true && cn.AccountId!=null){
                accIdSet.add(cn.AccountId);
            }
        }
        if(accIdSet!=null && accIdSet.size()>0){
            //Preparation of Map accIdNewMap for existing primary contact
            for(Contact con : [Select Id, AccountId, isPrimary__c from Contact where AccountId in:accIdSet and isPrimary__c=true ]){
                accIdNewMap.put(con.AccountId, con);
            }
            //validation starts
            for(Contact cnn : newCon){
                if(cnn.isPrimary__c==true && cnn.AccountId!=null && accIdNewMap.get(cnn.AccountId)!=null ){
                    cnn.addError('You can\'t create more than one primary contact' );
                }
            }
        }
    }
    public static void beforeUpdateHandler(Map<Id,Contact> newMapCon, Map<Id,Contact> oldMapCon){
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Contact> accIdNewMap= new Map<Id,Contact>();
        for(Contact cn : newMapCon.values()){
            if(newMapCon.get(cn.Id).isPrimary__c!=oldMapCon.get(cn.Id).isPrimary__c && newMapCon.get(cn.Id).isPrimary__c  ==true 
               && newMapCon.get(cn.Id).AccountId!=null){
                   accIdSet.add(newMapCon.get(cn.Id).AccountId);
               }
        }
        if(accIdSet!=null && accIdSet.size()>0){
            //Preparation of Map accIdNewMap for existing primary contact
            for(Contact con : [Select Id, AccountId, isPrimary__c from Contact where AccountId in:accIdSet and isPrimary__c=true ]){
                accIdNewMap.put(con.AccountId, con);
            }
            for(Contact con : newMapCon.values()){
                if(newMapCon.get(con.Id).isPrimary__c!=oldMapCon.get(con.Id).isPrimary__c && 
               accIdNewMap.get(newMapCon.get(con.Id).AccountId)!=null  && newMapCon.get(con.Id).isPrimary__c  ==true 
               && newMapCon.get(con.Id).AccountId!=null){
                   con.addError('You can\'t create more than one primary contact' );
               }
            }
            
        }
    }

}