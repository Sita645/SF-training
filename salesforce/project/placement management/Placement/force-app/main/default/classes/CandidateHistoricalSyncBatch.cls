global class CandidateHistoricalSyncBatch
    implements Database.Batchable<SObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator(
            'SELECT Id, Application_Status__c, Integration_Status__c ' +
            'FROM Job_Application__c ' +
            'WHERE Application_Status__c = \'Selected\''
        );
    }


    global void execute(
        Database.BatchableContext bc,
        List<SObject> scope
    ) {

        List<Job_Application__c> applications =
            new List<Job_Application__c>();

        for (SObject record : scope) {

            Job_Application__c application =
                (Job_Application__c) record;

            application.Integration_Status__c =
                'Retry Required';

            applications.add(application);
        }


        if (!applications.isEmpty()) {

            update applications;
        }
    }


    global void finish(
        Database.BatchableContext bc
    ) {

        System.debug(
            'Candidate Historical Synchronisation completed.'
        );
    }
}