import { LightningElement, track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';

import { createRecord } from 'lightning/uiRecordApi';

export default class CreateRecord extends NavigationMixin(LightningElement){
    @track name='';
    @track phone='';
    accountId;
   
    changeHandler(event){
        if(event.target.label==="Name"){
            this.name=event.target.value;
        }
        else if(event.target.label==="Phone"){
            this.phone=event.target.value;
        }
       
    }
    createAccount(){
        const fields = {};
        fields[NAME_FIELD.fieldApiName]=this.name;
        fields[PHONE_FIELD.fieldApiName]=this.phone;
        
        const recordInput= { apiName: ACCOUNT_OBJECT.objectApiName, fields};
        createRecord(recordInput) //This returns the promise of Record details
        .then(account=>{
            this.accountId=account.id;
            const event= new ShowToastEvent({
                title : 'Success',
                message : 'Account Created',
                variant : 'success',
            })
            this.dispatchEvent(event);

            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
            attributes: {
                recordId:account.id,
                objectApiName: 'Account',
                actionName: 'view'
            },
            });
        })
        .catch(error=>{
            console.log(error);
        })


    }
}