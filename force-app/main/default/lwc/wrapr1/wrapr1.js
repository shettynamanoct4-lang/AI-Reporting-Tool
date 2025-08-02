import { LightningElement,wire, track } from 'lwc';
import getAllAccountWithContactsList from '@salesforce/apex/WrapLwc1.show';

export default class Wrapr1 extends LightningElement {
    @track accountsWithContacts;
    @track error;
    
    /*
    get wprListu(){
        return this.wrpLst; 
    } */
    @wire(getAllAccountWithContactsList)
    shown({data,error}){
        if(data){
            this.accountsWithContacts= JSON.parse(JSON.stringify(data));
            console.log('List is'+JSON.stringify(this.accountsWithContacts));
        }
        else if(error){
            this.error = error;
            console.log('Error is'+error);
        }
       
    }
    

}