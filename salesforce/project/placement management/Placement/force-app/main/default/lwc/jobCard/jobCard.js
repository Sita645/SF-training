import { LightningElement, api } from 'lwc';

export default class JobCard extends LightningElement {

    @api job;

    @api isSubmitting = false;


    // ============================================================
    // VIEW DETAILS
    // ============================================================

    handleViewDetails() {

        const viewDetailsEvent = new CustomEvent(
            'viewdetails',
            {
                detail: {
                    jobId: this.job.Id
                }
            }
        );

        this.dispatchEvent(viewDetailsEvent);
    }


    // ============================================================
    // APPLY
    // ============================================================

    handleApply() {

        const applyEvent = new CustomEvent(
            'apply',
            {
                detail: {
                    jobId: this.job.Id
                }
            }
        );

        this.dispatchEvent(applyEvent);
    }


    // ============================================================
    // APPLY BUTTON LABEL
    // ============================================================

    get applyButtonLabel() {

        return this.isSubmitting
            ? 'Submitting...'
            : 'Apply';
    }
}