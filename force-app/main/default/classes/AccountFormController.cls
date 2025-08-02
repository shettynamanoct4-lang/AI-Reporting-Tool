public class AccountFormController {
    @AuraEnabled
    public static void saveAccount(String accountJson) {
        try {
            // Parse the JSON string to an Account object
            Account acc = (Account) JSON.deserialize(accountJson, Account.class);
            
            System.debug('Account: ' + acc);
            
            // Validate the number of employees
            if (acc.NumberOfEmployees < 100) {
                throw new EmployeeCountException('Number of employees must be 100 or more.');
            }
            
            // If no exception, proceed with saving the account
            insert acc;
            
            // Call asynchronous method to insert contact
            createContactAsync(acc.Id);
            
        } catch (EmployeeCountException e) {
            // Handle the custom exception (can log it or pass it back to the client/UI)
            throw new AuraHandledException(e.getMessage());
        } catch (Exception e) {
            // Catch other general exceptions
            throw new AuraHandledException('An error occurred while saving the account: ' + e.getMessage());
        }
    }

    @Future
    public static void createContactAsync(Id accountId) {
        Contact cn = new Contact();
        cn.LastName = 'Dummy Contact';
        cn.AccountId = accountId;  // Associate the Contact with the created Account
        insert cn;
    }
}