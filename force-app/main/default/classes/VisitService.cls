public with sharing class VisitService {

    public static void beforeInsert(List<Visit__c> visits){

    for(Visit__c visit : visits){
			system.debug('=======Visit Trigger Start');
        if(visit.Representative__c == null){
            visit.Representative__c = UserInfo.getUserId();
            system.debug('representative=' +userInfo.getUserId());
        }

        if(String.isBlank(visit.Status__c)){
            visit.Status__c = VisitConstants.STATUS_PLANNED;
            system.debug('Visit Status=' + VisitConstants.STATUS_PLANNED);
        }

        if(visit.Visit_Date__c == null){
            visit.Visit_Date__c = Date.today();
            system.debug('Visit Date=' + visit.Visit_Date__c);
        }
        
        if(visit.Follow_Up__c == True){
            visit.Next_Visit_Date__c = Date.today().addDays(7);
            system.debug('===Follow Up Task Created======');
        }

    }

}

    public static void beforeUpdate(
    List<Visit__c> visits,
    Map<Id,Visit__c> oldMap
){

    for(Visit__c visit : visits){

        Visit__c oldVisit = oldMap.get(visit.Id);

        if(
            oldVisit.Status__c == VisitConstants.STATUS_COMPLETED &&
            visit.Status__c == VisitConstants.STATUS_PLANNED
        ){
			system.debug('Completed visits cannot be changed back to Planned.');
            visit.addError(
                'Completed visits cannot be changed back to Planned.'
            );

        }

    }

}

    public static void afterInsert(List<Visit__c> visits){

    List<Task> tasks = new List<Task>();

    for(Visit__c visit : visits){

        if(visit.Follow_Up__c){

            Task t = new Task();

            t.Subject = 'Follow up Visit';

            t.WhatId = visit.Id;

            t.OwnerId = visit.Representative__c;

            t.ActivityDate = Date.today().addDays(7);

            tasks.add(t);

        }

    }

    if(!tasks.isEmpty()){

        insert tasks;

    }

}

    public static void afterUpdate(
    List<Visit__c> visits,
    Map<Id,Visit__c> oldMap
){

    for(Visit__c visit : visits){

        Visit__c oldVisit = oldMap.get(visit.Id);

        if(
            oldVisit.Status__c != VisitConstants.STATUS_COMPLETED &&
            visit.Status__c == VisitConstants.STATUS_COMPLETED
        ){

            System.debug(
                'Visit Completed : Ready for AI Processing'
            );

        }

    }

}
}