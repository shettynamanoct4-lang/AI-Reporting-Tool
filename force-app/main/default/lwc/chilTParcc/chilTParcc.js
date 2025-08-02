import { LightningElement } from 'lwc';
export default class ChldToPrntComChld extends LightningElement {
    handleClick(){
        
        this.dispatchEvent(new CustomEvent('count'));
    }

    handleClock(){
        
        this.dispatchEvent(new CustomEvent('not'));
    }

}