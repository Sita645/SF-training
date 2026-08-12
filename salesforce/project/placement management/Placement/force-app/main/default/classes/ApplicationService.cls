public with sharing class ApplicationService {

    // ============================================================
    // GET ELIGIBLE JOBS
    // Used by EligibleJobsController / LWC
    // ============================================================

    public static List<Job__c> getEligibleJobs(Id studentId) {

        if (studentId == null) {
            throw new AuraHandledException(
                'Student Record ID is required.'
            );
        }

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


    // ============================================================
    // VALIDATE APPLICATIONS
    // Called by JobApplicationTrigger BEFORE INSERT
    // ============================================================

    public static void validateApplications(
        List<Job_Application__c> applications
    ) {

        if (
            applications == null ||
            applications.isEmpty()
        ) {
            return;
        }

        Set<Id> studentIds =
            new Set<Id>();

        Set<Id> jobIds =
            new Set<Id>();


        // Collect related Student and Job IDs
        for (
            Job_Application__c application :
            applications
        ) {

            if (application.Student__c != null) {
                studentIds.add(
                    application.Student__c
                );
            }

            if (application.Job__c != null) {
                jobIds.add(
                    application.Job__c
                );
            }
        }


        // ========================================================
        // Query Students
        // ========================================================

        Map<Id, Student__c> studentsById =
            new Map<Id, Student__c>();

        if (!studentIds.isEmpty()) {

            studentsById =
                new Map<Id, Student__c>([
                    SELECT Id,
                           CGPA__c,
                           Active_Backlogs__c
                    FROM Student__c
                    WHERE Id IN :studentIds
                ]);
        }


        // ========================================================
        // Query Jobs
        // ========================================================

        Map<Id, Job__c> jobsById =
            new Map<Id, Job__c>();

        if (!jobIds.isEmpty()) {

            jobsById =
                new Map<Id, Job__c>([
                    SELECT Id,
                           Minimum_CGPA__c,
                           Maximum_Backlogs__c,
                           Application_Deadline__c
                    FROM Job__c
                    WHERE Id IN :jobIds
                ]);
        }


        // ========================================================
        // Validate Each Application
        // ========================================================

        for (
            Job_Application__c application :
            applications
        ) {

            // Student required
            if (application.Student__c == null) {

                application.addError(
                    'Student is required.'
                );

                continue;
            }


            // Job required
            if (application.Job__c == null) {

                application.addError(
                    'Job is required.'
                );

                continue;
            }


            Student__c student =
                studentsById.get(
                    application.Student__c
                );

            Job__c job =
                jobsById.get(
                    application.Job__c
                );


            // Student not found
            if (student == null) {

                application.addError(
                    'Student record could not be found.'
                );

                continue;
            }


            // Job not found
            if (job == null) {

                application.addError(
                    'Job record could not be found.'
                );

                continue;
            }


            // ====================================================
            // CGPA Validation
            // ====================================================

            if (
                student.CGPA__c == null ||
                job.Minimum_CGPA__c == null ||
                student.CGPA__c <
                job.Minimum_CGPA__c
            ) {

                application.addError(
                    'Student does not meet the minimum CGPA requirement.'
                );

                continue;
            }


            // ====================================================
            // Backlog Validation
            // ====================================================

            if (
                student.Active_Backlogs__c == null ||
                job.Maximum_Backlogs__c == null ||
                student.Active_Backlogs__c >
                job.Maximum_Backlogs__c
            ) {

                application.addError(
                    'Student does not meet the maximum backlog requirement.'
                );

                continue;
            }


            // ====================================================
            // Deadline Validation
            // ====================================================

            if (
                job.Application_Deadline__c == null ||
                job.Application_Deadline__c < Date.today()
            ) {

                application.addError(
                    'The application deadline has passed.'
                );

                continue;
            }
        }
    }


    // ============================================================
    // SUBMIT APPLICATION
    // Called by ApplicationController from LWC
    // ============================================================

    public static Id submitApplication(
        Id studentId,
        Id jobId
    ) {

        try {

            // ====================================================
            // 1. Validate Input
            // ====================================================

            if (studentId == null) {

                throw new AuraHandledException(
                    'Student Record ID is required.'
                );
            }

            if (jobId == null) {

                throw new AuraHandledException(
                    'Job ID is required.'
                );
            }


            // ====================================================
            // 2. Retrieve Student
            // ====================================================

            Student__c student = [
                SELECT Id,
                       Name,
                       CGPA__c,
                       Active_Backlogs__c
                FROM Student__c
                WHERE Id = :studentId
                LIMIT 1
            ];


            // ====================================================
            // 3. Retrieve Job
            // ====================================================

            Job__c selectedJob = [
                SELECT Id,
                       Name,
                       Minimum_CGPA__c,
                       Maximum_Backlogs__c,
                       Application_Deadline__c
                FROM Job__c
                WHERE Id = :jobId
                LIMIT 1
            ];


            // ====================================================
            // 4. Check Application Deadline
            // ====================================================

            if (
                selectedJob.Application_Deadline__c == null ||
                selectedJob.Application_Deadline__c < Date.today()
            ) {

                throw new AuraHandledException(
                    'The application deadline has passed.'
                );
            }


            // ====================================================
            // 5. Check CGPA Eligibility
            // ====================================================

            if (
                student.CGPA__c == null ||
                selectedJob.Minimum_CGPA__c == null ||
                student.CGPA__c <
                selectedJob.Minimum_CGPA__c
            ) {

                throw new AuraHandledException(
                    'You are not eligible based on CGPA.'
                );
            }


            // ====================================================
            // 6. Check Backlog Eligibility
            // ====================================================

            if (
                student.Active_Backlogs__c == null ||
                selectedJob.Maximum_Backlogs__c == null ||
                student.Active_Backlogs__c >
                selectedJob.Maximum_Backlogs__c
            ) {

                throw new AuraHandledException(
                    'You are not eligible based on active backlogs.'
                );
            }


            // ====================================================
            // 7. Check Duplicate Application
            // ====================================================

            List<Job_Application__c>
                existingApplications = [

                SELECT Id,
                       Name
                FROM Job_Application__c
                WHERE Student__c = :studentId
                AND Job__c = :jobId
                LIMIT 1
            ];


            if (
                !existingApplications.isEmpty()
            ) {

                throw new AuraHandledException(
                    'You have already applied for this job.'
                );
            }


            // ====================================================
            // 8. Create Job Application
            // ====================================================

            Job_Application__c application =
                new Job_Application__c();

            application.Student__c =
                studentId;

            application.Job__c =
                jobId;


            // ====================================================
            // 9. Save Record
            // ====================================================

            insert application;


            // ====================================================
            // 10. Return Application ID
            // ====================================================

            return application.Id;
        }


        // ========================================================
        // Handle Business Errors
        // ========================================================

        catch (AuraHandledException e) {

            throw e;
        }


        // ========================================================
        // Handle DML Errors
        // ========================================================

        catch (DmlException e) {

            AuraHandledException error =
                new AuraHandledException(
                    'Application could not be saved: ' +
                    e.getDmlMessage(0)
                );

            error.setMessage(
                'Application could not be saved: ' +
                e.getDmlMessage(0)
            );

            throw error;
        }


        // ========================================================
        // Handle Query Errors
        // ========================================================

        catch (QueryException e) {

            AuraHandledException error =
                new AuraHandledException(
                    'Unable to find the required Student or Job record.'
                );

            error.setMessage(
                'Unable to find the required Student or Job record.'
            );

            throw error;
        }


        // ========================================================
        // Handle Unexpected Errors
        // ========================================================

        catch (Exception e) {

            AuraHandledException error =
                new AuraHandledException(
                    'Application submission failed: ' +
                    e.getMessage()
                );

            error.setMessage(
                'Application submission failed: ' +
                e.getMessage()
            );

            throw error;
        }
    }
}