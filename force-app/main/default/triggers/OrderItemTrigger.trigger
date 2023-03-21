/*  Author: Chase Johns
    Last Modified: 3/21/23
    Description: Trigger on OrderItem Objects
*/

trigger OrderItemTrigger on OrderItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    switch on Trigger.operationType{
        when BEFORE_INSERT{

        }
        when BEFORE_UPDATE{

        }
        when BEFORE_DELETE{

        }
        //Not intended for given use cases, but included for best practice scalability
        when AFTER_INSERT{}
        when AFTER_UPDATE{}
        when AFTER_DELETE{}
        when AFTER_UNDELETE{}
    }

}