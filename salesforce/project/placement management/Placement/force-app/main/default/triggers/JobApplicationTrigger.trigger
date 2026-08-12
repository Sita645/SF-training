trigger JobApplicationTrigger
    on Job_Application__c (
        before insert,
        before update,
        after insert,
        after update
    ) {


    /*
     * ============================================================
     * BEFORE INSERT
     * ============================================================
     */

    if (Trigger.isBefore && Trigger.isInsert) {

        ApplicationService.validateApplications(
            Trigger.new
        );
    }


    /*
     * ============================================================
     * AFTER INSERT
     * ============================================================
     */

    if (Trigger.isAfter && Trigger.isInsert) {

        for (Job_Application__c application :
             Trigger.new) {

            if (
                application.Application_Status__c ==
                'Selected'
            ) {

                System.enqueueJob(
                    new CandidateSyncQueueable(
                        application.Id
                    )
                );
            }
        }
    }


    /*
     * ============================================================
     * AFTER UPDATE
     * ============================================================
     */

    if (Trigger.isAfter && Trigger.isUpdate) {

        for (Job_Application__c application :
             Trigger.new) {

            Job_Application__c oldApplication =
                Trigger.oldMap.get(
                    application.Id
                );


            /*
             * Only start integration when
             * status changes to Selected.
             */

            if (
                application.Application_Status__c ==
                'Selected'
                &&
                oldApplication.Application_Status__c !=
                'Selected'
            ) {

                System.enqueueJob(
                    new CandidateSyncQueueable(
                        application.Id
                    )
                );
            }
        }
    }
}