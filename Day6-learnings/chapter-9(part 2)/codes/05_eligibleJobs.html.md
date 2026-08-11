<template>

    <lightning-card title="Eligible Jobs">

        <div class="slds-p-around_medium">

            <lightning-input
                type="text"
                label="Student Record ID"
                placeholder="Enter Student Record ID"
                value={studentId}
                onchange={handleStudentIdChange}>
            </lightning-input>

            <div class="slds-m-top_medium">

                <lightning-button
                    variant="brand"
                    label="Check Eligibility"
                    onclick={handleCheckEligibility}>
                </lightning-button>

            </div>

        </div>


        <template if:true={isLoading}>

            <div class="slds-p-around_medium">

                <lightning-spinner
                    alternative-text="Checking eligibility">
                </lightning-spinner>

                <p>
                    Checking eligibility...
                </p>

            </div>

        </template>


        <template if:true={error}>

            <div class="slds-p-around_medium">

                <p class="slds-text-color_error">
                    {error}
                </p>

            </div>

        </template>


        <template if:true={successMessage}>

            <div class="slds-p-around_medium">

                <p class="slds-text-color_success">
                    ✓ {successMessage}
                </p>

            </div>

        </template>


        <template if:true={applicationError}>

            <div class="slds-p-around_medium">

                <p class="slds-text-color_error">
                    {applicationError}
                </p>

            </div>

        </template>


        <template if:true={hasJobs}>

            <div class="slds-p-around_medium">

                <h2 class="slds-text-heading_medium">
                    Eligible Jobs
                </h2>

            </div>


            <template
                for:each={jobs}
                for:item="job">

                <c-job-card
                    key={job.Id}
                    job={job}
                    is-submitting={isSubmitting}
                    onapply={handleApply}>
                </c-job-card>

            </template>

        </template>


        <template if:true={isEmpty}>

            <div class="slds-p-around_medium">

                <p>
                    No eligible jobs are currently available.
                </p>

            </div>

        </template>

    </lightning-card>

</template>
