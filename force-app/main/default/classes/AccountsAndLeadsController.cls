/*  Author: Chase Johns
    Last Modified: 3/24/23
    Description: Controller for the AccountsAndLeads Visualforce page
*/

public with sharing class AccountsAndLeadsController {
    
    public List<Account> accs {get; set;}
    private Map<String,Account> accMap {get; set;}
    public List<Lead> leads {get; set;}
    private Map<String,Lead> leadMap {get; set;}
    public List<SelectOption> deleteOptions {get; set;}
    public String accToDelete {get; set;}
    public String leadToDelete {get; set;}
    
    public Boolean accountInfoDisplay{get; set;}
    public Boolean accountCreateDisplay{get; set;}
    public Boolean leadInfoDisplay{get; set;}
    public Boolean leadCreateDisplay{get; set;}

    public Account desiredAccount {get; set;}
    public Lead desiredLead {get; set;}

    public Boolean deleteAccountDisplay {get; set;}
    public Boolean deleteLeadDisplay {get; set;}

    public List<Account> displayedAccs {get; set;}
    public List<Lead> displayedLeads {get; set;}

    public String accSearchTerm {get; set;}
    public String leadSearchTerm {get; set;}
    
    public AccountsAndLeadsController() {
        accs = [SELECT Name, Rating, AnnualRevenue, Industry, Phone, BillingCity, BillingState, NumberOfEmployees FROM Account];
        leads = [SELECT FirstName, LastName, Company, Status, Title, Industry, Rating, Phone, Email,Conversion_Date__c FROM Lead];
        accMap = new Map<String,Account>();
        leadMap = new Map<String,Lead>();
        desiredAccount = new Account();
        desiredLead = new Lead();
        accountInfoDisplay = true;
        accountCreateDisplay = false;
        leadInfoDisplay = true;
        leadCreateDisplay = false;
        deleteAccountDisplay = false;
        deleteLeadDisplay = false;
        deleteOptions = new List<SelectOption>();
        accToDelete = '';
        leadToDelete = '';
        for(Account a : accs){
            accMap.put(a.Name, a);
        }
        for(Lead l : leads){
            leadMap.put(l.LastName, l);
        }
        displayedAccs = accs.deepClone();
        displayedLeads = leads.deepClone();
        accSearchTerm = '';
        leadSearchTerm = '';
    }

    public void createAccount(){
        toggleAccountDisplay();
        desiredAccount = new Account();
    }

    public void createLead(){
        toggleLeadDisplay();
        desiredLead = new Lead();
    }

    public void saveAccount(){
        try{
            insert desiredAccount;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Account Successfully Saved'));
            accs.add(desiredAccount);
            accMap.put(desiredAccount.Name, desiredAccount);
            displayedAccs.add(desiredAccount);
            toggleAccountDisplay();
        }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account Not Saved; Something Went Horribly Wrong: '+ e.getMessage()));
        }
    }

    public void saveLead(){
        try{
            insert desiredLead;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Lead Successfully Saved'));
            leads.add(desiredLead);
            leadMap.put(desiredLead.LastName,desiredLead);
            displayedLeads.add(desiredLead);
            toggleLeadDisplay();
        }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Lead Not Saved; Something Went Horribly Wrong: ' + e.getMessage()));
        }
    }

    public void cancelAccountSave(){
        toggleAccountDisplay();
    }

    public void cancelLeadSave(){
        toggleLeadDisplay();
    }

    public void deleteAccount(){
        
        try{
            desiredAccount= accMap.get(accToDelete);
            delete desiredAccount;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Account Successfully Deleted'));
            accs.remove(accs.indexOf(desiredAccount));
            accMap.remove(accToDelete);
            displayedAccs.remove(displayedAccs.indexOf(desiredAccount));
            toggleAccountDeleteDisplay();
        }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account Not Deleted; Something Went Horribly Wrong: ' + e.getMessage()));
        }
    }

    public void deleteLead(){
        try{
            desiredLead = leadMap.get(leadToDelete);
            delete desiredLead;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Lead Successfully Deleted'));
            leads.remove(leads.indexOf(desiredLead));
            leadMap.remove(leadToDelete);
            displayedLeads.remove(displayedLeads.indexOf(desiredLead));
            toggleLeadDeleteDisplay();
        }
        catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Lead Not Deleted; Something Went Horribly Wrong: ' + e.getMessage()));
        }
    }

    private void toggleAccountDisplay(){
        accountInfoDisplay = !accountInfoDisplay;
        accountCreateDisplay = !accountCreateDisplay;
    }

    private void toggleLeadDisplay(){
        leadInfoDisplay = !leadInfoDisplay;
        leadCreateDisplay = !leadCreateDisplay;
    }

    public void displayAccountDelete(){
        for(Account acc: accs){
            deleteOptions.add(new SelectOption(acc.Name,acc.Name));
        }
        toggleAccountDeleteDisplay();
    }

    public void cancelAccountDelete(){
        accToDelete = '';
        deleteOptions.clear();
        toggleAccountDeleteDisplay();
    }

    public void cancelLeadDelete(){
        leadToDelete = '';
        deleteOptions.clear();
        toggleLeadDeleteDisplay();
    }

    public void displayLeadDelete(){
        for(Lead l : leads){
            String displayName = l.FirstName + ' ' +l.LastName;
            deleteOptions.add(new SelectOption(l.LastName,displayName));
        }
        toggleLeadDeleteDisplay();
    }

    private void toggleAccountDeleteDisplay(){
        deleteAccountDisplay = !deleteAccountDisplay;
    }

    private void toggleLeadDeleteDisplay(){
        deleteLeadDisplay = !deleteLeadDisplay;
    }

    public void executeAccSearch(){
        displayedAccs.clear();
        accSearchTerm = accSearchTerm.toLowerCase();
        for(Account acc : accs){
            String accName = acc.Name.toLowerCase();
            if(accName.contains(accSearchTerm)){
                displayedAccs.add(acc);
            }
        }
        if(displayedAccs.size() == 0){
            for(Account acc : accs){
                displayedAccs.add(acc);
            }
        }
    }

    public void executeLeadSearch(){
        displayedLeads.clear();
        leadSearchTerm = leadSearchTerm.toLowerCase();
        for(lead l : leads){
            String leadCompany = l.Company.toLowerCase();
            if(leadCompany.contains(leadSearchTerm)){
                displayedLeads.add(l);
            }
        }
        if(displayedLeads.size() == 0){
            for(lead l : leads){
                displayedLeads.add(l);
            }
        }
    }

    public void clearAccSearch(){
        displayedAccs.clear();
        accSearchTerm = '';
        for(Account acc: accs){
            displayedAccs.add(acc);
        }
    }

    public void clearLeadSearch(){
        displayedLeads.clear();
        leadSearchTerm = '';
        for(lead l : leads){
            displayedLeads.add(l);
        }
    }

}