public with sharing class fbcLightningUtilities {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        return [SELECT Id, Name, Rating, AnnualRevenue, Industry, NumberOfEmployees, Phone, BillingCity, BillingState FROM Account];
    }

    @AuraEnabled(cacheable=true)
    public static List<Lead> getLeads(){
        return [SELECT Id, FirstName, LastName, Status, Company, Title, Industry, Rating, Phone, Email, Conversion_Date__c FROM Lead];
    }

}