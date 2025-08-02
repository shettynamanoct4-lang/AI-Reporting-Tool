import { LightningElement , wire} from 'lwc';
import getAcc from '@salesforce/apex/DragDrop.getAcc';

export default class DragComponent extends LightningElement {
    @wire(getAcc) accounts;
    handleDrag(event){
        event.dataTransfer.setData("account_id", event.target.dataset.item);
    }
}