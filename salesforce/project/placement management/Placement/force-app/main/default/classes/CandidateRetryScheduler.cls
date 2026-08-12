global with sharing class CandidateRetryScheduler
    implements Schedulable {

    global void execute(SchedulableContext context) {

        List<Job_Application__c> applications = [
            SELECT Id,
                   Integration_Status__c,
                   External_Candidate_Id__c
            FROM Job_Application__c
            WHERE Integration_Status__c = 'Retry Required'
            AND External_Candidate_Id__c = null
            LIMIT 50
        ];

        for (Job_Application__c application : applications) {

            System.enqueueJob(
                new CandidateSyncQueueable(
                    application.Id
                )
            );
        }
    }
}