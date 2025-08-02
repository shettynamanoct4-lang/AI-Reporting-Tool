public with sharing class FrnPv {
    public static void test(List<Contact> cd){
        
            
                
                Set<Id> accountIds = new Set<Id>();
                for(Contact con:cd)
                {
                    accountIds.add(con.accountId);
                }
                List<Account> acc = [select id, Type from Account where id in :accountIds ];
                List<Contact> cont =[select id, Job_Name__c from Contact where accountId in:accountIds];
                //Integer size = cont.size();
                Map<Id,Contact> mapConAcc = new Map<Id,Contact>();
                for(Account a:acc)
                {
                    if(cont.size()>0){
                        Contact listcon =[select id, lastName,Job_Name__c,size__c from contact where 
                                          accountId=:a.id order By createdDate desc limit 1];
                        mapConAcc.put(a.id,listcon);
                    }
                }
                For(Account a1:acc)
                {
                    for(Contact c: cd){
                        if(a1.id==c.accountId)
                        {
                            if(cont.size()>0){
                                Contact lico = new Contact();
                                lico=mapConAcc.get(a1.id);
                                System.debug(lico);
                                Decimal size1 = lico.size__c+1;
                                c.size__c=size1;
                                String s = String.valueOf(c.size__c);
                                c.Job_Name__c=a1.Type+s;
                            }
                            else
                            {
                                Decimal size1 = 1;
                                c.size__c=size1;
                                String s = String.valueOf(c.size__c);
                                c.Job_Name__c=a1.Type+s;
                            }
                        }
                    }
                }
            }
        
        
        
        
    }