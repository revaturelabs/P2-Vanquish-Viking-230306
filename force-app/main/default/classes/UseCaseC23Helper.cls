public class UseCaseC23Helper {
    public static void emailDomainValidation(List<Contact> newContacts) {
        //Iterate through and validate all new Contacts as long as they have an Email and AccountId
        for (Contact newCont : newContacts) {
            if(newCont.Email != null && newCont.AccountId != null) {
                //Store the chars after '@' in the Email field 
                String newEmail = newCont.Email.substringAfter('@');
                
                //Query the pre-existing Contacts on the selected Account, iterate through them, store the chars after '@' if the Email field if not null, and throw an error if the current new Email's domain is different from the old
                List<Contact> oldConts = [SELECT Email FROM Contact WHERE AccountId = :newCont.AccountId AND Id != :newCont.Id];
                for (Contact oldCont : oldConts) {
                    if (oldCont.Email != null) {
                        String oldEmail = oldCont.Email.substringAfter('@');
                        if (!newEmail.equalsIgnoreCase(oldEmail)) {
                            newCont.Email.addError('All email addresses must resemble the existing collection Contact domains for said Account!');
                        }
                        break;
                    }
                }
            }
        }
    }
}
