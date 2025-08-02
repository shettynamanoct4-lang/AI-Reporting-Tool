import { LightningElement,wire } from 'lwc';
import actprnt from '@salesforce/apex/ActConInfoP2c.actprnt';

export default class Prnt2chldParent extends LightningElement {
    @wire(actprnt) accounts;
    actId;
    handleClick(event){
        event.preventDefault();
        this.actId=event.target.dataset.accountid;

    }
}