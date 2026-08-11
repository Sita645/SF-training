import { LightningElement } from 'lwc';

import getEligibleJobs
from '@salesforce/apex/EligibleJobsController.getEligibleJobs';

import submitApplication
from '@salesforce/apex/ApplicationController.submitApplication';


export default class EligibleJobs extends LightningElement {

    studentId = '';

    jobs = [];

    error;

    isLoading = false;

    isSubmitting = false;

    successMessage = '';

    applicationError = '';


    handleStudentIdChange(event) {

        this.studentId =
            event.target.value;

    }


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


    loadEligibleJobs() {

        this.isLoading = true;

        this.error = undefined;

        getEligibleJobs({
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

        })

        .finally(() => {

            this.isLoading = false;

        });
    }


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

        return 'Application submission failed. Please try again.';
    }


    get hasJobs() {

        return this.jobs.length > 0;

    }


    get isEmpty() {

        return !this.isLoading &&
               !this.error &&
               this.jobs.length === 0;

    }
}
