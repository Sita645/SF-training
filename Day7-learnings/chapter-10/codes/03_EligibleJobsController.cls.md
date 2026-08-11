# EligibleJobsController.cls

## Purpose

Provides eligible-job data to the `eligibleJobs` Lightning Web Component.

## Code

```apex
public with sharing class EligibleJobsController {

    @AuraEnabled(cacheable=true)
    public static List<Job__c> getEligibleJobs(
        Id studentId
    ) {

        if (studentId == null) {

            throw new AuraHandledException(
                'Student Record ID is required.'
            );
        }

        return ApplicationService.getEligibleJobs(
            studentId
        );
    }
}
