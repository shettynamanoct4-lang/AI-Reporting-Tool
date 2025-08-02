import { LightningElement, track } from 'lwc';

export default class GetterSetterPar extends LightningElement {
    @track val;
    handleChange(event){
        this.val = event.target.value;
    }
}