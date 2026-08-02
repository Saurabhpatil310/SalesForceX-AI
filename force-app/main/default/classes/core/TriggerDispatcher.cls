/**
 * Dispatches trigger events to the provided handler.
 */
public with sharing class TriggerDispatcher {

    /**
     * Executes the appropriate trigger handler method based on the current trigger context.
     *
     * @param handler The trigger handler instance to invoke.
     */
    public static void run(BaseTriggerHandler handler){

        if(Trigger.isBefore){

            if(Trigger.isInsert){
                handler.beforeInsert();
            }
            if(Trigger.isUpdate){
                handler.beforeUpdate();
            }
            if(Trigger.isDelete){
                handler.beforeDelete();

            }

        }

        if(Trigger.isAfter){

            if(Trigger.isInsert){
                handler.afterInsert();
            }
            if(Trigger.isUpdate){
                handler.afterUpdate();
            }
            if(Trigger.isDelete){
                handler.afterDelete();
            }

        }

    }

}
