import { LightningElement, track } from 'lwc';
import getAccountRecords from '@salesforce/apex/ActWithFilter.getAccountRecords';
import { deleteRecord } from 'lightning/uiRecordApi';
import deleteAccountRecords from '@salesforce/apex/ActWithFilter.deleteAccountRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ActTableWithFilterModal extends LightningElement {
    @track accounts = []; // Account data
    originalAccounts = []; // Copy of original account data
    showModal = false;
    filterField = '';
 

    isAsc = false;
    isDsc = false;
    isNameSort = false;
    isPhoneSort = false;
    isRatingSort = false;
    error;

    sortedDirection = 'asc';
    sortedColumn;

    selectedRows = new Set(); // To track selected rows

    isDeleteDisabled = true; // Initially disable the delete button

    connectedCallback() {
        // Fetch account records on component initialization
        this.fetchAccountRecords();
    }

    fetchAccountRecords() {
        getAccountRecords()
            .then(result => {
                this.accounts = result;
                this.originalAccounts = [...result]; // Make a copy of the original data
            })
            .catch(error => {
                // Handle error
                console.error('Error fetching account records:', error);
            });
    }

    openModal(event) {
        this.showModal = true;
        this.filterField = event.target.dataset.field;
    }

    applyFilter(event) {
        const filterCriteria = event.detail;
        const { criteria, value } = filterCriteria;
    
        // Filter the account records based on the selected criteria and value
        this.accounts = this.originalAccounts.filter(account => {
            if (account[this.filterField] !== null && account[this.filterField] !== undefined) {
                if (criteria === 'contains') {
                    return account[this.filterField].includes(value);
                } else if (criteria === 'notContains') {
                    return !account[this.filterField].includes(value);
                }
            }
            return false;
        });
    
        // Close modal
        this.showModal = false;
    }

    handleClear() {
        // Restore original data
        this.accounts = [...this.originalAccounts];
        this.selectedRows.clear();
        this.isDeleteDisabled = true;
    }

    handleModalClose() {
        // Hide the modal
        this.showModal = false;
    }

    
    
    sortName(event) {
        this.isNameSort = true;
        this.isPhoneSort = false;
        this.isRatingSort = false;
        

        this.sortData(event.currentTarget.dataset.id);
    }

    sortRating(event) {
        this.isNameSort = false;
        this.isPhoneSort = false;
        this.isRatingSort = true;
       

        this.sortData(event.currentTarget.dataset.id);
    }



    sortData(sortColumnName) {
        // check previous column and direction
        if (this.sortedColumn === sortColumnName) {
            this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
        } 
        else {
            this.sortedDirection = 'asc';
        }

        // check arrow direction
        if (this.sortedDirection === 'asc') {
            this.isAsc = true;
            this.isDsc = false;
        } 
        else {
            this.isAsc = false;
            this.isDsc = true;
        }

        // check reverse direction
        let isReverse = this.sortedDirection === 'asc' ? 1 : -1;

        this.sortedColumn = sortColumnName;

        // sort the data
        this.accounts = JSON.parse(JSON.stringify(this.accounts)).sort((a, b) => {
            a = a[sortColumnName] ? a[sortColumnName].toLowerCase() : ''; // Handle null values
            b = b[sortColumnName] ? b[sortColumnName].toLowerCase() : '';

            return a > b ? 1 * isReverse : -1 * isReverse;
        });;
    }


    handleSelectAll(event) {
        const isChecked = event.target.checked;
        const checkboxes = this.template.querySelectorAll('tbody input[type="checkbox"]');

        checkboxes.forEach(checkbox => {
            checkbox.checked = isChecked;
            const accountId = checkbox.dataset.id;
            if (isChecked) {
                this.selectedRows.add(accountId);
            } else {
                this.selectedRows.delete(accountId);
            }
        });

        this.isDeleteDisabled = !isChecked;

        console.log('All checkboxes selected:', isChecked);
        console.log('Selected rows:', [...this.selectedRows]);
    }

    handleRowSelect(event) {
        const checkbox = event.target;
        const accountId = checkbox.dataset.id;

        if (checkbox.checked) {
            this.selectedRows.add(accountId);
        } else {
            this.selectedRows.delete(accountId);
        }


        this.isDeleteDisabled = this.selectedRows.size === 0;
        console.log('Checkbox selected:', accountId, checkbox.checked);
        console.log('Selected rows:', [...this.selectedRows]);
    }

    handleDelete() {
        const accountIds = [...this.selectedRows];
        const originalAccountsState = [...this.accounts]; // Save the original state
        const originalSelectedRows = new Set(this.selectedRows); // Save the original selected rows

        deleteAccountRecords({ accountIds })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Records deleted successfully',
                        variant: 'success'
                    })
                );

                // Remove deleted records from the local data
                this.accounts = this.accounts.filter(account => !this.selectedRows.has(account.Id));
                this.originalAccounts = this.originalAccounts.filter(account => !this.selectedRows.has(account.Id));
                this.selectedRows.clear();
                this.isDeleteDisabled = true;
            })
            .catch(error => {
                // Revert to the original state
                this.accounts = originalAccountsState;
                this.selectedRows = originalSelectedRows;

                // Clear all checkboxes and unselect all rows
                this.clearAllCheckboxes();


                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error deleting records: ' + error.body.message,
                        variant: 'error'
                    })
                );
                console.error('Error deleting records:', error);
            });
    }

    clearAllCheckboxes() {
        // Forcefully update the checkbox selection
        this.template.querySelectorAll('tbody input[type="checkbox"]').forEach(checkbox => {
            checkbox.checked = false;
        });
        this.selectedRows.clear();
        this.isDeleteDisabled = true;
        // Force a refresh of the data
        this.accounts = [...this.accounts];
    }

    handleSearch(event) {
        const searchTerm = event.target.value;

        // Search only if the input length is greater than 3 characters
        if (searchTerm.length > 3) {
            this.accounts = this.originalAccounts.filter(account =>
                account.Name.toLowerCase().includes(searchTerm.toLowerCase())
            );
        } else {
            // If input is less than or equal to 3 characters, reset to original accounts
            this.accounts = [...this.originalAccounts];
        }
    }

   
    
}