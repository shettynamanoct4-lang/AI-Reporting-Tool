import { LightningElement,api } from 'lwc';

export default class Assignment7Child extends LightningElement {
    @api opportunity;

    handleRowClick() {
        const event = new CustomEvent('opportunityselect', {
            detail: this.opportunity
        });
        this.dispatchEvent(event);
    }
}