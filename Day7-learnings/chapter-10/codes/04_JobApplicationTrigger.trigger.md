# JobApplicationTrigger.trigger

## Purpose

Handles validation during Job Application creation.

## Code

```apex
trigger JobApplicationTrigger
    on Job_Application__c (before insert) {

    ApplicationService.validateApplications(
        Trigger.new
    );
}
