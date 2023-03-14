/*  Author: Chase Johns
    Last Modified: 3/14/23
    Description: Helper Class for Trigger on Order Objects
*/

    /* Outline notes:
        -Trigger to add Environmental Fee product should be fired on inserts and updates (before)
        -Only adds special fee on Orders with other Products of the "Paper Goods" Family
        -1) Check for what Products an Order has
        -2) If any Products are in the "Paper Goods" family:
            -a) Add the fee
        -3) This also should be prevented on Orders with NO Paper Goods
            -a) Prevent addition of this Product

        Day 2 Notes:
        -We can't go directly from Order to Products
        -It would be Order -> Order Items
        -Each Order Item has a Lookup to the Product it actually is
        -Perhaps make a Map between Order Item Name and Product ID
        -Query for a Set of Products based on the keymap of the Map

        Revision:
        -We just get a Set of all applicable Paper Good Names to check from
        -We can reference Product's Name through OrderItem's lookup
        -Doing it like this would only require 2 SOQL queries
    */

public class OrderTriggerHelper {

    //Utility method for handling Environmental fee actions; calls upon other helper methods
    public static void environmentalFeeHandler(List<Order> ordersToCheck){
        //Environmental Fee as a Product and as an Order Item
        Product2 environmentalFee = [SELECT Name FROM Product2 WHERE Name = 'Environmental Fee' LIMIT 1];
        OrderItem environmentalFeeItem = new OrderItem(Product2Id = environmentalFee.Id);

        for(Order orderToCheck : ordersToCheck){
            if(hasPaperProduct(orderToCheck)){
                //If it has any paper products, we can add our fee
                orderToCheck.OrderItems.add(environmentalFeeItem);
            }
            else if(orderHasFeeButNoPaperGoods(orderToCheck,environmentalFeeItem)){
                orderToCheck.addError('You cannot add the Environmental Fee on Orders with no Paper Goods');
            }
        }
    }

    //Utility method that checks if an Order contains any Paper Products
    private static Boolean hasPaperProduct(Order orderToCheck){
        /*We cannot directly reference the Product Family (or anything other than the ID) from Order Item, 
          so I cannot concieve of any way of avoiding looping SOQL. I have racked my brain for hours over this alone.
        */
        for(OrderItem lineItem : [SELECT Product2.Family FROM OrderItem WHERE Id IN :orderToCheck.OrderItems]){
            if(lineItem.Product2.Family == 'Paper Goods'){
                return true;
            }
        }
        //Exits the loop without finding any paper products
        return false;
    }

    //Utility method to verify whether the Order contains the Environmental Fee with no Paper Goods (due to when it is called)
    private static Boolean orderHasFeeButNoPaperGoods(Order orderToCheck,OrderItem environmentalFeeItem){
        for(OrderItem lineItem : orderToCheck.OrderItems){
            if(lineItem.Product2Id == environmentalFeeItem.Product2Id){
                return true;
            }
        }
        //Paperless Order does not erroneously have the fee
        return false;
    }


}