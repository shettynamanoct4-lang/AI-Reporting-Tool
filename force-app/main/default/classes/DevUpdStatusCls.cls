public with sharing class DevUpdStatusCls {
    public static Map<Id, Developer__c> WorkNumberDevMap = new Map<Id, Developer__c>();
    public static Map<Id, Developer__c> WorkNumberProjectWithDevMap = new Map<Id, Developer__c>();

    public static void testa(Map<Id, Developer__c> newdevelopers, Map<Id, Developer__c> olddevelopers) {
        System.debug('Hi');
        
        Set<Id> devIds = new Set<Id>();
        try {
            for (Developer__c dev : newdevelopers.values()) {
                if (dev.Work_Done__c != null && (dev.Work_Done__c != olddevelopers.get(dev.Id).Work_Done__c)) {
                    devIds.add(dev.Id);
                    WorkNumberDevMap.put(dev.Id, dev);
                    System.debug('Map of dev: ' + WorkNumberDevMap);
                }
            }

            Set<Id> projIds = new Set<Id>();
            List<Ticket__c> tickets = [SELECT Id, Proejct__c, Developer__c FROM Ticket__c WHERE Developer__c IN :WorkNumberDevMap.keySet()];
            for (Ticket__c tick : tickets) {
                if (tick.Proejct__c != null) {
                    projIds.add(tick.Proejct__c);
                    WorkNumberProjectWithDevMap.put(tick.Proejct__c, WorkNumberDevMap.get(tick.Developer__c));
                }
            }

            List<Status__c> updated = new List<Status__c>();
            List<Status__c> statuses = [SELECT Id, Proejct__c, Number_From_Dev__c FROM Status__c WHERE Proejct__c IN :WorkNumberProjectWithDevMap.keySet()];
            for (Status__c st : statuses) {
                st.Number_From_Dev__c = WorkNumberProjectWithDevMap.get(st.Proejct__c).Work_Done__c;
                updated.add(st);
            }

            if (updated.size() > 0) {
                try {
                    update updated;
                } catch (DmlException e) {
                    System.debug('Error during update: ' + e.getMessage());
                    // Optionally log to a custom object or notify admin
                    // CustomErrorLog__c log = new CustomErrorLog__c(Error_Message__c = e.getMessage());
                    // insert log;
                }
            }
        } catch (NullPointerException npe) {
            System.debug('NullPointerException caught: ' + npe.getMessage());
            // Handle the null pointer exception gracefully here
            // Optionally log to a custom object or notify admin
        } catch (Exception e) {
            System.debug('General Exception caught: ' + e.getMessage());
            // Handle any other exceptions gracefully here
        }
    }
}