import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/ActWithContTable.getAccounts'; // Apex method to fetch accounts
import getContactsByAccount from '@salesforce/apex/ActWithContTable.getContactsByAccount'; // Apex method to fetch contacts by account

export default class AccountTableWithContactImmediateBelow extends LightningElement {
    @track accounts = [];
    @track expandedRowIndex = null; // To track which row is expanded
    @track contacts = [];
    @track isLoading = false;
    @track hasContacts = false; // Track if there are any contacts
    @track noContactsAvailable = false; // Track if there are no contacts available

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            // Add isExpanded and unique key for each account to avoid key conflicts
            this.accounts = data.map((account, index) => ({
                ...account,
                isExpanded: false,
                key: account.Id + '-' + index // Prepare a unique key in JS
            }));
        } else if (error) {
            console.error(error);
        }
    }

    handleRowClick(event) {
        const accountId = event.target.dataset.accountId;
        const rowIndex = event.target.dataset.index;

        // Reset all isExpanded values to false before expanding the new row
        this.accounts = this.accounts.map((account, index) => {
            return { ...account, isExpanded: index == rowIndex };
        });

        // If the row is expanded, load the contacts for that account
        if (this.accounts[rowIndex].isExpanded) {
            this.loadContacts(accountId);
        } else {
            this.contacts = [];
            this.hasContacts = false;
            this.noContactsAvailable = false;
        }
    }

    loadContacts(accountId) {
        this.isLoading = true;
        this.contacts = [];
        getContactsByAccount({ accountId })
            .then((result) => {
                this.contacts = result;
                this.isLoading = false;
                this.hasContacts = this.contacts.length > 0;
                this.noContactsAvailable = this.contacts.length === 0;
            })
            .catch((error) => {
                console.error(error);
                this.isLoading = false;
                this.hasContacts = false;
                this.noContactsAvailable = true;
            });
    }
}