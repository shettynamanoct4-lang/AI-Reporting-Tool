import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';

export default class DynamicForm2 extends LightningElement {
    @track fields = []; // Fields to render

    connectedCallback() {
        this.initializeFields();
    }

    initializeFields() {
        // Define the configuration for the Account fields
        this.fields = [
            {
                apiName: 'Name',
                label: 'Account Name',
                type: 'text',
                required: true,
                value: ''
            },
            {
                apiName: 'Phone',
                label: 'Phone',
                type: 'phone',
                required: false,
                value: ''
            },
            {
                apiName: 'Rating',
                label: 'Rating',
                type: 'picklist',
                required: false,
                value: '',
                options: [
                    { label: 'Hot', value: 'Hot' },
                    { label: 'Warm', value: 'Warm' },
                    { label: 'Cold', value: 'Cold' }
                ]
            }
        ];

        // Set flags for rendering the correct input type
        this.fields = this.fields.map(field => {
            return {
                ...field,
                isText: field.type === 'text',
                isPhone: field.type === 'phone',
                isPicklist: field.type === 'picklist'
            };
        });
    }

    handleInputChange(event) {
        const fieldName = event.target.name;
        const value = event.target.value;
        const fieldIndex = this.fields.findIndex(f => f.apiName === fieldName);
        if (fieldIndex !== -1) {
            this.fields[fieldIndex].value = value;
        }
    }

    handleSubmit() {
        // Validate inputs
        const allValid = [...this.template.querySelectorAll('lightning-input, lightning-combobox')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);

        if (allValid) {
            // Collect form data into fields for LDS
            const fields = {};
            this.fields.forEach(field => {
                fields[field.apiName] = field.value;
            });

            // Prepare record input for LDS
            const recordInput = { apiName: 'Account', fields };

            // Create the Account record using LDS
            createRecord(recordInput)
                .then(account => {
                    console.log('Account Created : '+ JSON.stringify(account ));
                    // Show success message
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Success',
                        message: `Account created with Id: ${account.id}`,
                        variant: 'success'
                    }));
                    // Optionally reset form or handle further processing
                })
                .catch(error => {
                    // Show error message
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    }));
                });
        } else {
            // Handle validation error
            console.log('Please complete all required fields.');
        }
    }
}