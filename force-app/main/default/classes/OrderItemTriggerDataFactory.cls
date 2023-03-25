/*  Author: Chase Johns
    Last Modified: 3/24/23
    Description: Data Factory Class for OrderItemTriggerTest
*/
@isTest
public class OrderItemTriggerDataFactory {
    
    public static List<OrderItem> generateOrderItems(Integer numToGen){
        
        List<Product2> productsForOrderItems = [SELECT Id FROM Product2];
        List<OrderItem> orderItemsGenerated = new List<OrderItem>();
        
        Integer unitPrice = (Integer) Math.random() * 100;
        
        for(Integer i = 0; i < numToGen; i++){
            OrderItem orderItemGenerated = new OrderItem(Product2Id = productsForOrderItems[i].Id, UnitPrice = unitPrice,Quantity=1);
            orderItemsGenerated.add(orderItemGenerated);
        }
        return orderItemsGenerated;
    }
}