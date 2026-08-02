trigger VisitTrigger on Visit__c (

before insert,

before update,

after insert,

after update

){

    TriggerDispatcher.run(

        new VisitTriggerHandler()

    );

}
