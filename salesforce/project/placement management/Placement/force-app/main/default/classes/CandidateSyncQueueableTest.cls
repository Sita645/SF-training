@IsTest
private class CandidateSyncQueueableTest {

    // =========================================================
    // HTTP SUCCESS MOCK
    // =========================================================

    private class SuccessMock implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest request) {

            HttpResponse response = new HttpResponse();

            response.setStatusCode(201);

            response.setHeader(
                'Content-Type',
                'application/json'
            );

            response.setBody(
                '{"candidateId":"EXT-001"}'
            );

            return response;
        }
    }


    // =========================================================
    // TEST DATA
    // =========================================================

    @TestSetup
    static void createTestData() {

        // -----------------------------------------------------
        // CREATE STUDENT
        // -----------------------------------------------------

        Student__c student = new Student__c();

        student.Name = 'Test Student';

        student.Student_ID__c = 'TEST001';

        student.Email__c = 'test@example.com';

        student.Department__c = 'CSE';

        student.Batch_Year__c = 2026;

        student.CGPA__c = 8.5;

        insert student;


        // -----------------------------------------------------
        // CREATE COMPANY
        // -----------------------------------------------------

        Company__c company = new Company__c();

        company.Name = 'Test Company';

        company.Industry__c = 'IT';

        company.Recruiter_Name__c = 'Test Recruiter';

        company.Recruiter_Email__c = 'recruiter@test.com';

        insert company;


        // -----------------------------------------------------
        // CREATE JOB
        // -----------------------------------------------------

        Job__c job = new Job__c();

        job.Name = 'Test Developer Job';

        job.Company__c = company.Id;

        job.Job_Type__c = 'Full Time';

        job.Location__c = 'Hyderabad';

        job.Package_CTC__c = 8;

        job.Minimum_CGPA__c = 7;

        job.Application_Deadline__c =
            Date.today().addDays(30);

        insert job;


        // -----------------------------------------------------
        // CREATE JOB APPLICATION
        // -----------------------------------------------------

        Job_Application__c application =
            new Job_Application__c();

        application.Student__c =
            student.Id;

        application.Job__c =
            job.Id;

        application.Application_Status__c =
            'Selected';

        application.Application_Date__c =
            Date.today();

        insert application;
    }


    // =========================================================
    // TEST 1 - QUEUEABLE SUCCESS
    // =========================================================

    @IsTest
    static void testQueueableSuccess() {

        Test.setMock(
            HttpCalloutMock.class,
            new SuccessMock()
        );

        Job_Application__c application = [
            SELECT Id,
                   Integration_Status__c,
                   External_Candidate_Id__c
            FROM Job_Application__c
            LIMIT 1
        ];

        Test.startTest();

        System.enqueueJob(
            new CandidateSyncQueueable(
                application.Id
            )
        );

        Test.stopTest();


        Job_Application__c result = [
            SELECT Id,
                   Integration_Status__c,
                   External_Candidate_Id__c
            FROM Job_Application__c
            WHERE Id = :application.Id
        ];


        System.assertEquals(
            'Sent',
            result.Integration_Status__c
        );

        System.assertEquals(
            'EXT-001',
            result.External_Candidate_Id__c
        );
    }


    // =========================================================
    // TEST 2 - DUPLICATE PROTECTION
    // =========================================================

    @IsTest
    static void testDuplicateProtection() {

        Job_Application__c application = [
            SELECT Id,
                   External_Candidate_Id__c
            FROM Job_Application__c
            LIMIT 1
        ];


        application.External_Candidate_Id__c =
            'ALREADY-EXISTS';

        update application;


        Test.startTest();

        System.enqueueJob(
            new CandidateSyncQueueable(
                application.Id
            )
        );

        Test.stopTest();


        Job_Application__c result = [
            SELECT Id,
                   External_Candidate_Id__c
            FROM Job_Application__c
            WHERE Id = :application.Id
        ];


        System.assertEquals(
            'ALREADY-EXISTS',
            result.External_Candidate_Id__c
        );
    }


    // =========================================================
    // TEST 3 - RETRY SCHEDULER
    // =========================================================

    @IsTest
    static void testRetryScheduler() {

        Test.setMock(
            HttpCalloutMock.class,
            new SuccessMock()
        );


        Job_Application__c application = [
            SELECT Id,
                   Integration_Status__c,
                   External_Candidate_Id__c
            FROM Job_Application__c
            LIMIT 1
        ];


        application.Integration_Status__c =
            'Retry Required';

        application.External_Candidate_Id__c =
            null;

        update application;


        Test.startTest();

        String jobId =
            System.schedule(
                'Test Candidate Retry Scheduler',
                '0 0 2 * * ?',
                new CandidateRetryScheduler()
            );

        Test.stopTest();


        System.assertNotEquals(
            null,
            jobId
        );
    }
}