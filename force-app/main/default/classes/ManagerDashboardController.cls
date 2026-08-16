public with sharing class ManagerDashboardController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getTeamStatistics() {

        return DashboardService.getTeamStatistics();

    }

    @AuraEnabled(cacheable=true)
    public static List<RepresentativePerformanceWrapper>
    getRepresentativePerformance() {

    return DashboardService.getRepresentativePerformance();

}

@AuraEnabled(cacheable=true)
public static List<Visit__c> getUpcomingVisits() {

    return DashboardService.getUpcomingVisits();

}




}
