/*  Author: Chase Johns
    Last Modified: 3/21/23
    Description: Controller for the AccountsAndLeads Visualforce page
*/

public with sharing class AccountsAndLeadsController {
    
    public List<Account> accs {get; set;}
    public List<Lead> leads {get; set;}
    
    public AccountsAndLeadsController() {
        accs = [SELECT Name, Rating, AnnualRevenue, Industry, Phone, BillingCity, BillingState, NumberOfEmployees FROM Account];
        leads = [SELECT FirstName, LastName, Company, Status, Title, Industry, Rating, Phone, Email FROM Lead];
    }

    public void createAccount(){

    }

    public void createLead(){

    }

    public void deleteAccount(){

    }

    public void deleteLead(){

    }

    public String getAccountPageURL(){
        return null;
    }

    public String getLeadPageURL(){
        return null;
    }

}