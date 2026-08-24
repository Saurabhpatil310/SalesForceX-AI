/**
 * Selector class for Visit__c data operations.
 */
public with sharing class VisitSelector {

   /**
     * Returns visits scheduled for today.
     *
     * @return List<Visit__c> visits for the current day
     */
    // public static List<Visit__c> getTodayVisits() {
    //     // Enforce CRUD: ensure the running user has read access to Visit__c
    //     if (!Schema.sObjectType.Visit__c.isAccessible()) {
    //         // Return empty list when no access to avoid unauthorized SOQL
    //         return new List<Visit__c>();
    //     }

    //     return [
    //         SELECT Id,
    //                Name,
    //                Doctor__r.Name,
    //                Status__c,
    //                Priority__c,
    //                Visit_Date__c,
    //                Representative__r.Name,
    //                Check_In_Time__c,
    //                Check_Out_Time__c
    //         FROM Visit__c
    //         WHERE Representative__c = :UserInfo.getUserId()
    //         AND Visit_Date__c = TODAY
    //         ORDER BY CreatedDate DESC
    //     ];
    // }

    public static List<Visit__c> getTodaysMyVisits() {

    Id currentUserId = UserInfo.getUserId();

    return [
        SELECT
            Id,
            Name,
            Doctor__r.Name,
            Representative__c,
            Representative__r.Name,
            Visit_Date__c,
            Status__c,
            Priority__c,
            Check_In_Time__c,
            Check_Out_Time__c

        FROM Visit__c

        WHERE
            Visit_Date__c = TODAY
            AND Representative__c = :currentUserId

        ORDER BY CreatedDate ASC
    ];
}


/**
     * Returns visits scheduled for today of all users.
     *
     * @return List<Visit__c> visits for the current day
     */
public static List<Visit__c> getTodaysTeamVisits() {

    return [
        SELECT
            Id,
            Name,
            Doctor__r.Name,
            Representative__c,
            Representative__r.Name,
            Visit_Date__c,
            Status__c,
            Priority__c,
            Check_In_Time__c,
            Check_Out_Time__c

        FROM Visit__c

        WHERE Visit_Date__c = TODAY

        ORDER BY CreatedDate ASC
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


public static Map<String, Integer> getTeamStatistics() {

    Map<String, Integer> stats =
        new Map<String, Integer>{
            'Total' => 0,
            'Planned' => 0,
            'In Progress' => 0,
            'Completed' => 0,
            'Missed' => 0,
            'Cancelled' => 0
        };

    for (AggregateResult ar : [

        SELECT
            Status__c status,
            COUNT(Id) total

        FROM Visit__c

        GROUP BY Status__c

    ]) {

        String status = (String) ar.get('status');

        Integer total =
            (Integer) ar.get('total');

        stats.put(status, total);

        stats.put(
            'Total',
            stats.get('Total') + total
        );
    }

    return stats;
}


public static List<AggregateResult> getRepresentativePerformance() {

    return [
        SELECT
            Representative__c representativeId,
            Representative__r.Name representativeName,
            Status__c status,
            COUNT(Id) totalVisits

        FROM Visit__c

        WHERE Representative__c != null

        GROUP BY
            Representative__c,
            Representative__r.Name,
            Status__c

        ORDER BY Representative__r.Name
    ];
}


public static List<Visit__c> getUpcomingVisits() {

    return [
        SELECT
            Id,
            Name,
            Doctor__r.Name,
            Representative__r.Name,
            Visit_Date__c,
            Status__c,
            Priority__c

        FROM Visit__c

        WHERE
            Visit_Date__c >= TODAY
            AND Status__c = 'Planned'

        ORDER BY Visit_Date__c ASC

        LIMIT 10
    ];
}





}