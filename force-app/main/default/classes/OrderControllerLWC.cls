public with sharing class OrderControllerLWC {
   
    @AuraEnabled(cacheable=true)
    public static List<Order> getOrders(){
        return[
            SELECT Name, OrderNumber, TotalAmount,Status
            FROM Order
            WITH SECURITY_ENFORCED
            ORDER BY Id
        ];
    }
    @AuraEnabled
    public static void deleteOrder(Id rowid){
        try {
            delete [SELECT Id FROM Order WHERE Id=:rowid LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteOrderItem(Id rowid){
        try {
            delete [SELECT Id FROM OrderItem WHERE Id=:rowid LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<OrderItem> getOrderItems(){
        return[
            SELECT OrderName__c,OrderId,Quantity,Product2Id, TotalPrice, UnitPrice
            FROM OrderItem
            WITH SECURITY_ENFORCED
            ORDER BY OrderId
        ];
    }

    @AuraEnabled
    public static void addMacBook(Id orderId){
        
        PriceBookEntry macBook = [SELECT Name,Id,Pricebook2Id,Product2Id,UnitPrice FROM PricebookEntry WHERE Product2.Name='Marketing Macbook Pro'];
        List<OrderItem> chosenItems = new List<OrderItem>();
        
        Order chosenOrder= [SELECT Id, PriceBook2Id FROM Order WHERE Id =:orderId];
        if(chosenOrder.Pricebook2Id==null){
            chosenOrder.Pricebook2Id= macBook.Pricebook2Id;
            update chosenOrder;}
        
        chosenItems.add(new OrderItem(
            Product2Id=macBook.Product2Id,
            UnitPrice=macBook.UnitPrice,
            PricebookEntryId=macBook.Id,
            OrderId=orderId,
            Quantity=1));
        
        System.debug(chosenItems);
        insert chosenItems;
    }

    @AuraEnabled
    public static void add12CountPencils(Id orderId){
        
        PriceBookEntry pencils = [SELECT Name,Id,Pricebook2Id,Product2Id,UnitPrice FROM PricebookEntry WHERE Product2.Name='#2 Pencils - 1 Dozen'];
        List<OrderItem> chosenItems = new List<OrderItem>();
        
        Order chosenOrder= [SELECT Id, PriceBook2Id FROM Order WHERE Id =:orderId];
        
        if(chosenOrder.Pricebook2Id==null){
            chosenOrder.Pricebook2Id= pencils.Pricebook2Id;
            update chosenOrder;}
        
        chosenItems.add(new OrderItem(
            Product2Id=pencils.Product2Id,
            UnitPrice=pencils.UnitPrice,
            PricebookEntryId=pencils.Id,
            OrderId=orderId,
            Quantity=1));
         
        System.debug(chosenItems);
        insert chosenItems;
    }

    @AuraEnabled
    public static void addWindowsDesktop(Id orderId){
          PriceBookEntry desktop = [SELECT Name,Id,Pricebook2Id,Product2Id,UnitPrice FROM PricebookEntry WHERE Product2.Name='Windows Developer Desktop' LIMIT 1];
        List<OrderItem> chosenItems = new List<OrderItem>();
        
        Order chosenOrder= [SELECT Id, PriceBook2Id FROM Order WHERE Id =:orderId];
        
        if(chosenOrder.Pricebook2Id==null){
            chosenOrder.Pricebook2Id= desktop.Pricebook2Id;
            update chosenOrder;}
        
        chosenItems.add(new OrderItem(
            Product2Id=desktop.Product2Id,
            UnitPrice=desktop.UnitPrice,
            PricebookEntryId=desktop.Id,
            OrderId=orderId,
            Quantity=1));
         
        System.debug(chosenItems);
        insert chosenItems;
    }

}