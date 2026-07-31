public with sharing class VisitDashboardController {
    
   @AuraEnabled(cacheable=true)
    public static List<Visit__c>  getTodayVisits(){
    return[
        SELECT
        Id,
        Name,
        Doctor__r.Name,
        Status__c,
        Priority__c,
        Visit_Date__c
        FROM Visit__c
        WHERE Visit_Date__c = TODAY
        ORDER BY CreatedDate DESC
    ];
   }
}