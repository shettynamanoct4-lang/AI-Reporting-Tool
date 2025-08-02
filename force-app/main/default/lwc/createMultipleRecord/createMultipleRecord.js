import { LightningElement,track } from 'lwc';
import crtCon from '@salesforce/apex/createAccount.crtCon';
import NAME from '@salesforce/schema/Account.Name';
import PHONE from '@salesforce/schema/Account.Phone';

import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class CreateMultipleRecord extends LightningElement {
    title = "Create Account";
    @track error;
    @track AccountId;
    @track contRec={
        Name:NAME,
        Phone:PHONE,
        
    };
    changeHandler1(event){
        this.contRec.Name=event.target.value;
    }
    changeHandler2(event){
        this.contRec.Phone=event.target.value;
    }
    
    handleSave(){
        crtCon({ct:this.contRec})
        .then(result=>{
            this.contRec={};
            this.AccountId=result.Id;
            window.console.log(this.ContactId);
            const event= new ShowToastEvent({
                title : 'Success',
                message : 'Contact Created',
                variant : 'success'
            });
            this.dispatchEvent(event);
        })
        .catch(error=>{
            this.error=error.message;

        })
    }
}