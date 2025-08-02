import { LightningElement } from 'lwc';

export default class SimplePar extends LightningElement {
    messageFromChild = 'No message yet from the child!';

    // Handle the custom event from the child
    handleMessage(event) {
        this.messageFromChild = event.detail; // Update the message based on the event detail
    }
}