
# ApplicationService.cls

## Purpose

Contains the server-side business logic for student eligibility and job applications.

## Code

```apex
public with sharing class ApplicationService {

    /*
     * ============================================================
     * GET ELIGIBLE JOBS
     * ============================================================
     */

    public static List<Job__c> getEligibleJobs(Id studentId) {

        Student__c student = [
            SELECT Id,
                   CGPA__c,
                   Active_Backlogs__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];

        List<Job__c> jobs = [
            SELECT Id,
                   Name,
                   Minimum_CGPA__c,
                   Maximum_Backlogs__c,
                   Application_Deadline__c,
                   Location__c,
                   Package_CTC__c
            FROM Job__c
            WHERE Application_Deadline__c >= :Date.today()
            ORDER BY Application_Deadline__c ASC
        ];

        List<Job__c> eligibleJobs =
            new List<Job__c>();

        for (Job__c job : jobs) {

            Boolean cgpaEligible =
                student.CGPA__c != null &&
                job.Minimum_CGPA__c != null &&
                student.CGPA__c >= job.Minimum_CGPA__c;

            Boolean backlogEligible =
                student.Active_Backlogs__c != null &&
                job.Maximum_Backlogs__c != null &&
                student.Active_Backlogs__c <=
                    job.Maximum_Backlogs__c;

            if (cgpaEligible && backlogEligible) {
                eligibleJobs.add(job);
            }
        }

        return eligibleJobs;
    }


    /*
     * ============================================================
     * SUBMIT APPLICATION
     * ============================================================
     */

    @AuraEnabled
    public static Id submitApplication(
        Id studentId,
        Id jobId
    ) {

        if (studentId == null) {
            throw new AuraHandledException(
                'Student ID is required.'
            );
        }

        if (jobId == null) {
            throw new AuraHandledException(
                'Job ID is required.'
            );
        }


        /*
         * Get Student
         */

        Student__c student = [
            SELECT Id,
                   CGPA__c,
                   Active_Backlogs__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];


        /*
         * Get Job
         */

        Job__c job = [
            SELECT Id,
                   Name,
                   Minimum_CGPA__c,
                   Maximum_Backlogs__c,
                   Application_Deadline__c
            FROM Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];


        /*
         * Check Application Deadline
         */

        if (
            job.Application_Deadline__c != null &&
            job.Application_Deadline__c < Date.today()
        ) {

            throw new AuraHandledException(
                'Application deadline has passed.'
            );
        }


        /*
         * Check Eligibility
         */

        Boolean cgpaEligible =
            student.CGPA__c != null &&
            job.Minimum_CGPA__c != null &&
            student.CGPA__c >= job.Minimum_CGPA__c;

        Boolean backlogEligible =
            student.Active_Backlogs__c != null &&
            job.Maximum_Backlogs__c != null &&
            student.Active_Backlogs__c <=
                job.Maximum_Backlogs__c;


        if (!cgpaEligible) {

            throw new AuraHandledException(
                'You are not eligible based on the minimum CGPA requirement.'
            );
        }

        if (!backlogEligible) {

            throw new AuraHandledException(
                'You are not eligible based on the maximum backlog requirement.'
            );
        }


        /*
         * Check Duplicate Application
         */

        List<Job_Application__c> existingApplications = [
            SELECT Id
            FROM Job_Application__c
            WHERE Student__c = :studentId
            AND Job__c = :jobId
            LIMIT 1
        ];


        if (!existingApplications.isEmpty()) {

            throw new AuraHandledException(
                'You have already applied for this job.'
            );
        }


        /*
         * Create Application
         */

        Job_Application__c application =
            new Job_Application__c();

        application.Student__c = studentId;

        application.Job__c = jobId;

        application.Application_Date__c =
            Datetime.now();

        application.Application_Status__c =
            'Applied';

        insert application;

        return application.Id;
    }
}
