/*Created By: Khalil Newsome
 * Last Updated: 03/26/2023
 * Description: DataFactory for OrderAndProductsController Test
 */
@isTest
public class OrdersAndProductsDataFactory {
    
    public static List<Order> generateOrderList(Integer x){
        List<Order> testOrders = new List<Order>();
        Account testAcc = new Account(Name='testacc');
        insert testAcc;
        Id accId = [SELECT Id FROM Account WHERE Name ='testacc' LIMIT 1].Id;
        for (Integer i=0;i<x;i++){
            testOrders.add(new Order(Name='Test'+i, AccountId=accId,EffectiveDate=System.today(),Status='Draft'));
        }
        return testOrders;
    } 
    
    public static List<Pricebook2> generateBooks(){
        List<Pricebook2> testbooks = [SELECT Id, Name FROM Pricebook2 LIMIT 6];
        return testbooks;
    }
    public static List<Product2> generateProducts(){
        List<Product2> testProducts = [SELECT Id, Name FROM Product2 LIMIT 6];
        return testProducts;
    }
    
    public static List<Account> generateAccounts(Integer x){
        List<Account> testAccounts = new List<Account>();
        for(Integer i =0; i<x;i++){
            testAccounts.add(new Account(Name='TestAcc' + i));
        }
        return testAccounts;
    }
    
}