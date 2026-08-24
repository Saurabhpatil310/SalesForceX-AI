public with sharing class SecurityService {

    public static void requireManagerAccess() {

        if (
            !FeatureManagement.checkPermission(
                'SalesForceX_AI_Manager_Access'
            )
        ) {

            throw new AuraHandledException(
                'You do not have Manager Dashboard access.'
            );

        }

    }

}
