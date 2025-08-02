import { LightningElement,wire } from 'lwc';

import {
    subscribe,
    MessageContext,
    APPLICATION_SCOPE,
    publish
  } from "lightning/messageService";
import MESSAGE_CHANNEL from "@salesforce/messageChannel/MessageChannel__c";

export default class assignment6 extends LightningElement {
    messageFromAura = '';
    subscription = null;
    @wire(MessageContext)
    messageContext;

    sendMessage() {
      const payload  = {
        message: 'Hello from LWC'
      };
      publish(this.messageContext, MESSAGE_CHANNEL, payload );
    }

    // Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }
    // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                MESSAGE_CHANNEL,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }
     // Handler for message received by component
     handleMessage(message) {
        this.messageFromAura = message.message;
    }
}