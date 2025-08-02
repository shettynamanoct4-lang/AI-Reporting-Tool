import { LightningElement,track,wire } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';
export default class Assignment7Parent extends LightningElement {

    @track opportunities = [];

    @wire(getOpportunities)
    wiredAccounts(result) {
        this.wireResult = result;
        if (result.data) {
            this.opportunities = result.data;
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


    // @track opportunities = [
    //     {
    //         Id: '1',
    //         Name: 'Opportunity 1',
    //         AccountName: 'Account 1',
    //         Type: 'New Business',
    //         Probability: 75
    //     },
    //     {
    //         Id: '2',
    //         Name: 'Opportunity 2',
    //         AccountName: 'Account 2',
    //         Type: 'Existing Business',
    //         Probability: 50
    //     },
    //     // Add more opportunities here
    // ];
    @track selectedOpportunity;

    handleOpportunitySelect(event) {
        this.selectedOpportunity = event.detail;
    }
}