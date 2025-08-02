import { LightningElement,  api, track} from 'lwc';
import getAccounts from "@salesforce/apex/UnlimitedPaginationController.getAccounts";
import searchAccounts from "@salesforce/apex/UnlimitedPaginationController.searchAccounts";
import saveAccounts from "@salesforce/apex/UnlimitedPaginationController.saveAccounts";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const COLUMNS = [
    { label: 'Select', type: 'checkbox', fieldName: 'Id', initialWidth: 50, typeAttributes: { value: 'Id', label: '', checked: false, disabled: false, name: 'selectRow', variant: 'label-hidden' } },
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Site', fieldName: 'Site', type: 'text', editable: true }
];

export default class UnlimitedPaginationWithDataTable extends LightningElement {
    /** variable declarion */
    @api recordsPerPage = 50;  

    @track accounts = [];
    @track selectedRecords = [];
    
    elements = [];
    dataMap = [];
    count = 0;
    accName;  
    @track selectedRows = [];
    columns = COLUMNS;

    @track draftValues = [];

    /*
        @name: connectedCallback
        @params: none
        @description: calling the getRecords() method to get the Account records
    */
    connectedCallback(){
        this.getRecords();
    }

    /*
        @name: getRecords
        @params: none
        @description: to get the Account records by invoking Apex Clas method: getaccounts()
    */
    getRecords(){
        getAccounts({prevAccRef: null , nextAccRef: null, recordsLimit: this.recordsPerPage})
        .then(data=>{
            if(data){
                this.formatRecords(data);
                this.elements.push(data[0].Id,  data[data.length-1].Id);
                this.dataMap.push({
                    key: this.count,
                    value: this.elements
                });
            }
        })
    }

    /*
        @name: handleNext
        @params: none
        @description: used to show the records in the next page in pagination
    */
    handleNext(){ 
        if(this.accName && this.accName !== ''){
            console.log('entry');
            searchAccounts({name:this.accName, prevAccRef: null , nextAccRef: this.dataMap[this.count].value[1], recordsLimit: this.recordsPerPage})
            .then(data=>{
                if(data){
                    this.formatRecords(data);
                    this.elements = [];
                    this.count++;
                    if(!this.dataMap[this.count]){
                        this.elements.push(data[0].Id,  data[data.length-1].Id);
                        this.dataMap.push({
                            key: this.count,
                            value: this.elements
                        });
                    }
                }            
            })
        }
        else{
            getAccounts({prevAccRef: null , nextAccRef: this.dataMap[this.count].value[1], recordsLimit: this.recordsPerPage})
            .then(data=>{
                if(data){
                    this.formatRecords(data);
                    this.elements = [];
                    this.count++;
                    if(!this.dataMap[this.count]){
                        this.elements.push(data[0].Id,  data[data.length-1].Id);
                        this.dataMap.push({
                            key: this.count,
                            value: this.elements
                        });
                    }
                }            
            })
        }      
        
    }
    
    /*
        @name: handlePrevious
        @params: none
        @description: used to show the records in the previous page in pagination
    */
    handlePrevious(){
        if(this.dataMap){
            if(this.accName && this.accName !== ''){
                searchAccounts({name: this.accName, prevAccRef: this.dataMap[this.count-1].value[0], nextAccRef: this.dataMap[this.count-1].value[1], recordsLimit: this.recordsPerPage})
                .then(data=>{
                    if(data){
                        this.formatRecords(data);
                        this.count--;                   
                    }
                })
            }
            else{
                getAccounts({prevAccRef: this.dataMap[this.count-1].value[0], nextAccRef: this.dataMap[this.count-1].value[1], recordsLimit: this.recordsPerPage})
                .then(data=>{
                    if(data){
                        this.formatRecords(data);
                        this.count--;                   
                    }
                })
            }    
        
        }
    }

/*
    handleCellChange(event) {
        console.log('Inside Inline edit');
        const fieldName = event.detail.fieldName;
        console.log('fieldName : '+ JSON.stringify(fieldName));
        const rowId = event.detail.rowId;
        console.log('rowId : '+ JSON.stringify(rowId));
        const value = event.detail.value;
        console.log('value : '+ JSON.stringify(value));
    
        // Find the row that was edited in the accounts array
        console.log('Accounts : '+ JSON.stringify(this.accounts));
        let editedRow = this.accounts.find(row => row.Id === rowId);
        console.log('editedRow : '+ JSON.stringify(editedRow));
        if (editedRow) {
            console.log('Inside editedRow');
            // Update the field value
            editedRow[fieldName] = value;
    
            // Find the corresponding row in selectedRecords and update it
            let selectedRow = this.selectedRecords.find(row => row.Id === rowId);
            if (selectedRow) {
                selectedRow[fieldName] = value;
            } else {
                // If the edited row is not in selectedRecords, add it
                this.selectedRecords.push(editedRow);
            }
    
            // Trigger reactivity by creating a new reference of accounts array
            this.accounts = [...this.accounts];
            
            console.log('Accounts Rec :'+ JSON.stringify(this.accounts));
            console.log('Selected Rec :'+ JSON.stringify(this.selectedRecords)); // Added for debugging
        }
    } */
    

    
    


