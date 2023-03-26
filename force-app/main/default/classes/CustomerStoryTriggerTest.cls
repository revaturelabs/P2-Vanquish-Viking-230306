/*Created By: Khalil Newsome
 * Last Updated: 03/26/2023
 * Description: Test for CustomerStoryTrigger
 */
@isTest
public class CustomerStoryTriggerTest {

    
    @isTest
    static void TP_BeforeInsert(){
        Customer_Success_Story__c tpTest= new Customer_Success_Story__c();
        tpTest= new Customer_Success_Story__c(Name='Test', Success_Rating__c=5,Account__c='0018b00002Mf5iaAAB');
        insert tpTest;
        
        tpTest.Success_Rating__c= 3;
        update tpTest;
    }
    
    
}