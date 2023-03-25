@isTest
private class UseCaseC30ControllerTest {
    @isTest
    static void testFetchCustomerContacts() {
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName='John',
            LastName='Doe',
            AccountId=testAccount.Id,
            Phone='1234567890',
            Email='john.doe@example.com'
        );
        insert testContact;

        UseCaseC30Controller controller = new UseCaseC30Controller();

        controller.fetchCustomerContacts();
        System.assertEquals(1, controller.customerContacts.size());
    }

    @isTest
    static void testSaveNewCustomerContact() {
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        UseCaseC30Controller controller = new UseCaseC30Controller();

        controller.newCustomerContact.FirstName = 'Jane';
        controller.newCustomerContact.LastName = 'Doe';
        controller.newCustomerContact.AccountId = testAccount.Id;
        controller.newCustomerContact.Phone = '0987654321';
        controller.newCustomerContact.Email = 'jane.doe@example.com';

        controller.saveNewCustomerContact();

        List<Contact> savedContacts = [
            SELECT Id, FirstName, LastName, Phone, Email
            FROM Contact
            WHERE Email = 'jane.doe@example.com'];
            System.assertEquals(1, savedContacts.size());
            Contact savedContact = savedContacts[0];
            System.assertEquals('Jane', savedContact.FirstName);
            System.assertEquals('Doe', savedContact.LastName);
            System.assertEquals('0987654321', savedContact.Phone);
            System.assertEquals('jane.doe@example.com', savedContact.Email);
        }
    @isTest
    static void testDeleteContact() {
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            FirstName='John',
            LastName='Doe',
            AccountId=testAccount.Id,
            Phone='1234567890',
            Email='john.doe@example.com'
        );
        insert testContact;
        
        UseCaseC30Controller controller = new UseCaseC30Controller();
        
        controller.contactToDeleteId = testContact.Id;
        controller.deleteContact();
        
        List<Contact> deletedContacts = [SELECT Id FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(0, deletedContacts.size());
        
        Boolean exceptionThrown = false;
        try {
            Contact deletedContact = [SELECT Id FROM Contact WHERE Id = :testContact.Id];
        } catch (System.QueryException e) {
            exceptionThrown = true;
        }
        System.assert(exceptionThrown, 'Expected a System.QueryException to be thrown');
    }

}