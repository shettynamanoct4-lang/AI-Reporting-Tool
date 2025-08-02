import { LightningElement, track } from 'lwc';
import searchAccounts from '@salesforce/apex/AccountSearchController.searchAccounts';
import countOfAccounts from '@salesforce/apex/AccountSearchController.countOfAccounts';

const DELAY = 500; // Increase debounce delay for better performance
const CACHE_KEY = 'cachedInitialAccounts'; // Key for storing data in localStorage

export default class AccountSearchComponent extends LightningElement {
    @track accounts = [];
    @track globalSearchKey = ''; // Global search across all fields
    @track searchKey = ''; // Name search
    @track phoneFilter = ''; // Phone filter
    @track ratingFilter = ''; // Rating filter
    @track statusFilter = ''; // Status filter
    @track pageSize = 20; // Number of records to load per page
    @track totalRecords = 0; // Total number of records
    @track recordLoaded = 0; // Number of records loaded so far
    @track lastRecord = null; // Last record loaded (for infinite scrolling)
    @track isLoading = false; // Flag to show loading state
    @track hasMoreRecords = true; // Flag to determine if there are more records to load
    delayTimeout; // Used for debouncing
    @track selectedAccountId; // Track the selected account ID

    @track columns = [
        { label: 'Account Name', fieldName: 'Name' },
        { label: 'Phone', fieldName: 'Phone' },
        { label: 'Rating', fieldName: 'Rating' },
        { label: 'Status', fieldName: 'Status__c' },
        {
            type: 'button',
            typeAttributes: {
                label: 'View Details',
                name: 'view_details',
                variant: 'base'
            }
        }
    ];

    ratingOptions = [
        { label: 'Hot', value: 'Hot' },
        { label: 'Warm', value: 'Warm' },
        { label: 'Cold', value: 'Cold' }
    ];

    statusOptions = [
        { label: 'Active', value: 'Active' },
        { label: 'Not Active', value: 'Not Active' }
    ];

    connectedCallback() {
        console.log('Component connected');
        this.loadInitialData(); // Load from server and cache the data
    }

    // Load initial set of records and cache them
    loadInitialData() {
        console.log('Loading initial data');
        this.isLoading = true;
        
        // Fetch total records count
        countOfAccounts()
            .then((total) => {
                console.log(`Total number of records: ${total}`);
                this.totalRecords = total;
                // After fetching total records, check for cached data
                const cachedData = localStorage.getItem(CACHE_KEY);
                if (cachedData) {
                    console.log('Using cached data');
                    this.accounts = JSON.parse(cachedData);
                    this.recordLoaded = this.accounts.length;
                    this.lastRecord = this.accounts[this.accounts.length - 1];
                    this.isLoading = false;
                } else {
                    this.fetchAccounts(true); // Fetch initial records and cache them
                }
            })
            .catch((error) => {
                console.error('Error fetching total record count:', error);
                this.isLoading = false;
            });
    }

    // Fetch records based on filters and global search
    fetchAccounts(isInitialLoad = false, isLoadMore = false) {
        if (!this.hasMoreRecords) {
            // If there are no more records, stop loading
            console.log('No more records to load');
            this.isLoading = false;
            return;
        }

        console.log('Fetching accounts');
        console.log(`lastRecord: ${this.lastRecord ? this.lastRecord.Name : 'null'}`);
        console.log(`isInitialLoad: ${isInitialLoad}, isLoadMore: ${isLoadMore}`);

        this.isLoading = true;
        searchAccounts({
            globalSearchKey: this.globalSearchKey,
            searchKey: this.searchKey,
            phoneFilter: this.phoneFilter,
            ratingFilter: this.ratingFilter,
            statusFilter: this.statusFilter,
            limitSize: this.pageSize,
            lastRecordName: this.lastRecord && isLoadMore ? this.lastRecord.Name : null, // Only pass lastRecord for infinite scrolling
            lastRecordId: this.lastRecord && isLoadMore ? this.lastRecord.Id : null // Only pass lastRecord for infinite scrolling
        })
        .then((result) => {
            console.log(`Records fetched: ${result.length}`);
            if (isLoadMore) {
                console.log('Appending records');
                // Append the new records for infinite scrolling
                this.accounts = [...this.accounts, ...result];
            } else {
                console.log('Replacing records');
                // Replace the existing records for filtering/search
                this.accounts = result;
            }

            // Check if there are more records to load
            if (result.length < this.pageSize) {
                console.log('No more records to load');
                this.hasMoreRecords = false; // No more records to load
            }

            if (result.length > 0) {
                console.log('Updating lastRecord');
                this.lastRecord = result[result.length - 1]; // Track the last loaded record
            }
            this.recordLoaded = this.accounts.length; // Update the number of loaded records
            console.log(`Total records loaded: ${this.recordLoaded}`);
            this.isLoading = false;

            // Cache the initial records on the first load
            if (isInitialLoad) {
                console.log('Caching initial records');
                localStorage.setItem(CACHE_KEY, JSON.stringify(this.accounts)); // Store in localStorage
            }
        })
        .catch((error) => {
            console.error('Error fetching accounts:', error);
            this.isLoading = false;
        });
    }

