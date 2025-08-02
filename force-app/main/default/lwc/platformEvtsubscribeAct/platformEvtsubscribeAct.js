import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ACCOUNT_ID_FIELD from '@salesforce/schema/Account.Id';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
import ACCOUNT_PHONE_FIELD from '@salesforce/schema/Account.Phone';
import ACCOUNT_RATING_FIELD from '@salesforce/schema/Account.Rating';

export default class PlatformEvtsubscribeAct extends LightningElement {
    @api recordId;
    @track accountName;
    @track accountPhone;
    @track accountRating;

    // Platform event subscription
    subscription = {};
    channelName = '/event/Notify_Message__e';

    // Options for the Rating field
    ratingOptions = [
        { label: 'Hot', value: 'Hot' },
        { label: 'Cold', value: 'Cold' },
        { label: 'Warm', value: 'Warm' }
    ];

    @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_NAME_FIELD, ACCOUNT_PHONE_FIELD, ACCOUNT_RATING_FIELD] })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountName = data.fields.Name.value;
            this.accountPhone = data.fields.Phone.value;
            this.accountRating = data.fields.Rating.value;
        } else if (error) {
            this.showToast('Error', 'Error fetching account data', 'error');
        }
    }

    // Subscribe to platform event on component load
    connectedCallback() {
        this.subscribeToPlatformEvent();
    }

    // Unsubscribe from the platform event on component unload
    disconnectedCallback() {
        this.unsubscribeFromPlatformEvent();
    }

    // Platform Event Subscription
    subscribeToPlatformEvent() {
        const messageCallback = (response) => {
            console.log('New message received: ', JSON.stringify(response));
            const eventData = response.data.payload;
            if (eventData.Source_Of_Message__c === this.recordId) {
                this.accountRating = eventData.Message__c;
                this.updateAccountRating(eventData.Message__c);
            }
        };

        subscribe(this.channelName, -1, messageCallback).then((response) => {
            console.log('Subscribed to platform event:', response.channel);
            this.subscription = response;
        });

        // Handle errors
        onError((error) => {
            console.error('Received error from server:', JSON.stringify(error));
        });
    }

    // Unsubscribe from the platform event
    unsubscribeFromPlatformEvent() {
        unsubscribe(this.subscription, (response) => {
            console.log('Unsubscribed from platform event:', response);
        });
    }

    // Update the Account Rating field in Salesforce
    updateAccountRating(newRating) {
        const fields = {};
        fields[ACCOUNT_ID_FIELD.fieldApiName] = this.recordId;
        fields[ACCOUNT_RATING_FIELD.fieldApiName] = newRating;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.showToast('Success', 'Account rating updated', 'success');
            })
            .catch((error) => {
                this.showToast('Error', 'Failed to update account rating', 'error');
            });
    }

    // Show toast notifications
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
}