import { LightningElement, wire ,track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import deleteRecords from '@salesforce/apex/AccountController.deleteRecords';
import { refreshApex } from '@salesforce/apex';
const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Industry', fieldName: 'Industry' }
];

export default class assignment2 extends LightningElement {
    @track accounts = [];
    @track filteredAccounts = [];
    @track selectedAccountIds = [];
    @track showToast = false;

    columns = columns;
    wireResult;

    @wire(getAccounts)
    wiredAccounts(result) {
        this.wireResult = result;
        if (result.data) {
            this.accounts = result.data;
            if(!(this.accounts.length>0)){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'No records found to display',
                        variant: 'error'
                    })
                );
            }
            this.filteredAccounts = result.data;
        } else if (result.error) {
            // Handle error
        }
    }

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
        this.filteredAccounts = this.accounts.filter(account => account.Name.toLowerCase().includes(searchKey));
    }

    handleRowSelection(event) {
        this.selectedAccountIds = event.detail.selectedRows.map(row => row.Id);
    }

    deleteSelected() {
        console.log('entered here the ids----'+this.selectedAccountIds+'--'+this.selectedAccountIds.length);
        if (this.selectedAccountIds.length > 0) {
            console.log('Inside if');
            deleteRecords({list_deletedAccIds:this.selectedAccountIds})
                .then((result) => {
                    console.log('entered here--'+result);
                    if(result=='success'){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Account deleted successfully',
                                variant: 'success'
                            })
                        );
                        refreshApex(this.wireResult);
                        this.selectedAccountIds = [];
                        this.showToast = true;
                       // this.refreshAccounts();
                      
                        
                    }
                   
                })
                .catch(error => {
                    console.error('Error deleting records', error);
                });
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Please select atleast 1 record',
                    variant: 'Error'
                })
            );
        }
    }

    closeToast() {
        this.showToast = false;
    }
}