    // Handle global search input with debouncing
    handleGlobalSearchChange(event) {
        const searchKey = event.target.value;

        // Debounce logic: Trigger the search only after a delay
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            if (searchKey.length > 3) {
                console.log('Global search triggered');
                this.globalSearchKey = searchKey;
                this.resetAndFetch(); // Reset and fetch fresh data
            } else {
                console.log('Clearing global search');
                this.globalSearchKey = ''; // Clear search if less than 3 characters
            }
        }, DELAY);
    }

    // Optimized method to handle filter changes and debounce
    handleFilterChange(event, filterName) {
        window.clearTimeout(this.delayTimeout);
        this[filterName] = event.target.value; // Update the filter value
        console.log(`Filter changed: ${filterName} = ${event.target.value}`);
        this.delayTimeout = setTimeout(() => {
            this.resetAndFetch(); // Reset and fetch fresh data based on new filter
        }, DELAY);
    }

    handleSearchKeyChange(event) {
        this.handleFilterChange(event, 'searchKey');
    }

    handlePhoneFilterChange(event) {
        this.handleFilterChange(event, 'phoneFilter');
    }

    handleRatingFilterChange(event) {
        this.handleFilterChange(event, 'ratingFilter');
    }

    handleStatusFilterChange(event) {
        this.handleFilterChange(event, 'statusFilter');
    }

    // Reset existing records and fetch fresh data
    resetAndFetch() {
        console.log('Resetting and fetching data');
        this.accounts = []; // Clear out the current records
        this.lastRecord = null; // Reset last loaded record
        this.recordLoaded = 0; // Reset the record count
        this.hasMoreRecords = true; // Reset for infinite scrolling
        this.fetchAccounts(); // Fetch initial set of records
    }

    // Handle "Load More" when scrolling down (used for infinite scrolling)
    handleLoadMore() {
        console.log('isLoading:', this.isLoading);
        console.log('recordLoaded:', this.recordLoaded);
        console.log('totalRecords:', this.totalRecords);
        console.log('hasMoreRecords:', this.hasMoreRecords);
    
        if (!this.isLoading && this.recordLoaded < this.totalRecords && this.hasMoreRecords) {
            console.log('Fetching more records');
            this.fetchAccounts(false, true); // Fetch the next set of records (append)
        } else {
            console.log('Load more not triggered due to conditions');
        }
    }

    // Optimized Reset: Use cached initial data on reset
    handleReset() {
        console.log('Resetting filters and loading cached data');
        this.globalSearchKey = '';
        this.searchKey = '';
        this.phoneFilter = '';
        this.ratingFilter = '';
        this.statusFilter = '';

        // Use cached data if available
        const cachedData = localStorage.getItem(CACHE_KEY);
        if (cachedData) {
            this.accounts = JSON.parse(cachedData);
            this.recordLoaded = this.accounts.length;
            this.lastRecord = this.accounts[this.accounts.length - 1];
        } else {
            this.loadInitialData();
        }
    }

    // Handle row action to get the selected account
    handleRowAction(event) {
        const accountId = event.detail.row.Id;
        this.selectedAccountId = accountId; // Set selected account Id
    }
}