import { LightningElement,track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class assignment1 extends LightningElement {

    @track accountName = '';
    @track phone = '';
    @track industry = '';
    @track industryOptions = [
        { label: 'Sales', value: 'Sales' },
        { label: 'Service', value: 'Service' },
        // Add more industry options as needed
    ];
    @track isSalesRecord = false;

    handleAccountNameChange(event) {
        this.accountName = event.target.value;
    }

    handlePhoneChange(event) {
        this.phone = event.target.value;
    }

    handleIndustryChange(event) {
        this.industry = event.target.value;
        if(this.industry=='Sales'){
            this.isSalesRecord = true;
        }
    }

    handleSave() {
        // Determine the record type based on the isSalesRecord flag
        const recordTypeId = this.isSalesRecord ? '0125g000000nfJOAAY' : '0125g000000nfJTAAY';

        // Prepare the fields for the new Account record
        const fields = {
            Name: this.accountName,
            Phone: this.phone,
            Industry: this.industry,
            RecordTypeId: recordTypeId
        };

        // Create the Account record
        createRecord({ apiName: 'Account', fields })
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Account created successfully',
                        variant: 'success'
                    })
                );
                // Reset the form fields
                this.accountName = '';
                this.phone = '';
                this.industry = '';
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}