trigger useCaseC19 on Work_Order__c (before insert, before update) {
    UseCasec19Helper.updateAccNameWo(Trigger.new);
}

//Still Working on test!
