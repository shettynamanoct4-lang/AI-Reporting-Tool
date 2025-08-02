import { LightningElement } from 'lwc';

export default class SimpleChild extends LightningElement {
    // Method to send a message to the parent
    sendMessageToParent() {
        const message = 'Hello from the Child!';
        
        // Create a custom event with the message as detail
        const messageEvent = new CustomEvent('message', {
            detail: message,
            bubbles: false
        });
        
        // Dispatch the event
        this.dispatchEvent(messageEvent);
    }
}