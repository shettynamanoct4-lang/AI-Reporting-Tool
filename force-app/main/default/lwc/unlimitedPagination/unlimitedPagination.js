import { LightningElement, api, track } from 'lwc';
import getAccounts from "@salesforce/apex/UnlimitedPaginationController.getAccounts";
import searchAccounts from "@salesforce/apex/UnlimitedPaginationController.searchAccounts";
import saveAccounts from "@salesforce/apex/UnlimitedPaginationController.saveAccounts";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class UnlimitedPagination extends LightningElement {

    /** variable declarion */
    @api recordsPerPage = 50;  

    @track accounts = [];
    @track selectedRecords = [];
    
    elements = [];
    dataMap = [];
    count = 0;
    accName;  


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
        @name: doRecordSelection
        @params: event
        @description: get the selected record information from the table
    */
    doRecordSelection(event){
        let element = this.accounts.find(ele => ele.Id === event.target.dataset.id);

        if(event.target.checked && !this.selectedRecords.find(ele => ele.Id === event.target.dataset.id))
            this.selectedRecords.push(element);
        else if(!event.target.checked && this.selectedRecords.find(ele => ele.Id === event.target.dataset.id)){
            for(let i = 0; i<this.selectedRecords.length; i++){
                if(this.selectedRecords[i].Id === event.target.dataset.id){
                    element.IsChecked = false;
                    this.selectedRecords.splice(i, 1);
                }
            }            
        }
    }

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
        @name: handleUpdateSite
        @params: event
        @description: to update the record information in the array
    */
    handleUpdateSite(event){
        console.log('val-->'+event.target.value);
                
        let element = this.accounts.find(ele => ele.Id === event.target.dataset.id);
        element.IsChecked = true;
        element.Site = event.target.value;

        if(this.selectedRecords.length > 0 && this.selectedRecords.find(ele => ele.Id === event.target.dataset.id)){
            for(let i = 0; i<this.selectedRecords.length; i++){
                if(this.selectedRecords[i].Id === event.target.dataset.id){
                    this.selectedRecords.splice(i, 1);
                }
            }    
            this.selectedRecords.push(element);
        }else{
            this.selectedRecords.push(element);
        }     
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
        @name: saveRecords
        @params: none
        @description: to save the record information
    */
    saveRecords(){
        if(this.selectedRecords.length > 0){
            saveAccounts({selectedAccountsJSON: JSON.stringify(this.selectedRecords)})
            .then(data=>{
                if(data){
                    this.showMessage('Record(s) are saved succesfully!', 'Success', 'success', 'dismissable');
                }else{
                    this.showMessage('Record(s) are not saved!', 'Error', 'error', 'dismissable');
                }
            }).catch(error=>{
                this.showMessage('System Error: '+JSON.stringify(error.body.message), 'Error', 'error', 'dismissable');
            })

        }
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

    
}