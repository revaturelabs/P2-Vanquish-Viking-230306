public class OrdersAndProductsController {
    
    public List<Order> orders {get;set;}
    public String orderName {get;set;}
    public Id orderNameProd{get;set;}
    public Id orderToDelete{get;set;}
    public List <Account> accounts;
    public String accName{get;set;}
    public Order inputOrder{get;set;}
    public Order insertingOrder{get;set;}
    public List<OrderItem> items{get;set;}
    public OrderItem itemToAdd{get;set;}
    public List<Product2> products;
    public String prodName{get;set;}
    public List<PriceBook2> pricebooks;
    public String bookName{get;set;}
    public List<Order> orderOpts;
    public Order orderOwner;
    
    public OrdersAndProductsController(){
        orders=[SELECT Name,OrderNumber,TotalAmount,Status,Pricebook2Id,(SELECT Quantity,Product2Id,TotalPrice FROM OrderItems) FROM Order];
        accounts=[SELECT Id,Name FROM Account];
        products=[SELECT Id,Name FROM Product2 WHERE IsActive=true];
        inputOrder= new Order();
        itemToAdd= new OrderItem();
        orderOpts=[SELECT Name,OrderNumber,Pricebook2Id,TotalAmount FROM Order WHERE Name != null];
        items = new List<OrderItem>();
        for(Order ord:orders){
            if(ord.Pricebook2Id==null){
                ord.Pricebook2Id = '01s8b000002wiAbAAI';
            }
            for(OrderItem ite: [SELECT OrderId,Quantity,Product2Id,TotalPrice,UnitPrice,OrderName__c FROM OrderItem WHERE OrderId=:ord.id]){
                items.add(ite);
            }
        }
        
        for(Order o:orderOpts){
            if(o.Pricebook2Id==null){
                o.Pricebook2Id='01s8b000002wiAbAAI';
            }
        }
        
        orderOwner = new Order();
    }
    
    public List<SelectOption> getAccountOptions(){
        List<SelectOption> choices = new List<SelectOption>();
        for(Account acc:accounts){
            choices.add(new SelectOption(acc.name,acc.name));
        }
        return choices;
    }
    
    public List<SelectOption> getProductOptions(){
        List<SelectOption> choices = new List<SelectOption>();
        for(Product2 prod:products){
            choices.add(new SelectOption(prod.name,prod.name));
        }
        return choices;
    }
    
    public List<SelectOption> getBookOptions(){
        pricebooks=[SELECT Id, Name FROM Pricebook2 WHERE IsActive=true];
        List<SelectOption> choices = new List<SelectOption>();
        for(PriceBook2 book:pricebooks){
            choices.add(new SelectOption(book.name,book.name));
        }
        System.debug(choices);
        return choices;
    }
    
    public List<SelectOption> getOrderOptions(){
        List<SelectOption> choices = new List<SelectOption>();
        for(Order ord:orderOpts){
            choices.add(new SelectOption(ord.Id,ord.Name));
        }
        System.debug(choices);
        return choices;
    }
    
    public void saveNewOrder(){
        Account needAccId= [SELECT Id FROM Account WHERE Name=:accName LIMIT 1];
        Id accId= needAccId.Id;
        insertingOrder = new Order(Name=orderName, AccountId = accId, EffectiveDate=inputOrder.EffectiveDate, Status=inputOrder.Status);
        insert insertingOrder;
        orders.add(insertingOrder);
    }
    
    public void saveOrderItem(){
        PricebookEntry bookToAdd = [SELECT Id FROM PricebookEntry WHERE Product2Id=:itemToAdd.Product2Id LIMIT 1];
        Id bookEntryId = bookToAdd.Id;
        OrderItem ordItem= new OrderItem(PricebookEntryId= bookEntryId, OrderId=orderNameProd, Quantity= itemToAdd.Quantity
                                              , UnitPrice= itemToAdd.UnitPrice);
        
        insert ordItem;
    }
    
    public void saveChanges(){
        update orders;
    }
    
    public void deleteOrder(){
        Order deletingOrder =[SELECT Name FROM Order WHERE Id=:orderToDelete LIMIT 1];
        delete deletingOrder;
       	
    }
    
}