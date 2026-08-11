# jobCard.js

## Purpose

Controls the reusable Job Card and communicates user actions to the parent component.

## Code

```javascript
import { LightningElement, api } from 'lwc';


export default class JobCard extends LightningElement {

    @api job;

    @api isSubmitting = false;


    handleViewDetails() {

        const viewDetailsEvent =
            new CustomEvent(
                'viewdetails',
                {
                    detail: {
                        jobId: this.job.Id
                    }
                }
            );

        this.dispatchEvent(
            viewDetailsEvent
        );
    }


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

        this.dispatchEvent(
            applyEvent
        );
    }


    get applyButtonLabel() {

        return this.isSubmitting
            ? 'Submitting...'
            : 'Apply';
    }
}
