import { LightningElement, api } from 'lwc';

export default class JobCard extends LightningElement {

    @api job;

    @api isSubmitting = false;


    handleApply() {

        const applyEvent =
            new CustomEvent(
                'apply',
                {
                    detail: {
                        jobId: this.job.Id
                    }
                }
            );

        this.dispatchEvent(applyEvent);
    }


    get applyButtonLabel() {

        return this.isSubmitting
            ? 'Submitting...'
            : 'Apply';

    }
}
