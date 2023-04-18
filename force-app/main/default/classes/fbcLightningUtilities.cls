public with sharing class fbcLightningUtilities {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String searchTerm){
        if(searchTerm == '' || searchTerm == null){
            return [
                SELECT Id, Name, Rating, AnnualRevenue, Industry, NumberOfEmployees, Phone, BillingCity, BillingState 
                FROM Account
            ];
        }else{
            searchTerm = searchTerm.toLowerCase() + '%';
            return [
                SELECT Id, Name, Rating, AnnualRevenue, Industry, NumberOfEmployees, Phone, BillingCity, BillingState 
                FROM Account
                WHERE Name LIKE :searchTerm
            ];
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Lead> getLeads(String searchTerm){
        if(searchTerm == '' || searchTerm == null){
            return[
                SELECT Id, FirstName, LastName, Status, Company, Title, Industry, Rating, Phone, Email, Conversion_Date__c
                FROM Lead
            ];
        }
        else{
            searchTerm = searchTerm.toLowerCase() + '%';
            return[
                SELECT Id, FirstName, LastName, Status, Company, Title, Industry, Rating, Phone, Email, Conversion_Date__c
                FROM Lead
                WHERE Company LIKE :searchTerm
            ];
        }
    }

}