import { LightningElement } from 'lwc';

export default class ParCmp extends LightningElement {
    messageFromChild = 'No message yet from child!';

    connectedCallback() {
        // Add event listener for the custom event from child
        this.template.addEventListener('childmessage', this.handleChildMessage.bind(this));
    }

    // Handler for the custom event from the child
    handleChildMessage(event) {
        this.messageFromChild = event.detail; // Capture the message sent by the child
    }

}