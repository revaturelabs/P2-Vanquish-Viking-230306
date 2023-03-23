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
    /*
    public static Account generateUniqueAccount(){
        List<Integer> uniqueAccNums = new List<Integer>();
        for(Integer i = 0; i < 9; i++){
            i = (Integer)Math.random()*10;
            uniqueAccNums.add(i);
        }
        Account uniqueAcc = new Account(Rating='Hot',Industry='Agricultue',BillingCity='Austin',BillingState='TX');
        uniqueAcc.Name = 'UniqueAcc ' + uniqueAccNums[0] + uniqueAccNums[1];
        String phoneString = '(';
        for(Integer i = 0; i < 9; i++){
            phoneString += uniqueAccNums[i];
            //First 3 digits have been added
            if(i == 2){
                phoneString += ')';
            }
            //Second 3 digits have been added
            if(i == 5){
                phoneString += '-';
            }
        }
        uniqueAcc.NumberOfEmployees = uniqueAccNums[8] + uniqueAccNums[6] + uniqueAccNums [4] + uniqueAccNums[2] *10;
        uniqueAcc.AnnualRevenue = uniqueAccNums[3] + uniqueAccNums[5] + uniqueAccNums[7] + uniqueAccNums[1] * 1000;
        return uniqueAcc;
    }
    */
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
    /*
    public static Lead generateUniqueLead(){
        List<Integer> uniqueLeadNums = new List<Integer>();
        for(Integer i = 0; i < 9; i++){
            i = (Integer)Math.random()*10;
            uniqueLeadNums.add(i);
        }
        Lead uniqueLead = new Lead(Rating='Warm',Industry='Construction',Title='Associate',Status='Working - Contacted',Company='Sintracorp');
        uniqueLead.FirstName = 'JaneNumber' + uniqueLeadNums[4];
        uniqueLead.LastName = 'DoeNumber' + uniqueLeadNums[0] + uniqueLeadNums [3] + uniqueLeadNums [7];
        String phoneString = '(';
        for(Integer i = 0; i < 9; i++){
            phoneString += uniqueLeadNums[i];
            //First 3 digits have been added
            if(i == 2){
                phoneString += ')';
            }
            //Second 3 digits have been added
            if(i == 5){
                phoneString += '-';
            }
        }
        uniqueLead.Email = 'associate' + uniqueLeadNums[5] + uniqueLeadNums[2] + uniqueLeadNums[1] +'@sintra.net';
        return uniqueLead;
    }
*/
}