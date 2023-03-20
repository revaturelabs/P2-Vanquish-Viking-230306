trigger UseCaseC23 on Contact (before insert, before update) {
    //See helper class for details
    UseCaseC23Helper.emailDomainValidation(Trigger.new);
}
//Still working on Test class!