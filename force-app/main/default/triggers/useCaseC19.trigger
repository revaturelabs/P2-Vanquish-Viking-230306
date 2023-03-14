trigger useCaseC19 on Work_Order__c (before insert, before update) {
    //Map that holds the list of available service techs on each Account
    Map<Id, Set<id>> accToServiceMap = new Map<Id, Set<Id>>();
    // Retrieves all accounts related to Work Orders
    Set<Id> accountIds = new Set<Id>();
    for (Work_Order__c wo : Trigger.new) {
        accountIds.add(wo.Account__c);
    }

    List<Contact> contacts = [SELECT Id, AccountId, Is_Service_Technician__c FROM Contact WHERE AccountId IN :accountIds AND Is_Service_Technician__c = true];
    for(Contact c : contacts) {
        if(!accToServiceMap.containsKey(c.AccountId)) {
            accToServiceMap.put(c.AccountId, new Set<Id>());
        }
        accToServiceMap.get(c.AccountId).add(c.Id);
    }

    for(Work_Order__c wo : Trigger.new) {
        if (wo.Is_Service_Technician__c != null && !accToServiceMap.get(wo.Account__c).contains(wo.Is_Service_Technician__c)) {
            wo.addEroor('The Service Technician you selected is not available for this account!');
        }
    }

}