/**
 * VisitDashboardController class provides a controller for the visit dashboard.
 */
public with sharing class VisitDashboardController {
    
   /**
    * Retrieves today's visits.
    * @return List of Visit__c records for today
    */
   @AuraEnabled(cacheable=true)
    public static List<Visit__c>  getTodayVisits(){
    return VisitSelector.getTodayVisits();
   }

   /**
    * Retrieves aggregated visit statistics.
    *
    * @return Map<String, Integer> a map of statistic names to their integer values
    */
   @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getVisitStatistics() {
    return VisitService.getVisitStatistics();
}


}