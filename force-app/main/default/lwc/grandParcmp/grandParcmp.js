import { LightningElement } from 'lwc';

export default class GrandParcmp extends LightningElement {
    messageFromChild = 'No message yet from child!';

    connectedCallback() {
        // Add event listener for the custom event from child
        this.template.addEventListener('childmessage', this.handleChildMessage.bind(this));
    }

    // Handler for the custom event from the child (through parent)
    handleChildMessage(event) {
        this.messageFromChild = event.detail; // Capture the message sent by the child
    }

}