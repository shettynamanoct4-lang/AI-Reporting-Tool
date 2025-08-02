import { LightningElement, track, wire } from 'lwc';
import getAcco from '@salesforce/apex/wireEg.getAcco';
const columns = [
    {
        label: 'Name',
        fieldName : 'Name'
    },
    {
        label: 'Account Id',
        fieldName: 'Id'

    },
    {
        label: 'Account Number',
        fieldName: 'AccountNumber'
    },
];



export default class WireExample extends LightningElement {
    @track columns=columns;
    @track data;
    data=[];

    @wire(getAcco)
    fetchAcc({data,error}){
        if(data){
            this.data=data;
        }
        else if(error){
            console.log("error occured");
        }

    }



}