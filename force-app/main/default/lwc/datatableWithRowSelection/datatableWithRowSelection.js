import { LightningElement ,track,wire,api} from 'lwc';
import getContactList from '@salesforce/apex/datatableWithRowSelectionClass.getContactList';

const columns = [
    { label : 'Name', fieldName: 'Name'},
    { label : 'Phone', fieldName: 'Phone'}
]

export default class DatatableWithRowSelection extends LightningElement {

    @track showContacts = 'Show Contacts';
    @track isVisible = false; 
    columns = columns;
    @track data =[];
    @api recordId; //it store the current page record Id
    @api searchKey=''; 

    //get related contactlist from apex class
    connectedCallback(){
        // calling apex method
        getContactList({lwcRecordId : this.recordId })
        .then( response => {
            this.data = response;
        })
        .catch(err=>{
            console.log("erroe occured:"+err);
        })
    }

// search functionality
handleChanged(event){
 this.searchKey = event.target.value;
console.log("saercKey:"+ JSON.stringify(this.searchKey))

 //send searchKey and record Id to apex Method
 getContactList({ searchKeys : this.searchKey ,  lwcRecordId : this.recordId})
 .then(res =>{
     this.data = res;
 })
 .catch(error=>{
     console.log(error);
 })


}


// Show/Hide button toggele functionality
    handleClick(event){
        const label = event.target.label;

        if(label === 'Show Contacts' ){
            this.showContacts = 'Hide contacts';
            this.isVisible = true;
        }
        else if(label === 'Hide contacts'){
            this.showContacts = 'Show Contacts';
            this.isVisible =false;
        }

    }

    //Get details of selected row deatils
    getSelectedRows(event){

        const selectedRowDetails =  event.detail.selectedRows;
        window.alert(JSON.stringify(selectedRowDetails));
    } 
}