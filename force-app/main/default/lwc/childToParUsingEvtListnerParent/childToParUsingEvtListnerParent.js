import { LightningElement } from 'lwc';

export default class ChildToParUsingEvtListnerParent extends LightningElement {
    message = 'Hello from Parent!';

    connectedCallback() {
        // Add event listener for the custom event
        this.template.addEventListener('custommessage', this.handleCustomEvent.bind(this));
    }

    // Handler function for the custom event
    handleCustomEvent(event) {
        this.message = event.detail; // Capture the message sent by the child
    }

}