/*  Author: Chase Johns
    Last Modified: 3/23/23
    Description: Trigger on OrderItem Objects
*/

trigger OrderItemTrigger on OrderItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    switch on Trigger.operationType{
        when BEFORE_INSERT{}
        when BEFORE_UPDATE{}
        //Not intended for given use cases, but included for best practice scalability
        when BEFORE_DELETE{}
        when AFTER_INSERT{
            OrderItemTriggerHelper.environmentalFeeHandler(Trigger.new);
        }
        when AFTER_UPDATE{
            OrderItemTriggerHelper.environmentalFeeHandler(Trigger.new);
        }
        when AFTER_DELETE{}
        when AFTER_UNDELETE{}
    }

}