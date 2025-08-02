import { LightningElement } from 'lwc';

export default class ChildToParUsingEvtListnerChild extends LightningElement {
    sendMessageToParent() {
        const message = 'Hello from Child!';
        // Create a custom event with detail containing the message
        const customEvent = new CustomEvent('custommessage', {
            detail: message,
            bubbles: true, // Make sure the event bubbles up to the parent
            composed: true // Allow the event to cross shadow DOM boundaries
        });
        // Dispatch the custom event
        this.dispatchEvent(customEvent);
    }

}