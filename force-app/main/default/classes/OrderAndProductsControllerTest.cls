/*Created By: Khalil Newsome
* Last Updated: 03/26/2023
* Description: Test for OrderAndProducts Controller
*/
@isTest
public class OrderAndProductsControllerTest {
    
    @testSetup
    static void setupMethod(){
        Account acc= new Account(Name='TestAcc');
        insert acc;
        Id accId = [SELECT Name From Account WHERE Name='TestAcc'].Id;
        List<Order> orders = new List<Order>();
        orders.add(new Order(Name='orde',EffectiveDate= System.today(), AccountId= accId, Status='Draft'));
        insert orders;
        
    }
    
    @isTest
    static void TP_SaveNewOrder(){
        
        Id accId = [SELECT Name From Account WHERE Name='TestAcc'].Id;
        Order inputOrder = new Order(Name='ord',EffectiveDate= System.today(), AccountId= accId, Status='Draft');
        OrdersAndProductsController testcont = new OrdersAndProductsController();
        testcont.orders= OrdersAndProductsDataFactory.generateOrderList(3);
        Account acc2 = new Account(Name='TA');
        insert acc2;
        Test.startTest();
        testcont.accName= 'TA';
        testcont.inputOrder= inputOrder;
        testcont.orderName='Test Order';
        testcont.needAccId=acc2;
        
        testcont.saveNewOrder();
        Test.stopTest();
        
        
        System.assertEquals('Test Order',testcont.insertingOrder.Name);
        System.assertEquals(accId,testcont.insertingOrder.AccountId);
        System.assertEquals(System.today(),testcont.insertingOrder.EffectiveDate);
        System.assertEquals('TestAcc',testcont.accName);
        System.assertEquals('Test Order', testcont.orderName);
        
        
    }
    @isTest
    static void TP_SaveChanges(){
        
        OrdersAndProductsController t = new OrdersAndProductsController();
        Test.startTest();
        t.orders= OrdersAndProductsDataFactory.generateOrderList(3);
        t.orders[0].Name= 'New Name';
        t.saveChanges();
        Test.stopTest();
        System.assertEquals('New Name',t.orders[0].Name);
    }
    
    @isTest
    static void TP_GetOrderOptions(){
        OrdersAndProductsController testcont = new OrdersAndProductsController();
        testcont.orderOpts= OrdersAndProductsDataFactory.generateOrderList(3);
        
        Test.startTest();
        testcont.getOrderOptions();
        
        System.assert(testcont.orderOpts!=null);
        Test.stopTest();
    }
    
    @isTest
    static void TP_GetBookOptions(){
        OrdersAndProductsController testcont = new OrdersAndProductsController();
        testcont.pricebooks= OrdersAndProductsDataFactory.generateBooks();
        testcont.getBookOptions();
        
        System.assert(testcont.pricebooks!=null);
    }
    @isTest
    static void TP_GetProdcutOptions(){
        OrdersAndProductsController testcont = new OrdersAndProductsController();
        testcont.products= OrdersAndProductsDataFactory.generateProducts();
        testcont.getProductOptions();
        
        System.assert(testcont.products!=null);  
    }
    
    @isTest 
    static void TP_GetAccountOptions(){
        OrdersAndProductsController testcont = new OrdersAndProductsController();
        testcont.accounts= OrdersAndProductsDataFactory.generateAccounts(4);
        testcont.getAccountOptions();
        
        System.assert(testcont.accounts!=null);
    }
    
    @isTest
    static void TP_DeleteOrder(){
        OrdersAndProductsController testcont = new OrdersAndProductsController();
        testcont.orderOpts= OrdersAndProductsDataFactory.generateOrderList(3);
        insert testcont.orderOpts;
        testcont.orderToDelete= [SELECT Id FROM Order WHERE Name='Test1' LIMIT 1].Id;
        testcont.deleteOrder();
    }
    
    @isTest
    static void TP_ToAccounts(){
        OrdersAndProductsController testcont = new OrdersAndProductsController();
        testcont.toAccounts(); 
    }
    
     @isTest
    static void TP_ToContacts(){
        OrdersAndProductsController testcont = new OrdersAndProductsController();
        testcont.toContacts(); 
    }
}