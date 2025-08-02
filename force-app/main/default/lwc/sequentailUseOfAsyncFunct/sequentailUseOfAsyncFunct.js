import { LightningElement, track } from 'lwc';
import getInitialContacts from '@salesforce/apex/AsynAwaitEgCls.getInitialContacts';
import processContacts from '@salesforce/apex/AsynAwaitEgCls.processContacts';

const CONTACT_COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Email', fieldName: 'Email' },
    { label: 'Phone', fieldName: 'Phone' },
    // Add more columns as needed
];

export default class SequentailUseOfAsyncFunct extends LightningElement {
    @track processedContacts;
    @track error;
    columns = CONTACT_COLUMNS;

    connectedCallback() {
        this.fetchAndProcessContacts();
    }

    async fetchAndProcessContacts() {
        try {
            // Step 1: Fetch initial set of contacts
            const initialContacts = await getInitialContacts();
            console.log('Initial Contacts: '+JSON.stringify(initialContacts));

            // Step 2: Process the fetched contacts
            this.processedContacts = await processContacts({ contacts: initialContacts });
            console.log('Proccessed Contacts: '+JSON.stringify(this.processedContacts));
        } catch (error) {
            this.error = error;
        }
    }
}