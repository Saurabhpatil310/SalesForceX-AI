@IsTest
private class ManagerDashboardControllerTest {

    @TestSetup
    static void setupData() {

        User representative =
            TestDataFactory.createUser(
                'Representative',
                true
            );

        TestDataFactory.createVisits(
            representative.Id,
            5,
            VisitConstants.STATUS_COMPLETED,
            true
        );

        TestDataFactory.createVisits(
            representative.Id,
            2,
            VisitConstants.STATUS_PLANNED,
            true
        );

    }

    @IsTest
static void testTeamStatistics() {

    Test.startTest();

    Map<String, Integer> result =
        ManagerDashboardController.getTeamStatistics();

    Test.stopTest();

    System.assertEquals(
        7,
        result.get('Total')
    );

    System.assertEquals(
        5,
        result.get('Completed')
    );

    System.assertEquals(
        2,
        result.get('Planned')
    );

}

@IsTest
static void testRepresentativePerformance() {

    Test.startTest();

    List<RepresentativePerformanceWrapper>
        results =
        ManagerDashboardController.getRepresentativePerformance();

    Test.stopTest();

    System.assertEquals(
        1,
        results.size()
    );

    RepresentativePerformanceWrapper result =
        results[0];

    System.assertEquals(
        7,
        result.totalVisits
    );

    System.assertEquals(
        5,
        result.completedVisits
    );

    System.assertEquals(
        71.4,
        result.completionPercentage
    );

}

@IsTest
static void testUpcomingVisits() {

    Test.startTest();

    List<Visit__c> visits =
        ManagerDashboardController.getUpcomingVisits();

    Test.stopTest();

    System.assertEquals(
        2,
        visits.size()
    );

    for (Visit__c visit : visits) {

        System.assertEquals(
            VisitConstants.STATUS_PLANNED,
            visit.Status__c
        );

    }

}



}
