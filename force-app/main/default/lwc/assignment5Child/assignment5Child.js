import { LightningElement ,api} from 'lwc';


export default class Assignment5Child extends LightningElement {
    @api outputValueOneOne;
    handleChange( event ) {
        this.outputValueOne = event.target.value;
    }
    passToParent(event){
        // Creates the event with the data.
        const selectedEvent = new CustomEvent("outputonechange", {
        detail: this.outputValueOne
        });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
}