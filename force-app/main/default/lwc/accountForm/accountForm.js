import { LightningElement, track } from 'lwc';
import saveAccount from '@salesforce/apex/AccountFormController.saveAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountForm extends LightningElement {
    @track name = '';
    @track phone = '';
    @track numberOfEmployees = 0;
    @track errorMessage = '';

    handleInputChange(event) {
        const field = event.target.name;
        if (field === 'name') {
            this.name = event.target.value;
        } else if (field === 'phone') {
            this.phone = event.target.value;
        } else if (field === 'numberOfEmployees') {
            this.numberOfEmployees = event.target.value;
        }
    }

    handleSave() {
        const account = {
            Name: this.name,
            Phone: this.phone,
            NumberOfEmployees: this.numberOfEmployees
        };

        saveAccount({ accountJson: JSON.stringify(account) })
            .then(() => {
                this.errorMessage = '';
                this.showToast('Success', 'Account saved successfully!', 'success');
                // Reset form after success
                this.name = '';
                this.phone = '';
                this.numberOfEmployees = 0;
            })
            .catch((error) => {
                this.errorMessage = error.body.message;
                this.showToast('Error', this.errorMessage, 'error');
            });
    }

    // Method to display toast notifications
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}