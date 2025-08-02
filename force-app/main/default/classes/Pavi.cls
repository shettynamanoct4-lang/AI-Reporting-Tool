public with sharing class Pavi {
   /* public static void test(List<Contact> c){
        Set<Id> accountIds = new Set<Id>();
        for(Contact con:c)
        {
            if(con.AccountId!=null){
                accountIds.add(con.accountId);
            }
            
        }
        Map<Id,Account> mapConAcc = new Map<Id,Account>();
        List<Account> acc = [select id, Type from Account where id In :accountIds ];  
        for(Account a : acc){
            mapConAcc.put(a.Id,a);
        }
        Map<Id,Integer> mc = new Map<Id,Integer>();
        List<AggregateResult> asr = [Select AccountId, Count(Id)cg from Contact 
                                     where AccountId IN:accountIds GROUP BY AccountId];
                                     
        for(AggregateResult f : asr){
            mc.put((Id)f.get('AccountId'), (Integer)f.get('cg'));
        }
        for(Contact b : c){
            String s = mapConAcc.get(b.AccountId).Type;   
            Decimal dc = mc.get(b.AccountId);
            if(mc.get(b.AccountId) == null){
                //String st = String.valueOf(mc.get(b.AccountId));
                b.Job_Name__c = s + 1;
                b.size__c = 1;
            } 
            else{
                Integer d = mc.get(b.AccountId)+1;
                String st = String.valueOf(d);
                b.Job_Name__c = s + st;
                b.size__c = d;
            }
            
        }       
    }
    /*
    public static void test1(List<Contact> ol){
        Set<Id> accountIds = new Set<Id>();
        for(Contact c : ol){
            accountIds.add(c.AccountId);
        }
        Map<Id, Integer> ya = new Map<Id, Integer>();
        List<Account> ak = [Select Id, Name, (Select Id , LastName from Contacts) from Account where Id IN:accountIds];
        for(Account x : ak){
            List<Contact> fg = x.Contacts;
            Integer r = fg.size();
            ya.put(x.Id,r);
        }
        List<Contact> cv = [Select Id, AccountId, size__c from Contact where AccountId IN : accountIds];
        List<Contact> h = new List<Contact>();
        for(Contact d : cv){
            Integer t = ya.get(d.AccountId) + 2;
            
            Contact vb = new Contact();
            vb.Id= d.Id;
            vb.size__c = t;
            h.add(vb);
        }
        update h;
        
    } */
   /* public static void test(List<Contact>co){
        Set<Id> actId = new Set<Id>();
        for(Contact f : co){
            actId.add(f.AccountId);
        }
        Map<Id, String> mp = new Map<Id, String>();
        List<Account> h = [Select Id, Name, Type from Account where Id in:  actId];
        for(Account j : h){
            mp.put(j.Id, j.Type);
        }
        //List<Contact> mi = new List<Contact>();
        List<Contact> m = co;
        for(Integer i =0; i<m.size(); i++){
            
            String s = mp.get(m[i].AccountId); 
            String st = String.valueOf(i+1);
            //Decimal dc = mc.get(b.AccountId);
            Decimal dc = i + 1;
            m[i].Job_Name__c = s + st;
            m[i].size__c = dc;
            
            
            
            //i = i+1;
        }
        
    } */
    public static void test(List<Contact>co){
        Set<Id> accountIds = new Set<Id>();
        for(Contact f : co){
            accountIds.add(f.AccountId);
        }
        List<Account> acc = [select id, Type from Account where id in :accountIds ];
        List<Contact> cont =[select id, Job_Name__c from Contact where accountId in:accountIds];
        Map<Id,Account> mp = new Map<Id,Account>();
        for(Account u : acc){
            mp.put(u.Id,u);
        }
        Map<Id,Contact> mapConAcc = new Map<Id,Contact>();
                for(Account a:acc)
                {
                    if(cont.size()>0){
                        Contact listcon =[select id, lastName,Job_Name__c,size__c from contact where 
                                          accountId=:a.id order By createdDate desc limit 1];
                        mapConAcc.put(a.id,listcon);
                    }
                }
                
                    for(Contact c: co){
                        
                        
                            if(cont.size()>0){
                                Contact lico = new Contact();
                                lico=mapConAcc.get(c.AccountId);
                                System.debug(lico);
                                Decimal size1 = lico.size__c+1;
                                c.size__c=size1;
                                String s = String.valueOf(c.size__c);
                                String a = String.valueOf(mp.get(c.AccountId).Type);
                                c.Job_Name__c=a+s;
                            }
                            else
                            {
                                Decimal size1 = 1;
                                c.size__c=size1;
                                String s = String.valueOf(c.size__c);
                                String a = String.valueOf(mp.get(c.AccountId).Type);
                                c.Job_Name__c=a+s;
                            }
                        
                    }
                }
            
}