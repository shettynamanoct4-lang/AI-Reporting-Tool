import { LightningElement } from 'lwc';

export default class ChildCmp extends LightningElement {
    // Method to dispatch the custom event
    sendMessageToParent() {
        const message = 'Hello from Child!';
        // Create a custom event with detail containing the message
        const customEvent = new CustomEvent('childmessage', {
            detail: message,
            bubbles: true, // Enables the event to bubble up the DOM hierarchy
            composed: true // Allows the event to cross shadow DOM boundaries
        });
        // Dispatch the custom event
        this.dispatchEvent(customEvent);
    }

}