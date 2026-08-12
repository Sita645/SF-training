import { LightningElement } from 'lwc';

import getEligibleJobs
from '@salesforce/apex/EligibleJobsController.getEligibleJobs';

import submitApplication
from '@salesforce/apex/ApplicationController.submitApplication';

import {
    registerRefreshHandler,
    unregisterRefreshHandler
} from 'lightning/refresh';


export default class EligibleJobs extends LightningElement {

    studentId = '';

    jobs = [];

    error;

    isLoading = false;

    isSubmitting = false;

    successMessage = '';

    applicationError = '';

    refreshHandlerId;


    // ============================================================
    // COMPONENT CONNECTED
    // ============================================================

    connectedCallback() {

        this.refreshHandlerId =
            registerRefreshHandler(
                this,
                this.handleRefresh.bind(this)
            );
    }


    // ============================================================
    // COMPONENT DISCONNECTED
    // ============================================================

    disconnectedCallback() {

        if (this.refreshHandlerId) {

            unregisterRefreshHandler(
                this.refreshHandlerId
            );
        }
    }


    // ============================================================
    // REFRESH HANDLER
    // ============================================================

    handleRefresh() {

        if (!this.studentId) {

            return Promise.resolve(true);
        }


        return this.loadEligibleJobs()
            .then(() => true)
            .catch(() => false);
    }


    // ============================================================
    // STUDENT ID CHANGE
    // ============================================================

    handleStudentIdChange(event) {

        this.studentId =
            event.target.value.trim();

        this.error = undefined;

        this.successMessage = '';

        this.applicationError = '';
    }


    // ============================================================
    // CHECK ELIGIBILITY
    // ============================================================

    handleCheckEligibility() {

        if (!this.studentId) {

            this.error =
                'Please enter a Student Record ID.';

            this.jobs = [];

            return;
        }


        this.successMessage = '';

        this.applicationError = '';

        this.loadEligibleJobs();
    }


    // ============================================================
    // LOAD ELIGIBLE JOBS
    // ============================================================

    loadEligibleJobs() {

        this.isLoading = true;

        this.error = undefined;


        return getEligibleJobs({

            studentId: this.studentId

        })

        .then(result => {

            this.jobs = result;

        })

        .catch(error => {

            this.jobs = [];

            console.error(
                'Eligibility error:',
                error
            );

            this.error =
                this.getErrorMessage(error);

            throw error;

        })

        .finally(() => {

            this.isLoading = false;

        });
    }


    // ============================================================
    // VIEW DETAILS
    // ============================================================

    handleViewDetails(event) {

        const jobId =
            event.detail.jobId;

        console.log(
            'View Details Job Id:',
            jobId
        );
    }


    // ============================================================
    // APPLY
    // ============================================================

    handleApply(event) {

        const jobId =
            event.detail.jobId;

        this.isSubmitting = true;

        this.successMessage = '';

        this.applicationError = '';


        submitApplication({

            studentId: this.studentId,

            jobId: jobId

        })

        .then(applicationId => {

            console.log(
                'Application Created:',
                applicationId
            );

            this.successMessage =
                'Application submitted successfully.';

        })

        .catch(error => {

            console.error(
                'Application submission failed:',
                error
            );

            this.applicationError =
                this.getErrorMessage(error);

        })

        .finally(() => {

            this.isSubmitting = false;

        });
    }


    // ============================================================
    // ERROR MESSAGE
    // ============================================================

    getErrorMessage(error) {

        if (
            error &&
            error.body &&
            error.body.message
        ) {

            return error.body.message;
        }


        if (
            error &&
            error.message
        ) {

            return error.message;
        }


        return 'An unexpected error occurred.';
    }


    // ============================================================
    // HAS JOBS
    // ============================================================

    get hasJobs() {

        return this.jobs.length > 0;
    }


    // ============================================================
    // EMPTY STATE
    // ============================================================

    get isEmpty() {

        return !this.isLoading &&
               !this.error &&
               this.jobs.length === 0;
    }
}