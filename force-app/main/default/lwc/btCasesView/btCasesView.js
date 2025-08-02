import { LightningElement, track } from 'lwc';
import createCase from '@salesforce/apex/BTCaseController.createCase';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BtCasesView extends LightningElement {
    @track subject = '';
    @track description = '';
    @track isSubmitted = false;
    @track caseNumber = '';

    handleChange(event) {
        this[event.target.name] = event.target.value;
    }

    handleSubmit() {
        if (!this.subject || !this.description) {
            this.showToast('Missing Fields', 'Please fill in all required fields.', 'error');
            return;
        }

        createCase({ subject: this.subject, description: this.description })
            .then(result => {
                this.caseNumber = result;
                console.log(result);
                console.log('caseNumber: ' + this.caseNumber);
             
                this.isSubmitted = true;
                this.showToast('Success', 'Case created successfully!', 'success');
            })
            .catch(error => {
                console.error(error);
                this.showToast('Error', 'Error creating case. Please try again later.', 'error');
            });
    }

    resetForm() {
        this.subject = '';
        this.description = '';
        this.caseNumber = '';
        this.isSubmitted = false;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}