public with sharing class UseCaseC30Controller {
    public List<Contact> customerContacts {get;set;}
    public Contact newCustomerContact {get;set;}
    public String contactToDeleteId {get;set;}
    
    public UseCaseC30Controller() {
        fetchCustomerContacts();
        newCustomerContact = new Contact();
    }
    
    public void fetchCustomerContacts() {
        customerContacts = [SELECT Id, AccountId, FirstName, LastName, Phone, Email, Department, DoNotCall, Service_Technician__c FROM Contact];
    }
    
    public PageReference saveNewCustomerContact() {
        insert newCustomerContact;
        newCustomerContact = new Contact();
        fetchCustomerContacts();
        return null;
    }
    
    public PageReference deleteContact() {
        Contact contactToDelete = [SELECT Id FROM Contact WHERE Id = :contactToDeleteId];
        delete contactToDelete;
        fetchCustomerContacts();
        return null;
    }
}