import { LightningElement ,wire, api} from 'lwc';
import conOfAct from '@salesforce/apex/ActConInfoP2c.conOfAct';

export default class Prnt2chldChild extends LightningElement {
    
    @api accountId;
    columns=[
        {
            label:'First Name',
            fieldName: 'FirstName'
        },
        {
            label:'Last Name',
            fieldName: 'LastName'
        },
        {
            label:'Phone',
            fieldName: 'Phone'
        }
    ];
    @wire(conOfAct, {accntId: '$accountId'} ) contacts;
}