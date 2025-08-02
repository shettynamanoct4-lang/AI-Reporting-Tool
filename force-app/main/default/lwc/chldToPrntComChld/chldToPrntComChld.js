import { LightningElement } from 'lwc';
export default class ChldToPrntComChld extends LightningElement {
    handleClick(){
        
        this.dispatch(new CustomEvent('count'));
    }

    handleClock(){
        
        this.dispatch(new CustomEvent('not'));
    }

}