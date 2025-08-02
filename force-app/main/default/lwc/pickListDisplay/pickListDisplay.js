import { LightningElement, wire, track } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account' ;
import 	INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';

export default class PickListDisplay extends LightningElement {
    @track value;
    @track options;
    @track obj;
    @wire(getPicklistValues, {recordTypeId: '012000000000000AAA', fieldApiName: INDUSTRY_FIELD})
    wiredFun({data,error}){
        if(data){
            this.options=data.values;
            console.log('PickList values', data.values);
        }
        if(error){
            console.log('error',error);
        }
    }

    @wire(getObjectInfo, {objectApiName:ACCOUNT_OBJECT })
    wiredFunc({data,error}){
        if(data){
            this.obj=data.fields.AccountNumber;
            console.log('Object Info', data.fields.AccountNumber);
        }
        if(error){
            console.log('error', error);
        }
    }


    changeHandler(event){
        this.value = event.target.value;
    }



}