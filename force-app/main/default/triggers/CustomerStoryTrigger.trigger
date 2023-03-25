/*Created By: Khalil Newsome
 * Last Updated: 03/21/2023
 * Description: Apex Trigger for Customer_Success_Story__c.
 */

trigger CustomerStoryTrigger on Customer_Success_Story__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    
    switch on Trigger.operationType{
        
        when BEFORE_INSERT{
            
           CustomerStoryHelper.RankAssignment(Trigger.new);
        }
        when BEFORE_UPDATE{
            CustomerStoryHelper.UpdateRank(Trigger.new,Trigger.old);
            
        }
        when BEFORE_DELETE{}
        when AFTER_INSERT{}
        when AFTER_UPDATE{}
        when AFTER_DELETE{}
        when AFTER_UNDELETE{}
    }

}