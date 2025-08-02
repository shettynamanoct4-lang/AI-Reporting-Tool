import { LightningElement,wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJ from '@salesforce/schema/Account';
import NAME_F from '@salesforce/schema/Account.Name';
import DOB_F from '@salesforce/schema/Account.Date_Of_Birth__c';
import EMAIL_F from '@salesforce/schema/Account.Email__c';
import POSTAL_ADDRESS_F from '@salesforce/schema/Account.Postal_Address__c';
import validateCustomer from '@salesforce/apex/CustomerTk.validateCustomer';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class MiniProject extends LightningElement {
    validation
    showModal= false

    accId
    accName


    objectName=ACCOUNT_OBJ;
    fields={
        name:NAME_F,
        dob:DOB_F,
        email:EMAIL_F,
        poAddress:POSTAL_ADDRESS_F
    }

    handleSubmit(event){
        event.preventDefault()
        var fields = this.template.querySelectorAll('lightning-input-field')
        var values = []
        var output
        fields.forEach(field => {
            values.push(field.value)                   
        });
        validateCustomer({name:values[0],dob:values[1],email:values[2],poAddress:values[3]}).then(result=>{
            if(result){
                var theform = this.template.querySelector('lightning-record-edit-form')
                theform.submit()
                this.accName = values[0]
                
                this.showModalFunction()
            }
            else{
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Unsuccessful',
                    message: 'The customer already exists. Search from existing customer.',
                    variant: 'error'
                }));
            }
        }).catch(error=>{
            console.error(error);
        });
    }
    handleSuccess(event){
        var payLoad = event.detail.id
        this.accId = JSON.parse(JSON.stringify(payLoad))
    }
    showModalFunction(){
        this.showModal=true;
    }
    closeModalChild(event){
        this.showModal = false
        this.msg = event.detail
    }
}