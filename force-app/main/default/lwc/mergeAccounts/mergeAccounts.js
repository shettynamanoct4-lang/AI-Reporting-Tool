import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, deleteRecord } from 'lightning/uiRecordApi';
import getAccounts from '@salesforce/apex/MergeCls.getAccounts';
import mergeFields from '@salesforce/apex/MergeCls.mergeFields';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import { refreshApex } from 'lightning/uiRecordApi';
import { RefreshEvent } from 'lightning/refresh';
import reverseUpdate from '@salesforce/apex/MergeCls.reverseUpdate';
import getMergeStatus from '@salesforce/apex/MergeStatusTriggerHandler.getMergeStatus';

export default class MergeAccounts extends LightningElement {
    @api recordId; // Target Account ID
    @track sourceAccountId;
    @track accountOptions = [];
    mergeStatus = '';

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accountOptions = data.map(account => {
                return { label: account.Name, value: account.Id };
            });
        } else if (error) {
            this.showToast('Error', error.body.message, 'error');
        }
    }

    handleAccountChange(event) {
        this.sourceAccountId = event.detail.value;
    }

    async mergeAccounts() {
        try {
            // Execute the mergeFields Apex method asynchronously
            const mergeResult = await this.mergeFieldsAsync();

            // Wait for a brief moment to allow the trigger logic to update the record
            await this.delay(5000); // Adjust the delay time as needed

            // Query the updated record to get the merge status
            const mergeStatus = await getMergeStatus({ accountId: this.recordId });

            // Check the merge status and show toast message accordingly
            if (mergeStatus === 'Success') {
                console.log(JSON.stringify(mergeStatus));
                this.showToast('Success', 'Accounts have been merged successfully', 'success');
            } else if (mergeStatus === 'Error') {
                console.log(JSON.stringify(mergeStatus));
                // Perform reversal
                reverseUpdate({ targetId: this.recordId })
                .then(() => {
                    console.log('Reversal completed due to error in deletion');
                })
                .catch(error => {
                    console.error('Failed to reverse update:', error);
                });
                this.showToast('Error', 'An unexpected error occurred during the merge operation', 'error');
            } else {
                console.log(JSON.stringify(mergeStatus));
                this.showToast('Info', 'Merge status not available', 'info');
            }
            // Reload the page after 3 seconds
           setTimeout(() => {
               //window.location.reload();
               this.dispatchEvent(new RefreshEvent());
           }, 3000); 
        } catch (error) {
            // Display error toast if an error occurs
            console.error('Error :', error);
            this.showToast('Error', error.body ? error.body.message : error, 'error');
        }
        
    }

    async mergeFieldsAsync() {
        return await mergeFields({ targetId: this.recordId, sourceId: this.sourceAccountId });
    }

    
    // Remaining methods remain unchanged...

    delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}