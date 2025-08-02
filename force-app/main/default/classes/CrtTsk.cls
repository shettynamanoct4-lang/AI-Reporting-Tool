public with sharing class CrtTsk {
    public static void testo(Map<Id,Account> oldy , List<Account> newy){
        List<Task> tt = new List<Task>();
        for(Account c : newy){
            if((c.Industry!=null) && (oldy.get(c.Id).Industry == 'Banking' && c.Industry == 'Education')){
                
                Task t = new Task();
                t.OwnerId = c.OwnerId;
                t.WhatId = c.Id;
                t.Subject = 'Created Task';
                tt.add(t);
            }
            
        }
        insert tt;
    }

}