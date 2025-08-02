import { LightningElement, track, api, wire } from 'lwc';
import at from '@salesforce/apex/CrtActRec.at';
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
        label: 'Phone',
        fieldName: 'Phone'
    },
    {
        label: 'BillingAddress',
        fieldName: 'BillingAddress'
    },
    {
        label: 'AccountSource',
        fieldName: 'AccountSource'
    }
];

export default class CreateAndShowRecChild extends LightningElement {
    @api contId;
    @track columns=columns;
    @track data;
    data=[];
    @wire(at, {recId: '$contId'})
    fetchAcc({data,error}){
        if(data){
            this.data=data;
        }
        else if(error){
            console.log("error occured");
        }

    }
    

}