public with sharing class ManagerDashboardController {

    @AuraEnabled(cacheable=true)
public static Map<String, Integer> getTeamStatistics() {

    SecurityService.requireManagerAccess();

    return DashboardService.getTeamStatistics();

}


    @AuraEnabled(cacheable=true)
    public static List<RepresentativePerformanceWrapper>getRepresentativePerformance() {

    SecurityService.requireManagerAccess();

    return DashboardService.getRepresentativePerformance();

}

    @AuraEnabled(cacheable=true)    
    public static List<Visit__c> getUpcomingVisits() {

    SecurityService.requireManagerAccess();

    return DashboardService.getUpcomingVisits();

}




}
