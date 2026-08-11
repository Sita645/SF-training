# emptyState.js

## Purpose

Controls the reusable Empty State component.

## Code

```javascript
import { LightningElement, api } from 'lwc';


export default class EmptyState extends LightningElement {

    @api title;

    @api message;

    @api actionLabel;


    get showAction() {

        return !!this.actionLabel;
    }


    handleAction() {

        this.dispatchEvent(
            new CustomEvent('action')
        );
    }
}
