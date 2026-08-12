@IsTest
private class CandidateHistoricalSyncBatchTest {

    @TestSetup
    static void createTestData() {

        // -----------------------------
        // STUDENT
        // -----------------------------

        Student__c student = new Student__c();

        student.Name =
            'Historical Test Student';

        student.Student_ID__c =
            'HIST001';

        student.Email__c =
            'historical@test.com';

        student.Department__c =
            'CSE';

        student.Batch_Year__c =
            2026;

        student.CGPA__c =
            8.5;

        insert student;


        // -----------------------------
        // COMPANY
        // -----------------------------

        Company__c company =
            new Company__c();

        company.Name =
            'Historical Test Company';

        company.Industry__c =
            'IT';

        company.Recruiter_Name__c =
            'Test Recruiter';

        company.Recruiter_Email__c =
            'recruiter@test.com';

        insert company;


        // -----------------------------
        // JOB
        // -----------------------------

        Job__c job =
            new Job__c();

        job.Name =
            'Historical Developer Job';

        job.Company__c =
            company.Id;

        job.Job_Type__c =
            'Full Time';

        job.Location__c =
            'Hyderabad';

        job.Package_CTC__c =
            8;

        job.Minimum_CGPA__c =
            7;

        job.Application_Deadline__c =
            Date.today().addDays(30);

        insert job;


        // -----------------------------
        // JOB APPLICATION
        // -----------------------------

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


    // ---------------------------------
    // TEST BATCH
    // ---------------------------------

    @IsTest
    static void testBatchExecution() {

        Test.startTest();

        Id batchId =
            Database.executeBatch(
                new CandidateHistoricalSyncBatch(),
                200
            );

        Test.stopTest();

        System.assertNotEquals(
            null,
            batchId,
            'Batch job should be created.'
        );
    }


    // ---------------------------------
    // TEST SCHEDULER
    // ---------------------------------

    @IsTest
    static void testSchedulerExecution() {

        Test.startTest();

        String jobId =
            System.schedule(
                'Historical Sync Test',
                '0 0 3 * * ?',
                new CandidateHistoricalSyncScheduler()
            );

        Test.stopTest();

        System.assertNotEquals(
            null,
            jobId,
            'Scheduled job should be created.'
        );
    }
}