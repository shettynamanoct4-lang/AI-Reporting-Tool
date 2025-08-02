import { LightningElement } from 'lwc';

export default class DisconnectedClbckExample extends LightningElement {
    connectedCallback() {
        console.log('Inside Connected Callback');
    }

    disconnectedCallback() {
        // Safely remove event listener
        this.removeButtonClickListener();
        console.log('Inside Disconnected Callback');
    }

    renderedCallback() {
        // Add event listener when the component is rendered
        this.addButtonClickListener();
    }

    addButtonClickListener() {
        const button = this.template.querySelector('lightning-button');
        if (button) {
            button.addEventListener('click', this.handleClick.bind(this));
        }
    }

    removeButtonClickListener() {
        const button = this.template.querySelector('lightning-button');
        if (button) {
            button.removeEventListener('click', this.handleClick.bind(this));
        }
    }

    handleClick() {
        // Handle button click event
        console.log('Button clicked!');
    }
}