@isTest
public class UseCaseC23Test {
    @isTest
    static void testEmailDomainValidation() {
        // Create a test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create a contact with a valid email address
        Contact validContact = new Contact(
            LastName = 'Doe',
            AccountId = testAccount.Id,
            Email = 'john.doe@testdomain.com'
        );
        insert validContact;

        // Test inserting a new contact with the same email domain
        Contact newContactValid = new Contact(
            LastName = 'Smith',
            AccountId = testAccount.Id,
            Email = 'jane.smith@testdomain.com'
        );
        Test.startTest();
        insert newContactValid;
        Test.stopTest();

        // Check if the new contact was inserted successfully
        Contact insertedContact = [SELECT Id, Email FROM Contact WHERE Id = :newContactValid.Id];
        System.assertEquals('jane.smith@testdomain.com', insertedContact.Email);

        // Test inserting a new contact with a different email domain
        Contact newContactInvalid = new Contact(
            LastName = 'Brown',
            AccountId = testAccount.Id,
            Email = 'jane.brown@otherdomain.com'
        );
        try {
            Test.startTest();
            insert newContactInvalid;
            Test.stopTest();
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('All email addresses must resemble the existing collection Contact domains for said Account!'), 'Invalid email domain should throw an error.');
        }
    }
}