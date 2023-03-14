/*  Author: Chase Johns
    Last Modified: 3/14/23
    Description: Trigger on Order Objects
*/

trigger OrderTrigger on Order (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    switch on Trigger.operationType{
        when BEFORE_INSERT{
            //Calls handler method from helper class and allows for partial insertion
            OrderTriggerHelper.environmentalFeeHandler(Trigger.new);
            try{
                Database.insert(Trigger.new,false);
            }
            catch(System.Exception e){
                System.debug('You unfortunately have encountered an exception:\n' + e.getCause() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
            }
        }
        when BEFORE_UPDATE{
            //Calls handler method from helper class and allows for partial updating
            OrderTriggerHelper.environmentalFeeHandler(Trigger.new);
            try{
                Database.update(Trigger.new,false);
            }
            catch(System.Exception e){
                System.debug('You unfortunately have encountered an exception:\n' + e.getCause() + '\n' + e.getMessage() + '\n' + e.getStackTraceString());
            }
        }
        when BEFORE_DELETE{}
        when AFTER_INSERT{}
        when AFTER_UPDATE{}
        when AFTER_DELETE{}
        when AFTER_UNDELETE{}
    }

}