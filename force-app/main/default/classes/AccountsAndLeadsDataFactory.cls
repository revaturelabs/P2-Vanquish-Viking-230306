/*  Author: Chase Johns
    Last Modified: 3/23/23
    Description: Data Factory for the AccountsAndLeadsTest Class
*/

@isTest
public class AccountsAndLeadsDataFactory {
    
    public static List<Account> generateAccounts(Integer numOfAccs){
        List<Account> gennedAccs = new List<Account>();
        for(Integer i = 0; i < numOfAccs; i++){
            Account accToGen = new Account(Rating = 'Cold',AnnualRevenue=404404,Industry='Electronics',NumberOfEmployees=404,Phone='888-888-8888',BillingCity='Detroit',BillingState='MI');
            accToGen.Name = 'Test Acc Name ' + i;
            gennedAccs.add(accToGen);
        }
        return gennedAccs;
    }

    public static List<Lead> generateLeads(Integer numOfLeads){
        List<Lead> gennedLeads = new List<Lead>();
        for(Integer i = 0; i < numOfLeads; i++){
            Lead leadToGen = new Lead(Status='Open - Not Contacted',Company='Sintracorp',Title='Drone',Industry='Finance',Rating='Cold',Phone='222-666-7890');
            leadToGen.FirstName = 'GivenNameNumber' + i;
            leadToGen.LastName = 'SurnameNumber' + i;
            leadToGen.Email = 'drone' + i + '@sintra.net';
            gennedLeads.add(leadToGen);
        }
        return gennedLeads;
    }

}