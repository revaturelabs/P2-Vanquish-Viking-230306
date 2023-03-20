public class UseCasec19Helper {
    public static void updateAccNameWo(List<Work_Order__c> workOrders) {
        Set<Id> accountIds = getAccountIds(workOrders);
        Map<Id, Account> accountMap = getAccountMap(accountIds);

        for (Work_Order__c wo : workOrders) {
            Account relatedAccount = accountMap.get(wo.Account__c);
            if (relatedAccount != null) {
                wo.Account_Name__c = relatedAccount.Name;
                // Add other Account fields to copy as needed with any accompanying updates to the SOQL query
            }
        }
    }

    private static Set<Id> getAccountIds(List<Work_Order__c> workOrders) {
        Set<Id> accountIds = new Set<Id>();
        for (Work_Order__c wo : workOrders) {
            accountIds.add(wo.Account__c);
        }
        return accountIds;
    }

    private static Map<Id, Account> getAccountMap(Set<Id> accountIds) {
        return new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :accountIds]);
    }
}