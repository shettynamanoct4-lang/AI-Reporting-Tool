import { LightningElement } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class ToastFunct extends LightningElement {
    textDisplay = "Naman Good Job";
    
    handleClick(){
        let a = this.showToast(this.textDisplay);
    }

    showToast(param){
        const event= new ShowToastEvent({
            title : 'Show Notification',
            message : param,
            variant : 'success',
        })
        this.dispatchEvent(event);
    }



}