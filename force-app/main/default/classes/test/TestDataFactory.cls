@IsTest
public class TestDataFactory {

    public static Visit__c createVisit(
        Id representativeId,
        String status,
        Date visitDate,
        Boolean doInsert
    ) {

        Visit__c visit = new Visit__c();

        visit.Status__c = status;
        visit.Visit_Date__c = visitDate;
        visit.Representative__c = representativeId;

        if (status == VisitConstants.STATUS_IN_PROGRESS ||
    status == VisitConstants.STATUS_COMPLETED) {

    visit.Check_In_Time__c = System.now().addMinutes(-60);
}

if (status == VisitConstants.STATUS_COMPLETED) {

    visit.Check_Out_Time__c = System.now().addMinutes(-15);
}

        if (doInsert) {
            insert visit;
        }

        return visit;
    }

    public static User createUser(
    String lastName,
    Boolean doInsert
) {

    String uniqueValue =
        String.valueOf(DateTime.now().getTime());

    User user = new User(

        FirstName = 'Test',

        LastName = lastName,

        Alias = 'tstusr',

        Email =
            'test' + uniqueValue + '@example.com',

        Username =
            'test' + uniqueValue +
            '@salesforcexai.example',

        ProfileId =
            UserInfo.getProfileId(),

        TimeZoneSidKey = 'Asia/Kolkata',

        LocaleSidKey = 'en_IN',

        EmailEncodingKey = 'UTF-8',

        LanguageLocaleKey = 'en_US'

    );

    if (doInsert) {
        insert user;
    }

    return user;
}


public static List<Visit__c> createVisits(
    Id representativeId,
    Integer numberOfVisits,
    String status,
    Boolean doInsert
) {

    List<Visit__c> visits =
        new List<Visit__c>();

    for (Integer i = 0; i < numberOfVisits; i++) {

        visits.add(
            createVisit(
                representativeId,
                status,
                Date.today(),
                false
            )
        );
    }

    if (doInsert && !visits.isEmpty()) {
        insert visits;
    }

    return visits;
}


}
