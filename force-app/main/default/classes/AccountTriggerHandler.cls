public with sharing class AccountTriggerHandler {
    public static boolean alreadyExecuted= false;
    public static void beforeInsertHandler(List<Account>act){
        for(Account ac : act){
            if(String.isBlank(ac.Type)){
                ac.Type='Other';
            }
        }
    }
    public static void beforeInsertHandler2(List<Account>ac){
        Set<Id> AccOwn = new Set<Id>();
        for(Account a : ac){
            AccOwn.add(a.OwnerId);
        }
        List<Account> us = [Select Owner.Name, SalesRep__c from Account where OwnerId In:AccOwn];
        List<Account> actt = new List<Account>();
        for(Account aa : us){
            aa.SalesRep__c = aa.Owner.Name;
            actt.add(aa);
        }
        update actt;
    }
    
    public static void beforeUpdate(List<Account>act){
        for(Account ac : act){
            if(String.isBlank(ac.Type)){
                ac.Type='Other';
            }
        }
    }
    public static void beforeUpdate2(List<Account>act, Map<Id, Account>mp){
        Set<Id> actId = new Set<Id>();
        for(Account a: act){
            if(a.Status__c == 'Not Active' && a.Status__c != mp.get(a.id).Status__c){
                actId.add(a.Id);
            }
        }
        //Set<Id> acts = new Set<Id>();
        //Map<Id, AggregateResult> mo = new Map<Id, AggregateResult>([Select AccountId from Opportunity where AccountId 
        //IN:actId and StageName='Prospecting' group by AccountId]);
        Map<String,Opportunity> mo = new Map<String,Opportunity>();
        List<Opportunity> op = [Select AccountId from Opportunity where AccountId IN:actId and StageName='Prospecting'];
        for(Opportunity o : op){
               mo.put(o.AccountId,o);
        }
        //acts = mo.KeySet();
        for(Account ac : act){
            if(mo.containsKey(ac.Id)){
            //if(acts.contains(ac.Id)){
                ac.addError('You cant update this Account');
            }
//list<opportunity> lstOpp = [Select Id,AccountId,StageName From opportunity 
//                            Where AccountId IN :AccId AND StageName = 'Open'];
//For(Account Acc : trigger.New){
//If(!lstOpp.IsEmpty()){
//Acc.AddError('Error');
//}
//}
//}
        }
    }
    public static void beforeUpdate3(List<Account>na, Map<Id,Account>oa){
        //List<Account>ac = new List<Account>();
        for(Account a : na){
            if(a.Phone != oa.get(a.Id).Phone){
                a.Name = a.Name+a.Phone;
                //ac.add(a);
            }
        }
        //update ac;
    }
    
    public static void afterUpdate(List<Account>ac , Map<Id,Account>oldmp){
        List<Task> tsk = new List<Task>();
        for(Account a : ac){
            if(a.Type == 'Customer - Direct' && oldmp.get(a.Id).Type == 'Prospect'){
                Task t = new Task();
                t.Subject = 'Working Account';
                t.Priority = 'High';
                t.OwnerId = a.OwnerId;
                t.WhatId = a.Id;
                tsk.add(t);
            }
            
        }
        insert tsk;
    }
    
    
    
    public static void afterInsert(List<Account>act){
        List<Contact> con = new List<Contact>();
        for(Account ac : act){
            Contact cn = new Contact();
            cn.LastName= 'Cogni';
            cn.FirstName= 'Blr';
            cn.AccountId= ac.Id;
            con.add(cn);
        }
        insert con;
        if(AccountTriggerHandler.alreadyExecuted== false){
            AccountTriggerHandler.alreadyExecuted= true;
            
            Account acn = new Account(Name='Recursive', AccountNumber='10');
            insert acn;
            
        }
        
    }
    public static void afterInsert2(List<Account>ac ){
        Set<Id> accId = new Set<Id>();
        for(Account a : ac){
            if(a.NumOfLoc__c!=null){
                accId.add(a.Id);
            }
        }
        List<Account> al = [Select Id, NumOfLoc__c from Account where Id in:accId];
        for(Account aa : al){
            List<Contact> cn = new List<Contact>();
            for(Integer i=0; i<aa.NumOfLoc__c; i++){
                Contact c = new Contact();
                c.AccountId = aa.Id;
                c.LastName= 'con' + i;
                cn.add(c);
                
            }
            insert cn;
        }
        
    }
    
    public static void afterUpdate2(List<Account>act, Map<Id, Account>mp, Map<Id,Account>oop){
        Set<Id> actId = new Set<Id>();
        for(Account a : act ){
            if(a.Postal_Address__c != mp.get(a.Id).Postal_Address__c){
                actId.add(a.Id);
            }
        }
        List<Opportunity> updt = new List<Opportunity>();
        List<Opportunity> op = [Select Id, AccountId, Account.Postal_Address__c, City__c from Opportunity where AccountId IN:actId];
        for(Opportunity o : op){
            o.City__c = oop.get(o.AccountId).Postal_Address__c;
            //o.City__c = o.Account.Postal_Address__c;
            updt.add(o);
        }
        update updt;
    }
    /*
    public static void beforeDelete(List<Account>oldac){
        Set<Id> actId = new Set<Id>();
        for(Account a : oldAc){
            actId.add(a.Id);
        }
        List<Account> ac = [Select Id, (Select Id, lastName, firstName from Contacts) from Account where Id in: actId];
        Map<Id,Contact> ma= new Map<Id, Contact>();
        //Set<Id> ma = new Set<Id>();
        for(Account a : ac){
            List<Contact>cn = a.Contacts;
            if(cn.size()==2){
                ma.put(a.Id, a.Contacts);
                //ma.add(a.Id);
            }
        }
        for(Account at : oldAc){
            //if(ma.contains(at.Id))
            if(ma.containsKey(at.Id)){
                at.addError('You cant delete this accunt if u have 2 contacts');
            }
        }
    }
*/
    public static void beforeDelete(List<Account>oldac){
        Set<Id> actId = new Set<Id>();
        for(Account a : oldAc){
            actId.add(a.Id);
        }
        Map<Id,Contact> ma = new Map<Id,Contact>();
        //Set<Id> ma = new Set<Id>();
        List<AggregateResult> con = [Select AccountId from Contact where AccountId IN: actId 
                                     GROUP BY AccountId HAVING Count(Id)=2];
        for(AggregateResult ag : con){
            ma.put((String)ag.get('AccountId'),(Contact)ag.get('Contact'));
            //ma.add(ag.AccountId);
        }
        for(Account at : oldAc){
            //if(ma.contains(at.Id))
            if(ma.containsKey(at.Id)){
                at.addError('You cant delete this accunt if u have 2 contacts');
            }
        }
    }  
    
}