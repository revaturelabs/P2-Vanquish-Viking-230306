trigger useCaseC19 on Work_Order__c (before insert, before update) {
    // Store Account IDs of Work Orders inside of a Set 
    Set<Id> accountIds = new Set<Id>();
    for (Work_Order__c wo : Trigger.new) {
        accountIds.add(wo.Account__c);
    }
    // Populate Map of Account ID keys and Account Record values
    Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :accountIds]);
    for (Work_Order__c wo : Trigger.new) {
        Account relatedAccount = accountMap.get(wo.Account__c);
        if (relatedAccount != null) {
            wo.Account_Name__c = relatedAccount.Name;
            // Add other Account fields to copy as needed with accompanying updates to the SOQL query
        }
    }
}

//Still Working on test!
