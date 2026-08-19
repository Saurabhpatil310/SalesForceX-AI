@IsTest
private class VisitServiceTest {

    @TestSetup
    static void setupData() {

        User representative =
            TestDataFactory.createUser(
                'Representative',
                true
            );

        TestDataFactory.createVisit(
            representative.Id,
            VisitConstants.STATUS_PLANNED,
            Date.today(),
            true
        );
    }

    @IsTest
static void testCheckIn() {

    Visit__c visit = [
        SELECT
            Id,
            Status__c,
            Check_In_Time__c
        FROM Visit__c
        LIMIT 1
    ];

    Test.startTest();

    VisitService.checkIn(visit.Id);

    Test.stopTest();

    Visit__c updatedVisit = [
        SELECT
            Status__c,
            Check_In_Time__c
        FROM Visit__c
        WHERE Id = :visit.Id
    ];

    System.assertEquals(
        VisitConstants.STATUS_IN_PROGRESS,
        updatedVisit.Status__c
    );

    System.assertNotEquals(
        null,
        updatedVisit.Check_In_Time__c
    );
}

@IsTest
static void testCheckOut() {

    Visit__c visit = [
        SELECT Id
        FROM Visit__c
        LIMIT 1
    ];

    VisitService.checkIn(visit.Id);

    Test.startTest();

    visit.Check_In_Time__c =
    System.now().addMinutes(-30);

    update visit;

    VisitService.checkOut(visit.Id);

    Test.stopTest();

    Visit__c updatedVisit = [
        SELECT
            Check_In_Time__c,
            Check_Out_Time__c
        FROM Visit__c
        WHERE Id = :visit.Id
    ];

    System.assertNotEquals(
        null,
        updatedVisit.Check_In_Time__c
    );

    System.assertNotEquals(
        null,
        updatedVisit.Check_Out_Time__c
    );
}

@IsTest
static void testCompleteVisit() {

    Visit__c visit = [
        SELECT Id, Status__c, Check_In_Time__c, Check_Out_Time__c
        FROM Visit__c
        LIMIT 1
    ];

    // Prepare the Visit as if the user has already
    // checked in and checked out.
    visit.Check_In_Time__c =
        System.now().addMinutes(-60);

    visit.Check_Out_Time__c =
        System.now().addMinutes(-30);

    visit.Status__c =
        VisitConstants.STATUS_IN_PROGRESS;

    update visit;

    Test.startTest();

    VisitService.completeVisit(visit.Id);

    Test.stopTest();

    Visit__c updatedVisit = [
        SELECT Status__c,
               Check_In_Time__c,
               Check_Out_Time__c
        FROM Visit__c
        WHERE Id = :visit.Id
    ];

    System.assertEquals(
        VisitConstants.STATUS_COMPLETED,
        updatedVisit.Status__c,
        'Visit should be marked as Completed.'
    );

    System.assertNotEquals(
        null,
        updatedVisit.Check_In_Time__c,
        'Check In Time should exist.'
    );

    System.assertNotEquals(
        null,
        updatedVisit.Check_Out_Time__c,
        'Check Out Time should exist.'
    );
}


@IsTest
static void testCheckoutWithoutCheckin() {

    Visit__c visit = [
        SELECT Id, Status__c, Check_In_Time__c, Check_Out_Time__c
        FROM Visit__c
        LIMIT 1
    ];

    // Prepare visit that has NOT been checked in
    visit.Check_In_Time__c = null;
    visit.Check_Out_Time__c = null;

    visit.Status__c =
        VisitConstants.STATUS_PLANNED;

    update visit;

    Test.startTest();

    Boolean exceptionThrown = false;
    String exceptionMessage = '';

    try {

        VisitService.checkOut(visit.Id);

    } catch (AuraHandledException ex) {

        exceptionThrown = true;
        exceptionMessage = ex.getMessage();

    } catch (Exception ex) {

        exceptionThrown = true;
        exceptionMessage = ex.getMessage();

    }

    Test.stopTest();

    System.assert(
        exceptionThrown,
        'Expected exception was not thrown.'
    );

    System.assert(
        exceptionMessage.contains('Check In'),
        'Expected Check In validation message, but received: '
        + exceptionMessage
    );
}


@IsTest
static void testCompleteWithoutCheckout() {

    Visit__c visit = [
        SELECT Id, Status__c, Check_In_Time__c, Check_Out_Time__c
        FROM Visit__c
        LIMIT 1
    ];

    // Prepare visit as checked in but NOT checked out
    visit.Check_In_Time__c =
        System.now().addMinutes(-30);

    visit.Check_Out_Time__c = null;

    visit.Status__c =
        VisitConstants.STATUS_IN_PROGRESS;

    update visit;

    Test.startTest();

    Boolean exceptionThrown = false;
    String exceptionMessage = '';

    try {

        VisitService.completeVisit(visit.Id);

    } catch (AuraHandledException ex) {

        exceptionThrown = true;
        exceptionMessage = ex.getMessage();

    } catch (Exception ex) {

        exceptionThrown = true;
        exceptionMessage = ex.getMessage();

    }

    Test.stopTest();

    System.assert(
        exceptionThrown,
        'Expected exception was not thrown.'
    );

    System.assert(
        exceptionMessage.contains('Check Out'),
        'Expected Check Out validation message, but received: '
        + exceptionMessage
    );
}



}
