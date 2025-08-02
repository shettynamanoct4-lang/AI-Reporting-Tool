import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';

export default class CrtActUsingaddEvtListner extends LightningElement {
    connectedCallback() {
        this.template.addEventListener('click', this.handleClick.bind(this));
        console.log('Inside Connected Callback');
    }

    handleClick(event) {
        const element = event.target;
        if (element.dataset.id === 'createButton') {
            const accountName = this.template.querySelector('lightning-input[data-id="accountName"]').value;
            const phone = this.template.querySelector('lightning-input[data-id="phone"]').value;
            this.createAccount(accountName, phone);
        }
    }

    createAccount(accountName, phone) {
        const fields = {
            Name: accountName,
            Phone: phone
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