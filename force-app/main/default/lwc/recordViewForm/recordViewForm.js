import {LightningElement,api } from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import BILLINGADDRESS_FIELD from '@salesforce/schema/Account.BillingAddress';

export default class RecordViewForm extends LightningElement {
    @api recordId='0015g00000P6BtrAAF'; //If we want to include this component in a Record page then don't hardcode recordId and Object Api name, just keep it as @api recordId and @objectApiName(since the component automatically taked the recordId and ObjectApiName from the record page of that particular record itself)

    objectApiName=ACCOUNT_OBJECT;
    NameField=NAME_FIELD;
    Phone = PHONE_FIELD;
    BillingAddress=BILLINGADDRESS_FIELD;
}