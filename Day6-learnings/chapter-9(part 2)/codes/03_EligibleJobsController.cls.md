public with sharing class EligibleJobsController {

    @AuraEnabled
    public static List<Job__c> getEligibleJobs(
        Id studentId
    ) {
        return ApplicationService.getEligibleJobs(
            studentId
        );
    }
}
