import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
import ACCOUNT_RATING_FIELD from '@salesforce/schema/Account.Rating';
import ACCOUNT_EMAIL_FIELD from '@salesforce/schema/Account.Email__c'; // Adjust to your org's field API name
import CONTACT_FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import CONTACT_LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import CONTACT_ACCOUNT_FIELD from '@salesforce/schema/Contact.AccountId';

export default class MultiStepRecCreation extends LightningElement {
    @track currentStep = '1';

    // Form fields
    @track accountName = '';
    @track email = '';
    @track rating = '';
    @track firstName = '';
    @track lastName = '';

    // Error handling
    @track hasErrors = false;
    @track errorMessage = '';

    // Rating options for the picklist
    ratingOptions = [
        { label: 'Hot', value: 'Hot' },
        { label: 'Warm', value: 'Warm' },
        { label: 'Cold', value: 'Cold' }
    ];

    // Getters to determine which step is active
    get isStepOne() {
        return this.currentStep === '1';
    }

    get isStepTwo() {
        return this.currentStep === '2';
    }

    get isStepThree() {
        return this.currentStep === '3';
    }

    get isFirstStep() {
        return this.currentStep === '1';
    }

    get nextButtonLabel() {
        return this.currentStep === '3' ? 'Finish' : 'Next';
    }

    // Handle input field changes
    handleChange(event) {
        this[event.target.name] = event.target.value;
    }

    // Navigate to the next step
    handleNext() {
        if (this.validateInputs()) {
            this.hasErrors = false;
            if (this.currentStep === '2') {
                // Submit the form data to create records
                this.createAccountAndContact();
            } else {
                this.currentStep = String(Number(this.currentStep) + 1);
            }
        } else {
            this.hasErrors = true;
            this.errorMessage = 'Please complete all required fields.';
        }
    }

    // Navigate to the previous step
    handlePrevious() {
        this.hasErrors = false;
        this.currentStep = String(Number(this.currentStep) - 1);
    }

    // Validate inputs for the current step
    validateInputs() {
        const inputs = [...this.template.querySelectorAll('lightning-input')];
        let allValid = true;

        inputs.forEach(input => {
            if (!input.reportValidity()) {
                allValid = false;
            }
        });

        return allValid;
    }

    // Create Account and Contact using LDS
    createAccountAndContact() {
        // Create Account record
        const accountFields = {};
        accountFields[ACCOUNT_NAME_FIELD.fieldApiName] = this.accountName;
        accountFields[ACCOUNT_RATING_FIELD.fieldApiName] = this.rating;
        accountFields[ACCOUNT_EMAIL_FIELD.fieldApiName] = this.email;

        const accountRecordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields: accountFields };

        createRecord(accountRecordInput)
            .then(account => {
                // Account created successfully, create Contact now
                this.createContact(account.id);
            })
            .catch(error => {
                // Handle account creation error
                this.hasErrors = true;
                this.errorMessage = error.body.message;
            });
    }

    // Create Contact associated with the Account
    createContact(accountId) {
        const contactFields = {};
        contactFields[CONTACT_FIRSTNAME_FIELD.fieldApiName] = this.firstName;
        contactFields[CONTACT_LASTNAME_FIELD.fieldApiName] = this.lastName;
        contactFields[CONTACT_ACCOUNT_FIELD.fieldApiName] = accountId;

        const contactRecordInput = { apiName: CONTACT_OBJECT.objectApiName, fields: contactFields };

        createRecord(contactRecordInput)
            .then(() => {
                // Successfully created account and contact
                this.currentStep = '3';
                this.showToast('Success', 'Account and Contact created successfully!', 'success');
            })
            .catch(error => {
                // Handle contact creation error
                this.hasErrors = true;
                this.errorMessage = error.body.message;
            });
    }

    // Show toast notification
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}