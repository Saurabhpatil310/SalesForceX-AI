public with sharing class DashboardService {

    public static Map<String, Integer> getTeamStatistics() {

        return VisitSelector.getTeamStatistics();

    }


public static List<RepresentativePerformanceWrapper>
getRepresentativePerformance() {

    Map<Id, RepresentativePerformanceWrapper> performance =
        new Map<Id, RepresentativePerformanceWrapper>();

    for (AggregateResult ar :
        VisitSelector.getRepresentativePerformance()
    ) {

        Id representativeId =
            (Id) ar.get('representativeId');

        String representativeName =
            (String) ar.get('representativeName');

        String status =
            (String) ar.get('status');

        Integer count =
            (Integer) ar.get('totalVisits');

        if (!performance.containsKey(representativeId)) {

            performance.put(
                representativeId,
                new RepresentativePerformanceWrapper(
                    representativeId,
                    representativeName
                )
            );
        }

        RepresentativePerformanceWrapper result =
            performance.get(representativeId);

        result.totalVisits += count;

        if (status == 'Completed') {

            result.completedVisits += count;

        }
    }

    for (
        RepresentativePerformanceWrapper result :
        performance.values()
    ) {

        if (result.totalVisits > 0) {

            result.completionPercentage =
                (
                    Decimal.valueOf(result.completedVisits)
                    /
                    Decimal.valueOf(result.totalVisits)
                ) * 100;

            result.completionPercentage =
                result.completionPercentage.setScale(1);
        }
    }

    return performance.values();
}


public static List<Visit__c> getUpcomingVisits() {

    return VisitSelector.getUpcomingVisits();

}


}

