import { LightningElement, wire, track } from 'lwc';
import getAcco from '@salesforce/apex/wireEg.getAcco';

export default class ForEachYou extends LightningElement {
    @track data=[];

    @wire(getAcco)
    fetchAcc;
}