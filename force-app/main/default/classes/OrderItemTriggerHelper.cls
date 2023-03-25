/*  Author: Chase Johns
    Last Modified: 3/23/23
    Description: Helper Class for Trigger on OrderItem Objects
*/

public with sharing class OrderItemTriggerHelper {
    
    //Utility method for handling Environmental fee actions; calls upon other helper methods
    public static void environmentalFeeHandler(List<OrderItem> orderItemsToCheck){
        
        /*Query Criteria:
        1) Orders related to our Order Items being triggered on
        2) In those Orders, the ones that have at least one Order Item that is a Paper Good (i.e. Product Family = "Paper Goods")
        3) The Order does not already have the fee
        */

        //Querying for our special Environmental Fee Product Record
        PricebookEntry enviroFeeEntry = [SELECT UnitPrice, Product2Id FROM PricebookEntry WHERE Product2.Name = 'Environmental Fee' LIMIT 1];

        Set<Id> orderIdSet = new Set<Id>();

        for(OrderItem oi : orderItemsToCheck){
            orderIdSet.add(oi.OrderId);
        }

        List<Order> ordersWithoutFee = 
            [SELECT Id 
            FROM Order 
            WHERE Id In :orderIdSet
            AND Id In (SELECT OrderId FROM OrderItem WHERE Product2.Family = 'Paper Goods')
            AND Id NOT In (SELECT OrderId FROM OrderItem WHERE Product2.Name = 'Environmental Fee')];

        List<OrderItem> fees = new List<OrderItem>();
        
        for(Order o : ordersWithoutFee){
            OrderItem enviroFeeItem = new OrderItem(Product2Id = enviroFeeEntry.Product2Id,
                                                    UnitPrice = enviroFeeEntry.UnitPrice,
                                                    Quantity = 1,
                                                    OrderId = o.Id,
                                                    PricebookEntryId = enviroFeeEntry.Id);
            fees.add(enviroFeeItem);
        }

        insert fees;
    }

}