/*  Author: Chase Johns
    Last Modified: 3/24/23
    Description: Test Class for Trigger on OrderItem Objects
*/
@isTest
public class OrderItemTriggerTest {
    
    @testSetup
    public static void testSetup(){
        Pricebook2 testBook = new Pricebook2(isActive=true,Id=test.getStandardPricebookId());
        update testBook;
        List<Product2> testProducts = new List<Product2>();
        for(Integer i = 0; i < 5; i++){
            Product2 prod1 = new Product2(Name='testSever'+i,Family='Server');
        	Product2 prod2 = new Product2(Name='testPaper'+i,Family='Paper Goods');
            testProducts.add(prod1);
            testProducts.add(prod2);
        }
        Product2 enviroFeeProd = new Product2(Name='Environmental Fee');
        testProducts.add(enviroFeeProd);
        insert testProducts;
        List<PricebookEntry> testProductEntries = new List<PricebookEntry>();
        for(Product2 prod : testProducts){
             PricebookEntry prodEn = new PricebookEntry(Pricebook2Id = testBook.Id,Product2Id = prod.Id,UnitPrice=42,isActive=true);
            testProductEntries.add(prodEn);
        }
        insert testProductEntries;
        Account accForOrder = new Account(Name='Account For Order');
        insert accForOrder;
        List<Order> testOrders = new List<Order>();
        for(Integer i = 0; i < 2; i++){
            Order testOrder = new Order(Name='Test Order '+i,EffectiveDate=Date.today(),Status='Draft',AccountId=accForOrder.Id,Pricebook2Id=testBook.Id);
            testOrders.add(testOrder);
        }
        insert testOrders;
        
    }
    
    //Testing the trigger for a single order product that is a paper good
    @isTest
    public static void tp_addFee_OneOrderItem_WithPaper(){
        
        OrderItemTriggerHelper testHelper = new OrderItemTriggerHelper();
        
        List<OrderItem> testItems = OrderItemTriggerDataFactory.generateOrderItems(1);
        
        Order orderToRelate = [SELECT Id FROM Order LIMIT 1];
        Product2 paperGood = [SELECT Id, (SELECT Id FROM PricebookEntries) FROM Product2 WHERE Family = 'Paper Goods' LIMIT 1];
        
        testItems[0].OrderId = orderToRelate.Id;
        testItems[0].PricebookEntryId = paperGood.PricebookEntries[0].Id;
        testItems[0].Product2Id = paperGood.Id;
        
        Test.startTest();
        insert testItems;
        Test.stopTest();
        List<OrderItem> allOrderItems = [SELECT Id FROM OrderItem];
        Assert.areEqual(2, allOrderItems.size());
        OrderItem enviroFeeItem = [SELECT Id FROM OrderItem WHERE OrderId = :orderToRelate.Id AND Product2.Name = 'Environmental Fee'];
        Assert.isNotNull(enviroFeeItem);
    }
    /*
    //Testing the trigger for a single order product that is not paper good
    @isTest
    public static void tn_addFee_OneOrderItem_WithoutPaper(){
        OrderItemTriggerHelper testHelper = new OrderItemTriggerHelper();
        
      
        Test.startTest();
        try{
            insert testItems;
        }
        catch(System.Exception e){
            System.debug('The DML Operation Failed:\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
        System.assertNotEquals(2, testOrders[0].OrderItems.size());
        System.assertEquals(1, testOrders[0].OrderItems.size());
        
        Test.stopTest();
    }
    
    //Testing the trigger for many order products that is are paper goods
    @isTest
    public static void tp_addFee_ManyOrderItems_WithPaper(){
        OrderItemTriggerHelper testHelper = new OrderItemTriggerHelper();
        
        Test.startTest();
        try{
            insert testItems;
        }
        catch(System.Exception e){
            System.debug('The DML Operation Failed:\n' + e.getMessage() + '\n' + e.getStackTraceString());
        }
        
        for(Order o : testOrders){
            System.assertEquals(true,o.OrderItems.contains(enviroFeeItem));
        }
        
        Test.stopTest();
    }
    */

}