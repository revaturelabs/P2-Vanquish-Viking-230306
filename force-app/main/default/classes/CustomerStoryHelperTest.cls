@isTest
public class CustomerStoryHelperTest {
    
    @isTest
    public static void TP_RankAssignment(){
        
        List<Customer_Success_Story__c> tpTestList= new List<Customer_Success_Story__c>();
        tpTestList.add(new Customer_Success_Story__c(Name='TP Test', Success_Rating__c=3,Account__c='0018b00002Mf5iaAAB'));
        CustomerStoryHelper.rankAssignment(tpTestList);
    } 
    
    @isTest
    public static void TN_RankAssignment(){
        List<Customer_Success_Story__c> tnTestList= new List<Customer_Success_Story__c>();
        tnTestList.add(new Customer_Success_Story__c(Name='TN Test', Success_Rating__c=8,Account__c='0018b00002Mf5iaAAB'));
        CustomerStoryHelper.rankAssignment(tnTestList);
    }
    @isTest
    public static void TP_UpdateRankAndSortList(){
        List<Customer_Success_Story__c> tpTestList= new List<Customer_Success_Story__c>();
        tpTestList.add(new Customer_Success_Story__c(Name='TP Test', Success_Rating__c=3,Account__c='0018b00002Mf5iaAAB'));
        tpTestList.add(new Customer_Success_Story__c(Name='TPTest', Success_Rating__c=4.3,Account__c='0018b00002Mf5iaAAB'));
        List<Customer_Success_Story__c> tpTestList2= new List<Customer_Success_Story__c>();
        tpTestList2.add(new Customer_Success_Story__c(Name='TP Test2', Success_Rating__c=3.1,Account__c='0018b00002Mf5iaAAB'));
        
        CustomerStoryHelper.sortList(tpTestList);
        CustomerStoryHelper.updateRank(tpTestList,tpTestList2);
        
        List<Customer_Success_Story__c >tpTestList3 = new List<Customer_Success_Story__c>();
        tpTestList3.addAll(tpTestList);
        CustomerStoryHelper.updateRank(tpTestList,tpTestList3);
    }
  
    
    @isTest
    public static void TN_UpdateRank(){
        List<Customer_Success_Story__c> tnTestList= new List<Customer_Success_Story__c>();
        tnTestList.add(new Customer_Success_Story__c(Name='TN Test', Success_Rating__c=8,Account__c='0018b00002Mf5iaAAB'));
        List<Customer_Success_Story__c> tnTestList2= new List<Customer_Success_Story__c>();
        tnTestList.add(new Customer_Success_Story__c(Name='TN Test', Success_Rating__c=5,Account__c='0018b00002Mf5iaAAB'));
        CustomerStoryHelper.updateRank(tnTestList,tntestList2);
        
        
        
    }
}