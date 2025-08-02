import { LightningElement, track, wire } from 'lwc';
import getContactList from '@salesforce/apex/MassDeleteRecords.getContactList';
import deleteSelectedContact from '@salesforce/apex/MassDeleteRecords.deleteSelectedContact';
import {refreshApex} from '@salesforce/apex';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class MassDelete extends LightningElement {

    @track columns = [
        {
            label : 'First Name', 
            fieldName : 'FirstName',
            type : 'text'
        },
        {
            label : 'Last Name', 
            fieldName : 'LastName',
            type : 'text'
        }

    ]
    @track selectedContactIdList=[];
    @track message;
    @track error;
    @wire(getContactList) contacts;
    
    deleteRecords(){
        deleteSelectedContact({ids: this.selectedContactIdList})
        .then(result=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Selected Records are deleted',
                    variant: 'success',
                }),
            );
            this.template.querySelector('lightning-datatable').selectedRows=[];
            return refreshApex(this.contacts);
        })
        .catch(error => {
            this.message = undefined;
            this.error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating records',
                    message: error.body.pageErrors[0].message,
                    variant: 'error',
                }),
            );
            console.log("error", JSON.stringify(this.error));
            });

    }
    selectedRow(event){
        const selectedRow = event.detail.selectedRows;
        this.selectedContactIdList=[];
        for(let i = 0; i<selectedRow.length; i++){
            this.selectedContactIdList.push(selectedRow[i].Id);
        }

    }
}