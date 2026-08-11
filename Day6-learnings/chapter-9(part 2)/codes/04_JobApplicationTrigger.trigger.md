trigger JobApplicationTrigger
on Job_Application__c (before insert) {

    if (Trigger.isBefore && Trigger.isInsert) {

        ApplicationService.validateApplications(
            Trigger.new
        );
    }
}
