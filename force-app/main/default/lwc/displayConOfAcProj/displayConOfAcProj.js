import { LightningElement, wire, track, api} from 'lwc';
import gtCn from '@salesforce/apex/ProjCnt.gtCn';

const columns=[
    {
        label:'Name',
        fieldName: 'Name'
    },
    {
        label:'Contact Number',
        fieldName: 'Phone'
    }
]

export default class DisplayConOfAcProj extends LightningElement {
    @track displayContacts='Show';
    @track isVisible=false;
    columns=columns;
    @track data=[];
    @api recordId; //To store the record Id of the current Account Record
    @api searchKey='';

    

    //To get the contacts related to that Account
    connectedCallback(){
        gtCn({accotId : this.recordId})
        .then(response =>{
            this.data = response;
        })
        .catch(error =>{
            console.log("Error Occured:"+error );
        })
    }




    changeHandler(event){
        const a = event.target.label;
        if(a=="Show"){
            this.displayContacts="Hide";
            this.isVisible=true;
        }
        else if(a=="Hide"){
            this.displayContacts="Show";
            this.isVisible=false;
        }
    }
    

    //Search Functionlity
    handlerChange(event){
    this.searchKey=event.target.value;

    gtCn({searchValue : this.searchKey, accotId : this.recordId})
    .then(result =>{
        this.data=result;
    })
    .catch(err=>{
        console.log("Error:"+err);

    })
    }

    //Get details of selected contact
    getSelectedRows(event){
        const selectedRowDetails =  event.detail.selectedRows;
        window.alert(JSON.stringify(selectedRowDetails));

    }

    
}