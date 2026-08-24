@IsTest
private class SecurityServiceTest {

    @TestSetup
    static void setupData() {

        User managerUser = TestDataFactory.createUser(
            'Manager',
            true
        );

        User salesRepUser = TestDataFactory.createUser(
            'SalesRep',
            true
        );

    }


    @IsTest
    static void testManagerAccess() {

        User managerUser = [
            SELECT Id
            FROM User
            WHERE LastName = 'Manager'
            LIMIT 1
        ];

        System.runAs(managerUser) {

            Test.startTest();

            Map<String, Integer> result =
                ManagerDashboardController.getTeamStatistics();

            Test.stopTest();

            System.assertNotEquals(
                null,
                result,
                'Manager should be able to access team statistics.'
            );
        }
    }


    @IsTest
    static void testSalesRepAccessDenied() {

        User salesRepUser = [
            SELECT Id
            FROM User
            WHERE LastName = 'SalesRep'
            LIMIT 1
        ];

        System.runAs(salesRepUser) {

            Test.startTest();

            try {

                ManagerDashboardController.getTeamStatistics();

                System.assert(
                    false,
                    'Expected authorization failure.'
                );

            } catch (AuraHandledException ex) {

                System.assert(
                    ex.getMessage().contains(
                        'Manager Dashboard'
                    ),
                    'Expected Manager Dashboard access error.'
                );
            }

            Test.stopTest();
        }
    }
}