# studentProfile.html

## Purpose

Provides the UI for loading and editing a Student record.

## Code

```html
<template>

    <lightning-card title="Student Profile">

        <div class="slds-p-around_medium">

            <lightning-input
                type="text"
                label="Student Record ID"
                placeholder="Enter Student Record ID"
                value={studentRecordId}
                onchange={handleStudentIdChange}>
            </lightning-input>


            <div class="slds-m-top_medium">

                <lightning-button
                    variant="brand"
                    label="Load Profile"
                    onclick={handleLoadProfile}>
                </lightning-button>

            </div>


            <template if:true={errorMessage}>

                <div class="slds-m-top_medium">

                    <p class="slds-text-color_error">
                        {errorMessage}
                    </p>

                </div>

            </template>


            <template if:true={showForm}>

                <div class="slds-m-top_large">

                    <lightning-record-edit-form
                        record-id={studentRecordId}
                        object-api-name="Student__c"
                        onsuccess={handleSuccess}
                        onerror={handleError}>

                        <lightning-input-field
                            field-name="Name">
                        </lightning-input-field>


                        <lightning-input-field
                            field-name="Student_ID__c"
                            disabled>
                        </lightning-input-field>


                        <lightning-input-field
                            field-name="Email__c"
                            required>
                        </lightning-input-field>


                        <lightning-input-field
                            field-name="Department__c"
                            required>
                        </lightning-input-field>


                        <lightning-input-field
                            field-name="CGPA__c"
                            required>
                        </lightning-input-field>


                        <lightning-input-field
                            field-name="Active_Backlogs__c"
                            required>
                        </lightning-input-field>


                        <lightning-input-field
                            field-name="Batch_Year__c"
                            required>
                        </lightning-input-field>


                        <div class="slds-m-top_medium">

                            <lightning-button
                                type="submit"
                                variant="brand"
                                label="Save Profile">
                            </lightning-button>

                        </div>

                    </lightning-record-edit-form>

                </div>

            </template>


            <template if:true={successMessage}>

                <div class="slds-m-top_medium">

                    <p class="slds-text-color_success">
                        ✓ {successMessage}
                    </p>

                </div>

            </template>

        </div>

    </lightning-card>

</template>
