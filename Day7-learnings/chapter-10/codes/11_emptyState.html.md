# emptyState.html

## Purpose

Reusable UI component for displaying a meaningful empty state.

## Code

```html
<template>

    <div class="slds-p-around_large slds-text-align_center">

        <div class="slds-m-bottom_small">

            <lightning-icon
                icon-name="utility:info"
                alternative-text="Information"
                size="small">
            </lightning-icon>

        </div>


        <h2 class="slds-text-heading_medium">

            {title}

        </h2>


        <p class="slds-m-top_small slds-text-color_weak">

            {message}

        </p>


        <template if:true={showAction}>

            <div class="slds-m-top_medium">

                <lightning-button
                    variant="brand-outline"
                    label={actionLabel}
                    onclick={handleAction}>
                </lightning-button>

            </div>

        </template>

    </div>

</template>
