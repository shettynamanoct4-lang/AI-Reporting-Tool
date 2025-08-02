import { LightningElement,track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ACCOUNT_NAME from '@salesforce/schema/Account.Name';
import ACCOUNT_PHONE from '@salesforce/schema/Account.Phone';
import ACCOUNT_ADDRESS from '@salesforce/schema/Account.BillingAddress';
import 	AccountSource from '@salesforce/schema/Account.AccountSource';

export default class RecordEditForm extends LightningElement {
    @track AccountId= "Created Account Id is displayed here";
    objectApiName=ACCOUNT_OBJECT;
    Name=ACCOUNT_NAME;
    Phone=ACCOUNT_PHONE;
    BillingAddress=ACCOUNT_ADDRESS;
    AccountSource=AccountSource;
    @track display=false;
    
    handleSuccess(event){
        this.display=true;

        this.AccountId= event.detail.id;  //Use event.detail when action is completed and now we can catch it

        const events = new ShowToastEvent({
            title: 'Successful',
            message: 'Account Craeted',
            variant: 'success'
        })
        this.dispatchEvent(events);


    }
}