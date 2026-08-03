/**
 * Selector class for Visit__c data operations.
 */
public with sharing class VisitSelector {

   /**
     * Returns visits scheduled for today.
     *
     * @return List<Visit__c> visits for the current day
     */
    public static List<Visit__c> getTodayVisits() {
        // Enforce CRUD: ensure the running user has read access to Visit__c
        if (!Schema.sObjectType.Visit__c.isAccessible()) {
            // Return empty list when no access to avoid unauthorized SOQL
            return new List<Visit__c>();
        }

        return [
            SELECT Id,
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

    /**
     * Returns aggregated visit statistics by status.
     *
     * @return Map<String, Integer> counts keyed by visit status
     */
    public static Map<String, Integer> getVisitStatistics() {
        // Enforce CRUD: ensure the running user has read access to Visit__c
        if (!Schema.sObjectType.Visit__c.isAccessible()) {
            // Return zeroed stats when no access
            return new Map<String, Integer>{
                'Planned' => 0,
                'In Progress' => 0,
                'Completed' => 0,
                'Cancelled' => 0,
                'Missed' => 0
            };
        }

        Map<String, Integer> stats = new Map<String, Integer>{
            'Planned' => 0,
            'In Progress' => 0,
            'Completed' => 0,
            'Cancelled' => 0,
            'Missed' => 0
        };

        for (AggregateResult ar : [
            SELECT Status__c status, COUNT(Id) total
            FROM Visit__c
            GROUP BY Status__c
        ]) {
            stats.put(
                (String) ar.get('status'),
                (Integer) ar.get('total')
            );
        }

        return stats;
    }

    public static Visit__c getVisit(Id visitId){

    return [

        SELECT

            Id,

            Status__c,

            Check_In_Time__c,

            Check_Out_Time__c,

            Representative__c,

            Visit_Date__c

        FROM Visit__c

        WHERE Id=:visitId

        LIMIT 1

    ];

}


}