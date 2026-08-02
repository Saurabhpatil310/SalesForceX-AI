public with sharing class VisitDashboardController {
    
   @AuraEnabled(cacheable=true)
    public static List<Visit__c>  getTodayVisits(){
    return VisitSelector.getTodayVisits();
   }
}