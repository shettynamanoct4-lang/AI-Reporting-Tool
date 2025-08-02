import { LightningElement, track, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';

export default class assignment3 extends LightningElement {

    @track contacts = []; // List of contacts
    @track rowsPerPageOptions = [{label:'10',value:10}, {label:'5',value:5},{label:'15',value:15}]// Options for rows per page
    @track rowsPerPage = 5; // Selected rows per page
    @track sortedBy = 'ContactName'; // Default sorted field
    @track sortedDirection = 'asc'; // Default sorted direction
    @track searchValue = ''; // Search value
    @track filteredContacts;
    @track ShowContacts = false;

    columns = [
        { label: 'Contact Name', fieldName: 'ContactName', type: 'text', sortable: true },
        { label: 'Contact Email Id', fieldName: 'ContactEmail', type: 'email', sortable: true },
        { label: 'Contact Phone number', fieldName: 'ContactPhone', type: 'phone', sortable: true },
        

    ];

    @wire(getContacts, { searchKey: '$searchValue', rowsPerPage: '$rowsPerPage'})
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data.map(contact => ({
                Id: contact.Id,
                ContactName: contact.Name,
                ContactEmail: contact.Email,
                ContactPhone: contact.Phone,
                
            }));
            if (this.contacts.length) {
                this.ShowContacts = true;
            } else {
                this.ShowContacts = false;
            }
            console.log('the list of contact--' + JSON.stringify(this.contacts));
        } else if (error) {
            console.log('the error---' + JSON.stringify(error) + '--' + error);
        }
    }

    handleSort(event) {
        console.log('the sort detail--'+JSON.stringify(event.detail));
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.contacts];
        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.contacts = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }

    handleSearch(event) {
        this.searchValue = event.target.value;
    }

    handleRowsPerPageChange(event) {
        this.rowsPerPage = parseInt(event.target.value);
    }


    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }


}