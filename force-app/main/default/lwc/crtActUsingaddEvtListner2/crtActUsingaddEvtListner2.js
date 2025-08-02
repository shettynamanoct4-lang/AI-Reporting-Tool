import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';

export default class CrtActUsingaddEvtListner2 extends LightningElement {
    @track accountName = '';
    @track phone = '';
    handleClickBound;

    connectedCallback() {
        this.handleClickBound = this.handleClick.bind(this);
        this.template.addEventListener('click', this.handleClickBound);
        console.log('Inside  Connected Callback 2');
    }

    disconnectedCallback() {
        this.template.removeEventListener('click', this.handleClickBound);
        console.log('Inside Disconnected Callback');
    }

    handleNameChange(event) {
        this.accountName = event.target.value;
    }

    handlePhoneChange(event) {
        this.phone = event.target.value;
    }

    handleClick(event) {
        if (event.target.dataset.id === 'createButton') {
            this.createAccount();
        }
    }

    createAccount() {
        const fields = {
            Name: this.accountName,
            Phone: this.phone
        };
        const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields };
        
        createRecord(recordInput)
            .then(account => {
                console.log('Account created with Id: ', account.id);
                // Optionally, you can perform additional actions after account creation
                // For example, show a success message, navigate to the created account page, etc.
            })
            .catch(error => {
                console.error('Error creating account: ', error);
                // Optionally, handle error messages or display error to the user
            });
    }

}