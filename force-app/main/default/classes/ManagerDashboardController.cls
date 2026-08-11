public with sharing class ManagerDashboardController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getTeamStatistics() {

        return DashboardService.getTeamStatistics();

    }

}
