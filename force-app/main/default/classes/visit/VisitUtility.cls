public with sharing class VisitUtility {

    public static Boolean isCompleted(Visit__c visit) {
        return visit.Status__c == VisitConstants.STATUS_COMPLETED;
    }
}