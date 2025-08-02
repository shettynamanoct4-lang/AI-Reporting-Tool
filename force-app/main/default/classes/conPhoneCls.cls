// conPhoneCls.cls
public class conPhoneCls {
    public static void updateAccountPhone(Map<Id, Contact> newContactsMap, Map<Id, Contact> oldContactMap) {
        Set<Id> accountIdsToUpdate = new Set<Id>();
        
        // Identify the account IDs associated with the updated contacts
        for (Contact con : newContactsMap.values()) {
            Contact oldCon = oldContactMap.get(con.Id);
            if (oldCon != null && con.Phone != oldCon.Phone && con.AccountId != null) {
                accountIdsToUpdate.add(con.AccountId);
            }
        }
        
        // Query the related accounts and update their phone numbers
        if (!accountIdsToUpdate.isEmpty()) {
            List<Account> accountsToUpdate = [SELECT Id, Phone FROM Account WHERE Id IN :accountIdsToUpdate];
            for (Account acc : accountsToUpdate) {
                // Get the corresponding contact for the account
                for (Contact con : newContactsMap.values()) {
                    if (con.AccountId == acc.Id) {
                        acc.Phone = con.Phone; // Update account's phone number
                        break; // Break after updating to the first contact
                    }
                }
            }
            update accountsToUpdate;
        }
    }
    
    
}