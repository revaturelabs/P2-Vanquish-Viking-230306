@isTest
private class UseCaseC19Test {
    @isTest
    static void testUpdateAccNameWo() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = testAccount.Id, Service_Technician__c = true);
        insert testContact;

        Order testOrder = new Order(
            AccountId = testAccount.Id,
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        insert testOrder;

        Work_Order__c testWorkOrder = new Work_Order__c(
            Account__c = testAccount.Id,
            Assigned_Technician__c = testContact.Id,
            Order__c = testOrder.Id,
            Requested_Date__c = Date.today(),
            Estimated_Hours__c = 2
        );
        insert testWorkOrder;

        Work_Order__c insertedWorkOrder = [SELECT Id, Account_Name__c FROM Work_Order__c WHERE Id = :testWorkOrder.Id];
        System.assertEquals(testAccount.Name, insertedWorkOrder.Account_Name__c, 'The Account name should be copied to the Work Order');
        
        testAccount.Name = 'Updated Test Account';
        update testAccount;
        
        testWorkOrder.Estimated_Hours__c = 3;
        update testWorkOrder;
        
        Work_Order__c updatedWorkOrder = [SELECT Id, Account_Name__c FROM Work_Order__c WHERE Id = :testWorkOrder.Id];
        System.assertEquals(testAccount.Name, updatedWorkOrder.Account_Name__c, 'The updated Account name should be copied to the Work Order');
    }
}