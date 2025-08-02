import { LightningElement,api } from 'lwc';
import {CloseActionScreenEvent} from 'lightning/actions';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import createAcc from '@salesforce/apex/QckAcc.createAcc';
import {NavigationMixin} from 'lightning/navigation';
export default class QuickActionAcc extends NavigationMixin(LightningElement) {
    name='';
    phone='';
    @api recordId;

    navigateToList(){
        let pageReference= {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'list'
            },
            state: {
               filterName: 'Recent'
            }
        };
        this[NavigationMixin.Navigate](pageReference,true);
    }

    showToast(){
        const event= new ShowToastEvent({
            title : 'Show Notification',
            message : 'Account Created',
            variant : 'success',
        })
        this.dispatchEvent(event);
    }

    closeAction(){
        const myEvent = new CloseActionScreenEvent()
        this.dispatchEvent(myEvent);

    }


/*  @wire(createAcc, {name: this.name, phone: this.phone})
        ab({data,error}){
            if(data){
                /*eslint-disable no-console */
              /*  console.log(data);
            }
            else if(error){
                /*eslint-disable no-console */
              /*  console.log("error occured", error);
            }
    
        } */
  

    handleChange(event){
        event.preventDefault();
        let a = event.target.name;
        let b = event.target.value;
        if(a=='name'){
            this.name=b;
        }
        else{
            this.phone=b;
        }
    }
    
    // Better to use imperative method beacuse it gets called on handleSave() handler, if we would use wire than it calss automatically on load
    handleSave(event){
        event.preventDefault();
        createAcc({name: this.name, phone:this.phone, parentRecordId:this.recordId})
        .then(result => {
        console.log(result);
        })  
        .catch(error => {
        console.error("Error Occured",error);
        })

        this.showToast();

        this.navigateToList();

        


    }
      
}