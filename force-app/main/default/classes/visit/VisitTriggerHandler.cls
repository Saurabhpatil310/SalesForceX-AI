/**
 * Trigger handler for Visit__c records.
 */
public with sharing class VisitTriggerHandler
extends BaseTriggerHandler {

    public override void beforeInsert(){

        VisitService.beforeInsert(
            (List<Visit__c>)Trigger.new
        );

    }

    public override void beforeUpdate(){

        VisitService.beforeUpdate(

            (List<Visit__c>)Trigger.new,

            (Map<Id,Visit__c>)Trigger.oldMap

        );

    }

    public override void afterInsert(){

        VisitService.afterInsert(

            (List<Visit__c>)Trigger.new

        );

    }

    public override void afterUpdate(){

        VisitService.afterUpdate(

            (List<Visit__c>)Trigger.new,

            (Map<Id,Visit__c>)Trigger.oldMap

        );

    }

}
