import { LightningElement, api, track, wire } from 'lwc';
import getRelatedContacts from '@salesforce/apex/AccountDetailsController.getRelatedContacts';
import getRelatedCases from '@salesforce/apex/AccountDetailsController.getRelatedCases';

export default class AccountDetails extends LightningElement {
    @api accountId; // Account ID passed from parent component
    @track contacts = [];
    @track cases = [];
    
    contactColumns = [
        { label: 'Contact Name', fieldName: 'Name' },
        { label: 'Phone', fieldName: 'Phone' },
        { label: 'Email', fieldName: 'Email' }
    ];

    caseColumns = [
        { label: 'Case Number', fieldName: 'CaseNumber' },
        { label: 'Subject', fieldName: 'Subject' },
        { label: 'Status', fieldName: 'Status' }
    ];

    // Fetch related Contacts when the accountId is set
    @wire(getRelatedContacts, { accountId: '$accountId' })
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
        } else if (error) {
            console.error('Error fetching related contacts:', error);
        }
    }

    // Fetch related Cases when the accountId is set
    @wire(getRelatedCases, { accountId: '$accountId' })
    wiredCases({ error, data }) {
        if (data) {
            this.cases = data;
        } else if (error) {
            console.error('Error fetching related cases:', error);
        }
    }
}