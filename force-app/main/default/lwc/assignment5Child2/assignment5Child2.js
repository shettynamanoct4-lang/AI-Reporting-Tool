import { LightningElement,api } from 'lwc';

export default class Assignment5Child2 extends LightningElement {
    @api outputValue;
    handleChange( event ) {
        this.outputValue = event.target.value;
    }
    passToParent(event){
        // Creates the event with the data.
        const selectedEvent = new CustomEvent("outputvaluechange", {
        detail: this.outputValue
        });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
}