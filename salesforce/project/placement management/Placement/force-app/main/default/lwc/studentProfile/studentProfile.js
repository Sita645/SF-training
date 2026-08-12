import { LightningElement } from 'lwc';

import { RefreshEvent } from 'lightning/refresh';


export default class StudentProfile extends LightningElement {

    studentRecordId = '';

    showForm = false;

    errorMessage = '';

    successMessage = '';


    // ============================================================
    // STUDENT ID CHANGE
    // ============================================================

    handleStudentIdChange(event) {

        this.studentRecordId =
            event.target.value.trim();

        this.errorMessage = '';

        this.successMessage = '';

        this.showForm = false;
    }


    // ============================================================
    // LOAD PROFILE
    // ============================================================

    handleLoadProfile() {

        this.errorMessage = '';

        this.successMessage = '';


        if (!this.studentRecordId) {

            this.showForm = false;

            this.errorMessage =
                'Please enter a Student Record ID.';

            return;
        }


        this.showForm = true;
    }


    // ============================================================
    // SAVE SUCCESS
    // ============================================================

    handleSuccess(event) {

        console.log(
            'Student Profile Updated:',
            event.detail.id
        );


        this.successMessage =
            'Student profile updated successfully.';

        this.errorMessage = '';


        // Tell other components that Salesforce data changed.
        this.dispatchEvent(
            new RefreshEvent()
        );
    }


    // ============================================================
    // SAVE ERROR
    // ============================================================

    handleError(event) {

        console.error(
            'Student Profile Error:',
            event.detail
        );

        this.successMessage = '';

        this.errorMessage =
            'Unable to save the student profile. Please check the entered values and try again.';
    }
}