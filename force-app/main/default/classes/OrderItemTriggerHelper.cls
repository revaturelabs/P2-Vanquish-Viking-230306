/*  Author: Chase Johns
    Last Modified: 3/21/23
    Description: Helper Class for Trigger on OrderItem Objects
*/

public with sharing class OrderItemTriggerHelper {
    
    //Utility method for handling Environmental fee actions; calls upon other helper methods
    public static void environmentalFeeHandler(List<OrderItem> orderItemsToCheck){
        //Querying for our special Environmental Fee Product Record
        Product2 environmentalFee = [SELECT Name FROM Product2 WHERE Name = 'Environmental Fee' LIMIT 1];
        OrderItem enviroFeeItem = new OrderItem(Id=environmentalFee.Id);

        Map<OrderItem,Id> itemToOrderIdMap = mapItemsToOrderIds(orderItemsToCheck);
        List<Order> relatedOrders = [SELECT Name, (SELECT OrderItemNumber, Product2Id FROM OrderItems) FROM Order WHERE Id IN :itemsToOrderMapId.keyset()];
        Map<OrderItem,Order> itemToOrderMap = mapItemsToOrders(itemToOrderIdMap, relatedOrders);

        List<Product2> allProducts = [SELECT Name, Family, (SELECT OrderItemNumber, OrderId FROM OrderItems) FROM Product2];

        /* Iterate through our Order Items and determine:
            A) Does the Order have any paper goods?
            B) Does it have the environmental fee already on the order?

            If A == true and B == true, we do nothing additionally
            If A == false and B == true, we flag this operation as the Order cannot have the fee and no paper goods
            If A == true and B == false, we add the fee
            If A == false and B == false, we do nothing additionally
        */
        for(OrderItem oi : orderItemsToCheck){
            Order orderToCheck = itemToOrderMap.get(oi);
            if(orderHasPaperGood(itemToProductFamilyMap, orderToCheck)){
                if(!orderHasFee()){

                }
            }
            else if(orderHasFee()){

            }
        }


        

    }

    //Utility method to map a List of Order Items to their Orders (Id's)
    private static Map<OrderItem,Id> mapItemsToOrderIds(List<OrderItems> itemsToMap){
        Map<OrderItem,Id> lineItemMap = new Map<String,OrderItem>();
        //Populating the map of Order Id's by Item
        for(OrderItem oi : itemsToMap){
            lineItemMap.put(oi,oi.OrderId);
        }
        return lineItemMap;
    }

    //Utility method to map a List of Order Items to their Products (Id's)
    private static Map<OrderItem,Id> mapItemsToProductIds(List<OrderItem> itemsToMap){
        Map<OrderItem,Id> lineItemMap = new Map<OrderItem,Product2>();
        //Populating the map of Product Id's by Item
        for(OrderItem oi : itemsToMap){
            lineItemMap.put(oi,oi.Product2Id);
        }
        return lineItemMap;
    }

    //Utility method to map a List of Order Items to their Products
    private static Map<OrderItem,Product2> mapItemsToProducts(List<Product2> productsToMap, Map<OrderItem,Id> itemToProductMap){
        Map<OrderItem,Product2> lineItemMap = new Map<OrderItem,Product2>();
        //Populating the map of Product Id's by Item
        for(OrderItem oi : itemToProductMap){
            Product2 productToMap = new Product2();
            //Matching a Product's Id to the current Item's Product2Id
            for(Integer i = 0; i < productsToMap.size(); i++){
                if(productsToMap[i].Id == oi.Product2Id){
                    productToMap = productsToMap[i];
                    continue;
                }
            }
            //Mapped our matched Product
            lineItemMap.put(oi,productToMap);
        }
        return lineItemMap;
    }
    
    
    //Utility method to map Order Items to their associated Product Family
    private static Map<OrderItem,String> mapItemsToProductFamilies(Map<OrderItem,Product2> itemToProductMap){
        Map<OrderItem,String> lineItemMap = new Map<OrderItem,String>();
        //Populating the map of Items, relating them to their Families
        for(OrderItem oi : itemToProductMap){
            String productFamily = itemToProductMap.get(oi).Family;
            lineItemMap.put(oi,productFamily);
        }
        return lineItemMap;
    }

    //Utility method to map Order Items directly to the related Order objects
    private static Map<OrderItem,Order> mapItemsToOrders(Map<OrderItem,Id> itemsToOrderIdMap, List<Order> ordersToMap){
        Map<OrderItem,Order> lineItemMap = new Map<OrderItem,Order>();
        //Populating the map of Product Id's by Item
        for(OrderItem oi : itemToProductMap){
            Order orderToMap = new Order();
            //Matching a Product's Id to the current Item's Product2Id
            for(Integer i = 0; i < ordersToMap.size(); i++){
                if(ordersToMap[i].Id == oi.OrderId){
                    orderToMap = ordersToMap[i];
                    continue;
                }
            }
            //Mapped our matched Product
            lineItemMap.put(oi,orderToMap);
        }
        return lineItemMap;
    }
    
    //Utility method to verify if an Order has any Paper Goods
    private static Boolean orderHasPaperGood(Order orderToCheck){
        for(OrderItem oi : orderToCheck.OrderItems){

        }

    }

    //Utility method to verify if an Order has the Environmental Fee
    private static Boolean orderHasFee(Order orderToCheck, OrderItem enviroFeeItem){

    }

}