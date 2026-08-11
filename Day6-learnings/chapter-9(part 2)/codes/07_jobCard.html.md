<template>

    <lightning-card title={job.Name}>

        <div class="slds-p-around_medium">

            <p>
                <strong>Location:</strong>
                {job.Location__c}
            </p>

            <p>
                <strong>Package:</strong>
                {job.Package_CTC__c}
            </p>

            <p>
                <strong>Minimum CGPA:</strong>
                {job.Minimum_CGPA__c}
            </p>

            <p>
                <strong>Maximum Backlogs:</strong>
                {job.Maximum_Backlogs__c}
            </p>

            <p>
                <strong>Application Deadline:</strong>
                {job.Application_Deadline__c}
            </p>

            <div class="slds-m-top_small">

                <lightning-button
                    label={applyButtonLabel}
                    variant="brand"
                    onclick={handleApply}
                    disabled={isSubmitting}>
                </lightning-button>

            </div>

        </div>

    </lightning-card>

</template>
