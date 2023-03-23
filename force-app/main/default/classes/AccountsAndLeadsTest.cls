/*  Author: Chase Johns
    Last Modified: 3/23/23
    Description: Test Class for the AccountsAndLeads Visualforce page and its Custom Controller
*/

@isTest
public class AccountsAndLeadsTest {
    
    @testSetup
    public static void simulateInitialPageLoad(){
        List<Account> testAccounts = AccountsAndLeadsDataFactory.generateAccounts(20);
        List<Lead> testLeads = AccountsAndLeadsDataFactory.generateLeads(20);
        insert testAccounts;
        insert testLeads;
    }
    
    //Simulating a user creating a new account
    @isTest
    public static void tp_createNewAccount(){
        List<Account> accHolder = AccountsAndLeadsDataFactory.generateAccounts(1);
        Account accountToAdd = accHolder[0];
        AccountsAndLeadsController testController = new AccountsAndLeadsController();
        Test.startTest();
        //Simulating a user navigating the page to make a new Account
        testController.createAccount();
        testController.desiredAccount = accountToAdd;
        testController.saveAccount();
        //Verifying if the final account in our list is actually the account that we just added to the database
        System.assertEquals(accountToAdd, testController.accs[testController.accs.size()-1]);
        System.assertEquals(true, testController.accountInfoDisplay);
        System.assertEquals(false, testController.accountCreateDisplay);
        Test.stopTest();
    }
    
    //Simulating a user creating a new lead
    @isTest
    public static void tp_createNewLead(){
        List<Lead> leadHolder = AccountsAndLeadsDataFactory.generateLeads(1);
        Lead leadToAdd = leadHolder[0];
        AccountsAndLeadsController testController = new AccountsAndLeadsController();
        Test.startTest();
        //Simulating a user navigating the page to make a new Lead
        testController.createLead();
        testController.desiredLead = leadToAdd;
        testController.saveLead();
        //Verifying if our final lead in our list is actually the lead we just added to the database
        System.assertEquals(leadToAdd, testController.leads[testController.leads.size()-1]);
        System.assertEquals(true, testController.leadInfoDisplay);
        System.assertEquals(false, testController.leadCreateDisplay);
        Test.stopTest();
    }
    
    //Simulating a user deciding not to create a new account
    @isTest
    public static void tp_userCancelsAccountCreate(){
        AccountsAndLeadsController testController = new AccountsAndLeadsController();
        Test.startTest();
        testController.createAccount();
        testController.cancelAccountSave();
        System.assertEquals(true, testController.accountInfoDisplay);
        System.assertEquals(false, testController.accountCreateDisplay);
        Test.stopTest();
    }
    
    //Simulating a user deciding not to create a new lead
    @isTest
    public static void tp_userCancelsLeadCreate(){
        AccountsAndLeadsController testController = new AccountsAndLeadsController();
        Test.startTest();
        testController.createLead();
        testController.cancelLeadSave();
        System.assertEquals(true, testController.leadInfoDisplay);
        System.assertEquals(false, testController.leadCreateDisplay);
        Test.stopTest();
    }
    
    //Simulating a user deleting an account
    @isTest
    public static void tp_deleteAccount(){
        AccountsAndLeadsController testController = new AccountsAndLeadsController();
        Account accToAssert = testController.accs[testController.accs.size()-1];
        String accName = testController.accs[testController.accs.size()-1].Name;
        Test.startTest();
        //Simulating the necessary page navigation
        testController.displayAccountDelete();
        //Selecting the last account in the list to delete for assertion purposes
        testController.accToDelete = accName;
        testController.deleteAccount();
        System.assertNotEquals(accToAssert, testController.accs[testController.accs.size()-1]);
        System.assertEquals(false,testController.deleteAccountDisplay);
        Test.stopTest();
    }
    
    //Simulating a user deleting a lead
    @isTest
    public static void tp_deleteLead(){
        AccountsAndLeadsController testController = new AccountsAndLeadsController();
        //Simulating the lead that should become the last lead in the list
        Lead leadToAssert = testController.leads[testController.leads.size()-1];
        String leadLastName = testController.leads[testController.leads.size()-1].LastName;
        Test.startTest();
        //Simulating the necessary page navigation
        testController.displayLeadDelete();
        //Selecting the last lead in the list to delete for assertion purposes
        testController.leadToDelete = leadLastName;
        testController.deleteLead();
        System.assertNotEquals(leadToAssert, testController.leads[testController.leads.size()-1]);
        System.assertEquals(false,testController.deleteLeadDisplay);
        Test.stopTest();
    }
    
    //Simulating a user canceling a delete for both sObjects
    @isTest
    public static void tp_deleteAccAndLeadCancel(){
        AccountsAndLeadsController testController = new AccountsAndLeadsController();
        Test.startTest();
        testController.displayLeadDelete();
        System.assertEquals(true, testController.deleteLeadDisplay);
        testController.cancelLeadDelete();
        System.assertEquals(false, testController.deleteLeadDisplay);
        testController.displayAccountDelete();
        System.assertEquals(true, testController.deleteAccountDisplay);
        testController.cancelAccountDelete();
        System.assertEquals(false, testController.deleteAccountDisplay);
        Test.stopTest();
    }

}