    /*
        @name: formatRecords
        @params: data
        @description: to re-arrange the array after selection/de-selection of the rows
    */
    formatRecords(data){
        this.accounts = [];
        if(data){
            data.forEach(item=>{
                this.accounts.push({
                    "Id": item.Id,
                    "Name":item.Name,
                    "Site": item.Site,
                    "IsChecked": false
                })
            })
            if(this.selectedRecords.length>0){
                this.accounts.forEach(acc=>{
                    let element = this.selectedRecords.find(ele => ele.Id === acc.Id);
                    if(element !== undefined){
                        acc.IsChecked = true;
                        if(element.Site)
                            acc.Site = element.Site;
                    }
                })
                this.accounts = [...this.accounts];
            }
        
        }
    }

    /*
        @name: searchRecord
        @params: none
        @description: to search the record
    */
    searchRecord(){
        this.accName = this.template.querySelector(".inputaccname").value;
        this.elements = [];
        this.dataMap = [];
        searchAccounts({name: this.accName, prevAccRef: null, nextAccRef: null, recordsLimit: this.recordsPerPage})
        .then(data=>{
            if(data){
                this.formatRecords(data);
                this.elements.push(data[0].Id,  data[data.length-1].Id);
                this.dataMap.push({
                    key: this.count,
                    value: this.elements
                });
            }
            
        })

    }

    /*
        @name: showAllRecords
        @params: none
        @description: to show all records by clicking the button "Show All"
    */
    showAllRecords(){
        this.elements = [];
        this.dataMap = [];
        this.count = 0;
        this.template.querySelector(".inputaccname").value = '';
        this.accName = '';
        this.getRecords();
    }

    /*
        @name: handleSave
        @params: none
        @description: to save the record information
    */
    

        handleSave(event) {
            const draftValues = event.detail.draftValues;
            console.log('Draft Values: ', JSON.stringify(draftValues));
        
            const updatedRecords = draftValues.map(draft => {
                const updatedRecord = { Id: draft.Id, Site: draft.Site };
                updatedRecord[draft.fieldName] = draft.value;
                return updatedRecord;
            });
        
            console.log('Updated Records: ', JSON.stringify(updatedRecords));
        
            saveAccounts({ selectedAccountsJSON: JSON.stringify(updatedRecords) })
                .then(result => {
                    if (result) {
                        this.showMessage('Record(s) are saved successfully!', 'Success', 'success', 'dismissable');
                        
                        // Clear the draft values after successful save
                        this.draftValues = [];
        
                        // Refresh data depending on whether a search is active or not
                        if (this.accName && this.accName !== '') {
                            this.searchRecord(); // Refresh search results if there is an active search
                        } else {
                            this.getRecords(); // Otherwise, refresh the normal record view
                        }
                    } else {
                        this.showMessage('Record(s) are not saved!', 'Error', 'error', 'dismissable');
                    }
                })
                .catch(error => {
                    console.error('Error saving records: ', JSON.stringify(error));
                    this.showMessage('System Error: ' + JSON.stringify(error.body.message), 'Error', 'error', 'dismissable');
                });
        }
        

    /*
        @name: showMessage
        @params: message, title, variant,  mode
        @description: to show the success/error/warning message
    */
    showMessage(message, title, variant,  mode){
        const evt = new ShowToastEvent({title:title, message: message, variant: variant, mode: mode});
        this.dispatchEvent(evt);
    }

    handleRowSelection(event) {
        this.selectedRows = event.detail.selectedRows;
        
        // Clear the existing selected records
        this.selectedRecords = [];
    
        // Add the newly selected rows to the selectedRecords array
        this.selectedRows.forEach(row => {
            let selectedRecord = this.accounts.find(acc => acc.Id === row.Id);
            if (selectedRecord) {
                this.selectedRecords.push(selectedRecord);
            }
        });
    
        console.log('Selected Records : ' + JSON.stringify(this.selectedRecords));
    }

    
}