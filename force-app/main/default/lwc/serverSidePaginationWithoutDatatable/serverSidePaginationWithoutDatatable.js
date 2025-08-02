import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/PaginationDemoController.getAccounts';
import getTotalAccountsCount from '@salesforce/apex/PaginationDemoController.getTotalAccountsCount';
import getFilteredAccounts from '@salesforce/apex/PaginationDemoController.getFilteredAccounts';
import deleteAccountRecords from '@salesforce/apex/PaginationDemoController.deleteAccountRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ServerSidePaginationWithoutDatatable extends LightningElement {
    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Type', fieldName: 'Type' },
        { label: 'Rating', fieldName: 'Rating' },
        { label: 'Employees', fieldName: 'NumberOfEmployees' },
        { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' }
    ];
    @track recordsToDisplay = [];
    @track isLoading = true;
    @track records = [];
    @track pageSize = 10;
    @track pageNumber = 1;
    @track totalRecords = 0;
    @track sortedBy;
    @track sortDirection = 'asc';
    @track enablePagination = true;
    @track showModal = false;
    @track filterField = '';
    @track filterCriteria = '';
    @track filterValue = '';

    lastRecordId = '';
    sortedLastFieldValue = '';
    selectedRows = new Set();
    isDeleteDisabled = true;
    @track originalRecords = [];// Copy of original account data

    get hasRecords() {
        return this.records.length > 0;
    }

    get showPaginator() {
        return this.enablePagination && this.hasRecords;
    }

    @wire(getTotalAccountsCount)
    wiredGetTotalAccountsCount(result) {
        if (result.data) {
            this.totalRecords = parseInt(result.data, 10);
        } else if (result.error) {
            console.error('Error fetching total record count: ', result.error);
        }
    }

    connectedCallback() {
        this.fetchRecordsFromServer();
    }

    async fetchRecordsFromServer() {
        try {
            let lastRecord = this.records[this.records.length - 1];
            this.lastRecordId = lastRecord ? lastRecord.Id : '';
            this.sortedLastFieldValue = this.sortedBy && lastRecord ? lastRecord[this.sortedBy] : '';
            this.isLoading = true;

            console.log('pageSize: ', this.pageSize);

            console.log('lastRecordId: ', this.lastRecordId);

            console.log('sortColumnName: ', this.sortedBy);

            console.log('sortOrder: ', this.sortDirection);

            console.log('sortedLastFieldValue: ', this.sortedLastFieldValue);
    
            let response = await getAccounts({
                pageSize: this.pageSize,
                lastRecordId: this.lastRecordId,
                sortColumnName: this.sortedBy,
                sortOrder: this.sortDirection,
                sortedLastFieldValue: this.sortedLastFieldValue
            });
            this.isLoading = false;
            console.log('Fetched records response: ', response);
            this.recordsToDisplay = response;
            console.log('recordsToDisplay after fetch: ', JSON.stringify(this.recordsToDisplay));
            this.records = [...this.records, ...this.recordsToDisplay];
            console.log('records after update: ', JSON.stringify(this.records));
            this.originalRecords = [...this.records];
            console.log('original records : ', JSON.stringify(this.originalRecords));
        } catch (err) {
            this.isLoading = false;
            console.error('Error fetching records: ', err);
        }
    }    

    paginationChangeHandler(event) {
        if (event.detail) {
            if (this.pageSize !== event.detail.pageSize) {
                this.records = [];
                this.pageSize = event.detail.pageSize;
            }
            this.pageNumber = event.detail.pageNumber;

            if (this.records.length > this.pageSize * (this.pageNumber - 1)) {
                let from = (this.pageNumber - 1) * this.pageSize;
                let to = this.pageSize * this.pageNumber;
                this.recordsToDisplay = this.records.slice(from, to);
            } else {
                this.lastRecordId = this.records[this.records.length - 1]?.Id;
                this.isLoading = true;
                this.fetchRecordsFromServer();
            }
        }
    }

    handleSort(event) {
        const { id: fieldName } = event.target.closest('th').dataset;
        if (this.sortedBy === fieldName) {
            this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
        } else {
            this.sortDirection = 'asc';
        }
        this.sortedBy = fieldName;
        this.records = [];
        this.fetchRecordsFromServer();
    }

    openFilterModal(event) {
        event.stopPropagation(); // Stop event propagation to prevent sorting
        this.openModal(event);
    }

    openModal(event) {
        this.showModal = true;
        this.filterField = event.currentTarget.dataset.field;
    }

    handleModalClose() {
        this.showModal = false;
    }

    async applyFilter(event) {
        const filterCriteria = event.detail;
        const { criteria, value } = filterCriteria;
        console.log('Applying Filter - Field:', this.filterField, 'Criteria:', criteria, 'Value:', value);
    
        // Reset pagination state and clear existing records
        this.pageNumber = 1;
        this.records = [];
        this.recordsToDisplay = [];
        this.isLoading = true;
    
        try {
            // Fetch filtered records based on the filter criteria
            let response = await getFilteredAccounts({
                filterField: this.filterField,
                filterCriteria: criteria,
                filterValue: value,
                pageSize: this.pageSize,
                pageNumber: this.pageNumber
            });
            
            // Update displayed records with the filtered results
            this.records = response;
            this.recordsToDisplay = this.records.slice(0, this.pageSize); // Display first page
            this.isLoading = false;
            console.log('Filtered Records:', JSON.stringify(this.recordsToDisplay));
        } catch (err) {
            this.isLoading = false;
            console.error('Error fetching filtered records:', err);
        }
    
        // Close the modal
        this.showModal = false;
    
        // If no records match, log an appropriate message
        if (this.recordsToDisplay.length === 0) {
            console.log('No records match the filter criteria.');
        }
    }
    
    

    handleSelectAll(event) {
        const isChecked = event.target.checked;
        const checkboxes = this.template.querySelectorAll('tbody input[type="checkbox"]');
        checkboxes.forEach(checkbox => {
            checkbox.checked = isChecked;
            if (isChecked) {
                this.selectedRows.add(checkbox.dataset.id);
            } else {
                this.selectedRows.delete(checkbox.dataset.id);
            }
        });
        this.isDeleteDisabled = this.selectedRows.size === 0;
    }

    handleRowSelect(event) {
        const isChecked = event.target.checked;
        const recordId = event.target.dataset.id;
        if (isChecked) {
            this.selectedRows.add(recordId);
        } else {
            this.selectedRows.delete(recordId);
        }
        this.isDeleteDisabled = this.selectedRows.size === 0;
    }

    async handleDelete() {
        try {
            const idsToDelete = Array.from(this.selectedRows);
            const result = await deleteAccountRecords({ recordIds: idsToDelete });
            this.selectedRows.clear();
            this.records = this.records.filter(record => !idsToDelete.includes(record.Id));
            this.recordsToDisplay = this.records.slice(0, this.pageSize);
            this.isDeleteDisabled = true;
            this.showToast('Success', 'Records deleted successfully', 'success');
        } catch (error) {
            this.showToast('Error', 'Error deleting records', 'error');
            console.error('Error deleting records:', error);
        }
    }

    handleClear() {
        this.filterField = '';
        this.filterCriteria = '';
        this.filterValue = '';
        this.records = [];
        this.fetchRecordsFromServer();
    }

    handleSearch(event) {
        const searchTerm = event.target.value.toLowerCase().trim();
        console.log('Search Term:', searchTerm);
        // Search only if the input length is greater than 3 characters
        if (searchTerm.length > 3) {
            console.log('Search Term entered:', searchTerm);
            // Perform search across all records
            this.isLoading = true;
            getFilteredAccounts({
                filterField: 'Name', // Assuming you want to search by account name
                filterCriteria: 'contains', // Change as needed
                filterValue: searchTerm,
                pageSize: this.pageSize,
                pageNumber: 1 // Reset page number when searching
            })
            .then(result => {
                this.isLoading = false;
                this.records = result;
                console.log('Records after being filtered : '+ JSON.stringify(this.records));
                this.recordsToDisplay = this.records.slice(0, this.pageSize); // Display first page
            })
            .catch(error => {
                this.isLoading = false;
                console.error('Error fetching filtered records:', error);
            });
        } else {
            // If input is less than or equal to 3 characters, reset to original records
            this.records = [...this.originalRecords];
            this.recordsToDisplay = this.records.slice(0, this.pageSize); // Display first page
             console.log('Reset to original records: ', JSON.stringify(this.recordsToDisplay));
        }
    }
    
    
    
    

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}